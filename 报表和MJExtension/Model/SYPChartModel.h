//
//  SYPChartModel.h
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/29.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPBaseChartModel.h"


/**
 折线图和柱形图的点相关的内容
 */
@interface SYPChartSeriesModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy, readonly) NSString *maxValue;
@property (nonatomic, copy, readonly) NSString *minValue;
/**
 线的点和柱的点的集合，可能包含单个点的值，可能包含点和颜色的值
 */
@property (nonatomic, copy) NSArray *data;
@property (nonatomic, copy, readonly) NSArray *colors;


@end

/**
 折线柱状图
 */
@interface SYPChartModel : SYPBaseChartModel

@property (nonatomic, copy) NSDictionary *config;
@property (nonatomic, copy) NSArray *legend;
/**
 x轴刻度
 */
@property (nonatomic, copy) NSArray *xAxis;

/**
 y轴单位
 */
@property (nonatomic, copy) NSString *yAxisUnit;
/**
 y轴刻度
 */
@property (nonatomic, copy, readonly) NSArray *yAxisDataList;
/**
 线和柱的集合，第一组数据为点及颜色的字典数组集合，其余为单个点的string集合
 */
@property (nonatomic, copy, getter=getSeries) NSArray <SYPChartSeriesModel *> *series;
/**
 从series的第一个组数据获取颜色值
 */
@property (nonatomic, copy, readonly) NSArray <UIColor *> *seriesColor;
/**
 几条线中，长度最长的长度
 */
@property (nonatomic, assign, readonly) NSInteger maxLength;
/**
 几条线中，长度最长序列的index
 */
@property (nonatomic, assign, readonly) NSInteger maxLengthSeriesIdx;
/**
 几条线中，长度最短的长度
 */
@property (nonatomic, assign, readonly) NSInteger minLength;
/**
 几条线中，长度最短的序列的index
 */
@property (nonatomic, assign, readonly) NSInteger minLengthSeriesIdx;

/**
 几条线的标题
 */
@property (nonatomic, copy, readonly) NSArray <NSString *> *seriesName;
/**
 同一时刻的两条线的增长率数据
 */
@property (nonatomic, copy, readonly) NSArray <NSString *> *floatRatio;

@end
