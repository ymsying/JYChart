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
#import "Masonry.h"

@interface SYPLandscapeBarView () <SYPLandscapeBarDelegate> {
    UIView *titleView;
    NSArray <UILabel *> *proNameList;
    NSArray <UILabel *> *ratioList;
    
    SYPInvertView *inverBtnFirst;
    SYPInvertView *inverBtnSecond;
    
    NSInteger crtSelectedIdx; // 当前选中下标
    NSString *crtSelectedPro; // 当前选中产品名
}


@property (nonatomic, strong) SYPLandscapeBarLayer *landscapeBar;
@property (nonatomic, strong) SYPBargraphModel *bargraphModel;

@end

@implementation SYPLandscapeBarView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
//        self.clipsToBounds = YES;
        [self initializeTitle];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self initializeTitle];
    }
    return self;
}

- (SYPLandscapeBarLayer *)landscapeBar {
    if (!_landscapeBar) {
        _landscapeBar = [[SYPLandscapeBarLayer alloc] init];
        _landscapeBar.delegate = self;
        [self addSubview:_landscapeBar];
        [_landscapeBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_right).multipliedBy(0.6);
            make.top.mas_equalTo(titleView.mas_bottom);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.width.mas_equalTo(self.mas_width).multipliedBy(0.4);
        }];
    }
    return _landscapeBar;
}

- (SYPBargraphModel *)bargraphModel {
    if (!_bargraphModel) {
        _bargraphModel = (SYPBargraphModel *)self.moduleModel;
    }
    return _bargraphModel;
}

- (void)initializeTitle {
    titleView = [[UIView alloc] init];//WithFrame:CGRectMake(0, 0, SYPViewWidth, 40)
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    SYPInvertView *lastView;
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < 2; i++) { // 2/5, 1/5, 2/5
        SYPInvertView *inverBtn = [[SYPInvertView alloc] init];//WithFrame:CGRectMake(SYPViewWidth * 2 / 5 * i + SYPDefaultMargin/2 + 10, 0, SYPViewWidth / 5 * 2, 40)
        inverBtn.tag = -2000 + i;
        [inverBtn setInverHandler:^(NSString *type, BOOL isSelected) {
            [weakSelf invertActionWithType:type selected:isSelected];
        }];
        [titleView addSubview:inverBtn];
        [inverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            if (lastView) {
                make.left.mas_equalTo(lastView.mas_right).mas_equalTo(SYPDefaultMargin/2 + 10);
            }
            else {
                make.left.mas_equalTo(SYPDefaultMargin/2 + 10);
            }
            make.width.mas_equalTo(titleView.mas_width).multipliedBy(0.4);
            make.height.mas_equalTo(titleView.mas_height);
        }];
        
        lastView = inverBtn;
        if (i == 0) {
            inverBtnFirst = inverBtn;
        }
        else if (i == 1) {
            inverBtnSecond = inverBtn;
        }
    }
    UIView *sepLine = [[UIView alloc] init];//WithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), SYPViewWidth, 0.5)
    sepLine.backgroundColor = SYPColor_TextColor_Minor;
    [titleView addSubview:sepLine];
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(titleView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)initializeAxis {
    
    [[self viewWithTag:-3000] removeFromSuperview];
    UIView *proInfoView = [[UIView alloc] init];
    proInfoView.tag = -3000;
    [self addSubview:proInfoView];
    [proInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.landscapeBar.mas_top);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.6);
        make.bottom.mas_equalTo(self.landscapeBar.mas_bottom);
    }];
    
    NSMutableArray *nameList = [NSMutableArray arrayWithCapacity:self.bargraphModel.xAxisData.count];
    NSMutableArray *rList = [NSMutableArray arrayWithCapacity:self.bargraphModel.seriesData.count];
    for (NSInteger i = 0; i < self.bargraphModel.seriesData.count; i++) {
        
        UIImageView *IV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_greenarrow"]];
        [proInfoView addSubview:IV];
        IV.hidden = YES;
        IV.tag = -11000 + i;
        IV.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);
        [IV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(CGPointFromString(self.landscapeBar.pionts[i]).y);
            make.width.height.mas_equalTo(10);
        }];
        
        NSString *proName = self.bargraphModel.xAxisData[i];
        UILabel *proNameLB = [[UILabel alloc] init];
        proNameLB.tag = -12000 + i;
        proNameLB.text = proName;
        proNameLB.textColor = SYPColor_TextColor_Chief;
        proNameLB.font = [UIFont systemFontOfSize:13];
        [proInfoView addSubview:proNameLB];
        [proNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(IV.mas_right).mas_equalTo(4);
            make.centerY.mas_equalTo(IV.mas_centerY);
            make.height.mas_equalTo(kBarHeight);
        }];
        
        UILabel *ratio = [[UILabel alloc] init];
        ratio.tag = -13000 + i;
        ratio.text = self.bargraphModel.seriesData[i].value;
        ratio.textAlignment = NSTextAlignmentRight;
        ratio.textColor = SYPColor_TextColor_Chief;
        ratio.font = [UIFont systemFontOfSize:13];
        [proInfoView addSubview:ratio];
        [ratio mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(proNameLB.mas_right);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(proNameLB.mas_top);
            make.width.mas_equalTo(self.mas_width).dividedBy(5);
            make.height.mas_equalTo(kBarHeight);
        }];
        
        [nameList addObject:proNameLB];
        [rList addObject:ratio];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(clickNameActive:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = -10000 + i;
        [proInfoView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.centerY.mas_equalTo(IV.mas_centerY);
            make.height.mas_equalTo(kBarHeight);
        }];
        
        if ([proName isEqualToString:crtSelectedPro]) {
            IV.hidden = NO;
            proNameLB.textColor = SYPColor_LineColor_LightBlue;
            ratio.textColor = SYPColor_LineColor_LightBlue;
            crtSelectedIdx = i;
        }
    }
    
    proNameList = [nameList copy];
    ratioList = [rList copy];
}

