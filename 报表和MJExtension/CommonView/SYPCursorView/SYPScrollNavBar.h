//
//  SYPScrollNavBar.h
//  SYPScrollNavBar
//
//  Created by haha on 15/5/2.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPRootScrollView.h"

@interface SYPScrollNavBar : UIScrollView

@property (nonatomic, copy) NSString *currentTitle;

@property (nonatomic, weak  ) SYPRootScrollView *rootScrollView;
@property (nonatomic, strong) UIImage          *backgroundImage;
@property (nonatomic, strong) UIColor          *titleNormalColor;
@property (nonatomic, strong) UIColor          *titleSelectedColor;
@property (nonatomic, strong) UIColor          *backgroundSelectedColor;
@property (nonatomic, weak  ) UIButton         *currectItem;
@property (nonatomic, weak  ) UIButton         *oldItem;
@property (nonatomic, strong) NSMutableArray   *itemKeys;
@property (nonatomic, strong) NSMutableArray   *pageViews;

@property (nonatomic, assign) BOOL             isGraduallyChangColor;
@property (nonatomic, assign) BOOL             isGraduallyChangFont;
@property (nonatomic, assign) BOOL             isButtonAlignmentCenter;
@property (nonatomic, assign) BOOL             isButtonAutoWidth;
@property (nonatomic, assign) BOOL             isButtonShowIndicator;
@property (nonatomic, assign) BOOL             isItemHiddenAfterDelet;
@property (nonatomic, assign) CGFloat          itemW;
@property (nonatomic, assign) CGFloat          offsetX;
@property (nonatomic, assign) NSInteger        minFontSize;
@property (nonatomic, assign) NSInteger        maxFontSize;

- (void)hiddenAllItems;
- (void)showAllItems;
@end
