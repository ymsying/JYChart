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
@property (nonatomic, strong) SYPChartModel *chartModel;

@end

@implementation SYPClickableLineView

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
        lineColors = @[SYPColor_LineColor_LightBlue, SYPColor_LineColor_LightPurple, SYPColor_LineColor_Blue, SYPColor_SubColor_LightGreen, SYPColor_LineColor_LightOrange, SYPColor_ArrowColor_Yellow, SYPColor_LineColor_Green];;
    }
    return self;
}

- (UIView *)infoView {
    if (!_infoView) {
        
        _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(unitLB.frame), SYPViewWidth, SYPViewHeight * 0.7)];
        [self addSubview:_infoView];
    }
    return _infoView;
}

- (SYPClickableLineLayer *)lineView {
    if (!_lineView) {
        _lineView = [[SYPClickableLineLayer alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.infoView.bounds)/5, SYPDefaultMargin, CGRectGetWidth(self.infoView.bounds) * 4 / 5, SYPViewHeight1(self.infoView) - kAxisXViewHeight - SYPDefaultMargin)];
        _lineView.delegate = self;
    }
    [self.infoView addSubview:_lineView];
    return _lineView;
}

- (SYPChartModel *)chartModel {
    if (!_chartModel) {
        _chartModel = (SYPChartModel *)self.moduleModel;
    }
    return _chartModel;
}

- (void)initializeTitle {
    
    UIView *titleView = [self viewWithTag:-1999];
    [titleView removeFromSuperview];
    titleView = nil;
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYPViewWidth, SYPViewHeight * 0.3)];
    titleView.tag = -1999;
    //titleView.backgroundColor = SYPColor_LightGray_White;
    [self addSubview:titleView];
    
    timeLB = [[UILabel alloc] initWithFrame:CGRectMake(SYPDefaultMargin, SYPDefaultMargin / 2, 50, SYPViewHeight1(titleView) * 0.2)];
    timeLB.text = @"W1";
    timeLB.font = [UIFont systemFontOfSize:12];
    timeLB.textColor = SYPColor_TextColor_Chief;
    [titleView addSubview:timeLB];
    
    NSArray *titleList = self.chartModel.seriesName;
    CGFloat titleWidth = (SYPViewWidth1(titleView) - titleList.count * SYPDefaultMargin / 2 - 10 - SYPViewMinX1(timeLB)) / titleList.count;
    NSMutableArray *numberLB = [NSMutableArray arrayWithCapacity:titleList.count];
    NSMutableArray *titleLB = [NSMutableArray arrayWithCapacity:titleList.count];
    UILabel *title;
    for (int i = 0; i < (titleList.count == 2 ? 3 : titleList.count); i++) {
        
        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(timeLB.frame) + (SYPDefaultMargin / 2 + titleWidth) * i, CGRectGetMaxY(timeLB.frame) + 4, titleWidth, SYPViewHeight1(titleView) * 0.2)];

        [titleView addSubview:number];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(number.frame), CGRectGetMaxY(number.frame), titleWidth, SYPViewHeight1(titleView) * 0.2)];
        //title.backgroundColor = SYPColor_LightGray_White;
        
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = SYPColor_TextColor_Chief;
        [titleView addSubview:title];
        
        
        if (titleList.count == 2 && i == 2) {
            title.text = @"变化率";
            CGRect frame = number.frame;
            CGSize size = [number.text boundingRectWithSize:CGSizeMake(100, CGRectGetHeight(number.frame)) options:0 attributes:@{NSFontAttributeName: number.font} context:nil].size;
            number.frame = CGRectMake(frame.origin.x, frame.origin.y, size.width, CGRectGetHeight(number.frame));
            
            arrowView = [[SYPTrendTypeImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(number.frame) + SYPDefaultMargin, CGRectGetMinY(number.frame) + (20 - 10) / 2.0, 10, 10)];
            [titleView addSubview:arrowView];
        }
        else {
            title.text = titleList[i];
        }
        [numberLB addObject:number];
        [titleLB addObject:title];
    }
    
    
    numberLabelList = [numberLB copy];
    titleLabelList = [titleLB copy];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame)+4, SYPViewWidth, 0.5)];
    sepLine.backgroundColor = SYPColor_TextColor_Chief;
    [titleView addSubview:sepLine];
    
    unitLB = [[UILabel alloc] initWithFrame:CGRectMake(SYPViewWidth / 10, CGRectGetMaxY(sepLine.frame) + 4, SYPViewWidth / 10, SYPViewHeight1(titleView) * 0.2)];
    unitLB.text = self.chartModel.yAxisUnit;
    unitLB.font = [UIFont systemFontOfSize:12];
    unitLB.textAlignment = NSTextAlignmentRight;
    unitLB.textColor = SYPColor_TextColor_Chief;
    [titleView addSubview:unitLB];
}

- (void)initializeAxis {
    
    [self.infoView removeFromSuperview];
    self.infoView = nil;
    // 纵坐标
    UIView *axisYView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.infoView.bounds) / 5, CGRectGetHeight(self.infoView.bounds))];
    //axisYView.backgroundColor = SYPColor_ArrowColor_Red;
    [self.infoView addSubview:axisYView];
    NSMutableArray *yAxisList = [NSMutableArray arrayWithCapacity:4];
    CGFloat scaleHeight = (CGRectGetHeight(axisYView.bounds) - kAxisXViewHeight) / 4;
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SYPDefaultMargin, 0, SYPViewWidth1(axisYView) - SYPDefaultMargin, scaleHeight)];
        CGPoint center = label.center;
        center.y = scaleHeight * i + SYPDefaultMargin + SYPDefaultMargin;
        label.center = center;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = SYPColor_TextColor_Chief;
