//
//  SYPBaseComponentView.h
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPBaseChartModel.h"
#import "SYPConstantSize.h"

@protocol SYPBaseComponentViewProtocal <NSObject>

@required
/* 刷新数据 */
- (void)refreshSubViewData;

@end

@interface SYPBaseComponentLayer : UIView <SYPBaseComponentViewProtocal>

/* 默认无，当设置时，自动实现动画效果 */
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, strong) SYPBaseChartModel *model;

- (CGFloat)estimateViewHeight:(SYPBaseChartModel *)model;

@end
