//
//  SRRefreshWrapper.h
//  SFRefreshView
//
//  Created by 花菜 on 2018/4/12.
//  Copyright © 2018年 花菜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFRefreshView-Swift.h"
#import "SFRefreshComponent.h"


@class SFRefreshFooterView,SFRefreshHeaderView;

@interface SFRefreshWrapper : NSObject
@property (strong, nonatomic) UIScrollView * scrollView;

/**
下拉刷新控件
 */
@property (strong, nonatomic) SFRefreshHeaderView * header;

/**
 上拉加载控件
 */
@property (strong, nonatomic) SFRefreshFooterView * footer;
- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

/**
 添加下拉刷新控件

 @param handler 回调事件
 @return 下拉刷新控件
 */
- (SFRefreshHeaderView *)addHeaderRefreshWithHandler:(SFRefreshHandler)handler;

/**
 添加下拉刷新控件

 @param animator 自定义动画插件
 @param handler 回调事件
 @return 下拉刷新控件
 */
- (SFRefreshHeaderView *)addHeaderRefreshWithAnimator:(id<SFRefreshProtocol>)animator handler:(SFRefreshHandler)handler;

/**
 开始下拉刷新
 */
- (void)beginHeaderRefresh;

/**
 结束下拉刷新
 */
- (void)endHeaderRefresh;

/**
 移除头部
 */
- (void)removeHeader;

/**
 添加上拉加载控件

 @param handler 回调事件
 @return 上拉加载控件
 */
- (SFRefreshFooterView *)addFooterRefreshWithhandler:(SFRefreshHandler)handler;

/**
 添加上拉加载控件

 @param animator 自定义动画插件
 @param handler 回调事件
 @return 上拉加载控件
 */
- (SFRefreshFooterView *)addFooterRefreshWithAnimator:(id<SFRefreshProtocol>)animator handler:(SFRefreshHandler)handler;

/**
 没有更多数据
 */
- (void)endWithNoMoreData;

/**
 重置上拉加载控件状态
 */
- (void)resetNoMoreData;

/**
 结束上拉加载事件
 */
- (void)endFooterRefresh;

/**
 移除上拉加载控件
 */
- (void)removeFooter;
@end
