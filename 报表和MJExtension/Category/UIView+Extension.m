//
//  SYPScrollLabel.m
//  仿网易新闻滚动列表
//
//  Created by haha on 15/3/19.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>

CGFloat navStsH;
CGFloat navH;
CGFloat stsH;
CGFloat tabH;
static char *ViewController = "viewControllerFlag";

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
//    self.width = size.width;
//    self.height = size.height;
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}


#pragma mark -

- (UIViewController *)viewController {
    
    UIViewController *vc = objc_getAssociatedObject(self, ViewController);
    if (!vc) {
        for (UIView* next = [self superview]; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                vc = (UIViewController *)nextResponder;
                objc_setAssociatedObject(self, ViewController, vc, OBJC_ASSOCIATION_ASSIGN);
                break;
            }
        }
    }
    return vc;
}

- (CGFloat)navStsH {
    
    navStsH = self.navH + self.stsH;
    return navStsH;
}

- (CGFloat)stsH {
    if (!stsH) {
        stsH = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return stsH;
}

- (CGFloat)navH {
    if (!navH) {
        navH = self.viewController.navigationController.navigationBar.frame.size.height;
    }
    return navH;
}

- (CGFloat)tabH {
    if (!tabH) {
        tabH = self.viewController.tabBarController.tabBar.frame.size.height;
    }
    return tabH;
}

// 通过归解档的方式来复制UIView
- (UIView *)copy {
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}


// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen
{
    if (self == nil) {
        return FALSE;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    
    // 若view 隐藏
    if (self.hidden) {
        return FALSE;
    }
    
    // 若没有superview
    if (self.superview == nil) {
        return FALSE;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  FALSE;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    
    return TRUE;
}


@end
