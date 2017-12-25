//
//  SYPModuleTwoCell.m
//  各种报表
//
//  Created by niko on 17/5/8.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPPartViewCell.h"

/* 模块二元组件 */
#import "SYPClickableLineView.h"
#import "SYPCompareSaleView.h"
#import "SYPExcelView.h"
#import "SYPLandscapeBarView.h"
#import "SYPBannerView.h"
#import "SYPInfoView.h"

#define ToLeftMargin SYPDefaultMargin * 3

@interface SYPPartViewCell () <SYPBaseComponentViewDelegate>

@property (nonatomic, strong) SYPBannerView *bannerView; // 标题
@property (nonatomic, strong) SYPClickableLineView *clickableLineView; // 双线
@property (nonatomic, strong) SYPCompareSaleView *compareSaleView; // 单值
@property (nonatomic, strong) SYPExcelView *excelView;
@property (nonatomic, strong) SYPLandscapeBarView *landscapeBarView; // 条状横向
@property (nonatomic, strong) SYPInfoView *infoView;

@end

@implementation SYPPartViewCell

- (SYPInfoView *)infoView {
    if (!_infoView) {
        _infoView = [[SYPInfoView alloc] initWithFrame:CGRectMake(ToLeftMargin, 0, SYPViewWidth - ToLeftMargin * 2, SYPViewHeight)];
        _infoView.moduleModel = self.viewModel;
    }
    return _infoView;
}

- (SYPBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[SYPBannerView alloc] initWithFrame:CGRectMake(ToLeftMargin, 0, SYPViewWidth - ToLeftMargin * 2, SYPViewHeight)];
        _bannerView.moduleModel = self.viewModel;
        
    }
    return _bannerView;
}

- (SYPCompareSaleView *)compareSaleView {
    if (!_compareSaleView) {
        NSLog(@"cell %@", self);
        _compareSaleView = [[SYPCompareSaleView alloc] initWithFrame:CGRectMake(ToLeftMargin, 0, SYPViewWidth - ToLeftMargin * 2, SYPViewHeight)];
        _compareSaleView.moduleModel = self.viewModel;
        _compareSaleView.delegate = self;
    }
    return _compareSaleView;
}

- (SYPClickableLineView *)clickableLineView {
    if (!_clickableLineView) {
        _clickableLineView = [[SYPClickableLineView alloc] initWithFrame:CGRectMake(SYPDefaultMargin * 2, 0, SYPViewWidth - SYPDefaultMargin * 2, SYPViewHeight)];
        _clickableLineView.moduleModel = self.viewModel;
        _clickableLineView.delegate = self;
    }
    return _clickableLineView;
}

- (SYPExcelView *)excelView {
    if (!_excelView) {
        _excelView = [[SYPExcelView alloc] initWithFrame:CGRectMake(0, 0, SYPViewWidth, SYPViewHeight)];
        _excelView.moduleModel = self.viewModel;
        _excelView.delegate = self;
        _excelView.autoLayoutHeight = YES;
    }
    return _excelView;
}

- (SYPLandscapeBarView *)landscapeBarView {
    if (!_landscapeBarView) {
        _landscapeBarView = [[SYPLandscapeBarView alloc] initWithFrame:CGRectMake(SYPDefaultMargin * 1.5, 0, SYPViewWidth - SYPDefaultMargin * 1.5, SYPViewHeight)];
        _landscapeBarView.moduleModel = self.viewModel;
        _landscapeBarView.delegate = self;
        _landscapeBarView.autoLayoutHeight = YES;
    }
    return _landscapeBarView;
}

- (void)setViewModel:(SYPBaseChartModel *)viewModel {
    if (![_viewModel isEqual:viewModel]) {
        _viewModel = viewModel;
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        switch (self.viewModel.chartType) {
            case SYPChartTypeBanner:
                [self addSubview:self.bannerView];
                break;
            case SYPChartTypeLineOrHistogram:
                [self addSubview:self.clickableLineView];
                break;
            case SYPChartTypeTables:
                [self addSubview:self.excelView];
                break;
            case SYPChartTypeInfo:
                [self addSubview:self.infoView];
                break;
            case SYPChartTypeSingleValue:
                [self addSubview:self.compareSaleView];
                break;
            case SYPChartTypeBargraph:
                [self addSubview:self.landscapeBarView];
                break;
                
            default:
                break;
        }
    }
}

- (CGFloat)cellHeightWithModel:(SYPBaseChartModel *)model {
    
    CGFloat height = 0.0;
    switch (model.chartType) {
        case SYPChartTypeBanner:
            height = [self.bannerView estimateViewHeight:model];
            break;
        case SYPChartTypeLineOrHistogram:
            height = [self.clickableLineView estimateViewHeight:model];
            break;
        case SYPChartTypeTables:
            height = [self.excelView estimateViewHeight:model];
            break;
        case SYPChartTypeInfo:
            height = [self.infoView estimateViewHeight:model];
            break;
        case SYPChartTypeSingleValue:
            height = [self.compareSaleView estimateViewHeight:model];
            break;
        case SYPChartTypeBargraph:
            height = [self.landscapeBarView estimateViewHeight:model];
            break;
            
        default:
            break;
    }
    return height;
}

- (void)moduleTwoBaseView:(SYPBaseComponentView *)moduleTwoBaseView didSelectedAtIndex:(NSInteger)idx data:(id)data {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moduleTwoCell:didSelectedAtBaseView:Index:data:)]) {
        [self.delegate moduleTwoCell:self didSelectedAtBaseView:moduleTwoBaseView Index:idx data:data];
    }
}

@end
