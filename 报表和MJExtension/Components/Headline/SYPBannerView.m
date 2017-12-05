//
//  SYPBannerView.m
//  各种报表
//
//  Created by niko on 17/5/10.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPBannerView.h"

#import "SYPHelpInfoView.h"

@interface SYPBannerView () {
    UILabel *titleLB;
    UILabel *dateLB;
    SYPBannerModel *model;
}

@end

@implementation SYPBannerView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeSubVeiw];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeSubVeiw];
    }
    return self;
}

- (void)initializeSubVeiw {
    
    titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, SYPViewHeight)];
    titleLB.text = @"销售额VS目标";
    [self addSubview:titleLB];
    
    dateLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLB.frame) + SYPDefaultMargin, 0, 100, SYPViewHeight)];
    dateLB.text = @"2017/05/10";
    [self addSubview:dateLB];
    
    UIButton *showInfoBtn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    showInfoBtn.frame = CGRectMake(SYPViewWidth - SYPDefaultMargin - 20, (SYPViewHeight - 20)/2, 20, 20);
    [showInfoBtn addTarget:self action:@selector(showHelpInfo:) forControlEvents:UIControlEventTouchUpInside];
    showInfoBtn.tintColor = [UIColor lightGrayColor];
    [self addSubview:showInfoBtn];
}

- (void)refreshSubViewData {
    model = ((SYPBannerModel *)self.moduleModel);
    
    titleLB.text = model.title;
    dateLB.text = model.date;
    
    CGRect frame = titleLB.frame;
    CGFloat width = [model.title boundingRectWithSize:CGSizeMake((SYPViewWidth - 20 - SYPDefaultMargin * 2)/2.0, SYPViewHeight) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : titleLB.font} context:nil].size.width;
    frame.size.width = width;
    titleLB.frame = frame;
    
    frame = dateLB.frame;
    width = [model.date boundingRectWithSize:CGSizeMake((SYPViewWidth - 20 - SYPDefaultMargin * 2)/2.0, SYPViewHeight) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : dateLB.font} context:nil].size.width;
    frame.origin.x = SYPViewMaxX1(titleLB) + SYPDefaultMargin;
    frame.size.width = width;
    dateLB.frame = frame;
    
}

- (CGFloat)estimateViewHeight:(SYPBaseChartModel *)model {
    return 44;
}

- (void)showHelpInfo:(UIButton *)sender {
//    NSLog(@"%@", ((SYPBannerModel *)self.moduleModel).info);
//    SYPHelpInfoView *helpInfoView = [[SYPHelpInfoView alloc] initWithFrame:CGRectMake(0, 0, SYPScreenWidth, SYPScreenHeight)];
    [SYPHelpInfoView helpShowWithTitle:@"图标说明" info:((SYPBannerModel *)self.moduleModel).info];
}

@end
