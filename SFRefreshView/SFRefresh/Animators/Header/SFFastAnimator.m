//
//  SFFastAnimator.m
//  SFRefreshView
//
//  Created by 花菜 on 2018/4/12.
//  Copyright © 2018年 花菜. All rights reserved.
//

#import "SFFastAnimator.h"
@interface SFFastAnimator()
///
@property (nonatomic,strong) UIColor * color;
@property (nonatomic,strong) UIColor * arrowColor;
@property (nonatomic,assign) CGFloat  lineWidth;
@property (nonatomic,strong) FastLayer * fastLayer;
@end
@implementation SFFastAnimator

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.insets = UIEdgeInsetsZero;
        self.trigger = 120;
        self.execute = 120;
        self.endDelay = 1;
        self.hold = 120;
        _color = [UIColor redColor];
        _arrowColor = [UIColor blackColor];
        _lineWidth = 2.5;
    }
    return self;
}
- (UIView *)view {
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.fastLayer == nil) {
        CGFloat widht = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        _fastLayer = [FastLayer layerWithFrame:CGRectMake(widht / 2 - 35, height / 2 - 35, 70, 70) lineWidth:2.5];
        [self.layer addSublayer:_fastLayer];
    }
}
- (void)refreshView:(SFRefreshComponent *)view progressDidChange:(CGFloat)progress {
    
}

- (void)refreshView:(SFRefreshComponent *)view stateDidChange:(SFRefreshState)state {
    
}

- (void)refreshViewBegin:(SFRefreshComponent *)view {
    __weak typeof(self) weakself = self;
    [self.fastLayer.arrow startAnimation].animationEnd = ^{
        [weakself.fastLayer.circle startAnimation];
    };
}

- (void)refreshViewWillEnd:(SFRefreshComponent *)view {
    
    [self.fastLayer.circle endAnimationWithFinish:NO];
}

- (void)refreshview:(SFRefreshComponent *)view endRefresh:(BOOL)finish {
    if (finish) {
        [self.fastLayer.arrow endAnimation];
        [self.fastLayer.circle endAnimationWithFinish:YES];
    }
}





@end
