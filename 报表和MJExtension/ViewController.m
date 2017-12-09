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
#import "SYPPageView.h"

@interface ViewController ()

@property (nonatomic, strong) SYPPageModel *pageModel;


@property (weak, nonatomic) IBOutlet SYPPageView *PageView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    CGFloat staH = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
//    CGFloat navH = CGRectGetHeight(self.navigationController.navigationBar.frame);
//    CGFloat tabH = CGRectGetHeight(self.tabBarController.tabBar.frame);
//    CGFloat topOffset = staH + navH + SYPDefaultMargin;
    
    /*
    // 组件测试
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
            //            self.ExcelView.autoLayoutHeight = YES;
        }
    }];
     // 筛选组件测试
 //    self.FilterView.filterModel = self.pageModel.filter;
    */
    
    
    // 整体数据测试
    self.PageView.pageModel = self.pageModel;
    
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
