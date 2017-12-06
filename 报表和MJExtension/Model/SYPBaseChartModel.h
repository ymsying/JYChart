//
//  SYPBaseCharModel.h
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/29.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJExtension.h"
#import "SYPConstantColor.h"
#import "SYPConstantEnum.h"


@interface SYPBaseChartModel : NSObject

@property (nonatomic, copy) NSString *pageTitle;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign, readonly) SYPChartType chartType;
//@property (nonatomic, copy) NSDictionary *config;// 每种图形均有config，但表格类型的config不一致，不做提抽象操作


+ (UIColor *)arrowToColor:(TrendTypeArrow)arrow;

- (BOOL)verifyIntegrality:(NSError **)error;

@end
