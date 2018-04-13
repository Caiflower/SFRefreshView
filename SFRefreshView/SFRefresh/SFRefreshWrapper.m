//
//  SRRefreshWrapper.m
//  SFRefreshView
//
//  Created by 花菜 on 2018/4/12.
//  Copyright © 2018年 花菜. All rights reserved.
//

#import "SFRefreshWrapper.h"
#import <objc/runtime.h>
#import "SFRefreshHeaderView.h"
#import "SFRefreshFooterView.h"
#import "SFFastAnimator.h"
#import "SFNormalFooterAnimator.h"
static NSString * kSFRefreshHeaderKey = @"kSFRefreshHeaderKey";
static NSString * kSFRefreshFooterKey = @"kSFRefreshFooterKey";
@implementation SFRefreshWrapper
- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    if (self = [super init]) {
        self.scrollView = scrollView;
    }
    return self;
}

- (SFRefreshHeaderView *)addHeaderRefreshWithHandler:(SFRefreshHandler)handler {
    
    
    return [self addHeaderRefreshWithAnimator:[SFFastAnimator new] handler:handler];
}
- (SFRefreshHeaderView *)addHeaderRefreshWithAnimator:(id<SFRefreshProtocol>)animator handler:(SFRefreshHandler)handler {
    SFRefreshHeaderView * header = [[SFRefreshHeaderView alloc] initWithAnimator:animator handler:handler];
    [self.header endRefreshing];
    [self.header removeFromSuperview];
    self.header = nil;
    CGFloat headerH = header.animator.execute;
    header.frame = CGRectMake(0,
                              -headerH,
                              self.scrollView.bounds.size.width,
                              headerH);
    [self.scrollView addSubview:header];
    self.header = header;
    return header;
}
- (void)beginHeaderRefresh {
    [self.header beginRefreshing];
    [self resetNoMoreData];
}
- (void)endHeaderRefresh {
    [self.header endRefreshing];
}

- (SFRefreshFooterView *)addFooterRefreshWithhandler:(SFRefreshHandler)handler {
    return [self addFooterRefreshWithAnimator:[SFNormalFooterAnimator new] handler:handler];
}
- (SFRefreshFooterView *)addFooterRefreshWithAnimator:(id<SFRefreshProtocol>)animator handler:(SFRefreshHandler)handler {
    SFRefreshFooterView * footer = [[SFRefreshFooterView alloc] initWithAnimator:animator handler:handler];
    [self.footer endRefreshing];
    [self.footer removeFromSuperview];
    self.footer = nil;
    CGFloat footerH = footer.animator.execute;
    footer.frame = CGRectMake(0,
                              self.scrollView.contentSize.height + self.scrollView.contentInset.bottom,
                              self.scrollView.bounds.size.width,
                              footerH);
    [self.scrollView addSubview:footer];
    self.footer = footer;
    return footer;
}
- (void)endWithNoMoreData {
    [self.footer endRefreshing];
    [self.footer noticeNoMoreData];
}
- (void)resetNoMoreData {
    [self.footer resetNoMoreData];
}
- (void)endFooterRefresh {
    [self.footer endRefreshing];
}


- (void)removeFooter {
    [self.footer endRefreshing];
    [self.footer removeFromSuperview];
    self.footer = nil;
}
- (void)removeHeader {
    [self.header endRefreshing];
    [self.header removeFromSuperview];
    self.header = nil;
}
- (void)setFooter:(SFRefreshFooterView *)footer {
    
    objc_setAssociatedObject(self.scrollView, &kSFRefreshFooterKey, footer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (SFRefreshFooterView *)footer {
    return objc_getAssociatedObject(self.scrollView, &kSFRefreshFooterKey);
}

- (void)setHeader:(SFRefreshHeaderView *)header {
    objc_setAssociatedObject(self.scrollView, &kSFRefreshHeaderKey, header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SFRefreshHeaderView *)header {
    return objc_getAssociatedObject(self.scrollView, &kSFRefreshHeaderKey);
}

@end
