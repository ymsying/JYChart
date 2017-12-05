//
//  SYPRootScrollViewManager.m
//  SYPRootScrollView
//
//  Created by haha on 15/7/23.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "SYPRootScrollViewManager.h"
#import "SYPRootScrollViewCell.h"

@implementation SYPRootScrollViewManager

- (void)setPageViews:(NSMutableArray *)pageViews{
    _pageViews = pageViews;
    [self.rootScrollView reloadPageViews];
}

- (id)initWithRootScrollView:(SYPRootScrollView *)rootScrollView{
    self = [super init];
    if (self) {
        self.rootScrollView = rootScrollView;
    }
    return self;
}

- (NSUInteger)numberOfCellInRootScrollView:(SYPRootScrollView *)rootScrollView{
    return self.pageViews.count;
}

- (CGFloat)rootScrollView:(SYPRootScrollView *)rootScrollView marginForType:(SYPRootScrollViewMarginType)type{
    return self.margin;
}

- (SYPRootScrollViewCell *)rootScrollView:(SYPRootScrollView *)rootScrollView AtIndex:(NSUInteger)index{
    SYPRootScrollViewCell *cell = [SYPRootScrollViewCell cellWithRootScrollView:rootScrollView];
    UIView *pageView = self.pageViews[index];
    [cell setpageViewInCell:pageView];
    return cell;
}
@end
