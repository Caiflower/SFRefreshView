//
//  SFRefreshFooterView.h
//  refresh
//
//  Created by 花菜 on 2018/4/11.
//  Copyright © 2018年 Cai.flower. All rights reserved.
//

#import "SFRefreshComponent.h"

@interface SFRefreshFooterView : SFRefreshComponent
@property (nonatomic,assign) BOOL  noMoreData;
- (void)noticeNoMoreData;
- (void)resetNoMoreData;
@end
