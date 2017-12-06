//
//  SYPBaseCharModel.m
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/29.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPBaseChartModel.h"


@implementation SYPBaseChartModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"pageTitle" : @"page_title",
             };
}

- (BOOL)verifyIntegrality:(NSError *__autoreleasing *)error {
    
    return YES;
}

- (NSString *)description {

    return [NSString stringWithFormat:@"<%@ %p> %@", [self class], self, [self mj_keyValues]];
}

- (SYPChartType )chartType {

    NSString *typeStr = self.type;
    SYPChartType type = NSNotFound;
    if ([@"banner" isEqualToString:typeStr]) {
        type = SYPChartTypeBanner;
    }
    else if ([@"chart" isEqualToString:typeStr]) {
        type = SYPChartTypeLineOrHistogram;
    }
    else if ([@"info" isEqualToString:typeStr]) {
        type = SYPChartTypeInfo;
    }
    else if ([@"single_value" isEqualToString:typeStr]) {
        type = SYPChartTypeSingleValue;
    }
    else if ([@"bargraph" isEqualToString:typeStr]) {
        type = SYPChartTypeBargraph; // 横向条状图
    }
    else if ([@"tables" isEqualToString:typeStr]) {
        type = SYPChartTypeTables;
    }
    return type;
}



+ (UIColor *)arrowToColor:(TrendTypeArrow)arrow {
    UIColor *color;
    
    switch (arrow) {
        case TrendTypeArrowUpRed:
        case TrendTypeArrowDownRed:
            color = SYPColor_ArrowColor_Red;
            break;
            
        case TrendTypeArrowUpGreen:
        case TrendTypeArrowDownGreen:
            color = SYPColor_ArrowColor_Green;
            break;
            
        case TrendTypeArrowUpYellow:
        case TrendTypeArrowDownYellow:
            color = SYPColor_ArrowColor_Yellow;
            break;
            
        case TrendTypeArrowNoArrow:
            color = SYPColor_ArrowColor_Unkown;
            break;
            
        default:
            color = [UIColor lightGrayColor]; // 灰色表示未定义
            break;
    }
    
    return color;
}


@end
