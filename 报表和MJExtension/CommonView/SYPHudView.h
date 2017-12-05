//
//  SYPHudView.h
//  各种报表
//
//  Created by niko on 17/5/16.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 实现短小的弹出框，仅包含文字内容
 */
@interface SYPHudView : UIView

+ (void)showHUDWithTitle:(NSString *)title;

@end
