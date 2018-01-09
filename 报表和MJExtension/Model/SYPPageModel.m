//
//  SYPPageModel.m
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/29.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPPageModel.h"
#import "SYPChartModel.h"

@interface SYPPageModel () {
    NSString *lastestFilter;
}

@property (nonatomic, copy) NSArray <NSString *> *tabControl;
@property (nonatomic, strong) SYPFilterModel *filter;
@property (nonatomic, copy) NSArray <SYPBaseChartModel *> *parts;
@property (nonatomic, copy) NSArray <SYPBaseChartModel *> *filteredList;
@property (nonatomic, copy) NSArray <SYPPartModel *> *filteredPartList;


@end


@implementation SYPPageModel

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> %@", [self class], self, [self mj_keyValues]];
}

- (void)dealloc {
    [self.filter removeObserver:self forKeyPath:@"display" context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"display"]) {
        [self filterWithFilter:self.filter];
    }
}

+ (instancetype)pageModel:(NSDictionary *)info {

    NSArray *parts = info[@"parts"];
    NSMutableArray *tabTitles = [NSMutableArray arrayWithCapacity:5];// 预估不超过5个左右
    // 设置图表数组
    NSMutableArray <SYPBaseChartModel *> *chartList = [NSMutableArray arrayWithCapacity:parts.count];
    for (NSDictionary *dic in parts) {

        NSString *partKey = dic[@"page_title"];
        // 设置页签，可为@""
        if (![tabTitles containsObject:partKey] && partKey) {
//            partKey = [partKey isEqualToString:@""] ? @" " : partKey;
            [tabTitles addObject:partKey];
        }
        
        NSString *type = [dic[@"type"] capitalizedString];
        type = [type mj_camelFromUnderline];
        Class klass = NSClassFromString([NSString stringWithFormat:@"SYP%@Model", type]);
        SYPBaseChartModel *baseChart = [klass mj_objectWithKeyValues:dic];
        
        [chartList addObject:baseChart];
    }
    
    SYPFilterModel *filter = [SYPFilterModel mj_objectWithKeyValues:info[@"filter"]];
    SYPPageModel *pageModel = [[SYPPageModel alloc] init];
    pageModel.filter = filter;
    pageModel.parts = chartList;
    pageModel.tabControl = tabTitles;

    [filter addObserver:pageModel forKeyPath:@"display" options:NSKeyValueObservingOptionNew context:NULL];
    return pageModel;
}

- (NSArray<NSString *> *)tabControl {
    // 整理选项卡
    NSMutableArray *tabs = [NSMutableArray array];
    [self.parts enumerateObjectsUsingBlock:^(SYPBaseChartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![tabs containsObject:obj.pageTitle]) {
            [tabs addObject:obj.pageTitle];
        }
    }];
    _tabControl = [tabs copy];
    return _tabControl;
}

- (void)filterWithFilter:(SYPFilterModel *)filter {
    
    if ([filter.display isEqualToString:lastestFilter]) return;
    
    if (filter.display.length) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", filter.display];
        NSArray <SYPBaseChartModel *> *parts = [_parts filteredArrayUsingPredicate:predicate];
        // or
        //    NSArray <SYPBaseChartModel *> *parts = [_parts filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SYPBaseChartModel *chartModel, NSDictionary<NSString *,id> * _Nullable bindings) {
        //        return [chartModel.name isEqualToString:filter.display];
        //    }]];
        self.filteredList = parts;
        
    }
    else {
        self.filteredList = [_parts copy];;
    }
    
    lastestFilter = filter.display;
}



// 返回已经过滤了的数组，以便保护原数据; 无过滤条件时返回原数据复印件
- (NSArray<SYPBaseChartModel *> *)parts {
    
    [self filterWithFilter:self.filter];
    
    return self.filteredList;
}


- (NSArray<SYPPartModel *> *)filteredPartList {
    
    NSMutableArray <SYPPartModel *> *temp = [NSMutableArray arrayWithCapacity:self.tabControl.count];
    for (int i = 0; i < self.tabControl.count; i++) {
        SYPPartModel *part = [[SYPPartModel alloc] init];
        
        NSMutableArray <SYPBaseChartModel *> *chartList = [NSMutableArray array];
        part.chartList = chartList;
        [temp addObject:part];
    }
    
    [self.parts enumerateObjectsUsingBlock:^(SYPBaseChartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = [self.tabControl indexOfObject:obj.pageTitle];
        NSMutableArray <SYPBaseChartModel *> *chartList = [NSMutableArray arrayWithArray:temp[index].chartList];
        [chartList addObject:obj];
        
        temp[index].chartList = [chartList copy];
    }];
    
    return [temp copy];
}











@end






