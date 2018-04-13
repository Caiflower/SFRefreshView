//
//  SFRefreshComponent.h
//  SFRefreshView
//
//  Created by 花菜 on 2018/4/12.
//  Copyright © 2018年 花菜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRefreshView-Swift.h"
typedef void(^SFRefreshHandler)(void);

static CGFloat kSFAnimationDuration = 0.25;

typedef NS_ENUM(NSUInteger, SFRefreshState) {
    /// 普通闲置状态
    SFRefreshStateIdle = 0,
    /// 松开就可以进行刷新的状态
    SFRefreshStatePulling = 1,
    /// 正在刷新中的状态
    SFRefreshStateRefreshing = 2,
    /// 即将刷新的状态
    SFRefreshStateWillRefresh = 3,
    /// 所有数据加载完毕，没有更多的数据了
    SFRefreshStateNoMoreData = 4,
};

@class SFRefreshComponent;
@protocol SFRefreshProtocol <NSObject>
/// view的insets
@property (assign, nonatomic) UIEdgeInsets insets;
/// 触发刷新的高度
@property (assign, nonatomic) CGFloat trigger;
/// 动画执行时的高度
@property (assign, nonatomic) CGFloat execute;
/// 动画结束时延迟的时间，单位秒
@property (assign, nonatomic) CGFloat endDelay;
/// 延迟时悬停的高度
@property (assign, nonatomic) CGFloat hold;/// 自定义的view
- (UIView *)view;
/// 开始刷新
- (void)refreshViewBegin:(SFRefreshComponent *)view;
/// 将要开始刷新
- (void)refreshViewWillEnd:(SFRefreshComponent *)view;
/// 结束刷新
- (void)refreshview:(SFRefreshComponent *)view endRefresh:(BOOL)finish;
/// 刷新进度的变化
- (void)refreshView:(SFRefreshComponent *)view progressDidChange:(CGFloat)progress;
/// 刷新状态的变化
- (void)refreshView:(SFRefreshComponent *)view stateDidChange:(SFRefreshState)state;
@end
@interface SFRefreshComponent : UIView
@property (weak, nonatomic) UIScrollView * scrollView;
@property (assign, nonatomic) UIEdgeInsets scrollViewInsets;
/// SFRefreshHandler
@property (copy, nonatomic) SFRefreshHandler handler;
/// animator
@property (strong, nonatomic) id<SFRefreshProtocol> animator;
@property (assign, nonatomic) BOOL isRefreshing;
@property (assign, nonatomic) SFRefreshState state;
- (instancetype)initWithAnimator:(id<SFRefreshProtocol>)animator handler:(SFRefreshHandler)handler;
- (void)beginRefreshing;
- (void)endRefreshing;
- (void)ignoreObserver:(BOOL)ignore;
- (void)start;
- (void)stop;
- (void)sizeChange:(NSDictionary *)change;
- (void)offsetChange:(NSDictionary *)change;
@end
