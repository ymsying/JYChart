//
//  SYPSingleValueModel.h
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/29.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPBaseChartModel.h"

@interface SYPSingleValueModel : SYPBaseChartModel

@property (nonatomic, copy) NSDictionary *config;

@property (nonatomic, copy) NSString *mainName;
@property (nonatomic, copy) NSString *subName;
@property (nonatomic, copy) NSString *mainData; // 主数值
@property (nonatomic, copy) NSString *subData; // 对比数值
@property (nonatomic, copy, readonly) NSString *floatRatio;
@property (nonatomic, copy, readonly) NSString *floatValue;
@property (nonatomic, assign) TrendTypeArrow arrow;
/**
 浮动率
 */
@property (nonatomic, copy, readonly) UIColor *arrowToColor;


@end
