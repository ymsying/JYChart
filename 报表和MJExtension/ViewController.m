//
//  ViewController.m
//  报表和MJExtension
//
//  Created by 应明顺 on 2017/12/1.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "ViewController.h"
#import "SYPConstantSize.h"

#import "SYPPageModel.h"

#import "SYPCompareSaleView.h"
#import "SYPBannerView.h"
#import "SYPInfoView.h"
#import "SYPLandscapeBarView.h"
#import "SYPClickableLineView.h"
#import "SYPExcelView.h"
#import "SYPFilterView.h"

@interface ViewController ()

@property (nonatomic, strong) SYPPageModel *pageModel;

/**
 单值
 */
@property (weak, nonatomic) IBOutlet SYPCompareSaleView *singeValueView;

@property (weak, nonatomic) IBOutlet SYPInfoView *Crosshead;

@property (weak, nonatomic) IBOutlet SYPBannerView *BannerView;

@property (weak, nonatomic) IBOutlet SYPLandscapeBarView *LandscapeBarView;

@property (weak, nonatomic) IBOutlet SYPClickableLineView *ClickLine;

@property (weak, nonatomic) IBOutlet SYPExcelView *ExcelView;

@property (weak, nonatomic) IBOutlet SYPFilterView *FilterView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    CGFloat staH = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
//    CGFloat navH = CGRectGetHeight(self.navigationController.navigationBar.frame);
//    CGFloat tabH = CGRectGetHeight(self.tabBarController.tabBar.frame);
//    CGFloat topOffset = staH + navH + SYPDefaultMargin;
    
    self.FilterView.filterModel = self.pageModel.filter;
    [self.pageModel.parts enumerateObjectsUsingBlock:^(SYPBaseChartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[SYPSingleValueModel class]]) {
            self.singeValueView.moduleModel = obj;
            //                CGRect frame  = self.singeValueView.frame;
            //                frame.size.height = [self.singeValueView estimateViewHeight:obj];
            //                self.singeValueView.frame = frame;
        }
        if ([obj isKindOfClass:[SYPBannerModel class]]) {
            self.BannerView.moduleModel = obj;
        }
        if ([obj isKindOfClass:[SYPInfoModel class]]) {
            self.Crosshead.moduleModel = obj;
        }
        if ([obj isKindOfClass:[SYPBargraphModel class]]) {
            self.LandscapeBarView.moduleModel = obj;
            //                self.LandscapeBarView.autoLayoutHeight = YES;
        }
        if ([obj isKindOfClass:[SYPChartModel class]]) {
            self.ClickLine.moduleModel = obj;
        }
        if ([obj isKindOfClass:[SYPTablesModel class]]) {
            self.ExcelView.moduleModel = obj;
            //                self.ExcelView.autoLayoutHeight = YES;
        }
    }];
}

- (SYPPageModel *)pageModel {
    if (!_pageModel) {
        // 数据准备
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"template1_01" ofType:@"json"];
        
        id data = [NSData dataWithContentsOfFile:dataPath];
        NSError *error = nil;
        id serializedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        _pageModel = [SYPPageModel pageModel:serializedData];
    }
    
    return _pageModel;
}




@end
