//
//  SYPClickableLine.m
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPClickableLineLayer.h"
#import "SYPChartModel.h"

@interface SYPClickableLineLayer () {
    
    NSInteger barGroupCount; // 柱状图组数统计
    CGFloat barWidth; // 柱状图柱子宽度
    CGFloat maxValue;
    CGFloat minValue;
    CGFloat margin;
    CGFloat originalPointY;
    NSInteger currentBarIndex;
}

@property (nonatomic, strong) NSArray <CAShapeLayer *> * lineLayerList; // 折线列表
@property (nonatomic, strong) NSDictionary <NSString *, NSArray <CAShapeLayer *> *> * barLayerInfo; // 柱状列表
@property (nonatomic, strong) NSArray <UIColor *> *lineColorList; // 多条折线的颜色列表
@property (nonatomic, strong) NSArray <SYPChartSeriesModel *> *dataSource; // 多条折线的关键点处理前列表
@property (nonatomic, strong) NSArray <NSArray <NSString *> *> *keyPointsList; // 关键点处理后列表
@property (nonatomic, strong) NSArray <UIView *> *flagPointList; // 圆圈⭕️列表

@end

@implementation SYPClickableLineLayer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        maxValue = 0.0;
        minValue = CGFLOAT_MAX;
        currentBarIndex = NSIntegerMax;
        [self addGesture];
    }
    return self;
}

- (void)addGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
    [self addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
    [self addGestureRecognizer:pan];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    self.flagPointList = nil;
    
    [self formatterPoints];
    [self addChartLayers];
}

#pragma mark - Lazy
- (NSArray<UIView *> *)flagPointList {
    if (!_flagPointList) {
        NSMutableArray *flagTemp = [NSMutableArray array];
        for (UIColor *lineColor in self.lineColorList) {
            UIView *flagPoint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            flagPoint.layer.cornerRadius = 10;
            flagPoint.layer.zPosition = 10;
            flagPoint.backgroundColor = [lineColor appendAlpha:0.15];
            
            UIView *point = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 10, 10)];
            point.backgroundColor = [UIColor whiteColor];
            point.layer.cornerRadius = 5;
            point.layer.borderWidth = 2;
            point.layer.borderColor = lineColor.CGColor;
            [flagPoint addSubview:point];
            
            [self addSubview:flagPoint];
            [flagTemp addObject:flagPoint];
        }
        _flagPointList = [flagTemp copy];
    }
    return _flagPointList;
}

#pragma mark - Setter Method
- (void)setLineParms:(NSDictionary<NSString *,NSDictionary *> *)lineParms {
    if (![_lineParms isEqual:lineParms]) {
        
        NSMutableArray *lineColorListTemp = [NSMutableArray array];
        NSMutableArray *lineDataListTemp = [NSMutableArray array];
        for (NSDictionary *dic in [lineParms allValues]) {
            [lineColorListTemp addObject:dic[@"color"]];
            [lineDataListTemp addObject:dic[@"series"]];
        }
        self.lineColorList = [lineColorListTemp copy];
        self.dataSource = [lineDataListTemp copy];
        
        _lineParms = lineParms;
    }
}

- (void)setDataSource:(NSArray<SYPChartSeriesModel *> *)dataSource {
    if (![_dataSource isEqual:dataSource]) {
        _dataSource = dataSource;
    }
}

- (void)setLineColorList:(NSArray<UIColor *> *)lineColorList {
    if (![_lineColorList isEqual:lineColorList]) {
        _lineColorList = lineColorList;
        
        for (int i = 0; i < self.lineLayerList.count; i++) {
            CAShapeLayer *line = self.lineLayerList[i];
            line.strokeColor = self.lineColorList[i].CGColor;
        }
    }
}

#pragma mark - draw
- (void)addChartLayers {
    [self.dataSource enumerateObjectsUsingBlock:^(SYPChartSeriesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *type = obj.type;
        if ([@"line" isEqualToString:type]) {
            [self addLineWithPointsAtIndex:idx];
        }
        else if ([@"bar" isEqualToString:type]) {
            [self addBarWithPointsAtIndex:idx];
        }
    }];
    
    if (minValue < 0) {
        [self addOriginalPointLine];
    }
    
    // 默认显示第一个点
    [self showFlagPointAtIndex:0];
    currentBarIndex = 0;
}

// 柱子采用平铺方式，不进行重叠，平铺是平分重叠时柱子的宽度
- (void)addBarWithPointsAtIndex:(NSInteger)index {
    
    NSArray *points = [NSMutableArray arrayWithArray:self.keyPointsList[index]];
    NSMutableArray *barList = [NSMutableArray arrayWithCapacity:points.count];
    for (int j = 0; j < points.count; j++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(CGPointFromString(points[j]).x, originalPointY)];
        [path addLineToPoint:CGPointFromString(points[j])];
        
        CAShapeLayer *shape = [CAShapeLayer layer];
        shape.strokeStart = 0.0;
        shape.strokeEnd = 1.0;
        shape.lineWidth = barWidth;
        // 默认灰色，选中SYPColor_TextColor_Minor
        shape.strokeColor = SYPColor_TextColor_Minor.CGColor;
        shape.fillColor = [UIColor clearColor].CGColor;
        shape.path = path.CGPath;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = 0.5;
        animation.fromValue = @(0.0);
        animation.toValue = @(1.0);
        [shape addAnimation:animation forKey:nil];
        
        [self.layer addSublayer:shape];
        
        [barList addObject:shape];
    }
    NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:self.barLayerInfo];
    [tmp setObject:barList forKey:[NSString stringWithFormat:@"%zi", index]];
    self.barLayerInfo = [tmp copy];
}

