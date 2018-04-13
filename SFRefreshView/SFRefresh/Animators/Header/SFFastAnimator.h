//
//  SFFastAnimator.h
//  SFRefreshView
//
//  Created by 花菜 on 2018/4/12.
//  Copyright © 2018年 花菜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRefreshComponent.h"

@interface SFFastAnimator : UIView<SFRefreshProtocol>
@property (assign, nonatomic) UIEdgeInsets insets;
@property (assign, nonatomic) CGFloat  trigger;
@property (assign, nonatomic) CGFloat  execute;
@property (assign, nonatomic) CGFloat  endDelay;
@property (assign, nonatomic) CGFloat  hold;
- (UIView *)view;
@end
