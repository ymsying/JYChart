//
//  SYPLandscapeBar.m
//  各种报表
//
//  Created by niko on 17/5/4.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPLandscapeBarLayer.h"
#import "SYPBargraphModel.h"
#import "SYPColourPointModel.h"

@interface SYPLandscapeBarLayer () {
    
    CGFloat maxValue;
    CGFloat minValue;
    CGFloat centerLineX;
    CGFloat barHeight;
}

@property (nonatomic, strong) NSArray <SYPColourPointModel *> *dataSource;
@property (nonatomic, strong) NSMutableArray *pointList;

@end

@implementation SYPLandscapeBarLayer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        barHeight = SYPViewHeight / self.dataSource.count;
        maxValue = 0.0;
        minValue = CGFLOAT_MAX;
    }
    return self;
}

- (void)setAutoLayoutHeight:(BOOL)autoLayoutHeight {
    _autoLayoutHeight = autoLayoutHeight;
    if (autoLayoutHeight) {
        barHeight = kBarHeight;
    } else {
        barHeight = (SYPViewHeight - (SYPDefaultMargin * _dataSource.count)) / _dataSource.count;
    }
    [self layoutIfNeeded];
}

- (void)setDataSource:(NSArray *)dataSource {
    
    _dataSource = dataSource;
    if (self.autoLayoutHeight) {
        barHeight = kBarHeight;
    }
    else {
        barHeight = (SYPViewHeight - (SYPDefaultMargin * _dataSource.count) - SYPDefaultMargin) / _dataSource.count;
    }
    [self layoutIfNeeded];
}

- (void)layoutIfNeeded {
    [super layoutIfNeeded];
    [self addLayer];
}

- (void)refreshSubViewData {
    self.dataSource = [(SYPBargraphModel *)self.model seriesData];
}

- (void)addLayer {
    
    [self formatDataSource];
    [self drawBarViewWithPoints:[_pointList copy]];
    
    if (self.autoLayoutHeight) {
        CGRect frame = self.frame;
        frame.size.height = CGPointFromString([_pointList lastObject]).y + barHeight/2 + SYPDefaultMargin;
        self.frame = frame;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(landscapeBar:refreshHeight:)]) {
        [self.delegate landscapeBar:self refreshHeight:CGPointFromString([_pointList lastObject]).y + barHeight / 2 + SYPDefaultMargin];
    }
}

- (void)drawBarViewWithPoints:(NSArray *)points {
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    for (NSInteger i = 0; i < points.count; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(centerLineX, CGPointFromString(points[i]).y)];
        [path addLineToPoint:CGPointFromString(points[i])];
        
        CAShapeLayer *shape = [CAShapeLayer layer];
        shape.strokeStart = 0.0;
        shape.strokeEnd = 1.0;
        shape.lineWidth = barHeight;
        shape.strokeColor = ((SYPBargraphModel *)self.model).seriesData[i].color1.CGColor;
        shape.fillColor = [UIColor clearColor].CGColor;
        shape.path = path.CGPath;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = 0.5;
        animation.fromValue = @(0.0);
        animation.toValue = @(1.0);
        [shape addAnimation:animation forKey:nil];
        
        [self.layer addSublayer:shape];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(centerLineX, 0)];
    [path addLineToPoint:CGPointMake(centerLineX, CGPointFromString(_pointList.lastObject).y + barHeight / 2 + SYPDefaultMargin)];
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = path.CGPath;
    lineLayer.strokeColor = SYPColor_TextColor_Chief.CGColor;
    lineLayer.strokeStart = 0.0;
    lineLayer.strokeEnd = 1.0;
    lineLayer.lineWidth = 0.2;
    [self.layer addSublayer:lineLayer];
    
}

- (void)formatDataSource {
    
    [self.dataSource enumerateObjectsUsingBlock:^(SYPColourPointModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        maxValue = [obj.value floatValue] > maxValue ? [obj.value floatValue] : maxValue;
        minValue = [obj.value floatValue] > minValue ? minValue : [obj.value floatValue];
    }];
    
    
    CGFloat total = maxValue;
    if (minValue < 0) {
        total = fabs(minValue) + maxValue;
    }
    
    centerLineX = (fabs(minValue) / total) * (SYPViewWidth - SYPDefaultMargin);
    
    _pointList = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    // 计算各值对应的坐标
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        CGFloat value = [self.dataSource[i].value floatValue];
        CGFloat barY = SYPDefaultMargin + barHeight / 2 + (barHeight + SYPDefaultMargin) * i;
        CGFloat barX = 0.0;
        if (value > 0) {
            barX = centerLineX + ((SYPViewWidth - SYPDefaultMargin / 2) - centerLineX) * (value / maxValue);
        }
        else {
            barX = centerLineX - (centerLineX * fabs(value) / fabs(minValue)) + SYPDefaultMargin / 2;
        }
        
        [_pointList addObject:NSStringFromCGPoint(CGPointMake(barX, barY))];
    }
}

- (CGFloat)estimateViewHeight:(SYPBaseChartModel *)model {
    self.dataSource = [((SYPBargraphModel *)model) seriesData];
    [self formatDataSource];
    return CGPointFromString([_pointList lastObject]).y + kBarHeight / 2 + SYPDefaultMargin;
}

- (NSArray *)pionts {
    return [_pointList copy];
}

@end
