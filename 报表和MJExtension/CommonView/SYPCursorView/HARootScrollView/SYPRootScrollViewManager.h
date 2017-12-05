//
//  SYPRootScrollViewManager.h
//  SYPRootScrollView
//
//  Created by haha on 15/7/23.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYPRootScrollView.h"

@interface SYPRootScrollViewManager : NSObject <SYPRootScrollViewDateSource, SYPRootScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, weak) SYPRootScrollView *rootScrollView;
@property (nonatomic, assign) CGFloat margin;

- (id)initWithRootScrollView:(SYPRootScrollView *)rootScrollView;

@end
