//
//  SYPInfoView.m
//  各种报表
//
//  Created by niko on 17/5/14.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPInfoView.h"
#import "SYPInfoModel.h"

@interface SYPInfoView ()

@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) SYPInfoModel *infoModel;

@end

@implementation SYPInfoView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self addSubview:self.infoLabel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.infoLabel];
    }
    return self;
}

- (void)layoutSubviews {
    self.infoLabel.frame = self.bounds;
}

- (SYPInfoModel *)infoModel {
    if (!_infoModel) {
        _infoModel = (SYPInfoModel *)self.moduleModel;
    }
    return _infoModel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        //_infoLabel.textColor = SYPColor_TextColor_Chief;
        _infoLabel.font = [UIFont systemFontOfSize:15];
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}

- (void)refreshSubViewData {
    self.infoLabel.text =  self.infoModel.title;
}

- (CGFloat)estimateViewHeight:(SYPBaseChartModel *)model {
    NSString *infoStr = ((SYPInfoModel *)model).title;
    CGFloat height = [infoStr boundingRectWithSize:CGSizeMake(SYPScreenWidth - 2 * SYPDefaultMargin, SYPScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{UIFontDescriptorNameAttribute: [UIFont systemFontOfSize:15]} context:nil].size.height;
    
    return height + 4 * SYPDefaultMargin;
}

@end
