//
//  SYPBargraphModel.m
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/29.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPBargraphModel.h"

@implementation SYPBargraphModel {
    
    NSMutableArray <NSNumber *> *sortedIndexList;
}
//
//- (NSString *)description {
//    return [NSString stringWithFormat:@"<%@ : %p> %@", [self class], self, [self mj_keyValues]];
//}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"seriesData" : @"SYPColourPointModel",
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary:[super mj_replacedKeyFromPropertyName]];
    [replaced setValuesForKeysWithDictionary:@{
                                               @"xAxisData" : @"config.xAxis.data",
                                               @"xAxisName" : @"config.xAxis.name",
                                               @"seriesName" : @"config.series.name",
                                               @"seriesData" : @"config.series.data",
                                               @"seriesPercentage" : @"config.series.percentage",
                                               }];
    return replaced;
}

- (void)changeDataSequenceWithType:(SYPBargraphModelSortType)type {
    //NSLog(@"排序顺序：%@", sortedIndexList);
    
    NSMutableArray *destinationSeriesData = [NSMutableArray arrayWithCapacity:sortedIndexList.count];
    NSMutableArray *destinationXAxisData = [NSMutableArray arrayWithCapacity:sortedIndexList.count];
    
    [sortedIndexList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [destinationSeriesData addObject:[self.seriesData objectAtIndex:[obj integerValue]]];
        [destinationXAxisData addObject:[self.xAxisData objectAtIndex:[obj integerValue]]];
    }];
    
    self.seriesData = [destinationSeriesData copy];
    self.xAxisData = [destinationXAxisData copy];
}

- (void)sortedSeriesList:(SYPBargraphModelSortType)type {
    
    NSString *sortKey = @"value";
    NSArray *orginArr = nil;
    if (type == SYPBargraphModelSortRatioDown || type == SYPBargraphModelSortRatioUp) {
        sortKey = @"value";
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.seriesData.count];
        [self.seriesData enumerateObjectsUsingBlock:^(SYPColourPointModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = @{
                                  @"value" : @([obj.value floatValue]),
                                  @"color" : obj.color,
                                  };
            [temp addObject:dic];
        }];
        orginArr = temp;
    }
    else {
        sortKey = @"pinyin";
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:[self.xAxisData count]];
        for (NSString *chinese in self.xAxisData) {
            NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
            [mdic setObject:chinese forKey:@"chinese"];
            [mdic setObject:[self chineseToPinyin:chinese] forKey:@"pinyin"];
            [temp addObject:mdic];
        }
        orginArr = [temp copy];
    }
    
    BOOL ascending = NO;
    switch (type) {
        case SYPBargraphModelSortRatioUp:
            ascending = YES;
            break;
        case SYPBargraphModelSortRatioDown:
            ascending = NO;
            break;
        case SYPBargraphModelSortProNameUp:
            ascending = YES;
            break;
        case SYPBargraphModelSortProNameDown:
            ascending = NO;
            break;
            
        default:
            break;
    }
    
    NSMutableArray *sortedArray = [NSMutableArray arrayWithArray:orginArr];
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:ascending]];
    [sortedArray sortUsingDescriptors:sortDescriptors];
    
    sortedIndexList = [NSMutableArray arrayWithCapacity:sortedArray.count];
    for (NSDictionary *dic in sortedArray) {
        NSInteger index = [orginArr indexOfObjectIdenticalTo:dic];
        [sortedIndexList addObject:@(index)];
    }
    
    [self changeDataSequenceWithType:type];
}

- (NSString *)chineseToPinyin:(NSString *)chinese {
    NSMutableString *mutableString = [NSMutableString stringWithString:chinese];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    
    return [mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
}


@end
