//
//  SYPClickableLine.h
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPBaseComponentLayer.h"

@class SYPClickableLineLayer;
@protocol SYPClickableLineLayerDelegate <NSObject>

- (void)clickableLine:(SYPClickableLineLayer *)clickableLine didSelected:(NSInteger)index data:(id)data;

@end

/*
 可以点击的折线图、趋势图、柱状图复合图
 根据lineParms传入的数据来决定显示几条折线，
 */
@interface SYPClickableLineLayer : SYPBaseComponentLayer

/*
 存储显示折线的数据，包括折线条数、折线颜色、折线关键点列表，传入字典类型
 @{
 @"series" : self.chartModel.series[i],
 @"color"  : lineColors[i]
 }
*/
@property (nonatomic, strong) NSDictionary <NSString *, NSDictionary *> *lineParms; // 折线图的参数
@property (nonatomic, weak) id <SYPClickableLineLayerDelegate> delegate;
/**
 视图中关键点最多的一条折线的数据
 */
@property (nonatomic, strong, readonly) NSArray *points;


//// 返回值为NO时说明已尽到了最大值了无法显示，
//- (BOOL)showFlagPointAtIndex:(NSInteger)index;

@end
