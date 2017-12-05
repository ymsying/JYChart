//
//  SYPPortraitBar.h
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPBaseComponentLayer.h"


@class SYPPortraitBar;
@protocol SYPPortraitBarDelegate <NSObject>

// 其它视图可根据子高高度进行相应的调整
- (void)portraitBar:(SYPPortraitBar *)bar refreshWidth:(CGFloat)width;

@end

/**
 * 纵向柱状图
 * 该view宽度可以自适应(在绘制完柱状后，根据柱状的多少进行自适应)
 * 需要注意，自适应后通过delegate向外发出通知，其它视图应在收到通知后进行相应调整
 * 同时展示两条柱状，主值和对比值
 */
@interface SYPPortraitBar : SYPBaseComponentLayer

@property (nonatomic, assign) id <SYPPortraitBarDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray *pionts;
@property (nonatomic, strong) NSArray <UIColor *> *selectColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, assign) NSInteger selectedIndex;

@end
