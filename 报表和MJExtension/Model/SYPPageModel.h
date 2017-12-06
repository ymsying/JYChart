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

@property (nonatomic, copy) NSDictionary <NSString *, SYPPartModel *> *parts;
@property (nonatomic, strong) SYPFilterModel *filter;
@property (nonatomic, copy, readonly) NSArray <NSString *> *tabControl;

+ (instancetype)pageModel:(NSDictionary *)info;

@end
