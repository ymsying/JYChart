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
        [self addSubview:self.helpTitleLabel];
        
        [self addSubview:self.helpInfoView];
        [self addSubview:self.closePageBtn];
    }
    return self;
}

- (UITextView *)helpInfoView {
    if (!_helpInfoView) {
        _helpInfoView = [[UITextView alloc] initWithFrame:CGRectMake(SYPDefaultMargin * 2, CGRectGetMaxY(self.helpTitleLabel.frame) + SYPDefaultMargin, SYPScreenWidth - SYPDefaultMargin * 2 * 2, SYPViewHeight - CGRectGetMaxY(self.helpTitleLabel.frame))];
        _helpInfoView.editable = NO;
    }
    return _helpInfoView;
}

- (UILabel *)helpTitleLabel {
    if (!_helpTitleLabel) {
        _helpTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SYPScreenWidth, 44)];
        _helpTitleLabel.textColor = SYPColor_TextColor_Chief;
        _helpTitleLabel.textAlignment = NSTextAlignmentCenter;
        _helpTitleLabel.font = [UIFont boldSystemFontOfSize:15];
        _helpTitleLabel.text = @"图标说明";
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_helpTitleLabel.frame), SYPViewWidth, 0.5)];
        line.backgroundColor = SYPColor_SepLineColor_LightGray;
        [self addSubview:line];
    }
    return _helpTitleLabel;
}

- (UIButton *)closePageBtn {
    if (!_closePageBtn) {
        _closePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closePageBtn.frame = CGRectMake((SYPViewWidth - 36)/2, SYPViewHeight - 36 - 30, 36, 36);
        [_closePageBtn setImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
        [_closePageBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
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
