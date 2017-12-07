//
//  UIColor+Utility.h
//  ddd
//
//  Created by niko on 16/8/27.
//  Copyright © 2016年 niko. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct
{
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat a;
}RGBA;

@interface UIColor (SYPUtility)

/**
 *  获取UIColor对象的RGBA值
 *
 *  @param color UIColor
 *
 *  @return RGBA
 */
RGBA RGBAFromUIColor(UIColor *color);



+ (UIColor *)randomColor;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

- (UIColor *)appendAlpha:(CGFloat)alpha;

@end
