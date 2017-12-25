//
//  SYPTabButton.m
//  报表和MJExtension
//
//  Created by 应明顺 on 2017/12/7.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPTabButton.h"
#import "SYPConstantColor.h"
#import "Masonry.h"

@interface SYPTabButton () {
    UIColor *indicatorColorNormal;
    UIColor *indicatorColorSelected;
}

@property (nonatomic, copy) UIView *indicatorLine;
@end

@implementation SYPTabButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.indicatorLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.indicatorLine.frame = CGRectMake(0, self.bounds.size.height - 2, self.bounds.size.width, 2);
    [self.indicatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom).mas_equalTo(-2);
        make.height.mas_equalTo(2);
    }];
}

- (UIView *)indicatorLine {
    if (!_indicatorLine) {
        _indicatorLine = [[UIView alloc] init];
        _indicatorLine.backgroundColor = SYPColor_LineColor_Blue;
    }
    return _indicatorLine;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        _indicatorLine.backgroundColor = indicatorColorSelected;
    } else {
        _indicatorLine.backgroundColor = indicatorColorNormal;
    }
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    [super setTitleColor:color forState:state];
    if (state == UIControlStateNormal) {
        indicatorColorNormal = color;
    }
    else if (state == UIControlStateSelected) {
        indicatorColorSelected = color;
    }
}





@end
