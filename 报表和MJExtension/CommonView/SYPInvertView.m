//
//  SYPInvertButton.m
//  各种报表
//
//  Created by niko on 17/5/6.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPInvertView.h"
#import "SYPBlockButton.h"
#import "SYPConstantColor.h"
#import "SYPConstantSize.h"
#import "Masonry.h"

@interface SYPInvertView () {
    UILabel *title;
}

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) SYPBlockButton *btn;

@end

@implementation SYPInvertView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeSubView];
    }
    
    return self;
}

- (void)initializeSubView {
    
    title = [[UILabel alloc] init];//WithFrame:CGRectMake(0, 0, 60, SYPViewHeight)
    title.textColor = SYPColor_TextColor_Chief;
    title.font = [UIFont systemFontOfSize:14];
    title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(60);
    }];
    
    _icon = [[UIImageView alloc] init];//WithFrame:CGRectMake(CGRectGetMaxX(title.frame), (CGRectGetHeight(self.bounds) - 12) / 2.0, 6, 12)
    _icon.image = [UIImage imageNamed:@"icon_sort"];
    _icon.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:_icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(title.mas_right);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
    }];
    
    __weak typeof(self) weakSelf = self;
    _btn = [SYPBlockButton buttonWithType:UIButtonTypeCustom];
    //_btn.frame = self.bounds;
    [_btn setHandler:^(BOOL isSelected) {
        
        if (weakSelf.inverHandler) {
            weakSelf.inverHandler(weakSelf.typeName, isSelected);
        }
        weakSelf.icon.image = [UIImage imageNamed:@"icon_array"];
        if (isSelected) {
            weakSelf.icon.layer.transform = CATransform3DIdentity;
        }
        else {
            weakSelf.icon.layer.transform = CATransform3DMakeRotation(-M_PI, 0, 0, 1);
        }
    }];
    [self addSubview:_btn];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}

- (void)setTypeName:(NSString *)typeName {
    if (![_typeName isEqualToString:typeName]) {
        _typeName = typeName;
    }
    CGSize size = [typeName boundingRectWithSize:CGSizeMake(SYPViewWidth - SYPViewWidth1(_icon) - SYPDefaultMargin/2, SYPViewHeight) options:0 attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
    CGRect frame = title.frame;
    frame.size.width = size.width;
    title.frame = frame;
    title.text = typeName;
    
    frame = self.icon.frame;
    frame.origin.x = CGRectGetMaxX(title.frame) + SYPDefaultMargin / 2.0;
    self.icon.frame = frame;
}

- (void)recoverIconTransform {
    self.icon.image = [UIImage imageNamed:@"icon_sort"];
    self.btn.selected = NO;
    self.icon.layer.transform = CATransform3DIdentity;
}

@end