- (void)addLineWithPointsAtIndex:(NSInteger)index {
    
    NSArray *pointList = self.keyPointsList[index];
    UIBezierPath *layerPath = [UIBezierPath bezierPath];
    for (int i = 0; i < pointList.count; i++) {
        CGPoint point = CGPointFromString(pointList[i]);
        if (i == 0) {
            [layerPath moveToPoint:point];
        }
        [layerPath addLineToPoint:point];
    }
    layerPath.lineJoinStyle = kCGLineJoinRound;
    CAShapeLayer *linelayer = [CAShapeLayer layer];
    linelayer.zPosition = 1; // 防止bar将line挡住
    linelayer.lineWidth = 2;
    linelayer.strokeEnd = 0.0;
    linelayer.strokeEnd = 1.0;
    linelayer.path = layerPath.CGPath;
    linelayer.fillColor = [UIColor clearColor].CGColor;
    linelayer.strokeColor = (self.lineColorList[index] ?: [UIColor whiteColor]).CGColor;
    linelayer.lineCap = kCALineCapSquare;
    linelayer.lineJoin = kCALineJoinMiter;
    [self.layer addSublayer:linelayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.duration = 0.5;
    [linelayer addAnimation:animation forKey:nil];
}

- (void)addOriginalPointLine {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, originalPointY)];
    [path addLineToPoint:CGPointMake(SYPViewWidth, originalPointY)];
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.strokeStart = 0.0;
    shape.strokeEnd = 1.0;
    shape.lineWidth = 0.5;
    shape.strokeColor = SYPColor_LineColor_LightBlue.CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.path = path.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 0.5;
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    [shape addAnimation:animation forKey:nil];
    
    [self.layer addSublayer:shape];
}

#pragma mark - Logic Method
- (void)formatterPoints {
    
    NSInteger keyPointCountMax = 0; // 查找最长的线或柱状的点个数，最终长度按出入长度计算宽度
    
    for (SYPChartSeriesModel *series in self.dataSource) {
        keyPointCountMax = series.data.count > keyPointCountMax ? series.data.count : keyPointCountMax;
        
        if ([@"bar" isEqualToString:series.type]) {
            barGroupCount++;
        }
        
        for (NSNumber *number in series.data) {
            maxValue = [number floatValue] > maxValue ? [number floatValue] : maxValue;
            minValue = [number floatValue] < minValue ? [number floatValue] : minValue;
        }
    }
    keyPointCountMax = self.keyPointCountMax ? self.keyPointCountMax : keyPointCountMax;
    
    // 折线中点的间距
    margin = SYPViewWidth / (keyPointCountMax - 1);
    CGFloat barMargin = barGroupCount == 1 ? kBarMargin * 2 : kBarMargin;
    // 单组柱图时，bar的宽度，bar间距SYPDefaultMargin*2
    barWidth = (SYPViewWidth - barMargin * (keyPointCountMax - 1) - SYPDefaultMargin * 2) / keyPointCountMax;
    // 多组柱图时，bar宽度变窄，且bar之间添加间隙
    barWidth = barGroupCount ? (barWidth - barGroupCount*1) / barGroupCount : barWidth; // 为同关键点不同分组的bar之间添加间隙
    
    CGFloat total = 0;
    if (minValue < 0) {
        total = fabs(minValue) + maxValue;
        originalPointY = maxValue / total * SYPViewHeight;
    }
    else {
        total = maxValue;
        originalPointY = maxValue / total * SYPViewHeight;
    }
    
    // 记录执行到第几组bar计算
    NSInteger tempBarGroupCount = 0;
    
    NSMutableArray *keyPointsListTemp = [NSMutableArray array];
    for (int j = 0; j < self.dataSource.count; j++) {
        NSArray *keyPoints = self.dataSource[j].data;
        NSString *type = self.dataSource[j].type;
        
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:keyPoints.count];
        for (int i = 0; i < keyPoints.count; i++) {
            CGFloat y = 0;
            CGFloat value = [keyPoints[i] floatValue];
            y = originalPointY - (value / total) * SYPViewHeight;
            if (value > 0) {
                y += SYPViewHeight * 0.04;
            }else if (value < 0) {
                y -= SYPViewHeight * 0.04;
            }
            
            CGFloat x = (margin * i + SYPDefaultMargin * 2) * 0.9; // 按比率缩小x轴，避免标记点显示不全的问题
            // 当图形是bar时进行相应的挪动
            if ([@"bar" isEqualToString:type]) {
                x = [self moveBarPointXaxisWithOriginalX:x index:tempBarGroupCount];
            }
            
            CGPoint point = CGPointMake(x, y);
            [points addObject:NSStringFromCGPoint(point)];
        }
        
        if ([@"bar" isEqualToString:type]) {
            tempBarGroupCount++;
        }
        
        [keyPointsListTemp addObject:[points copy]];
    }
    
    self.keyPointsList = [keyPointsListTemp copy];
}
/**
 有多组柱状图时，对每组柱状进行适当的移动
 移动量按2的等差数列进行移动
 an = a1 + (n - 1) * d

 @param x 多组柱在同一x坐标的位置
 @param idx 当前分组的下表
 @return 移动后的x轴上的位置
 */
