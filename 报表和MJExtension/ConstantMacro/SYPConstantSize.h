//
//  SYPConstantSize.h
//  各种报表2封装
//
//  Created by 应明顺 on 2017/11/28.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#ifndef SYPConstantSize_h
#define SYPConstantSize_h

////////////////////////////////////////////////////
#pragma mark - size

#define SYPScreenWidth [[UIScreen mainScreen] bounds].size.width
#define SYPScreenHeight [[UIScreen mainScreen] bounds].size.height
#define SYPViewWidth CGRectGetWidth(self.bounds)
#define SYPViewHeight CGRectGetHeight(self.bounds)
#define SYPVCWidth CGRectGetWidth(self.view.bounds)
#define SYPVCHeight CGRectGetHeight(self.view.bounds)

#define SYPViewWidth1(view) CGRectGetWidth(view.bounds)
#define SYPViewHeight1(view) CGRectGetHeight(view.bounds)
#define SYPViewMaxX1(view) CGRectGetMaxX(view.frame)
#define SYPViewMaxY1(view) CGRectGetMaxY(view.frame)
#define SYPViewMinX1(view) CGRectGetMinX(view.frame)
#define SYPViewMinY1(view) CGRectGetMinY(view.frame)

#define SYPScreenRatio (SYPScreenWidth / 375.0)

#define kStaH CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
#define kNavH CGRectGetHeight([[UINavigationController alloc] init].navigationBar.frame)


////////////////////////////////////////////////////
#pragma mark - number

#define SYPDefaultMargin (8.0)
#define kBarHeight (20.0)



#endif /* SYPConstantSize_h */
