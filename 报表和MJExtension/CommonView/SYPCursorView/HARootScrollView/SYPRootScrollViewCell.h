//
//  SYPRootScrollViewCell.h
//  SYPRootScrollView
//
//  Created by haha on 15/7/23.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYPRootScrollView;

@interface SYPRootScrollViewCell : UIView

@property (nonatomic, copy) NSString *identifier;

+ (instancetype)cellWithRootScrollView:(SYPRootScrollView *)rootScrollView;
- (void)setpageViewInCell:(UIView *)pageView;

@end
