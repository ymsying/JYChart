//
//  SYPLandscapeBarView.m
//  各种报表
//
//  Created by niko on 17/5/6.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPLandscapeBarView.h"

#import "SYPLandscapeBarLayer.h"
#import "SYPInvertView.h"
#import "SYPBlockButton.h"
#import "SYPHudView.h"

@interface SYPLandscapeBarView () <SYPLandscapeBarDelegate> {
    UIView *titleView;
    NSArray <UIButton *> *proNameList;
    NSArray <UILabel *> *ratioList;
    
    SYPInvertView *inverBtnFirst;
    SYPInvertView *inverBtnSecond;
}


@property (nonatomic, strong) SYPLandscapeBarLayer *landscapeBar;
@property (nonatomic, strong) SYPBargraphModel *bargraphModel;

@end

@implementation SYPLandscapeBarView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
//        self.clipsToBounds = YES;
        [self initializeSubVeiw];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self initializeSubVeiw];
    }
    return self;
}

- (SYPLandscapeBarLayer *)landscapeBar {
    if (!_landscapeBar) {
        _landscapeBar = [[SYPLandscapeBarLayer alloc] initWithFrame:CGRectMake(SYPViewWidth * 3/5, CGRectGetMaxY(titleView.frame), SYPViewWidth * 2/5, SYPViewHeight - SYPViewHeight1(titleView))];
        _landscapeBar.delegate = self;
        [self addSubview:_landscapeBar];
    }
    return _landscapeBar;
}

- (SYPBargraphModel *)bargraphModel {
    if (!_bargraphModel) {
        _bargraphModel = (SYPBargraphModel *)self.moduleModel;
    }
    return _bargraphModel;
}

- (void)initializeSubVeiw {
    
    [self initializeTitle];
    //[self initializeAxis];
}

- (void)initializeTitle {
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYPViewWidth, 40)];
    [self addSubview:titleView];
    
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < 2; i++) { // 2/5, 1/5, 2/5
        SYPInvertView *inverBtn = [[SYPInvertView alloc] initWithFrame:CGRectMake(SYPViewWidth * 2 / 5 * i + SYPDefaultMargin/2 + 10, 0, SYPViewWidth / 5.0 * (i==0? 2 : 1), 40)];
        //inverBtn.typeName = @[self.bargraphModel.xAxisName, self.bargraphModel.seriesName][i];
        inverBtn.tag = -2000 + i;
        [inverBtn setInverHandler:^(NSString *type, BOOL isSelected) {
            [weakSelf invertActionWithType:type selected:isSelected];
        }];
        [titleView addSubview:inverBtn];
        
        if (i == 0) {
            inverBtnFirst = inverBtn;
        }
        else if (i == 1) {
            inverBtnSecond = inverBtn;
        }
    }
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), SYPViewWidth, 0.5)];
    sepLine.backgroundColor = SYPColor_TextColor_Chief;
    [titleView addSubview:sepLine];

}

- (void)initializeAxis {
    
    [[self viewWithTag:-3000] removeFromSuperview];
    UIView *proInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.landscapeBar.frame), SYPViewWidth * 3 / 5, CGRectGetHeight(self.landscapeBar.frame))];
    proInfoView.tag = -3000;
    [self addSubview:proInfoView];
    
    NSMutableArray *nameList = [NSMutableArray arrayWithCapacity:self.bargraphModel.xAxisData.count];
    NSMutableArray *rList = [NSMutableArray arrayWithCapacity:self.bargraphModel.seriesData.count];
    for (NSInteger i = 0; i < self.bargraphModel.seriesData.count; i++) {
        
        UIImageView *IV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_greenarrow"]];
        IV.frame = CGRectMake(0, 0, 10, 10);
        [proInfoView addSubview:IV];
        CGPoint center = IV.center;
        center.y = CGPointFromString(self.landscapeBar.pionts[i]).y;
        IV.center = center;
        IV.hidden = YES;
        IV.tag = -11000 + i;
        IV.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);
        
        UIButton *proName = [UIButton buttonWithType:UIButtonTypeCustom];
        proName.frame = CGRectMake(CGRectGetMaxX(IV.frame) + SYPDefaultMargin / 2.0, 0, SYPViewWidth1(proInfoView) - (SYPViewWidth1(IV) + SYPDefaultMargin / 2.0) - SYPViewWidth / 5, kBarHeight);
        [proName addTarget:self action:@selector(clickNameActive:) forControlEvents:UIControlEventTouchUpInside];
        proName.tag = -10000 + i;
        [proName setTitle:self.bargraphModel.xAxisData[i] forState:UIControlStateNormal];
        [proName setTitleColor:SYPColor_TextColor_Chief forState:UIControlStateNormal];
        proName.titleLabel.font = [UIFont systemFontOfSize:13];
        proName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        proName.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [proInfoView addSubview:proName];
        
        center = proName.center;
        center.y = CGPointFromString(self.landscapeBar.pionts[i]).y;
        proName.center = center;
        /*
         proName.userInteractionEnabled = NO;
        // 判断显示不全，用蓝色标示出来，并且点击时显示完整名称
        CGSize size = [proName.currentTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(proName.frame)) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName : proName.titleLabel.font} context:nil].size;
        if (size.width > CGRectGetWidth(proName.frame)) {
            proName.userInteractionEnabled = YES;
        }
        */
        
        
        UILabel *ratio = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(proName.frame), CGRectGetMinY(proName.frame), SYPViewWidth/5, kBarHeight)];
        ratio.text = self.bargraphModel.seriesData[i].value;
        ratio.textAlignment = NSTextAlignmentRight;
        ratio.textColor = SYPColor_TextColor_Chief;
        ratio.font = [UIFont systemFontOfSize:12];
        [proInfoView addSubview:ratio];
        
        [nameList addObject:proName];
        [rList addObject:ratio];
    }
    
    proNameList = [nameList copy];
    ratioList = [rList copy];
}

