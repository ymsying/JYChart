//
//  SYPItemManager.m
//  SYPScrollNavBar
//
//  Created by haha on 15/7/16.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "SYPItemManager.h"


#define scrollNavBarUpdate @"scrollNavBarUpdate"
#define rootScrollerUpdate @"rootScrollerUpdate"

@interface SYPItemManager()
@property (nonatomic, strong) NSMutableArray *titles;
@end

@implementation SYPItemManager
- (NSMutableArray *)titles{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

+ (id)shareitemManager{
    static SYPItemManager *manger = nil;
    if (manger == nil) {
        manger = [[SYPItemManager alloc]init];
    }
    return manger;
}

- (void)setItemTitles:(NSMutableArray *)titles{
    _titles = titles;
    self.scrollNavBar.itemKeys = titles;
}

- (void)removeTitle:(NSString *)title{
    [self.titles removeObject:title];
}

- (void)printTitles{
    NSLog(@"********************************");
    for (NSString *title in self.titles) {
        NSLog(@"SYPItemManager ---> %@",title);
    }
}
@end
