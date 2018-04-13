//
//  UIScrollView+SFRefresh.m
//  SFRefreshView
//
//  Created by Cai.flower on 2018/4/13.
//  Copyright © 2018年 花菜. All rights reserved.
//

#import "UIScrollView+SFRefresh.h"
#import <objc/runtime.h>
static NSString * kSFRefreshWrapperKey = @"kSFRefreshWrapperKey";

@implementation UIScrollView (SFRefresh)

- (SFRefreshWrapper *)refreshWrapper {
    
    SFRefreshWrapper * wrapper = objc_getAssociatedObject(self, &kSFRefreshWrapperKey);
    if (!wrapper) {
        wrapper = [[SFRefreshWrapper alloc] initWithScrollView:self];
        objc_setAssociatedObject(self, &kSFRefreshWrapperKey, wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return wrapper;
}

- (void)setRefreshWrapper:(SFRefreshWrapper *)refreshWrapper {
    if (refreshWrapper) {
        objc_setAssociatedObject(self, &kSFRefreshWrapperKey, refreshWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
@end
