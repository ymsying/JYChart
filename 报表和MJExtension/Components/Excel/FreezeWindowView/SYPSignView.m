//
//  SYPFreezeView.m
//  SYPFreezeWindowView
//
//  Created by niko on 17/5/4.
//  Copyright © 2015年 YMS All rights reserved.
//

#import "SYPSignView.h"
#import "SYPConstantSize.h"
#import "SYPConstantColor.h"

@interface SYPSignView ()

@property (strong, nonatomic) UILabel *contentLabel;
@property (nonatomic, strong) UIView *rightLine;
@property (strong, nonatomic) UIView *bottomLine;

@end

@implementation SYPSignView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *whiteBG = [[UIView alloc] initWithFrame:CGRectMake(-SYPDefaultMargin * 2, 0, SYPViewWidth + SYPDefaultMargin * 2, SYPViewHeight)];
        whiteBG.backgroundColor = SYPColor_BackgroudColor_SubWhite;
        [self addSubview:whiteBG];
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, frame.size.height / 4, frame.size.width - 7, frame.size.height / 2)];
        _contentLabel.textColor = SYPColor_TextColor_Chief;
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_contentLabel];
        
        [self addSubview:self.rightLine];
        [self addSubview:self.bottomLine];
        self.backgroundColor = SYPColor_BackgroudColor_SubWhite;
    }
    return self;
}

- (UIView *)rightLine {
    if (!_rightLine) {
        _rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height)];
        _rightLine.backgroundColor = [UIColor colorWithRed:205./255. green:205./255. blue:205./255. alpha:1];
    }
    return _rightLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(-SYPDefaultMargin * 2, self.frame.size.height - 0.5, self.frame.size.width + SYPDefaultMargin * 2, 0.5)];
        _bottomLine.backgroundColor = [UIColor colorWithRed:205./255. green:205./255. blue:205./255. alpha:1];
    }
    return _bottomLine;
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentLabel.text = content;
}

@end
