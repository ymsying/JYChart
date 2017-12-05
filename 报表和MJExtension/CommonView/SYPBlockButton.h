//
//  SYPCloseButton.h
//  各种报表
//
//  Created by niko on 17/4/27.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^callHander)(BOOL isSelected);

@class SYPBlockButton;
@interface SYPCallbackButtonHelper : NSObject


@property (nonatomic, copy) void(^handler)(BOOL isSelected);
@property (nonatomic, weak) SYPBlockButton *button;

- (void)callBtnhandler;


@end




@interface SYPBlockButton : UIButton

@property (nonatomic, copy) void(^handler)(BOOL isSelected);

@end
