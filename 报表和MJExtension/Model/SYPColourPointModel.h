//
//  SYPColourPointModel.h
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/30.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 值和颜色
 */
@interface SYPColourPointModel : NSObject

@property (nonatomic, copy) NSString *value;
/**
 颜色对应数值
 */
@property (nonatomic, copy) NSNumber *color;
/**
 真实颜色
 */
@property (nonatomic, copy, readonly) UIColor *color1;

@end
