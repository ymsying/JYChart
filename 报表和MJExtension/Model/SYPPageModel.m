//
//  SYPPageModel.m
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/29.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPPageModel.h"
#import "SYPChartModel.h"

@interface SYPPageModel ()

@property (nonatomic, copy) NSArray <NSString *> *tabControl;

@end

@implementation SYPPageModel

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> %@", [self class], self, [self mj_keyValues]];
}

+ (instancetype)pageModel:(NSDictionary *)info {

    NSDictionary *parts = info[@"parts"];
    NSMutableArray *tabTitles = [NSMutableArray arrayWithCapacity:5];// 预估不超过5个左右
    NSMutableDictionary *partCategory = [NSMutableDictionary dictionary];

    for (NSDictionary *dic in parts) {

        NSString *partKey = dic[@"page_title"];
        // 设置页签
        if (![tabTitles containsObject:partKey] && partKey.length > 0) {
            [tabTitles addObject:partKey];
        }
        SYPPartModel *part = [partCategory objectForKey:partKey];
        if (!part) {
            part = [[SYPPartModel alloc] init];
        }
        // 设置图表数组
        NSMutableArray <SYPBaseChartModel *> *chartList = [NSMutableArray arrayWithArray:[part chartList]];

        NSString *type = [dic[@"type"] capitalizedString];
        type = [type mj_camelFromUnderline];
        Class klass = NSClassFromString([NSString stringWithFormat:@"SYP%@Model", type]);
        SYPBaseChartModel *baseChart = [klass mj_objectWithKeyValues:dic];
        
        [chartList addObject:baseChart];
        part.chartList = chartList;
        
        [partCategory setObject:part forKey:partKey];
    }
    
    
    SYPPageModel *model = [[SYPPageModel alloc] init];
    model.filter = [SYPFilterModel mj_objectWithKeyValues:info[@"filter"]];
    model.parts = [partCategory copy];
    model.tabControl = tabTitles;

    return model;
}


/*
 ///////////////////////////////////////////////////////////////
 //                                                           //
 //                                                           //
 //                                                           //
 //                                                           //
 //                                                           //
 //                                                           //
 //                                                           //
 //                                                           //
 //                                                           //
 //                                                           //
 //                                                           //
 //                                                           //
 //                                                           //
 //                                                           //
 //                                                           //
 //                                                           //
 //                                                           //
 //                                                           //
 //                                                           //
 //                                                           //
 ///////////////////////////////////////////////////////////////
 */














@end






