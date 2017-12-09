//
//  SYPPageModel.h
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/29.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYPPartModel.h"
#import "SYPFilterModel.h"

/**
 每页数据模型
 */
@interface SYPPageModel : NSObject

+ (instancetype)pageModel:(NSDictionary *)info;


@property (nonatomic, strong, readonly) SYPFilterModel *filter;
@property (nonatomic, copy, readonly) NSArray <SYPBaseChartModel *> *parts;
/**
 根据filter过滤后的数据
 */
@property (nonatomic, copy, readonly) NSArray <SYPBaseChartModel *> *filteredList;
/**
 页签数组
 */
@property (nonatomic, copy, readonly) NSArray <NSString *> *tabControl;

/**
 根据filter过滤后的数据
 */
@property (nonatomic, copy, readonly) NSArray <SYPPartModel *> *filteredPartList;

/**
 通过filter过滤出filter中display所标示出来的信息
 */
- (void)filterWithFilter:(SYPFilterModel *)filter;


@end
