//
//  SYPSectionViewCell.m
//  SYPFreezeWindowView
//
//  Created by niko on 17/5/4.
//  Copyright © 2015年 YMS All rights reserved.
//

#import "SYPSectionViewCell.h"
#import "SYPBlockButton.h"
#import "SYPConstantColor.h"
#import "SYPConstantSize.h"

@interface SYPSectionViewCell ()
@property (strong, nonatomic) UIView *leftLine;
@property (strong, nonatomic) UIView *rightLine;
@property (strong, nonatomic) UIView *bottomLine;
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *sortIcon;
@property (nonatomic, strong) SYPBlockButton *clickBtn;
@property (nonatomic, copy) void(^clickActive)(NSString *title, BOOL isSelect);

@end

@implementation SYPSectionViewCell

- (instancetype)initWithStyle:(SYPSectionViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        [self addLine];
        switch (style) {
            case SYPSectionViewCellStyleDefault:
            {
                _style = style;
                _titleLabel = [[UILabel alloc] init];
                _titleLabel.textAlignment = NSTextAlignmentLeft;
                _titleLabel.numberOfLines = 0;
                _titleLabel.textColor = SYPColor_TextColor_Chief;
                _titleLabel.font = [UIFont systemFontOfSize:13];
                [self addSubview:_titleLabel];
            }
                break;
            case SYPSectionViewCellStyleCustom:
            {
                _style = style;
            }
            default:
                break;
        }
        [self addSubview:self.clickBtn];
        self.backgroundColor = SYPColor_BackgroudColor_SubWhite;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSeparatorStyle:(SYPSectionViewCellSeparatorStyle)separatorStyle {
    _separatorStyle = separatorStyle;
    if (separatorStyle == SYPSectionViewCellSeparatorStyleNone) {
        [self removeLine];
    }
}

- (UIImageView *)sortIcon {
    if (!_sortIcon) {
        _sortIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_sort"]];
        [self addSubview:_sortIcon];
    }
    return _sortIcon;
}

- (SYPBlockButton *)clickBtn {
    if (!_clickBtn) {
        _clickBtn = [SYPBlockButton buttonWithType:UIButtonTypeCustom];
        __weak typeof(self) weakSelf = self;
        [_clickBtn setHandler:^(BOOL isSelected){
            weakSelf.clickActive(weakSelf.title, isSelected);
            weakSelf.sortIcon.image = [UIImage imageNamed:@"icon_array"];
            if (isSelected) {
                weakSelf.sortIcon.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            }
            else {
                weakSelf.sortIcon.layer.transform = CATransform3DIdentity;
            }
        }];
    }
    return _clickBtn;
}

- (void)addLine {
    UIColor *lineGrayColor = [UIColor colorWithRed:205./255. green:205./255. blue:205./255. alpha:1];
    _leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
    _leftLine.backgroundColor = lineGrayColor;
    _leftLine.hidden = YES;
    [self addSubview:_leftLine];
    _rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height)];
    _rightLine.backgroundColor = lineGrayColor;
    _rightLine.hidden = YES;
    [self addSubview:_rightLine];
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width + SYPDefaultMargin * 2, 0.5)];
    _bottomLine.backgroundColor = lineGrayColor;
    //_bottomLine.hidden = YES;
    [self addSubview:_bottomLine];
}

- (void)removeLine {
    [self.leftLine removeFromSuperview];
    [self.rightLine removeFromSuperview];
    [self.bottomLine removeFromSuperview];
}

- (void)setLine {
    [self.leftLine setFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
    [self.rightLine setFrame:CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height)];
    [self.bottomLine setFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.clickBtn.frame = self.bounds;
    if (self.style == SYPSectionViewCellStyleDefault) {
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin;
        CGFloat width = [self.titleLabel.text boundingRectWithSize:self.titleLabel.frame.size options:opts attributes:@{NSFontAttributeName: self.titleLabel.font} context:nil].size.width;
        [self.titleLabel setFrame:CGRectMake((self.frame.size.width - width) / 2 - 6, 0, width, self.frame.size.height)];
        [self.sortIcon setFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 4, (CGRectGetHeight(self.titleLabel.frame) - 12) / 2, 6, 12)];
    }
    if (self.separatorStyle == SYPSectionViewCellSeparatorStyleSingleLine) {
        [self setLine];
    }
}

- (void)setClickedActive:(void (^)(NSString *, BOOL))selectedActive {
    self.clickActive = selectedActive;
}

- (void)rotationCellSortIcon:(CGFloat)angle {
    self.sortIcon.image = [UIImage imageNamed:@"icon_array"];
    self.sortIcon.layer.transform = CATransform3DMakeRotation(angle, 0, 0, 1);
}

@end
