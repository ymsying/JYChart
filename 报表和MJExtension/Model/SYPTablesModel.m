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
             @"mainData" : @"main_data",
             @"subData" : @"sub_data",
             };
}

- (NSArray<NSString *> *)leadLineTitle {
    if (!leadLineTitle) {
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

@end


////////////////////////// SYPTablesModel ////////////////////////////////
@implementation SYPTablesModel
//
//- (NSString *)description {
//    return [NSString stringWithFormat:@"<%@ : %p> %@", [self class], self, [self mj_keyValues]];
//}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"config" : @"SYPTableConfigModel",
             };
}


@end
