//
//  SYPItemManager.h
//  SYPScrollNavBar
//
//  Created by haha on 15/7/16.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYPScrollNavBar.h"
#import "SYPSortItemView.h"

@interface SYPItemManager : NSObject

@property (nonatomic, weak) SYPScrollNavBar *scrollNavBar;
@property (nonatomic, weak) SYPSortItemView *sortItemView;

+ (id)shareitemManager;

- (void)setItemTitles:(NSMutableArray *)titles;
- (void)removeTitle:(NSString *)title;
- (void)printTitles;
@end
