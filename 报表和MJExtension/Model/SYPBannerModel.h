//
//  SYPBannerModel.h
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/29.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPBaseChartModel.h"

/**
 标题
 */
@interface SYPBannerModel : SYPBaseChartModel

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSDictionary *config;

@end
