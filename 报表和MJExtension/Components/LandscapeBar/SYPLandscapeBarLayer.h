//
//  SYPLandscapeBar.h
//  各种报表
//
//  Created by niko on 17/5/4.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPBaseComponentLayer.h"


@class SYPLandscapeBarLayer;
@protocol SYPLandscapeBarDelegate <NSObject>

// 其它视图可根据子高高度进行相应的调整
- (void)landscapeBar:(SYPLandscapeBarLayer *)bar refreshHeight:(CGFloat)height;

@end

/**
 * 横向条状图
 * 按0点分列，左右两边均取数据的绝对值进行渲染
 * 该view高度可以自适应(在绘制完柱状后，根据柱状的多少进行自适应)
 * 需要注意，自适应后通过delegate向外发出通知，其它视图应在收到通知后进行相应调整
 */
@interface SYPLandscapeBarLayer : SYPBaseComponentLayer

@property (nonatomic, assign) id <SYPLandscapeBarDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray *pionts;

@property (nonatomic, assign) BOOL autoLayoutHeight;


@end
