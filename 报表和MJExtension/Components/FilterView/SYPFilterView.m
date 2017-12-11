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


#pragma mark - SYPFilterView
@interface SYPFilterView ()

@property (nonatomic, copy) UILabel *filterLabel;
@property (nonatomic, copy) UIButton *filterBtn;

@end

@implementation SYPFilterView


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.clipsToBounds = YES;
        [self addSubview:self.filterLabel];
        [self addSubview:self.filterBtn];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self addSubview:self.filterLabel];
        [self addSubview:self.filterBtn];
    }
    return self;
}

- (void)layoutSubviews {
    self.filterLabel.frame = CGRectMake(0, 0, SYPViewWidth * 0.7, SYPViewHeight);
    self.filterBtn.frame = CGRectMake(SYPViewMaxX1(self.filterLabel), 0, SYPViewWidth * 0.3, SYPViewHeight);
    [self updateFilterBtnContentFrame];
}

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

- (void)setFilterModel:(SYPFilterModel *)filterModel {
    if (![_filterModel isEqual:filterModel]) {
        _filterModel = filterModel;
        _filterLabel.text = filterModel.display;
    }
}

//- (void)refreshSubViewData {
//    if (!self.filterModel) {
//        self.filterModel = (SYPFilterModel *)self.moduleModel;
//    }
//}

- (void)updateFilterBtnContentFrame {
    
    // btn中title和image交互位置。偏移时，相对原位置进行移动，保证title、image大小不变
    CGFloat offset = 0;
    CGFloat imageWidth = _filterBtn.imageView.bounds.size.width;
    CGFloat labelWidth = _filterBtn.titleLabel.bounds.size.width;
    _filterBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + offset, 0, -labelWidth - offset);
    _filterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth - 6, 0, imageWidth + 6);
}


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








