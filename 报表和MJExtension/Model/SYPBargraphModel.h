//
//  SYPBargraphModel.h
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/29.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPBaseChartModel.h"
#import "SYPColourPointModel.h"

typedef NS_ENUM(NSUInteger, SYPBargraphModelSortType) {
    SYPBargraphModelSortNone = 0,
    SYPBargraphModelSortProNameUp,
    SYPBargraphModelSortProNameDown,
    SYPBargraphModelSortRatioUp,
    SYPBargraphModelSortRatioDown,
};


/**
 条状图
 */
@interface SYPBargraphModel : SYPBaseChartModel

@property (nonatomic, copy) NSDictionary *config;
@property (nonatomic, copy) NSNumber *index;
@property (nonatomic, copy) NSArray <NSString *> *xAxisData;
@property (nonatomic, copy) NSString *xAxisName;
@property (nonatomic, copy) NSString *seriesName;
@property (nonatomic, copy) NSNumber *seriesPercentage;
@property (nonatomic, copy) NSArray <SYPColourPointModel *> *seriesData;

- (void)sortedSeriesList:(SYPBargraphModelSortType)type;

@end
