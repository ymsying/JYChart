//
//  SYPColourPointModel.m
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/30.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPColourPointModel.h"
#import "SYPBaseChartModel.h"
#import "MJExtension.h"

@implementation SYPColourPointModel {
    UIColor *color1;
}

- (UIColor *)color1 {
    if (!color1) {
        color1 = [SYPBaseChartModel arrowToColor:[self.color integerValue]];
    }
    return color1;
}

@end
