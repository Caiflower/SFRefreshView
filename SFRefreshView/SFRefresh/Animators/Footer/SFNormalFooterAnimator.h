//
//  SFNormalFooterAnimator.h
//  SFRefreshView
//
//  Created by Cai.flower on 2018/4/13.
//  Copyright © 2018年 花菜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRefreshComponent.h"
@interface SFNormalFooterAnimator : UIView<SFRefreshProtocol>
/// 自定义的view
@property (strong, nonatomic) UIView * view;
/// view的insets
@property (assign, nonatomic) UIEdgeInsets insets;
/// 触发刷新的高度
@property (assign, nonatomic) CGFloat trigger;
/// 动画执行时的高度
@property (assign, nonatomic) CGFloat execute;
/// 动画结束时延迟的时间，单位秒
@property (assign, nonatomic) CGFloat endDelay;
/// 延迟时悬停的高度
@property (assign, nonatomic) CGFloat hold;
@end
