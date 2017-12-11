//
//  SYPFirstViewController.m
//  报表和MJExtension
//
//  Created by 应明顺 on 2017/12/9.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPFirstViewController.h"

#import <objc/runtime.h>

#import "SYPPageModel.h"
#import "SYPCompareSaleView.h"
#import "SYPBannerView.h"
#import "SYPInfoView.h"
#import "SYPLandscapeBarView.h"
#import "SYPClickableLineView.h"
#import "SYPExcelView.h"
#import "SYPFilterView.h"
#import "SYPPageView.h"
#import "SYPHudView.h"


@interface SYPFirstViewController () {
    UIView *currentChart;
}

@property (nonatomic, strong) SYPPageModel *pageModel;

@property (weak, nonatomic) IBOutlet SYPCompareSaleView *SingeValueView;

@property (weak, nonatomic) IBOutlet SYPInfoView *InfoView;

@property (weak, nonatomic) IBOutlet SYPBannerView *BannerView;

@property (weak, nonatomic) IBOutlet SYPLandscapeBarView *BargraphView;

@property (weak, nonatomic) IBOutlet SYPClickableLineView *ChartView;

@property (weak, nonatomic) IBOutlet SYPExcelView *TablesView;

@property (weak, nonatomic) IBOutlet SYPFilterView *FilterView;

@end

@implementation SYPFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)clickBtn:(UIButton *)sender {
    NSLog(@"%@", sender.currentTitle);
    NSString *currentTitle = sender.currentTitle;
    NSString *type = @"";
    if ([@"单值" isEqualToString:currentTitle]) {
        type = @"SingeValue";
    } else if ([@"大标题" isEqualToString:currentTitle]) {
        type = @"Banner";
    } else if ([@"副标题" isEqualToString:currentTitle]) {
        type = @"Info";
    } else if ([@"折线图" isEqualToString:currentTitle]) {
        type = @"Chart";
    } else if ([@"筛选" isEqualToString:currentTitle]) {
        type = @"Filter";
        currentChart.hidden = YES;
        self.FilterView.filterModel = self.pageModel.filter;
        self.FilterView.hidden = NO;
        currentChart = self.FilterView;
        return;
    } else if ([@"条状图" isEqualToString:currentTitle]) {
        type = @"Bargraph";
    } else if ([@"表格" isEqualToString:currentTitle]) {
        type = @"Tables";
    }
    
    Class clazzModel = NSClassFromString([NSString stringWithFormat:@"SYP%@Model", type]);
    
    NSString *selfView = [NSString stringWithFormat:@"%@View", type];
    SYPBaseComponentView *chartView = [self valueForKey:selfView];
    
    
    currentChart.hidden = YES;
    [self.pageModel.parts enumerateObjectsUsingBlock:^(SYPBaseChartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:clazzModel]) {
            chartView.moduleModel = obj;
            chartView.hidden = NO;
            *stop = YES;
        } else if (idx == self.pageModel.parts.count-1){
            [SYPHudView showHUDWithTitle:@"无此类数据"];
        }
        
    }];
    currentChart = chartView;
}

- (SYPPageModel *)pageModel {
    if (!_pageModel) {
        // 数据准备
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"template1_03" ofType:@"json"];
        
        id data = [NSData dataWithContentsOfFile:dataPath];
        NSError *error = nil;
        id serializedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSAssert(serializedData, @"数据解析错误");
        _pageModel = [SYPPageModel pageModel:serializedData];
    }
    
    return _pageModel;
}


@end
