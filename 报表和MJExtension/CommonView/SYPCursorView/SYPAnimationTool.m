//
//  SYPAnimationTool.m
//  test2
//
//  Created by haha on 15/8/30.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "SYPAnimationTool.h"
#import <UIKit/UIKit.h>

#define SYPAnimationToolDuration       0.5
#define SYPAnimationToolSpringDuration 0.7
#define SYPAnimationToolDamp           0.3
#define SYPAnimationToolVelocity       0.3

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
