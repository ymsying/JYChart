//
//  SYPTablesModel.m
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/29.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPTablesModel.h"

@implementation SYPTableRowModel {
    NSString *longestValue;
    NSString *rowTitle;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"mainData" : @"SYPColourPointModel",
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"mainData" : @"main_data",
             @"subData" : @"sub_data",
             };
}

- (NSString *)longestValue {
    
    if (!longestValue) {
        longestValue = @"";
        [self.mainData enumerateObjectsUsingBlock:^(SYPColourPointModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            longestValue = (obj.value.length > longestValue.length) ? obj.value : longestValue;
        }];
    }
    
    return longestValue;
}

- (NSString *)rowTitle {
    if (!rowTitle) {
        rowTitle = self.mainData[0].value;
    }
    return rowTitle;
}

@end

//////////////////////// SYPTableConfigModel //////////////////////////////////
@implementation SYPTableConfigModel {
    NSArray *leadLineTitle;
    NSArray *columnLongestValue;
    NSMutableArray *sortIndexList;
    BOOL sortFinish; // 保证排序只调用一次
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"SYPTableRowModel",
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"head" : @"table.head",
             @"data" : @"table.data",
             };
}

- (NSArray<NSString *> *)leadLineTitle {
    if (!leadLineTitle || sortIndexList.count) {
        NSMutableArray *leadTitle = [NSMutableArray arrayWithCapacity:self.data.count];
        [self.data enumerateObjectsUsingBlock:^(SYPTableRowModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = obj.mainData[0].value;
            [leadTitle addObject:title];
        }];
        leadLineTitle = [leadTitle copy];
    }
    return leadLineTitle;
}

- (NSArray<NSString *> *)columnLongestValue {
    if (!columnLongestValue) {
        NSMutableArray *columnValue = [NSMutableArray arrayWithCapacity:self.head.count];
        // 列控制
        for (int column = 0; column < self.head.count; column++) {
            
            NSString *longestString = @"";
            // 行控制
            for (int row = 0; row < self.data.count; row++) {
                SYPTableRowModel *rowModel = self.data[row];
                NSString *cellValue = rowModel.mainData[column].value;
                if (longestString.length < cellValue.length) {
                    longestString = cellValue;
                }
            }
            
            [columnValue addObject:longestString];
        }
        columnLongestValue = [columnValue copy];
    }
    return columnLongestValue;
}

- (NSArray<SYPTableRowModel *> *)data {
    if (_data) {
        if (sortIndexList.count > 0 && !sortFinish) {
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:[_data count]];
            for (int i = 0; i < [_data count]; i++) {
                SYPTableRowModel *rowModel = _data[(sortIndexList ? [sortIndexList[i] integerValue] : i)];
                [temp addObject:rowModel];
            }
            _data = [temp copy];
            sortFinish = YES;
        }
    }
    return _data;
}

// !!!: 排序
/*
 1.取出对应列所有数据，组装成一个数组originList，2.对取出的数组进行按需排序sortList，3.逐一查找sortList在originList中对应的位置，并记录在sortIndexList中,
 4.如果sortList有相同数据，查找originList的下一个数据，直到找到相同数据，并记录位置，5.根据sortIndexList重新组装mianDataModelList，组装成功返回；
 */
- (void)sortMainDataListWithSection:(NSInteger)section ascending:(BOOL)ascending {
    
    //NSLog(@"第%zi列 %@", section, (ascending ? @"升序" : @"降序"));
    sortFinish = NO;
    [sortIndexList removeAllObjects];
    
    // 原始数组
    NSArray <SYPTableRowModel *> *originMainData = self.data;
    // 获取原数据的section位置的数组
    NSMutableArray <NSNumber *> *mainDataAtSectionList = [NSMutableArray arrayWithCapacity:originMainData.count];
    // 从原始数组中提取出要排序列的一组数组，即提取出排序列数组
    for (int i = 0; i < originMainData.count; i++) {
        [mainDataAtSectionList addObject:@([originMainData[i].mainData[section + 1].value floatValue])];
    }
    // 排序列数组进行排序，生成排后列数组
    NSArray *sortedMainDataAtSectionList = [mainDataAtSectionList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];;
        if (!ascending) {
            if (result != NSOrderedSame) {
                result = result * (-1);
            }
        }
        return result;
    }];
    
    // 记录 “排后列数组” 的每个数据在原 “排序列数组” 中的位置
    sortIndexList = [NSMutableArray arrayWithCapacity:mainDataAtSectionList.count];
    for (int i = 0; i < sortedMainDataAtSectionList.count; i++) {
        NSNumber *sortNumber = sortedMainDataAtSectionList[i];
        NSInteger index = [mainDataAtSectionList indexOfObjectIdenticalTo:sortNumber];// indexOfObjectIdenticalTo 比较内存地址
        // 当sortNumber为0时，0的内存地址均相同，因此采用向后查找的方式继续查找
        if ([sortIndexList containsObject:@(index)]) {
            for (NSInteger j = ++index; j < sortedMainDataAtSectionList.count; j++) {
                if ([[mainDataAtSectionList objectAtIndex:j] isEqual:sortNumber]) {
                    [sortIndexList addObject:@(index)];
                    break;
                }
            }
            continue;
        }
        [sortIndexList addObject:@(index)];
    }
    //NSLog(@"sortIndexList:%@", sortIndexList);
    
}



@end



////////////////////////////////////////////////////////////
#pragma mark - SYPTableSubSheetModel
@implementation SYPTableSubSheetModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"SYPTableRowModel",
             };
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"head" : @"head",
             @"data" : @"data",
             };
}

@end


////////////////////////// SYPTablesModel ////////////////////////////////
@implementation SYPTablesModel {
    NSArray *configTitles;
}
//
//- (NSString *)description {
//    return [NSString stringWithFormat:@"<%@ : %p> %@", [self class], self, [self mj_keyValues]];
//}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"config" : @"SYPTableConfigModel",
             };
}

- (NSArray<NSString *> *)configTitles {
    if (!configTitles) {
        NSMutableArray *titles = [NSMutableArray arrayWithCapacity:self.config.count];
        [self.config enumerateObjectsUsingBlock:^(SYPTableConfigModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titles addObject:obj.title];
        }];
        configTitles = [titles copy];
    }
    return configTitles;
}


@end
