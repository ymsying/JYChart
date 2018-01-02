//
//  SYPClickableLineView.m
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPClickableLineView.h"
#import "SYPClickableLineLayer.h"
#import "SYPTrendTypeImageView.h"
#import "Masonry.h"

#define kAxisXViewHeight (40)

@interface SYPClickableLineView () <SYPClickableLineLayerDelegate> {
    
    SYPTrendTypeImageView *arrowView;
    UILabel *timeLB; // 时间
    UILabel *unitLB; // 单位
    NSArray <UILabel *> *numberLabelList; // 指标区数字显示文本数组
    NSArray <UILabel *> *titleLabelList;  // 指标区标题显示文本数组
    NSArray <UILabel *> *xAxisLabelList;  // 数据区x轴
    NSArray <UILabel *> *yAxisLabelList;  // 数据区y轴
    NSArray <UIColor *> *lineColors;
}

@property (nonatomic, strong) SYPClickableLineLayer *lineView;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) SYPChartModel *chartModel;

@end

@implementation SYPClickableLineView

#pragma mark - Initialize Method
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        numberLabelList = [NSArray array];
        titleLabelList = [NSArray array];
        xAxisLabelList = [NSArray array];
        yAxisLabelList = [NSArray array];
        lineColors = @[SYPColor_LineColor_LightBlue, SYPColor_LineColor_LightPurple, SYPColor_LineColor_Blue, SYPColor_SubColor_LightGreen, SYPColor_LineColor_LightOrange, SYPColor_ArrowColor_Yellow, SYPColor_LineColor_Green];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        numberLabelList = [NSArray array];
        titleLabelList = [NSArray array];
        xAxisLabelList = [NSArray array];
        yAxisLabelList = [NSArray array];
        lineColors = @[SYPColor_LineColor_LightBlue, SYPColor_LineColor_LightPurple, SYPColor_LineColor_Blue, SYPColor_SubColor_LightGreen, SYPColor_LineColor_LightOrange, SYPColor_ArrowColor_Yellow, SYPColor_LineColor_Green];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //  两条数量时，显示成变化率
    if (self.chartModel.series.count == 2) {
        [self updateThirdNumber];
    }
}

#pragma mark - Lazy

- (UIView *)titleView {
    if (!_titleView) {
        
        _titleView = [[UIView alloc] init];
        [self addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(self.mas_height).multipliedBy(0.3);
        }];
    }
    return _titleView;
}

- (UIView *)infoView {
    if (!_infoView) {
        _infoView = [[UIView alloc] init];//WithFrame:CGRectMake(0, CGRectGetMaxY(unitLB.frame), SYPViewWidth, SYPViewHeight * 0.7)
        [self addSubview:_infoView];
        [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(unitLB.mas_bottom);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(self.mas_height).multipliedBy(0.7);
        }];
    }
    return _infoView;
}

- (SYPClickableLineLayer *)lineView {
    if (!_lineView) {
        _lineView = [[SYPClickableLineLayer alloc] init];
        _lineView.delegate = self;
        [self.infoView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.infoView.mas_right).multipliedBy(0.2);
            make.top.mas_equalTo(SYPDefaultMargin);
            make.width.mas_equalTo(self.infoView.mas_width).mas_equalTo(-2).multipliedBy(0.8);
            make.height.mas_equalTo(self.infoView.mas_height).mas_equalTo(-kAxisXViewHeight - SYPDefaultMargin);
        }];
    }
    return _lineView;
}

- (SYPChartModel *)chartModel {
    if (!_chartModel) {
        _chartModel = (SYPChartModel *)self.moduleModel;
    }
    return _chartModel;
}

- (void)initializeTitle {
    
    timeLB = [[UILabel alloc] init];//WithFrame:CGRectMake(SYPDefaultMargin, SYPDefaultMargin / 2, 50, SYPViewHeight1(titleView) * 0.2)
    timeLB.text = @"W1";
    timeLB.font = [UIFont systemFontOfSize:12];
    timeLB.textColor = SYPColor_TextColor_Chief;
    [self.titleView addSubview:timeLB];
    [timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SYPDefaultMargin/2);
        make.left.mas_equalTo(SYPDefaultMargin);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(self.titleView.mas_height).multipliedBy(0.2);
    }];
    
    NSArray *titleList = self.chartModel.seriesName;
    NSInteger titleListCount = (titleList.count == 2 ? 3 : titleList.count);
