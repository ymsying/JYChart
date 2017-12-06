//
//  SYPPartModel.h
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/29.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYPBaseChartModel.h"

/**
 每页中大分类，
 */
@interface SYPPartModel : NSObject

@property (nonatomic, copy) NSArray <SYPBaseChartModel *> *chartList;

@end
