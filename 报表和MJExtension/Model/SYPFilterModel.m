//
//  SYPFilterModel.m
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/29.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPFilterModel.h"
#import "MJExtension.h"

@implementation SYPFilterDataModel {
    NSString *filterName;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"<%@ %p> %@", [self class], self, [self mj_keyValues]];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id",
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"SYPFilterDataModel",
             };
}


@end

@implementation SYPFilterModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"SYPFilterDataModel",
             };
}

- (void)appendSubFilterName:(NSString *)name {
    
    self.display = [self.display stringByAppendingString:[NSString stringWithFormat:@"||%@", name]];
}



@end
