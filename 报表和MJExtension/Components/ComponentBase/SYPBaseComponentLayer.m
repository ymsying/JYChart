//
//  SYPBaseComponentView.m
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPBaseComponentLayer.h"

@implementation SYPBaseComponentLayer

- (void)setModel:(SYPBaseChartModel *)model {
    if (![_model isEqual:model]) {
        _model = model;
    }
    [self refreshSubViewData];
}

- (void)refreshSubViewData {
    
}

- (CGFloat)estimateViewHeight:(SYPBaseChartModel *)model {
    return 0;
}

@end
