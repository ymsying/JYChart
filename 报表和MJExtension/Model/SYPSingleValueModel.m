//
//  SYPSingleValueModel.m
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/29.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPSingleValueModel.h"

@implementation SYPSingleValueModel {
    UIColor *arrowToColor;
    NSString *floatRatio;
    NSString *floatValue;
}
//
//- (NSString *)description {
//    return [NSString stringWithFormat:@"<%@ : %p> %@", [self class], self, [self mj_keyValues]];
//}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary:[super mj_replacedKeyFromPropertyName]];
    [replaced setValuesForKeysWithDictionary:@{
                                               @"mainName" : @"config.main_data.name",
                                               @"subName" : @"config.sub_data.name",
                                               @"mainData" : @"config.main_data.data",
                                               @"subData" : @"config.sub_data.data",
                                               @"floatRatio" : @"config.series.data",
                                               @"arrow" : @"config.state.color",
                                               }];
    return replaced;
}

- (UIColor *)arrowToColor {
    if (!arrowToColor) {
        arrowToColor = [SYPBaseChartModel arrowToColor:self.arrow];
    }
    return arrowToColor;
}

- (NSString *)floatRatio {
    if (!floatRatio) {
        CGFloat ratio = ([self.mainData floatValue] - [self.subData floatValue]) / [self.subData floatValue] * 100;
        floatRatio = [NSString stringWithFormat:@"%@%0.2f％", (ratio > 0 ? @"+" : @"") ,ratio];
    }
    return floatRatio;
}

- (NSString *)floatValue {
    if (!floatValue) {
        long int value = lrintf([self.mainData floatValue] - [self.subData floatValue]);
        floatValue = [NSString stringWithFormat:@"%@%ld％", (value > 0 ? @"+" : @"") ,value];
    }
    return floatValue;
}

@end
