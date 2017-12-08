//
//  SYPCursor.h
//  SYPScrollNavBar
//
//  Created by haha on 15/7/6.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYPCursor : UIView

@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, strong) NSArray        *titles;

@property (nonatomic, strong) UIColor        *titleNormalColor;
@property (nonatomic, strong) UIColor        *titleSelectedColor;
/**
 导航栏剧中显示
 */
@property (nonatomic, assign) BOOL           navItemAlignmentCenter;
@property (nonatomic, strong) UIColor        *backgroudSelectedColor;
@property (nonatomic, strong) UIColor        *navLineColor;
@property (nonatomic, strong) UIImage        *backgroundImage;

@property (nonatomic, assign) BOOL           isGraduallyChangColor;
@property (nonatomic, assign) BOOL           isGraduallyChangFont;
@property (nonatomic, assign) NSInteger      minFontSize;
@property (nonatomic, assign) NSInteger      maxFontSize;
@property (nonatomic, assign) NSInteger      defFontSize;
@property (nonatomic, assign) CGFloat        rootScrollViewHeight;

- (id)initWithTitles:(NSArray *)titles AndPageViews:(NSArray *)pageViews;

@end
