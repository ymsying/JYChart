//
//  SYPCompareSaleView.m
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPCompareSaleView.h"

#import "SYPTrendTypeImageView.h"

@interface SYPCompareSaleView () {
    UIButton *ratio;
    SYPTrendTypeImageView *arrowView;
    UILabel *actualLB;
    UILabel *targetLB;
    UILabel *actualTitleLB;
    UILabel *targetTitleLB;
    NSInteger ratioShowIndex; // 对比处显示数据对应的下标，0:主值、1:变化率、2:对比值
}

@property (nonatomic, strong) SYPSingleValueModel *singleValueModel;

@end

@implementation SYPCompareSaleView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        ratioShowIndex = 0;
        [self initializeSubView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        ratioShowIndex = 0;
        [self initializeSubView];
    }
    return self;
}

- (SYPSingleValueModel *)singleValueModel {
    if (!_singleValueModel) {
        _singleValueModel = (SYPSingleValueModel *)self.moduleModel;
    }
    return _singleValueModel;
}

- (void)initializeSubView {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake((SYPViewWidth - SYPViewWidth * 0.6) / 2.0, 0, SYPViewWidth * 0.6, SYPViewHeight / 2.0)];
    [self addSubview:topView];
    
    NSArray *titles = @[@"销售_额", @"－VS－", @"对比数_据"];
    CGFloat widthPer = (CGRectGetWidth(topView.bounds) - SYPDefaultMargin * 4) / 3.0;
    for (int i = 0; i < 3; i++) {
        CGFloat x = (widthPer + SYPDefaultMargin * 2) * i;
        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(x, (CGRectGetHeight(topView.bounds) - 30) / 2.0, widthPer , 30)];
        if (i != 1) number.text = @"4543";
        number.adjustsFontSizeToFitWidth = YES;
        number.textAlignment = NSTextAlignmentCenter;
        number.textColor = SYPColor_TextColor_Chief;
        number.font = [UIFont boldSystemFontOfSize:20];
        [topView addSubview:number];
            
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(number.frame), i==1?(CGRectGetMaxY(number.frame) - SYPDefaultMargin):CGRectGetMaxY(number.frame), CGRectGetWidth(number.frame), 20)];
        title.text = titles[i];
        title.adjustsFontSizeToFitWidth = YES;
        title.font = [UIFont systemFontOfSize:(i == 1?13:11)];
        //title.adjustsFontSizeToFitWidth = YES;
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = i != 1 ? SYPColor_TextColor_Chief : title.textColor;
        [topView addSubview:title];
        if (i == 0) {
            actualTitleLB = title;
            actualLB = number;
        }
        else if (i == 2) {
            targetTitleLB = title;
            targetLB = number;
        }
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake((SYPViewWidth * (1 - 0.6)) / 2.0 - 10, SYPViewHeight / 2.0, SYPViewWidth * 0.6, SYPViewHeight / 2.0)];
    [self addSubview:bottomView];
    
    ratio = [UIButton buttonWithType:UIButtonTypeCustom];
    ratio.frame = CGRectMake(0, 0, SYPViewWidth1(bottomView) * 0.5, SYPViewHeight1(bottomView));
    [ratio addTarget:self action:@selector(changeHighNumber:) forControlEvents:UIControlEventTouchUpInside];
    [ratio setTitle:@"+9.00" forState:UIControlStateNormal];
    [ratio setTitleColor:SYPColor_TextColor_Chief forState:UIControlStateNormal];
    [ratio.titleLabel setTextAlignment:NSTextAlignmentCenter];
    ratio.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [bottomView addSubview:ratio];
    
    arrowView = [[SYPTrendTypeImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ratio.frame), CGRectGetMidY(ratio.frame) - 15 / 2.0, 15, 15)];
    [bottomView addSubview:arrowView];
    
    [self refreshSubViewData];
}

- (void)changeHighNumber:(UIButton *)sender {
    sender.selected = !sender.selected;
    ratioShowIndex++;
    if (ratioShowIndex == 3) {
        ratioShowIndex = 0;
    }
    [self refreshSubViewData];
}

- (void)refreshSubViewData {
    
    actualLB.text = self.singleValueModel.mainData;
    actualTitleLB.text = self.singleValueModel.mainName;
    actualLB.textColor = self.singleValueModel.arrowToColor;
    targetLB.text = self.singleValueModel.subData;
    targetTitleLB.text = self.singleValueModel.subName;
    [ratio setTitleColor:self.singleValueModel.arrowToColor forState:UIControlStateNormal];
    
    if (ratioShowIndex == 0) {
        [ratio setTitle:self.singleValueModel.mainData forState:UIControlStateNormal];
    }
    else if (ratioShowIndex == 1) {
        [ratio setTitle:self.singleValueModel.floatRatio forState:UIControlStateNormal];
    }
    else if (ratioShowIndex == 2) {
        [ratio setTitle:self.singleValueModel.subData forState:UIControlStateNormal];
    }
    
    CGSize size = [ratio.currentTitle boundingRectWithSize:CGSizeMake(SYPViewWidth * 0.5, SYPViewHeight/2.0) options:0 attributes:@{NSFontAttributeName : ratio.titleLabel.font} context:nil].size;
    CGRect frame = ratio.frame;
    frame.size.width = size.width;
    ratio.frame = frame;
    
    CGPoint center = ratio.center;
    center.x = SYPViewWidth1(ratio.superview)/2.0;
    ratio.center = center;
    
    frame = arrowView.frame;
    frame.origin.x = CGRectGetMaxX(ratio.frame) + SYPDefaultMargin;
    arrowView.frame = frame;
    arrowView.arrow = self.singleValueModel.arrow;
    
}


- (CGFloat)estimateViewHeight:(SYPBaseChartModel *)model {
    return SYPViewWidth * 0.4;
}

@end
