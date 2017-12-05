//
//  SYPRootScrollView.h
//  SYPRootScrollView
//
//  Created by haha on 15/7/23.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPRootScrollViewCell.h"

typedef enum{
    SYPRootScrollViewMarginTypeTop,
    SYPRootScrollViewMarginTypeBottom,
    SYPRootScrollViewMarginTypeLeft,
    SYPRootScrollViewMarginTypeRight
} SYPRootScrollViewMarginType;

@class SYPRootScrollView;

/**
 * rootScrollView的数据方法
 */
@protocol SYPRootScrollViewDateSource <NSObject>
@required
- (NSUInteger)numberOfCellInRootScrollView:(SYPRootScrollView *)rootScrollView;
- (SYPRootScrollViewCell *)rootScrollView:(SYPRootScrollView *)rootScrollView AtIndex:(NSUInteger)index;
@end

/**
 * rootScrollView的代理方法
 */
@protocol SYPRootScrollViewDelegate <NSObject>
@optional
- (void)rootScrollView:(SYPRootScrollView *)rootScrollView didSelectAtIndex:(NSUInteger)index;

- (CGFloat)rootScrollView:(SYPRootScrollView *)rootScrollView marginForType:(SYPRootScrollViewMarginType)type;
@end

@interface SYPRootScrollView : UIScrollView

@property (nonatomic, weak) id <SYPRootScrollViewDateSource>rootScrollViewDateSource;
@property (nonatomic, weak) id <SYPRootScrollViewDelegate>rootScrollViewDelegate;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat rootScrollWidth;
@property (nonatomic, assign) CGFloat rootScrollHeight;

- (void)reloadPageViews;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
@end
