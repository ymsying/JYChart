//
//  SYPBannerView.m
//  各种报表
//
//  Created by niko on 17/5/10.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPBannerView.h"
#import "Masonry.h"
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

- (void)updateConstraints {
    [super updateConstraints];
    
    CGFloat width = [model.title boundingRectWithSize:CGSizeMake((SYPViewWidth - 20)/2.0, SYPViewHeight) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : titleLB.font} context:nil].size.width;
    [titleLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width + SYPDefaultMargin);
    }];
    
    width = [model.date boundingRectWithSize:CGSizeMake((SYPViewWidth - 20)/2.0, SYPViewHeight) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : dateLB.font} context:nil].size.width;
    [dateLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width + SYPDefaultMargin);
    }];
}

- (void)initializeSubVeiw {
    
    titleLB = [[UILabel alloc] init];//WithFrame:CGRectMake(0, 0, 110, SYPViewHeight)
    titleLB.text = @"销售额-VS-目标";
    [self addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
    }];
    
    dateLB = [[UILabel alloc] init];//WithFrame:CGRectMake(CGRectGetMaxX(titleLB.frame) + SYPDefaultMargin, 0, 100, SYPViewHeight)
    dateLB.text = @"2017/05/10";
    [self addSubview:dateLB];
    [dateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLB.mas_right);
        make.top.bottom.mas_equalTo(0);
    }];
    
    
    UIButton *showInfoBtn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    //showInfoBtn.frame = CGRectMake(SYPViewWidth - SYPDefaultMargin - 20, (SYPViewHeight - 20)/2, 20, 20);
    [showInfoBtn addTarget:self action:@selector(showHelpInfo:) forControlEvents:UIControlEventTouchUpInside];
    showInfoBtn.tintColor = [UIColor lightGrayColor];
    [self addSubview:showInfoBtn];
    [showInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(20);
    }];
}

- (void)refreshSubViewData {
    
    model = ((SYPBannerModel *)self.moduleModel);
    
    titleLB.text = model.title;
    dateLB.text = model.date;
    [self setNeedsUpdateConstraints];
}

- (CGFloat)estimateViewHeight:(SYPBaseChartModel *)model {
    return 44;
}

- (void)showHelpInfo:(UIButton *)sender {
    [SYPHelpInfoView helpShowWithTitle:@"图标说明" info:((SYPBannerModel *)self.moduleModel).info];
}

@end