//    CGFloat titleWidth = (SYPViewWidth1(titleView) - titleListCount * SYPDefaultMargin / 2 - 10 - SYPViewMinX1(timeLB)) / titleListCount;
    NSMutableArray *numberLB = [NSMutableArray arrayWithCapacity:titleList.count];
    NSMutableArray *titleLB = [NSMutableArray arrayWithCapacity:titleList.count];
    UILabel *lastTitle;
    for (int i = 0; i < titleListCount; i++) {
        
        UILabel *title = [[UILabel alloc] init];//WithFrame:CGRectMake(CGRectGetMinX(number.frame), CGRectGetMaxY(number.frame), titleWidth, SYPViewHeight1(titleView) * 0.2)
        //title.backgroundColor = SYPColor_LightGray_White;
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = SYPColor_TextColor_Chief;
        [self.titleView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastTitle) {
                make.width.mas_equalTo(lastTitle.mas_width);
                make.left.mas_equalTo(lastTitle.mas_right).mas_equalTo(SYPDefaultMargin/2);
            }
            else {
                make.left.mas_equalTo(timeLB.mas_left);
            }
            if (i == titleListCount - 1) {
                make.right.mas_equalTo(-SYPDefaultMargin);
            }
            make.height.mas_equalTo(self.titleView.mas_height).multipliedBy(0.2);
        }];
        lastTitle = title;
        
        UILabel *number = [[UILabel alloc] init];//WithFrame:CGRectMake(CGRectGetMinX(timeLB.frame) + (SYPDefaultMargin / 2 + titleWidth) * i, CGRectGetMaxY(timeLB.frame) + 4, titleWidth, SYPViewHeight1(titleView) * 0.2)
        [self.titleView addSubview:number];
        [number mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(timeLB.mas_bottom).mas_equalTo(SYPDefaultMargin / 2);
            make.left.mas_equalTo(title.mas_left);//.mas_equalTo((SYPDefaultMargin / 2 + titleWidth) * i)
            make.bottom.mas_equalTo(title.mas_top);
            make.width.mas_equalTo(title.mas_width);
            make.height.mas_equalTo(title.mas_height);
        }];
        
        if (titleList.count == 2 && i == 2) {
        
            title.text = @"变化率";
            arrowView = [[SYPTrendTypeImageView alloc] init];//WithFrame:CGRectMake(CGRectGetMaxX(number.frame) + SYPDefaultMargin, CGRectGetMinY(number.frame) + (20 - 10) / 2.0, 10, 10)
            [self.titleView addSubview:arrowView];
            [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
                //make.left.mas_equalTo(number.mas_right).mas_equalTo(SYPDefaultMargin);
                //make.top.mas_equalTo(number.mas_top);
                make.centerY.mas_equalTo(number.mas_centerY);
                make.width.height.mas_equalTo(10);
            }];
            
        }
        else {
            title.text = titleList[i];
        }
        [numberLB addObject:number];
        [titleLB addObject:title];
    }
    
    
    numberLabelList = [numberLB copy];
    titleLabelList = [titleLB copy];
    
    UIView *sepLine = [[UIView alloc] init];//WithFrame:CGRectMake(0, CGRectGetMaxY(title.frame)+4, SYPViewWidth, 0.5)
    sepLine.backgroundColor = SYPColor_TextColor_Chief;
    [self.titleView addSubview:sepLine];
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        if (lastTitle) make.top.mas_equalTo(lastTitle.mas_bottom).mas_equalTo(4);
        make.height.mas_equalTo(0.5);
    }];
    
    unitLB = [[UILabel alloc] init];//WithFrame:CGRectMake(SYPViewWidth / 10, CGRectGetMaxY(sepLine.frame) + 4, SYPViewWidth / 10, SYPViewHeight1(self.titleView) * 0.2)
    unitLB.text = self.chartModel.yAxisUnit;
    unitLB.font = [UIFont systemFontOfSize:12];
    unitLB.textAlignment = NSTextAlignmentRight;
    unitLB.textColor = SYPColor_TextColor_Chief;
    [self.titleView addSubview:unitLB];
    [unitLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sepLine.mas_bottom).mas_equalTo(4);
        make.left.mas_equalTo(self.mas_right).multipliedBy(0.1);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.1);
        make.height.mas_equalTo(self.titleView.mas_height).multipliedBy(0.2);
    }];
}

