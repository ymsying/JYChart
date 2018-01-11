//
//  ViewController.m
//  报表和MJExtension
//
//  Created by 应明顺 on 2017/12/1.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
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


@property (nonatomic, strong) SYPPageView *pageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat navStsH = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    // 整体数据测试
    [self.view addSubview:self.pageView];
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navStsH);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    self.pageView.pageModel = self.pageModel;
    
}


#pragma mark - Getter/Setter

- (SYPPageModel *)pageModel {
    if (!_pageModel) {
        // 数据准备// 数据准备 3#数据大，1#筛选
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"template1_01" ofType:@"json"];
        
        id data = [NSData dataWithContentsOfFile:dataPath];
        NSError *error = nil;
        id serializedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSAssert(serializedData, @"数据解析错误");
        _pageModel = [SYPPageModel pageModel:serializedData];
    }
    
    return _pageModel;
}

-(SYPPageView *)pageView {
    if (!_pageView) {
        _pageView = [[SYPPageView alloc]init];
    }
    return _pageView;
}


@end
