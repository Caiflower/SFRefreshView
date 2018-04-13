//
//  SFNormalFooterAnimator.m
//  SFRefreshView
//
//  Created by Cai.flower on 2018/4/13.
//  Copyright © 2018年 花菜. All rights reserved.
//

#import "SFNormalFooterAnimator.h"

@interface SFNormalFooterAnimator()
/// titleLabel
@property (strong, nonatomic) UILabel * titleLabel;

/// indicatorView
@property (strong, nonatomic) UIActivityIndicatorView * indicatorView;
/// duration
@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) SFRefreshState state;
@end
@implementation SFNormalFooterAnimator

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _insets = UIEdgeInsetsZero;
        _trigger = 50;
        _execute = 50;
        _endDelay = 0;
        _hold = 50;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.titleLabel.text = @"上拉加载更多";
    [self addSubview:self.titleLabel];
    [self addSubview:self.indicatorView];
}
- (UIView *)view {
    return self;
}
- (void)refreshViewBegin:(SFRefreshComponent *)view {
    [self.indicatorView startAnimating];
    self.titleLabel.text = @"正在加载更多的数据...";
    self.indicatorView.hidden = NO;
}


- (void)refreshViewWillEnd:(SFRefreshComponent *)view {
    
    
}

- (void)refreshview:(SFRefreshComponent *)view endRefresh:(BOOL)finish {
    [self.indicatorView stopAnimating];
    self.titleLabel.text = @"上拉加载更多";
    self.indicatorView.hidden = YES;
    
}

- (void)refreshView:(SFRefreshComponent *)view stateDidChange:(SFRefreshState)state {
    _state = state;
    switch (state) {
        case SFRefreshStateRefreshing:
            _titleLabel.text = @"正在加载更多的数据...";
            break;
        case SFRefreshStateNoMoreData:
            _titleLabel.text = @"没有更多数据";
            break;
        case SFRefreshStatePulling:
            _titleLabel.text = @"上拉加载更多";
            break;
            
        default:
            break;
    }
    [self setNeedsLayout];
}

- (void)refreshView:(SFRefreshComponent *)view progressDidChange:(CGFloat)progress {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(width * 0.5, height * 0.5 + _insets.top);
    _indicatorView.center = CGPointMake(_titleLabel.frame.origin.x - 18, self.titleLabel.center.y);
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithWhite:130/255.0 alpha:1];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidden = YES;
    }
    return _indicatorView;
}

@end
