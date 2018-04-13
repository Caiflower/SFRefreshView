//
//  SFRefreshHeaderView.h
//  refresh
//
//  Created by 花菜 on 2018/4/11.
//  Copyright © 2018年 Cai.flower. All rights reserved.
//

#import "SFRefreshComponent.h"

@interface SFRefreshHeaderView : SFRefreshComponent
- (void)start;
- (void)stop;
- (void)offsetChange:(NSDictionary *)change ;
@end
