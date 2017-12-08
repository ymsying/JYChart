//
//  SYPAnimationTool.m
//  test2
//
//  Created by haha on 15/8/30.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "SYPAnimationTool.h"
#import <UIKit/UIKit.h>
#import "SYPConstantString.h"

@implementation SYPAnimationTool

+ (void)animateWithAnimations:(void (^)(void))animator{
    [UIView animateWithDuration:SYPAnimationToolDuration animations:animator];
}

+ (void)animateWithAnimations:(void (^)(void))animator Completion:(void (^)(BOOL))completion{
    [UIView animateWithDuration:SYPAnimationToolDuration animations:animator completion:completion];
}

+ (void)springAnimateWithAnimations:(void (^)(void))animator completion:(void (^)(BOOL))completion{
    [UIView animateWithDuration:SYPAnimationToolSpringDuration delay:0 usingSpringWithDamping:SYPAnimationToolDamp initialSpringVelocity:SYPAnimationToolVelocity options:UIViewAnimationOptionBeginFromCurrentState animations:animator completion:completion];
}

@end
