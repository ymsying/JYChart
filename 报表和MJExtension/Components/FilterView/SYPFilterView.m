//
//  SYPFilterView.m
//  报表和MJExtension
//
//  Created by 应明顺 on 2017/12/7.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPFilterView.h"
#import "SYPConstantColor.h"
#import "SYPConstantSize.h"
#import "SYPFilterPopView.h"
#import "UIButton+SYPPositionSwap.h"
#import "Masonry.h"

#pragma mark - SYPFilterView
@interface SYPFilterView ()

@property (nonatomic, copy) UILabel *filterLabel;
@property (nonatomic, copy) UIButton *filterBtn;

@end

@implementation SYPFilterView

#pragma mark - Initialize Method
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.clipsToBounds = YES;
        [self addSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    
    [self addSubview:self.filterLabel];
    [self.filterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.7);
    }];
    
    [self addSubview:self.filterBtn];
    [self.filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.3);
        make.right.mas_equalTo(0);
    }];
    
    [self.filterBtn updateBtnContentPosition];
}

#pragma mark - lazy
- (UILabel *)filterLabel {
    if (!_filterLabel) {
        _filterLabel = [[UILabel alloc] init];
        _filterLabel.textColor = SYPColor_LineColor_Blue;
        _filterLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _filterLabel;
}

- (UIButton *)filterBtn {
    if (!_filterBtn) {
        _filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
        _filterBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_filterBtn setTitleColor:SYPColor_AlertBackgroudColor_BlackGray forState:UIControlStateNormal];
        [_filterBtn setImage:[UIImage imageNamed:@"pop_screen"] forState:UIControlStateNormal];
        _filterBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;        
        [_filterBtn addTarget:self action:@selector(showFilterList:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterBtn;
}

#pragma mark - Property Mothed
- (void)setFilterModel:(SYPFilterModel *)filterModel {
    if (![_filterModel isEqual:filterModel]) {
        _filterModel = filterModel;
        _filterLabel.text = filterModel.display;
    }
}

#pragma mark Logic Method
//- (void)refreshSubViewData {
//    if (!self.filterModel) {
//        self.filterModel = (SYPFilterModel *)self.moduleModel;
//    }
//}

- (void)showFilterList:(UIButton *)sender {
    
    __weak typeof(self) ws = self;
    [SYPFilterPopView showFilterListViewWithFilter:self.filterModel completionHandler:^(NSString *result) {
        __strong typeof(ws) ss = ws;
        ss.filterLabel.text = result;
        ss.filterModel.display = result;
        
        if (ss.delegate && [(id)ss.delegate respondsToSelector:@selector(filterView:selecteResult:)]) {
            [ss.delegate filterView:ss selecteResult:result];
        }
    }];
    
}

- (CGFloat)estimateViewHeight:(SYPBaseChartModel *)model {

    return 40 * SYPScreenRatio;
}



@end








