//
//  SYPHelpInfoView.m
//  各种报表
//
//  Created by niko on 17/5/20.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPHelpInfoView.h"
#import "SYPConstantSize.h"
#import "SYPConstantColor.h"
#import "Masonry.h"

@interface SYPHelpInfoView ()

@property (nonatomic, strong) UILabel *helpTitleLabel;
@property (nonatomic, strong) UIButton *closePageBtn;
@property (nonatomic, strong) UITextView *helpInfoView;

@property (nonatomic, strong) NSString *helpInfo;
@property (nonatomic, strong) NSString *helpTitle;

@end

@implementation SYPHelpInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.helpTitleLabel.text = @"图标说明";
        self.helpInfoView.text = @"数据更新时间";
        [self bringSubviewToFront:self.closePageBtn];
    }
    return self;
}

- (UILabel *)helpTitleLabel {
    if (!_helpTitleLabel) {
        _helpTitleLabel = [[UILabel alloc] init];
        _helpTitleLabel.textColor = SYPColor_TextColor_Chief;
        _helpTitleLabel.textAlignment = NSTextAlignmentCenter;
        _helpTitleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:_helpTitleLabel];
        [_helpTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(kStaH);
            make.height.mas_equalTo(44);
        }];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_helpTitleLabel.frame), SYPViewWidth, 0.5)];
        line.backgroundColor = SYPColor_SepLineColor_LightGray;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(_helpTitleLabel.mas_bottom);
        }];
    }
    return _helpTitleLabel;
}

- (UITextView *)helpInfoView {
    if (!_helpInfoView) {
        _helpInfoView = [[UITextView alloc] init];
        _helpInfoView.editable = NO;
        [self addSubview:_helpInfoView];
        [_helpInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(SYPDefaultMargin * 2);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.top.mas_equalTo(self.helpTitleLabel.mas_bottom);
        }];
    }
    return _helpInfoView;
}

- (UIButton *)closePageBtn {
    if (!_closePageBtn) {
        _closePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closePageBtn.frame = CGRectMake((SYPViewWidth - 36)/2, SYPViewHeight - 36 - 30, 36, 36);
        [_closePageBtn setImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
        [_closePageBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closePageBtn];
        [_closePageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_right).multipliedBy(0.5);
            make.width.height.mas_equalTo(36);
            make.bottom.mas_equalTo(self.mas_bottom).with.mas_equalTo(-30);
        }];
    }
    return _closePageBtn;
}

- (void)setHelpInfo:(NSString *)helpInfo {
    self.helpInfoView.text = helpInfo;
}

- (void)setHelpTitle:(NSString *)helpTitle {
    self.helpTitleLabel.text = helpTitle;
}

+ (void)helpShowWithTitle:(NSString *)title info:(NSString *)info {
    
    SYPHelpInfoView *helpView = [[SYPHelpInfoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    helpView.helpTitle = title;
    helpView.helpInfo = info;
    [helpView show];
}

- (void)show {
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

- (void)close {
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:0.25 animations:^{
        frame.origin.y = SYPScreenHeight;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
