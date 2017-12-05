//
//  SYPHudView.m
//  各种报表
//
//  Created by niko on 17/5/16.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPHudView.h"
#import "SYPConstantSize.h"
#import "SYPConstantColor.h"

@implementation SYPHudView

+ (void)showHUDWithTitle:(NSString *)title {
    
    UILabel *alertLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    alertLable.font = [UIFont systemFontOfSize:13];
    CGSize size = [title boundingRectWithSize:CGSizeMake(SYPScreenWidth, CGRectGetHeight(alertLable.frame)) options:0 attributes:@{NSFontAttributeName: alertLable.font} context:nil].size;
    alertLable.bounds = CGRectMake(0, 0, size.width + 30 * 2, CGRectGetHeight(alertLable.frame));
    alertLable.center = CGPointMake(SYPScreenWidth/2, SYPScreenHeight - 64 - SYPDefaultMargin * 2);
    alertLable.layer.cornerRadius = CGRectGetHeight(alertLable.frame) / 2.0;
    alertLable.clipsToBounds = YES;
    alertLable.text = title;
    alertLable.textColor = [UIColor whiteColor];
    alertLable.backgroundColor = [SYPColor_AlertBackgroudColor_BlackGray appendAlpha:0.8];
    alertLable.textAlignment = NSTextAlignmentCenter;
    [[UIApplication sharedApplication].keyWindow addSubview:alertLable];
    [self performSelector:@selector(removeAlertLB:) withObject:alertLable afterDelay:1.0];
}

+ (void)removeAlertLB:(UILabel *)label {
    [UIView animateWithDuration:0.5 animations:^{
        label.alpha = 0.0;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
    }];
}

@end
