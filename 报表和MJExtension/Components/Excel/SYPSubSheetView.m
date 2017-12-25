//
//  SYPSubSheetView.m
//  各种报表
//
//  Created by niko on 17/5/18.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPSubSheetView.h"
#import "SYPSheetView.h"
#import "Masonry.h"
@interface SYPSubSheetView ()

@property (nonatomic, strong) SYPSheetView *sheetView;
@property (nonatomic, strong) UILabel *sheetTitleLabel;
@property (nonatomic, strong) UIButton *closePageBtn;

@end

@implementation SYPSubSheetView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.sheetTitleLabel];
        [self.sheetTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
        
        [self addSubview:self.sheetView];
        [self.sheetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.sheetTitleLabel.mas_bottom);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        [self addSubview:self.closePageBtn];
        [self.closePageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(self.mas_bottom).mas_equalTo(-30);
            make.width.height.mas_equalTo(36);
        }];
    }
    return self;
}

- (SYPSheetView *)sheetView {
    if (!_sheetView) {
        
        _sheetView = [[SYPSheetView alloc] init];//WithFrame:CGRectMake(0, CGRectGetMaxY(self.sheetTitleLabel.frame), SYPScreenWidth, SYPViewHeight - CGRectGetMaxY(self.sheetTitleLabel.frame))
        _sheetView.flexibleHeight = YES;
    }
    return _sheetView;
}

- (UILabel *)sheetTitleLabel {
    if (!_sheetTitleLabel) {
        _sheetTitleLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(0, 20, SYPScreenWidth, 44)
        //_sheetTitleLabel.textColor = SYPColor_TextColor_Chief;
        _sheetTitleLabel.textAlignment = NSTextAlignmentCenter;
        _sheetTitleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _sheetTitleLabel;
}

- (UIButton *)closePageBtn {
    if (!_closePageBtn) {
        _closePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //_closePageBtn.frame = CGRectMake((SYPViewWidth - 36)/2, SYPViewHeight - 36 - 30, 36, 36);
        [_closePageBtn setImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
        [_closePageBtn addTarget:self action:@selector(closeSubSheetView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closePageBtn;
}

- (void)setSheetModel:(SYPTableConfigModel *)sheetModel {
    if (![_sheetModel isEqual:sheetModel]) {
        _sheetModel = sheetModel;
    }
    self.sheetTitleLabel.text = _sheetModel.title;
    self.sheetView.moduleModel = _sheetModel;
}

- (void)showSubSheetView {
    
    self.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    __block CGRect frame = self.frame;
    frame.origin.y = SYPScreenHeight;
    self.frame = frame;
    [UIView animateWithDuration:0.25 animations:^{
        frame.origin.y = 0;
        self.frame = frame;
    }];
}

- (void)closeSubSheetView {
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:0.25 animations:^{
        frame.origin.y = SYPScreenHeight;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
