//
//  SYPModuleTwoBaseView.h
//  各种报表
//
//  Created by niko on 17/5/8.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPBaseChartModel.h"
#import "SYPConstantSize.h"
#import "SYPConstantColor.h"

@class SYPBaseComponentView;

@protocol SYPBaseComponentViewDelegate <NSObject>

@optional
- (void)moduleTwoBaseView:(SYPBaseComponentView *)moduleTwoBaseView didSelectedAtIndex:(NSInteger)idx data:(id)data;

@end

@interface SYPBaseComponentView : UIView


@property (nonatomic, strong) SYPBaseChartModel *moduleModel;
@property (nonatomic, weak) id <SYPBaseComponentViewDelegate> delegate;

- (void)refreshSubViewData;


/**
 视图根据所传入的对象模型，预判视图可能需要的高度
 */
- (CGFloat)estimateViewHeight:(SYPBaseChartModel *)model;



@end
