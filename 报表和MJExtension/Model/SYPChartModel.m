//
//  SYPChartModel.m
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/29.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPChartModel.h"


#pragma mark -
@implementation SYPChartSeriesModel {
    NSString *maxValue;
    NSString *minValue;
    NSArray *colors;
}

- (NSString *)maxValue {
    if (!maxValue) {
        [self.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                if ([obj[@"value"] floatValue] > [maxValue floatValue]) {
                    maxValue = obj;
                }
            } else if ([obj isKindOfClass:[NSString class]]) {
                if ([obj floatValue] > [maxValue floatValue]) {
                    maxValue = obj;
                }
            }
        }];
    }
    return maxValue;
}

- (NSString *)minValue {
    if (!minValue) {
        [self.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                if ([obj[@"value"] floatValue] < [maxValue floatValue]) {
                    minValue = obj;
                }
            } else if ([obj isKindOfClass:[NSString class]]) {
                if ([obj floatValue] < [maxValue floatValue]) {
                    minValue = obj;
                }
            }
        }];
    }
    return minValue;
}

- (NSArray *)data{
    
    if ([_data[0] isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *tempData = [NSMutableArray arrayWithCapacity:_data.count];
        NSMutableArray *tempColor = [NSMutableArray arrayWithCapacity:_data.count];
        [_data enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tempData addObject:[obj objectForKey:@"value"]];
            [tempColor addObject:[obj objectForKey:@"color"]];
        }];
        colors = [tempColor copy];
        return [tempData copy];
    } else {
        return _data;
    }
}

- (NSArray *)colors {
    if (!colors) {
        NSMutableArray *tempColor = [NSMutableArray arrayWithCapacity:_data.count];
        [_data enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tempColor addObject:[obj objectForKey:@"color"]];
        }];
        colors = [tempColor copy];
    }
    return colors;
}

@end


////////////////////////////////////
#pragma mark -
@implementation SYPChartModel {
    NSArray <NSNumber *> *seriesColor;
    CGFloat maxValue;
    CGFloat minValue;
    NSInteger maxLength;
    NSInteger minLengthSeriesIdx;
    NSInteger minLength;
    NSInteger maxLengthSeriesIdx;
    NSArray *seriesName;
    NSArray *floatRatio;
}
//
//- (NSString *)description {
//    return [NSString stringWithFormat:@"<%@ : %p> %@", [self class], self, [self mj_keyValues]];
//}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"series" : @"SYPChartSeriesModel",
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary:[super mj_replacedKeyFromPropertyName]];
    [replaced setValuesForKeysWithDictionary:@{
                                               @"xAxis" : @"config.xAxis",
                                               @"legend" : @"config.legend",
                                               @"series" : @"config.series",
                                               @"yAxisUnit" : @"config.yAxis[0].name",
                                               }];
    return replaced;
}

- (BOOL)verifyIntegrality:(NSError *__autoreleasing *)error {
    __block BOOL integrality = YES;
    // 当各条线的点个数与x轴上的刻度数不同时，模型数据不对
    [self.series enumerateObjectsUsingBlock:^(SYPChartSeriesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.data.count != self.xAxis.count) {
            *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:110 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"第%zi条数据点个数与x轴上的刻度数不同，请检查数据", idx]}];
            integrality = NO;
        }
    }];
    
    return integrality;
}

// 对已有series数据进行处理长度不一致，将所有线的长度按x轴数量length0处理，大于length0的去掉多余的，小于的在后续中处理
- (NSArray<SYPChartSeriesModel *> *)getSeries {
    if (_series) {
        if (_series.count == 1) return _series; // 大于两条的时候进行处理
        
        NSInteger destineLength = _series[0].data.count;
        for (int i = 1; i < _series.count; i++) {
            NSMutableArray *tempSeriesData = [NSMutableArray arrayWithArray:_series[i].data];
            if (tempSeriesData.count > destineLength) {
                NSArray *seriesData = [tempSeriesData subarrayWithRange:NSMakeRange(0, destineLength)];
                _series[i].data = [seriesData copy];
            }
        }
    }
    return _series;
}

- (NSArray<NSNumber *> *)seriesColor {
    if (!seriesColor) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.series[0].data.count];
        [self.series[0].colors enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [temp addObject:[SYPBaseChartModel arrowToColor:[obj integerValue]]];
        }];
        seriesColor = [temp copy];
    }
    return seriesColor;
}

- (CGFloat)maxValue {
    if (!maxValue) {
        __block CGFloat value = 0;
        [self.series enumerateObjectsUsingBlock:^(SYPChartSeriesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj floatValue] > value) {
                    value = [obj floatValue];
                }
            }];
        }];
        maxValue = value;
    }
    
    return maxValue;
}

- (CGFloat)minValue {
    if (!minValue) {
        __block CGFloat value = 0;
        [self.series enumerateObjectsUsingBlock:^(SYPChartSeriesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj floatValue] < value) {
                    value = [obj floatValue];
                }
            }];
        }];
        minValue = value;
    }
    return minValue;
}


- (NSArray *)yAxisDataList {
    NSInteger abs = [self maxValue] - [self minValue];
    while (abs % 4 != 0) {
        abs++;
    }
    
    NSInteger per = abs / 4;
    NSMutableArray *yAxisArr = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 4; i++) {
        NSInteger value = per * (4 - i) + minValue;
        [yAxisArr addObject:[NSString stringWithFormat:@"%zi", value]];
    }
    
    return [yAxisArr copy];
}

- (NSInteger)maxLength {
    if (!maxLength) {
        [self.series enumerateObjectsUsingBlock:^(SYPChartSeriesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.data.count > maxLength) {
                maxLength = obj.data.count;
                maxLengthSeriesIdx = idx;
            }
        }];
    }
    return maxLength;
}

- (NSInteger)minLength {
    if (!minLength) {
        minLength = NSNotFound;
        [self.series enumerateObjectsUsingBlock:^(SYPChartSeriesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.data.count < minLength) {
                minLength = obj.data.count;
                minLengthSeriesIdx = idx;
            }
        }];
    }
    return minLength;
}

- (NSInteger)maxLengthSeriesIdx {
    if (!maxLengthSeriesIdx) {
        [self maxLength];
    }
    return maxLengthSeriesIdx;
}

- (NSInteger)minLengthSeriesIdx {
    if (!minLengthSeriesIdx) {
        [self minLength];
    }
    return minLengthSeriesIdx;
}

- (NSArray *)seriesName {
    if (!seriesName) {
        NSMutableArray *tempSeriesName = [NSMutableArray arrayWithCapacity:self.series.count];
        [self.series enumerateObjectsUsingBlock:^(SYPChartSeriesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tempSeriesName addObject:obj.name];
        }];
        seriesName = [tempSeriesName copy];
    }
    return seriesName;
}

- (NSArray *)floatRatio {
    if (!floatRatio) {
        NSMutableArray *tempSeriesName = [NSMutableArray arrayWithCapacity:self.seriesColor.count];
        for (int i = 0; i < self.seriesColor.count; i++) {
            if (i >= self.minLength) {
               [tempSeriesName addObject:@"暂无数据"];
                continue;
            }
            CGFloat mainData = [[self.series[0].data[i] stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
            CGFloat subData = [[self.series[1].data[i] stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
            
            CGFloat ratio = (mainData - subData) / subData;
            
            NSString *ratioStr = [NSString stringWithFormat:@"%@%.2lf", (ratio >= 0 ? @"+" : @""), ratio];
            [tempSeriesName addObject:ratioStr];
        }
        floatRatio = [tempSeriesName copy];
    }
    return floatRatio;
}

@end
