//
//  SYPSortButton.h
//  SYPScrollNavBar
//
//  Created by haha on 15/7/10.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYPSortButton : UIButton

@property (nonatomic, assign) BOOL isScareing;

- (void)itemShake;
- (void)itemStop;
- (void)itemShakeWithItem;
- (void)itemStopWithItem;
- (void)itemlittleScare;
@end
