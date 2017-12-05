//
//  SYPCloseButton.m
//  各种报表
//
//  Created by niko on 17/4/27.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPBlockButton.h"

@implementation SYPCallbackButtonHelper

- (void)callBtnhandler {
    self.button.selected = !self.button.selected;
    self.handler(self.button.selected);
}

@end


@interface SYPBlockButton ()
@property (nonatomic, strong) SYPCallbackButtonHelper *helper;
@end

@implementation SYPBlockButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    SYPBlockButton *btn = [super buttonWithType:buttonType];
    if (btn) {
        SYPCallbackButtonHelper *helper = [[SYPCallbackButtonHelper alloc] init];
        helper.button = btn;
        btn.helper = helper;
        [btn addTarget:btn.helper action:@selector(callBtnhandler) forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

- (void)setHandler:(callHander)handler {
    self.helper.handler = handler;
}

@end
