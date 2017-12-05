//
//  SYPConstantEnum.h
//  各种报表2封装
//
//  Created by 应明顺 on 2017/11/28.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#ifndef SYPConstantEnum_h
#define SYPConstantEnum_h


typedef NS_ENUM(NSUInteger, TrendTypeArrow) {
    TrendTypeArrowUpRed         = 0,
    TrendTypeArrowUpYellow      = 1,
    TrendTypeArrowUpGreen       = 2,
    TrendTypeArrowDownRed       = 3,
    TrendTypeArrowDownYellow    = 4,
    TrendTypeArrowDownGreen     = 5,
    TrendTypeArrowNoArrow       = NSNotFound,
};

typedef NS_ENUM(NSUInteger, SYPChartType) {
    SYPChartTypeBanner           = 0, // 顶部说明，轮播
    SYPChartTypeLineOrHistogram  = 1, // 线性折线图\柱状图
    SYPChartTypeTables           = 2, // excel
    SYPChartTypeInfo             = 3, // 副标题说明
    SYPChartTypeSingleValue      = 4, // 单值对比图
    SYPChartTypeBargraph         = 5, // 横向条状图
    SYPChartTypeLine             = 6, // 线性折线图
    SYPChartTypeCartHistogram    = 7, // 柱状图
};


#endif /* SYPConstantEnum_h */
