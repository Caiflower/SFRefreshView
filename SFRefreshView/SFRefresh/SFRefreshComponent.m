//
//  SFRefreshComponent.m
//  SFRefreshView
//
//  Created by 花菜 on 2018/4/12.
//  Copyright © 2018年 花菜. All rights reserved.
//

#import "SFRefreshComponent.h"
static NSString * kSFContext = @"SFRefreshContext";
static NSString * kSFOffsetKeyPath = @"contentOffset";
static NSString * kSFContentSizeKeyPath = @"contentSize";
@interface SFRefreshComponent()

@property (assign, nonatomic) BOOL isObservingScrollView;
@property (assign, nonatomic) BOOL isIgnoreObserving;

@end
@implementation SFRefreshComponent

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.scrollViewInsets = UIEdgeInsetsZero;
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    }
    return self;
}

- (instancetype)initWithAnimator:(id<SFRefreshProtocol>)animator handler:(SFRefreshHandler)handler {
    if (self = [super init]) {
        _handler = handler;
        _animator = animator;
    }
    return self;
}
- (void)setState:(SFRefreshState)state {
    _state = state;
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.animator refreshView:weakself stateDidChange:state];
    });
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    // 旧的父控件移除监听
    [self removeObserver];
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        // 记录UIScrollView最开始的 contentInset
        UIScrollView * view = (UIScrollView *)newSuperview;
        _scrollViewInsets = view.contentInset;
        __weak typeof(self) weakself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakself) {
                [self addObserverForView:view];
            }
        });
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        self.scrollView = (UIScrollView *)self.superview;
        UIView * view = self.animator.view;
        if (view.superview == nil) {
            UIEdgeInsets inset = self.animator.insets;
            [self addSubview:view];
            view.frame = CGRectMake(inset.left,
                                    inset.top,
                                    self.bounds.size.width - inset.left - inset.right,
                                    self.bounds.size.height - inset.top - inset.bottom);
            
            view.autoresizingMask = UIViewAutoresizingFlexibleWidth |
            UIViewAutoresizingFlexibleWidth |
            UIViewAutoresizingFlexibleTopMargin|
            UIViewAutoresizingFlexibleHeight |
            UIViewAutoresizingFlexibleBottomMargin;
        }
        
    }
}

- (void)beginRefreshing {
    if (_isRefreshing) {
        return;
    }
    
    if (self.window != nil) {
        self.state = SFRefreshStateRefreshing;
        [self start];
    } else {
        if (self.state != SFRefreshStateRefreshing) {
            self.state = SFRefreshStateWillRefresh;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.scrollViewInsets = self.scrollView.contentInset;
                if (self.state == SFRefreshStateWillRefresh) {
                    self.state = SFRefreshStateRefreshing;
                    [self start];
                }
            });
        }
    }
}

- (void)endRefreshing {
    if (!_isRefreshing) {
        return;
    }
    [self stop];
}

- (void)ignoreObserver:(BOOL)ignore {
    _isIgnoreObserving = ignore;
}


- (void)start {
    _isRefreshing = YES;
}

- (void)stop {
    _isRefreshing = NO;
}

- (void)sizeChange:(NSDictionary *)change {
    
}
- (void)offsetChange:(NSDictionary *)change {
    
}




#pragma mark - ====KVO 相关====
- (void)removeObserver {
    if (self.scrollView == self.superview && self.isObservingScrollView) {
        [self.scrollView removeObserver:self forKeyPath:kSFOffsetKeyPath context:&kSFContext];
        [self.scrollView removeObserver:self forKeyPath:kSFContentSizeKeyPath context:&kSFContext];
        self.isObservingScrollView = NO;
    }
}

- (void)addObserverForView:(UIView *)view {
    if ([view isKindOfClass:[UIScrollView class]] && !self.isObservingScrollView) {
        UIScrollView * scrollerView = (UIScrollView *)view;
        [scrollerView addObserver:self forKeyPath:kSFOffsetKeyPath options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:&kSFContext];
        [scrollerView addObserver:self forKeyPath:kSFContentSizeKeyPath options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:&kSFContext];
        
        self.isObservingScrollView = YES;
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == &kSFContext) {
        if (self.userInteractionEnabled != YES && self.hidden != NO) {
            return;
        }
        
        if (keyPath == kSFContentSizeKeyPath) {
            if (self.isIgnoreObserving == NO) {
                [self sizeChange:change];
            }
        }
        
        if (keyPath == kSFOffsetKeyPath) {
            if (self.isIgnoreObserving == NO) {
                [self offsetChange:change];
            }
        }
    }
}


@end
