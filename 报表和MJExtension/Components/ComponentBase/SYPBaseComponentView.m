//
//  SYPModuleTwoBaseView.m
//  各种报表
//
//  Created by niko on 17/5/8.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPBaseComponentView.h"

@implementation SYPBaseComponentView


- (void)setModuleModel:(SYPBaseChartModel *)moduleModel {
    if (![_moduleModel isEqual:moduleModel]) {
        _moduleModel = moduleModel;
        [self refreshSubViewData];
    }
}


- (void)refreshSubViewData {
    
}



- (CGFloat)estimateViewHeight:(SYPBaseChartModel *)model {
    return 200.0;
}

@end
