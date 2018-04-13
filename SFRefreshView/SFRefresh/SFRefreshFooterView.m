//
//  SFRefreshFooterView.m
//  refresh
//
//  Created by 花菜 on 2018/4/11.
//  Copyright © 2018年 Cai.flower. All rights reserved.
//

#import "SFRefreshFooterView.h"

@implementation SFRefreshFooterView

- (void)setNoMoreData:(BOOL)noMoreData {
    if (_noMoreData != noMoreData) {
        self.state = SFRefreshStateIdle;
    }
    _noMoreData = noMoreData;
    
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (hidden) {
        UIEdgeInsets inset =  self.scrollView.contentInset;
        inset.bottom = self.scrollViewInsets.bottom;
        self.scrollView.contentInset = inset;
        CGRect rect = self.frame;
        rect.origin.y = self.scrollView.contentSize.height;
        self.frame = rect;
    } else {
        UIEdgeInsets inset =  self.scrollView.contentInset;
        inset.bottom = self.scrollViewInsets.bottom + self.animator.execute;
        self.scrollView.contentInset = inset;
        CGRect rect = self.frame;
        rect.origin.y = self.scrollView.contentSize.height;
        self.frame = rect;
    }
}

- (instancetype)initWithAnimator:(id<SFRefreshProtocol>)animator handler:(SFRefreshHandler)handler {
    if (self = [super initWithAnimator:animator handler:handler]) {
        self.handler = handler;
        self.animator = animator;
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakself) {
            weakself.scrollViewInsets = weakself.scrollView.contentInset;
            UIEdgeInsets inset =  weakself.scrollView.contentInset;
            inset.bottom = weakself.scrollViewInsets.bottom + weakself.bounds.size.height;
            weakself.scrollView.contentInset = inset;
            CGRect rect = self.frame;
            rect.origin.y = self.scrollView.contentSize.height;
            weakself.frame = rect;
        }
    });
}

- (void)start {
    if (self.scrollView) {
        [super start];
        [self.animator refreshViewBegin:self];
        CGFloat x = self.scrollView.contentOffset.x;
        CGFloat y = MAX(0.0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollView.contentInset.bottom);
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.scrollView.contentOffset = CGPointMake(x, y);
        } completion:^(BOOL finished) {
            self.handler();
        }];
    }
}
- (void)stop {
    if (self.scrollView) {
        
        [self.animator refreshview:self endRefresh:NO];
        [UIView animateWithDuration:kSFAnimationDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
 
        } completion:^(BOOL finished) {
            if (self.noMoreData == NO) {
                self.state = SFRefreshStateIdle;
            }
            [super stop];
            [self.animator refreshview:self endRefresh:YES];
            
        }];
        if (self.scrollView.isDecelerating) {
            CGPoint contentOffset = self.scrollView.contentOffset;
            contentOffset.y = MIN(contentOffset.y, self.scrollView.contentSize.height - self.scrollView.frame.size.height);
            if (contentOffset.y < 0) {
                contentOffset.y = 0;
                [UIView animateWithDuration:0.1 animations:^{
                    [self.scrollView setContentOffset:contentOffset animated:NO];
                }];
            } else {
                [self.scrollView setContentOffset:contentOffset animated:NO];
            }
        }
    }
}

- (void)sizeChange:(NSDictionary *)change {
    if (self.scrollView) {
        [super sizeChange:change];
        
        CGFloat targetY = self.scrollView.contentSize.height + self.scrollViewInsets.bottom;
        if (self.frame.origin.y != targetY) {
            CGRect rect = self.frame;
            rect.origin.y = targetY;
            self.frame = rect;
        }
    }
}

- (void)offsetChange:(NSDictionary *)change {
    if (self.scrollView) {
        [super offsetChange:change];
        if (self.isRefreshing | self.noMoreData | self.isHidden) {
            // 正在loading more或者内容为空时不相应变化
            return;
        }
        
        if (self.scrollView.contentSize.height <= 0 || self.scrollView.contentOffset.y + self.scrollView.contentInset.top <= 0) {
            self.alpha = 0;
            return;
        } else {
            self.alpha = 1;
        }
        
        if (self.scrollView.contentSize.height + self.scrollView.contentInset.top > self.scrollView.bounds.size.height) {
            // 内容超过一个屏幕 计算公式，判断是不是在拖在到了底部
            if (self.scrollView.contentSize.height - self.scrollView.contentOffset.y + self.scrollView.contentInset.bottom <= self.scrollView.bounds.size.height) {
                self.state = SFRefreshStateRefreshing;
                [self beginRefreshing];
            }
        } else {
            //内容没有超过一个屏幕，这时拖拽高度大于1/2footer的高度就表示请求上拉
            if (self.scrollView.contentOffset.y + self.scrollView.contentInset.top >= self.animator.trigger / 2) {
                self.state = SFRefreshStateRefreshing;
                [self beginRefreshing];
            }
        }
    }
}

- (void)noticeNoMoreData {
    self.noMoreData = YES;
    self.state = SFRefreshStateNoMoreData;
}

- (void)resetNoMoreData {
    self.noMoreData = NO;
}


















@end
