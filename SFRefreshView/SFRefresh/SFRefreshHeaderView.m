//
//  SFRefreshHeaderView.m
//  refresh
//
//  Created by 花菜 on 2018/4/11.
//  Copyright © 2018年 Cai.flower. All rights reserved.
//

#import "SFRefreshHeaderView.h"
@interface SFRefreshHeaderView ()
/// 记录之前的offsetY
@property (nonatomic,assign) CGFloat previousOffsetY;
@property (nonatomic,assign) BOOL  scrollViewBounces;
/// 记录结束刷新时需要调整的contentInsetY
@property (nonatomic,assign) CGFloat insetTDelta;
/// 记录悬停时需要调整的contentInsetY
@property (nonatomic,assign) CGFloat holdInsetTDelta;
@end
@implementation SFRefreshHeaderView

- (instancetype)initWithAnimator:(id<SFRefreshProtocol>)animator handler:(SFRefreshHandler)handler {
    if (self = [super initWithAnimator:animator handler:handler]) {
        self.handler = handler;
        self.animator = animator;
        _previousOffsetY = 0;
        _insetTDelta = 0;
        _holdInsetTDelta = 0;
        _scrollViewBounces = YES;
    }
    return self;
}


- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakself) {
            weakself.scrollViewBounces = self.scrollView.bounces;
        }
    });
}

- (void)start {
    if (self.scrollView) {
        /// 动画的时候先忽略监听
        [self ignoreObserver:YES];
        self.scrollView.bounces = NO;
        [super start];
        /// 开始动画
        [self.animator refreshViewBegin:self];
        /// 调整scrollView的 contentInset
        UIEdgeInsets inset = self.scrollView.contentInset;
        UIEdgeInsets scrollViewInsets = self.scrollViewInsets;
        scrollViewInsets.top = inset.top;
        self.scrollViewInsets = scrollViewInsets;
        
        inset.top += self.animator.execute;
        self.insetTDelta = -self.animator.execute;
        self.holdInsetTDelta = -(self.animator.execute - self.animator.hold);
        [UIView  animateWithDuration:kSFAnimationDuration animations:^{
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, self.previousOffsetY);;
            self.scrollView.contentInset = inset;
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -inset.top);
        } completion:^(BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.handler();
                [self ignoreObserver:NO];
                self.scrollView.bounces = self.scrollViewBounces;
            });
        }];
    }
}

- (void)stop {
    if (self.scrollView) {
        /// 动画的时候先忽略监听
        [self ignoreObserver:YES];
        [self.animator refreshViewWillEnd:self];
        if (self.animator.hold != 0) {
            [UIView animateWithDuration:kSFAnimationDuration animations:^{
               UIEdgeInsets inset = self.scrollView.contentInset;
                inset.top += self.holdInsetTDelta;
                NSLog(@"stop %f",inset.top);
                self.scrollView.contentInset = inset;
            }];
        }
        if (self.animator.endDelay > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animator.endDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self beginStop];
            });
        } else {
            [self beginStop];
        }
    }
}

- (void)beginStop {
    /// 结束动画
    [self.animator refreshview:self endRefresh:NO];
    // 调整scrollView的contentInset
    [UIView animateWithDuration:kSFAnimationDuration animations:^{
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.top += self.insetTDelta - self.holdInsetTDelta;
        self.scrollView.contentInset = inset;
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.state = SFRefreshStateIdle;
            [super stop];
            [self.animator refreshview:self endRefresh:YES];
            [self ignoreObserver:NO];
        });
    }];
}


- (void)offsetChange:(NSDictionary *)change {
    if (self.scrollView) {
        [super offsetChange:change];
        // sectionheader停留的解决方案
        if (self.isRefreshing) {
            if (self.window == nil) { return; }
            CGFloat top = self.scrollViewInsets.top;
            CGFloat offsetY = self.scrollView.contentOffset.y;
            CGFloat height = self.frame.size.height;
            CGFloat scrollingTop = (-offsetY > top) ? -offsetY: top;
            scrollingTop = (scrollingTop > height + top) ? (height + top) : scrollingTop;
            UIEdgeInsets inset = self.scrollView.contentInset;
            inset.top = scrollingTop;
            self.scrollView.contentInset = inset;
            self.insetTDelta = self.scrollViewInsets.top - scrollingTop;
            return;
        }
        
        // 算出Progress
        BOOL isRecordingProgress = NO;
        
        CGFloat offsets = self.previousOffsetY + self.scrollViewInsets.top;
        if (offsets < -self.animator.trigger) {
            if (self.isRefreshing == NO) {
                if (self.scrollView.isDragging == NO && self.state == SFRefreshStatePulling) {
                    [self beginRefreshing];
                    self.state = SFRefreshStateRefreshing;
                } else {
                    self.state = SFRefreshStatePulling;
                    isRecordingProgress = YES;
                }
            }
        } else if (offsets < 0){
            if (self.isRefreshing == NO) {
                self.state = SFRefreshStateIdle;
                isRecordingProgress = YES;
            }
        }
        self.previousOffsetY = self.scrollView.contentOffset.y;        
        if (isRecordingProgress == YES) {
            CGFloat percent = -(_previousOffsetY + self.scrollViewInsets.top) / self.animator.trigger;
            [self.animator refreshView:self progressDidChange:percent];
        }
    }
}













@end
