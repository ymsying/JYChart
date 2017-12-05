//
//  SYPTrendTypeImageView.m
//  各种报表
//
//  Created by niko on 17/4/28.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPTrendTypeImageView.h"
#import <objc/runtime.h>

#import "UIColor+SYPUtility.h"

@interface SYPTrendTypeImageView ()

@end

@implementation SYPTrendTypeImageView

- (void)setArrow:(TrendTypeArrow)arrow {
    
    _arrow = arrow;
    NSString *imageName = @"up_redarrow";
    switch (arrow) {
        case TrendTypeArrowUpRed:
            imageName = @"up_redarrow";
            break;
        case TrendTypeArrowUpYellow:
            imageName = @"up_yellowarrow";
            break;
        case TrendTypeArrowUpGreen:
            imageName = @"up_greenarrow";
            break;
        case TrendTypeArrowDownRed:
            imageName = @"down_redarrow";
            break;
        case TrendTypeArrowDownYellow:
            imageName = @"down_yellowarrow";
            break;
        case TrendTypeArrowDownGreen:
            imageName = @"down_greenarrow";
            break;
        case TrendTypeArrowNoArrow:
            imageName = @"";
            break;
            
        default:
            break;
    }
    
    self.image = [UIImage imageNamed:imageName];
}


@end