- (void)setAutoLayoutHeight:(BOOL)autoLayoutHeight {
    _autoLayoutHeight = autoLayoutHeight;
    self.landscapeBar.autoLayoutHeight = autoLayoutHeight;
}

- (void)clickNameActive:(UIButton *)sender {
    NSInteger tag = sender.tag + 10000;
    if (self.delegate && [self.delegate respondsToSelector:@selector(moduleTwoBaseView:didSelectedAtIndex:data:)]) {
        [self.delegate moduleTwoBaseView:self didSelectedAtIndex:tag data:self.bargraphModel.xAxisData[tag]];
    }
    
    // 显示完整文字
    [SYPHudView showHUDWithTitle:self.bargraphModel.xAxisData[tag]];
    
    // 指示，恢复默认
    UILabel *proName = [[self viewWithTag:-3000] viewWithTag:-12000 + crtSelectedIdx];
    proName.textColor = SYPColor_TextColor_Chief;
    UILabel *ratioLB = [[self viewWithTag:-3000] viewWithTag:-13000 + crtSelectedIdx];
    ratioLB.textColor = SYPColor_TextColor_Chief;
    UIImageView *iv = [[self viewWithTag:-3000] viewWithTag:-11000 + crtSelectedIdx];
    iv.hidden = YES;
    
    // 指示，选中状态
    [[self viewWithTag:-3000] viewWithTag:-11000 + tag].hidden = NO;
    proNameList[tag].textColor = SYPColor_LineColor_LightBlue;
    ratioList[tag].textColor = SYPColor_LineColor_LightBlue;
    
    crtSelectedIdx = tag;
    crtSelectedPro = self.bargraphModel.xAxisData[crtSelectedIdx];
}

- (CGFloat)estimateViewHeight:(SYPBaseChartModel *)model {
    
    return [self.landscapeBar estimateViewHeight:model] + 40/*CGRectGetHeight(titleView.frame)*/;
}

- (void)refreshSubViewData {
    self.landscapeBar.model = self.bargraphModel;
    
    inverBtnFirst.typeName = self.bargraphModel.xAxisName;
    inverBtnSecond.typeName = self.bargraphModel.seriesName;
}

#pragma mark - <SYPLandscapeBarDelegate>
- (void)landscapeBar:(SYPLandscapeBarLayer *)bar refreshHeight:(CGFloat)height {
    // bar 布局完成后会自动更新frame
    
    if (self.autoLayoutHeight) {
        CGRect frame = self.frame;
        frame.size.height = CGRectGetHeight(self.landscapeBar.frame) + CGRectGetHeight(titleView.frame);
        self.frame = frame;
    }
    
    // 重绘产品区域
    [self initializeAxis];
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
    
    // 排序
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
    
    // 更新页面展示
    // 图形更新后，重绘标题区
    self.landscapeBar.model = self.bargraphModel;
//    // 产品名、变化率更新
//    for (int i = 0; i < proNameList.count; i++) {
//        UIButton *proNameBtn = proNameList[i];
//        NSString *proName = self.bargraphModel.xAxisData[i];
//        [proNameBtn setTitle:proName forState:UIControlStateNormal];
//        ratioList[i].text = self.bargraphModel.seriesData[i].value;
//
//        // 恢复上一次选中的产品标示
//        if ([proName isEqualToString:crtSelectedPro]) {
//            UIImageView *proNameIV = [[self viewWithTag:-3000] viewWithTag:-11000 + i];
//            proNameIV.hidden = NO;
//            [proNameBtn setTitleColor:SYPColor_LineColor_LightBlue forState:UIControlStateNormal];
//        }
//    }
    
}


@end