//        label.text = self.seriesModel.yAxisDataList[i];//[NSString stringWithFormat:@"%d00,000", 4 - i];
        [axisYView addSubview:label];
        
        [yAxisList addObject:label];
    }
    
    // 横坐标
    UIView *axisXView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineView.frame), CGRectGetWidth(self.infoView.bounds), kAxisXViewHeight)];
    //axisXView.backgroundColor = SYPColor_ArrowColor_Yellow;
    [self.infoView addSubview:axisXView];
    CGFloat weekWidth = (SYPViewWidth1(axisXView) - SYPViewWidth1(axisYView)) / self.chartModel.xAxis.count;
    NSMutableArray *xAxisList = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < self.chartModel.xAxis.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, weekWidth, 30)];
        CGPoint center = label.center;
        center.x = CGPointFromString(self.lineView.points[i]).x + CGRectGetWidth(axisYView.frame);// + SYPDefaultMargin;
        center.y = CGRectGetHeight(axisXView.bounds) / 2.0;
        label.center = center;
        label.hidden = YES;
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.chartModel.xAxis[i];
        label.textColor = SYPColor_SubColor_LightGreen;
        [axisXView addSubview:label];
        if (i == 0 || i == self.chartModel.xAxis.count - 1) {
            label.hidden = NO;
        }
        [xAxisList addObject:label];
    }
    
    xAxisLabelList = [xAxisList copy];
    yAxisLabelList = [yAxisList copy];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYPViewWidth, 0.5)];
    sepLine.backgroundColor = SYPColor_TextColor_Chief;
    [axisXView addSubview:sepLine];
}

- (CGFloat)estimateViewHeight:(SYPBaseChartModel *)model {
    return SYPViewWidth * SYPScreenRatio + 40;
}

- (void)refreshSubViewData {
    
    [self initializeTitle];
    timeLB.text = [self.chartModel.xAxis lastObject];
    
    if (self.chartModel.series) {
        
        NSMutableDictionary *lineParams = [NSMutableDictionary dictionary];
        
        for (NSInteger i = 0; i < self.chartModel.series.count; i++) {
            NSDictionary *line = @{@"series"  : self.chartModel.series[i],
                                   @"color" : lineColors[i]};
            [lineParams setObject:line forKey:[NSString stringWithFormat:@"line%zi", i]];
        }
        // 线
        self.lineView.lineParms = lineParams;
    }
    
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
    //  两条数量时，显示成变化率
    if (self.chartModel.series.count == 2) {
        numberLabelList[2].text = [self.chartModel.floatRatio firstObject];//变化率
        numberLabelList[2].textColor = self.chartModel.seriesColor[0];
    }
    
    [xAxisLabelList firstObject].textColor = self.chartModel.seriesColor[0];
    arrowView.arrow = [self.chartModel.series[0].colors[0] integerValue];

    {
        CGRect frame = numberLabelList[2].frame;
        CGSize size = [numberLabelList[2].text boundingRectWithSize:CGSizeMake(100, CGRectGetHeight(frame))
                                                            options:0
                                                         attributes:@{NSFontAttributeName: numberLabelList[2].font}
                                                            context:nil].size;
        frame.size.width = size.width;
        numberLabelList[2].frame = frame;
        
        frame = arrowView.frame;
        frame.origin.x = CGRectGetMaxX(numberLabelList[2].frame) + SYPDefaultMargin/2.0;
        arrowView.frame = frame;
        
    }
    
}

#pragma mark - <SYPClickableLineDelegate>
// 拖拽时数据显示
- (void)clickableLine:(SYPClickableLineLayer *)clickableLine didSelected:(NSInteger)index data:(id)data {
    
    // 为保证两条线长度不一致时比较区域内数字有变化
    if (index >= self.chartModel.maxLength) return;
    if (index >= self.chartModel.minLength) return;
    
    // 更新标题栏区域内容
    [self.chartModel.series enumerateObjectsUsingBlock:^(SYPChartSeriesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index < self.chartModel.minLength) {
            numberLabelList[idx].text = obj.data[index];
        }
    }];

    timeLB.text = self.chartModel.xAxis[index];
    if (self.chartModel.series.count == 2) {
        numberLabelList[2].text = self.chartModel.floatRatio[index];
        numberLabelList[2].textColor = [self.chartModel seriesColor][index];
        arrowView.arrow = [self.chartModel.series[0].colors[index] integerValue];
    }

    // 更新横坐标高亮颜色
    [xAxisLabelList enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.textColor = SYPColor_SubColor_LightGreen;
    }];
    xAxisLabelList[index].textColor = self.chartModel.seriesColor[index];
    
    // 更新箭头大小及位置
    CGRect frame = numberLabelList[2].frame;
    CGSize size = [numberLabelList[2].text boundingRectWithSize:CGSizeMake(100, CGRectGetHeight(numberLabelList[2].frame)) options:0 attributes:@{NSFontAttributeName: numberLabelList[2].font} context:nil].size;
    numberLabelList[2].frame = CGRectMake(frame.origin.x, frame.origin.y, size.width, CGRectGetHeight(numberLabelList[2].frame));
    frame = arrowView.frame;
    frame.origin.x = CGRectGetMaxX(numberLabelList[2].frame) + SYPDefaultMargin/2.0;
    arrowView.frame = frame;
    
    // 调用代理，更新外部视图及数据
    if (self.delegate && [self.delegate respondsToSelector:@selector(moduleTwoBaseView:didSelectedAtIndex:data:)]) {
        [self.delegate moduleTwoBaseView:self didSelectedAtIndex:index data:data];
    }
}



@end


