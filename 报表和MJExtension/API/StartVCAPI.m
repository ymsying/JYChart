//
//  StartVCAPI.m
//  报表和MJExtension
//
//  Created by 钱宝峰 on 2018/1/10.
//  Copyright © 2018年 应明顺. All rights reserved.
//

#import "StartVCAPI.h"

@implementation StartVCAPI


-(NSString *)requestUrl {
    return @"http://yonghui-test.idata.mobi/api/v1.1/app/component/reports";
}

-(YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

-(id)requestArgument {
    return @{
             @"_app_version" : @"i1.5.3",
             @"_coordinate" : @"-122.019733,37.326914",
             @"_user_device_id" : @"19747",
             @"_user_num" : @"13162726850",
             @"api_token" : @"100d575b3bb087751e4193fa63cfee44",
             @"group_id" : @"165",
             @"role_id" : @"99"
             };
}

@end