- (void)setAutoLayoutHeight:(BOOL)autoLayoutHeight {
    _autoLayoutHeight = autoLayoutHeight;
    self.landscapeBar.autoLayoutHeight = autoLayoutHeight;
}

- (void)clickNameActive:(UIButton *)sender {
    NSInteger i = sender.tag + 10000;
    if (self.delegate && [self.delegate respondsToSelector:@selector(moduleTwoBaseView:didSelectedAtIndex:data:)]) {
        [self.delegate moduleTwoBaseView:self didSelectedAtIndex:i data:self.bargraphModel.xAxisData[i]];
    }
    
    // 显示完整文字
    [SYPHudView showHUDWithTitle:self.bargraphModel.xAxisData[i]];
    // 箭头指示
    for (int index = 0; index < self.bargraphModel.seriesData.count; index++) {
        UIButton *proName = [[self viewWithTag:-3000] viewWithTag:-10000 + index];
        [proName setTitleColor:SYPColor_TextColor_Chief forState:UIControlStateNormal];
        
        UIImageView *iv = [[self viewWithTag:-3000] viewWithTag:-11000 + index];
        iv.hidden = YES;
    }
    
    [sender setTitleColor:SYPColor_LineColor_LightBlue forState:UIControlStateNormal];
    [[self viewWithTag:-3000] viewWithTag:-11000 + i].hidden = NO;
}

- (CGFloat)estimateViewHeight:(SYPBaseChartModel *)model {
    
    return [self.landscapeBar estimateViewHeight:model] + CGRectGetHeight(titleView.frame);
}

- (void)refreshSubViewData {
    self.landscapeBar.model = self.bargraphModel;
    
    for (int i = 0; i < proNameList.count; i++) {
        [proNameList[i] setTitle:self.bargraphModel.xAxisData[i] forState:UIControlStateNormal];
        ratioList[i].text = self.bargraphModel.seriesData[i].value;
    }
    
    inverBtnFirst.typeName = self.bargraphModel.xAxisName;
    inverBtnSecond.typeName = self.bargraphModel.seriesName;
}

#pragma mark - <SYPLandscapeBarDelegate>
- (void)landscapeBar:(SYPLandscapeBarLayer *)bar refreshHeight:(CGFloat)height {
    // bar 布局完成后悔自动更新frame
    
    if (self.autoLayoutHeight) {
        CGRect frame = self.frame;
        frame.size.height = CGRectGetHeight(self.landscapeBar.frame) + CGRectGetHeight(titleView.frame);
        self.frame = frame;
    }
    [self initializeAxis];

    
    // 视图布局完成后调用的代理方法，
}

- (void)invertActionWithType:(NSString *)type selected:(BOOL)isSelected{
    // 有一个在进行排序，另外一个就不排序
    for (UIView *view in titleView.subviews) {
        if ([view isKindOfClass:[SYPInvertView class]]) {
            SYPInvertView *inverBtn = (SYPInvertView *)view;
            if ([inverBtn.typeName isEqualToString:type]) continue;
            [inverBtn recoverIconTransform];
        }
    }
    
    // NSLog(@"TODO：排序 %@", type);
    if ([type isEqualToString:self.bargraphModel.seriesName]) {
        if (isSelected) {
            [self.bargraphModel sortedSeriesList:SYPBargraphModelSortRatioUp];
        }
        else {
            [self.bargraphModel sortedSeriesList:SYPBargraphModelSortRatioDown];
        }
    }
    else if ([type isEqualToString:self.bargraphModel.xAxisName]) {
        if (isSelected) {
            [self.bargraphModel sortedSeriesList:SYPBargraphModelSortProNameUp];
        }
        else {
            [self.bargraphModel sortedSeriesList:SYPBargraphModelSortProNameDown];
        }
    }
    
    //[proNameList makeObjectsPerformSelector:@selector(setTitle:forState:) withObject:self.bargraphModel.xAxisData];
    for (int i = 0; i < proNameList.count; i++) {
        [proNameList[i] setTitle:self.bargraphModel.xAxisData[i] forState:UIControlStateNormal];
        ratioList[i].text = self.bargraphModel.seriesData[i].value;
    }
    self.landscapeBar.model = self.bargraphModel;
    
}

@end
