//
//  UIScrollView+SFRefresh.h
//  SFRefreshView
//
//  Created by Cai.flower on 2018/4/13.
//  Copyright © 2018年 花菜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRefreshWrapper.h"
@interface UIScrollView (SFRefresh)
/// 刷新相关
@property (strong, nonatomic) SFRefreshWrapper * refreshWrapper;

@end
