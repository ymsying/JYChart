//
//  SYPFreezeViewCell.m
//  各种报表
//
//  Created by niko on 17/5/6.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPFreezeViewCell.h"
#import "SYPBlockButton.h"
#import "SYPConstantColor.h"
#import "SYPConstantSize.h"
@interface SYPFreezeViewCell ()

@property (strong, nonatomic) UIView *bottomLine;
@property (strong, nonatomic) UIView *rightLine;
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic, strong) SYPBlockButton *clickBtn;
@property (nonatomic, copy) void(^clickActive)(NSString *title);
@property (nonatomic, strong) UIView *flagPoint;

@end

@implementation SYPFreezeViewCell

- (instancetype)initWithStyle:(SYPFreezeViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        [self addLine];
        switch (style) {
            case SYPFreezeViewCellStyleDefault:
            {
                _style = style;
                _titleLabel = [[UILabel alloc] init];
                _titleLabel.textColor = SYPColor_TextColor_Chief;
                _titleLabel.textAlignment = NSTextAlignmentLeft;
                _titleLabel.font = [UIFont systemFontOfSize:14];
                _titleLabel.numberOfLines = 2;
                [self addSubview:_titleLabel];
            }
                break;
            case SYPFreezeViewCellStyleCustom:
            {
                _style = style;
            }
                break;
            default:
                break;
        }
        [self addSubview:self.clickBtn];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSeparatorStyle:(SYPRowViewCellSeparatorStyle)separatorStyle {
    _separatorStyle = separatorStyle;
    if (separatorStyle == SYPFreezeViewCellSeparatorStyleNone) {
        [self removeLine];
    }
}

- (SYPBlockButton *)clickBtn {
    if (!_clickBtn) {
        _clickBtn = [SYPBlockButton buttonWithType:UIButtonTypeCustom];
        __weak typeof(self) weakSelf = self;
        [_clickBtn setHandler:^(BOOL isSelected) {
            __strong typeof(weakSelf) inStrongSelf = weakSelf;
            if (inStrongSelf.clickActive) {
                inStrongSelf.clickActive(inStrongSelf.title);
            }
        }];
    }
    return _clickBtn;
}

- (void)addLine {
    UIColor *lineGrayColor = [UIColor colorWithRed:205./255. green:205./255. blue:205./255. alpha:1];
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(-SYPDefaultMargin * 2, self.frame.size.height - 1, self.frame.size.width + SYPDefaultMargin * 2, 0.5)];
    _bottomLine.backgroundColor = lineGrayColor;
    [self addSubview:_bottomLine];
    _rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height)];
    _rightLine.backgroundColor = lineGrayColor;
    [self addSubview:_rightLine];
}

- (void)removeLine {
    [self.bottomLine removeFromSuperview];
    [self.rightLine removeFromSuperview];
}

- (void)setLine {
    [self.bottomLine setFrame:CGRectMake(-SYPDefaultMargin * 2, self.frame.size.height - 0.5, self.frame.size.width + SYPDefaultMargin * 2, 0.5)];
    [self.rightLine setFrame:CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.clickBtn.frame = self.bounds;
    if (self.style == SYPFreezeViewCellStyleDefault) {
        [self.titleLabel setFrame:CGRectMake(SYPDefaultMargin, 0, self.frame.size.width-SYPDefaultMargin * 1.5, self.frame.size.height)];
        [self.flagPoint setFrame:CGRectMake(-13, (CGRectGetHeight(self.titleLabel.frame) - 15) / 2.0, 15, 15)];
    }
    if (self.separatorStyle == SYPFreezeViewCellSeparatorStyleSingleLine) {
        [self setLine];
    }
    
    UIView *whiteBG = [[UIView alloc] initWithFrame:CGRectMake(-SYPDefaultMargin * 2, 0, SYPViewWidth + SYPDefaultMargin * 2, SYPViewHeight - 1)];
    whiteBG.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteBG];
    [self sendSubviewToBack:whiteBG];
}

- (void)setClickedActive:(void (^)(NSString *))selectedActive {
    self.clickActive = selectedActive;
}

- (UIView *)flagPoint {
    if (!_flagPoint) {
        _flagPoint = [[UIView alloc] initWithFrame:CGRectMake(-13, (CGRectGetHeight(self.titleLabel.frame) - 15) / 2.0, 15, 15)];
        _flagPoint.layer.cornerRadius = CGRectGetWidth(_flagPoint.frame)/2.0;
        _flagPoint.backgroundColor = [SYPColor_LineColor_LightBlue appendAlpha:0.15];
        _flagPoint.hidden = YES;
        
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        point.layer.cornerRadius = CGRectGetWidth(point.frame)/2.0;
        point.backgroundColor = SYPColor_LineColor_LightBlue;
        point.center = CGPointMake(CGRectGetWidth(_flagPoint.frame) /2.0, CGRectGetWidth(_flagPoint.frame) /2.0);
        [_flagPoint addSubview:point];
        
        [self addSubview:_flagPoint];
    }
    return _flagPoint;
}

- (void)setShowFlagPoint:(BOOL)showFlagPoint {
    _showFlagPoint = showFlagPoint;
    if (showFlagPoint) {
        self.flagPoint.hidden = NO;
        self.titleLabel.textColor = SYPColor_LineColor_LightBlue;
    }
}


@end
