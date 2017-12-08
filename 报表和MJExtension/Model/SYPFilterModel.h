//
//  SYPFilterModel.h
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/29.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYPFilterDataModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray <SYPFilterDataModel *> *data;


@end



@interface SYPFilterModel : NSObject

@property (nonatomic, copy) NSString *display;
@property (nonatomic, copy) NSArray <SYPFilterDataModel *> *data;


- (void)appendSubFilterName:(NSString *)name;

@end
