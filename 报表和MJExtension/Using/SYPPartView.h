//
//  SYPPartView.h
//  各种报表
//
//  Created by niko on 17/5/20.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPPartModel.h"
/**
 某一类型报表
 */
@interface SYPPartView : UIView

@property (nonatomic, strong) SYPPartModel *partModel;
@property (nonatomic, assign) CGFloat offsetExcelHead;

@end
