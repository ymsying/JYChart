//
//  SYPModuleTwoCell.h
//  各种报表
//
//  Created by niko on 17/5/8.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPBaseComponentView.h"


@class SYPPartViewCell;
@protocol SYPModuleTwoCellDelegate <NSObject>

- (void)moduleTwoCell:(SYPPartViewCell *)moduleTwoCell didSelectedAtBaseView:(SYPBaseComponentView *)baseView Index:(NSInteger)idx data:(id)data;

@end

/**
 每种类型的报表中使用TableViewCell
 cell中具体的contentView根据数据决定
 */
@interface SYPPartViewCell : UITableViewCell

@property (nonatomic, strong) SYPBaseChartModel *viewModel;

@property (nonatomic, weak) id<SYPModuleTwoCellDelegate>delegate;

- (CGFloat)cellHeightWithModel:(SYPBaseChartModel *)model;


@end

