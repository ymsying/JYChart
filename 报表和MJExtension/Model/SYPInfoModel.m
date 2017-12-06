//
//  SYPInfoModel.m
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/29.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPInfoModel.h"

@implementation SYPInfoModel
//
//- (NSString *)description {
//    return [NSString stringWithFormat:@"<%@ : %p> %@", [self class], self, [self mj_keyValues]];
//}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary:[super mj_replacedKeyFromPropertyName]];
    [replaced setValuesForKeysWithDictionary:@{
                                               @"title": @"config.title"
                                               }];
    return replaced;
}

@end