- (void)initializeAxis {
    
    // 纵坐标
    UIView *axisYView = [[UIView alloc] init];//WithFrame:CGRectMake(0, 0, CGRectGetWidth(self.infoView.bounds) / 5, CGRectGetHeight(self.infoView.bounds))
    //axisYView.backgroundColor = SYPColor_ArrowColor_Red;
    [self.infoView addSubview:axisYView];
    [axisYView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(self.infoView.mas_width).dividedBy(5);
        make.height.mas_equalTo(self.infoView.mas_height);
    }];
    
    NSMutableArray *yAxisList = [NSMutableArray arrayWithCapacity:4];
//    CGFloat scaleHeight = (CGRectGetHeight(axisYView.bounds) - kAxisXViewHeight) / 4;
    UILabel *lastLabel;
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] init];//WithFrame:CGRectMake(SYPDefaultMargin, 0, SYPViewWidth1(axisYView) - SYPDefaultMargin, scaleHeight)
//        CGPoint center = label.center;
//        center.y = scaleHeight * i + SYPDefaultMargin + SYPDefaultMargin;
//        label.center = center;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = SYPColor_TextColor_Chief;
//        label.text = self.seriesModel.yAxisDataList[i];//[NSString stringWithFormat:@"%d00,000", 4 - i];
        [axisYView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat offset = -SYPDefaultMargin * 2;
            if (lastLabel) {
                make.top.mas_equalTo(lastLabel.mas_bottom);
                make.height.mas_equalTo(lastLabel.mas_height);
            }
            else {
                make.top.mas_equalTo(offset);
            }
            make.left.mas_equalTo(SYPDefaultMargin);
            make.width.mas_equalTo(axisYView.mas_width).mas_equalTo(-SYPDefaultMargin);
            if (i == 3) {
                make.bottom.mas_equalTo(axisYView.mas_bottom).mas_equalTo(-kAxisXViewHeight+offset);
            }
        }];
        lastLabel = label;
        
        [yAxisList addObject:label];
    }
    
    // 横坐标
    UIView *axisXView = [[UIView alloc] init];//WithFrame:CGRectMake(0, CGRectGetMaxY(self.lineView.frame), CGRectGetWidth(self.infoView.bounds), kAxisXViewHeight)
    //axisXView.backgroundColor = SYPColor_ArrowColor_Yellow;
    [self.infoView addSubview:axisXView];
    [axisXView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(axisYView.mas_right);
        make.top.mas_equalTo(self.lineView.mas_bottom);
        make.right.mas_equalTo(self.infoView.mas_right);
        make.height.mas_equalTo(kAxisXViewHeight);
    }];
    
    // 只展示前后
    NSInteger xAxisCount = self.chartModel.xAxis.count;
    NSMutableArray *xAxisList = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < xAxisCount; i++) {
        UILabel *label = [[UILabel alloc] init];//WithFrame:CGRectMake(0, 0, weekWidth, 30)
        label.hidden = YES;
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.chartModel.xAxis[i];
        label.textColor = SYPColor_SubColor_LightGreen;
        [label sizeToFit];
        [axisXView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            if (i == 0) {
                label.textAlignment = NSTextAlignmentLeft;
                make.left.mas_equalTo(0);
            }
            if (i == xAxisCount - 1) {
                make.right.mas_equalTo(-SYPDefaultMargin/2);
                label.textAlignment = NSTextAlignmentRight;
            }
        }];
        
        if (i == 0 || i == self.chartModel.xAxis.count - 1) {
            label.hidden = NO;
        }
        [xAxisList addObject:label];
        
        lastLabel = label;
    }
    
    xAxisLabelList = [xAxisList copy];
    yAxisLabelList = [yAxisList copy];
    
    UIView *sepLine = [[UIView alloc] init];//WithFrame:CGRectMake(0, 0, SYPViewWidth, 0.5)
    sepLine.backgroundColor = [SYPColor_TextColor_Chief colorWithAlphaComponent:0.5];
    [self addSubview:sepLine];
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(axisXView.mas_top);
        make.height.mas_equalTo(0.5);
    }];
}