- (CGFloat)moveBarPointXaxisWithOriginalX:(CGFloat)x index:(NSInteger)idx {
    CGFloat rst = x;
    NSInteger a1 = barGroupCount % 2 ? 0 : 1;
    NSInteger a1Idx = barGroupCount / 2;
    NSInteger d = 2;
    NSInteger moveOffset = a1 + ((idx - a1Idx)) * d;
    
    rst = x + moveOffset * barWidth / 2;
    
    return rst;
}

- (NSArray *)points {
    NSInteger keyPointCountMax = [self.dataSource firstObject].data.count, maxLineIndex = 0;
    for (int i = 0; i < self.dataSource.count; i++) {
        maxLineIndex = self.dataSource[i].data.count > keyPointCountMax ? i : maxLineIndex;
    }
    return [self.keyPointsList[maxLineIndex] copy];
}

- (void)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    
    [self findNearestKeyPointOfPoint:[gestureRecognizer locationInView:self]];
}

- (void)showFlagPointAtIndex:(NSInteger)idx {
    
    CGPoint keyPoint;
    NSInteger pointIdx = idx;
    for (int group = 0; group < self.flagPointList.count; group++) { // 寻组
        
        // 视觉处理
        // 处理分组数据中长度不一致时，短分组无数据时有标记点
        if (pointIdx > [self.keyPointsList[group] count] - 1) {
            self.flagPointList[group].hidden = YES;
            CGPoint tmpCenter = self.flagPointList[group].center;
            tmpCenter.x = CGPointFromString([self.keyPointsList[0] lastObject]).x;
            self.flagPointList[group].center = tmpCenter;
            continue;
        } else {
            self.flagPointList[group].hidden = NO;
        }
        
        keyPoint = CGPointFromString(self.keyPointsList[group][pointIdx]);
        
        // 给指定bar上色，并记录其位置
        NSString *barInfoKey = [NSString stringWithFormat:@"%zi", group];
        if ([self.barLayerInfo.allKeys containsObject:barInfoKey]) {
            
            self.flagPointList[group].hidden = YES;
            NSArray <CAShapeLayer *> *barList = [self.barLayerInfo objectForKey:barInfoKey];
            UIColor *color = self.lineColorList[group];
            barList[pointIdx].strokeColor = color.CGColor;
        }
        else { // 线条上加点
            // 首次展现时从左进入视图增加视角效果
            if (pointIdx == 0 && currentBarIndex == NSIntegerMax) {
                CGPoint tmpCenter = CGPointMake(-10, keyPoint.y);
                self.flagPointList[group].center = tmpCenter;
            }
            [UIView animateWithDuration:0.25 animations:^{
                self.flagPointList[group].center = keyPoint;
            }];
        }
        
        
    }
    // 外部数据处理
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickableLine:didSelected:data:)]) {
        [self.delegate clickableLine:self didSelected:pointIdx data:nil];
    }
}

// 寻找最近的点
- (void)findNearestKeyPointOfPoint:(CGPoint)point {
    
    if (point.x < 0) { // 超出左边界不处理
        return;
    }
    
    // 取消上次bar颜色
    [[self.barLayerInfo allValues] enumerateObjectsUsingBlock:^(NSArray<CAShapeLayer *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        currentBarIndex = currentBarIndex == NSIntegerMax ? 0 : currentBarIndex;
        if (currentBarIndex < [obj count]) {
            obj[currentBarIndex].strokeColor = SYPColor_TextColor_Minor.CGColor;
        }
    }];
    
    
    // 查找最近的一个关键点 CGFloat x = (margin * i + SYPDefaultMargin * 2) * 0.9;
    NSInteger idx = (point.x / 0.9 - SYPDefaultMargin * 2 + margin / 2) / margin;
    [self showFlagPointAtIndex:idx];
    currentBarIndex = idx;
    
//    // 将标记点进行位置移动，移动到点击处最近的一个关键点
//    for (int pointIdx = 0; pointIdx < self.keyPointsList[0].count; pointIdx++) { // 寻点，找一次就行
//        CGPoint keyPoint = CGPointFromString(self.keyPointsList[0][pointIdx]);
//
//        // margin/2时表示中间位置，有多组柱状时会出现同时选中两组的问题，如果时margin/4时中间有部分无点击效果
//        if (fabs(keyPoint.x - point.x) < (margin / 2)) {
//
//            [self showFlagPointAtIndex:pointIdx];
//            currentBarIndex = pointIdx;
//            break;
//        }
//    }
}


@end