- (CGFloat)estimateViewHeight:(SYPBaseChartModel *)model {
    return SYPViewWidth * SYPScreenRatio + 40;
}

- (void)refreshSubViewData {
    
    [self initializeTitle];
    timeLB.text = [self.chartModel.xAxis firstObject];
    
    if (self.chartModel.series) {
        
        NSMutableDictionary *lineParams = [NSMutableDictionary dictionary];
        
        for (NSInteger i = 0; i < self.chartModel.series.count; i++) {
            NSDictionary *line = @{@"series"  : self.chartModel.getSeries[i],
                                   @"color" : lineColors[i]};
            [lineParams setObject:line forKey:[NSString stringWithFormat:@"line%zi", i]];
        }
        self.lineView.keyPointCountMax = self.chartModel.xAxis.count;
        // 线，设置后即更新
        self.lineView.lineParms = lineParams;
    }
    // 横坐标需要根据折线图的点来布局
    [self initializeAxis];
    [self setAxisAndTitleData];
}

// 第一次赋值
- (void)setAxisAndTitleData {
    
    // 坐标刻度内容
    for (int i = 0; i < xAxisLabelList.count; i++) {
        xAxisLabelList[i].text = self.chartModel.xAxis[i];
    }
    for (int i = 0; i < 4; i++) {
        yAxisLabelList[i].text = self.chartModel.yAxisDataList[i];
    }
    
    // 更新标题栏区域内容
    // 默认显示第一条数据
    [self.chartModel.series enumerateObjectsUsingBlock:^(SYPChartSeriesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        numberLabelList[idx].text = obj.data[0];
        numberLabelList[idx].textColor = lineColors[idx];
    }];

    [xAxisLabelList firstObject].textColor = self.chartModel.seriesColor[0];
    arrowView.arrow = [self.chartModel.series[0].colors[0] integerValue];
}

- (void)updateThirdNumber {
    
    numberLabelList[2].text = [self.chartModel.floatRatio firstObject];//变化率
    numberLabelList[2].textColor = self.chartModel.seriesColor[0];
    
    CGRect frame = numberLabelList[2].frame;
    CGSize size = [numberLabelList[2].text boundingRectWithSize:CGSizeMake(100, CGRectGetHeight(frame)) options:0 attributes:@{NSFontAttributeName: numberLabelList[2].font} context:nil].size;
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(numberLabelList[2].mas_left).mas_equalTo(size.width + SYPDefaultMargin);
    }];
}

#pragma mark - <SYPClickableLineDelegate>
// 拖拽时数据显示
- (void)clickableLine:(SYPClickableLineLayer *)clickableLine didSelected:(NSInteger)index data:(id)data {
    
    // 折线、柱状的长度按x轴数据量为准，
    timeLB.text = self.chartModel.xAxis[index];
    
    // 更新横坐标高亮颜色
    [xAxisLabelList enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.textColor = SYPColor_SepLineColor_LightGray;
    }];
    xAxisLabelList[index].textColor = SYPColor_TextColor_Black;
    // 更新标题栏区域内容
    [self.chartModel.series enumerateObjectsUsingBlock:^(SYPChartSeriesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index < obj.data.count) {
            numberLabelList[idx].text = obj.data[index];
        } else {
            numberLabelList[idx].text = @"暂无数据";
        }
    }];
    
    if (self.chartModel.series.count == 2) {
        if (index > self.chartModel.floatRatio.count-1) {
            numberLabelList[2].text = @"暂无数据";
            numberLabelList[2].textColor = SYPColor_SepLineColor_LightGray;
            arrowView.arrow = TrendTypeArrowNoArrow;
        }
        else {
            numberLabelList[2].text = self.chartModel.floatRatio[index];
            numberLabelList[2].textColor = [self.chartModel seriesColor][index];
            arrowView.arrow = [self.chartModel.series[0].colors[index] integerValue];
        }
        // 更新箭头大小及位置
        CGSize size = [numberLabelList[2].text boundingRectWithSize:CGSizeMake(100, CGRectGetHeight(numberLabelList[2].frame)) options:0 attributes:@{NSFontAttributeName: numberLabelList[2].font} context:nil].size;
        [arrowView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(numberLabelList[2].mas_left).mas_equalTo(size.width + SYPDefaultMargin);
        }];
    }
}



@end


