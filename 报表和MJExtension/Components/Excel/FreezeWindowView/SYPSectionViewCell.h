//
//  SYPSectionViewCell.h
//  SYPFreezeWindowView
//
//  Created by niko on 17/5/4.
//  Copyright © 2015年 YMS All rights reserved.
//

#import "SYPFreezeViewCell.h"

typedef NS_ENUM(NSInteger, SYPSectionViewCellStyle) {
    SYPSectionViewCellStyleDefault,
    SYPSectionViewCellStyleCustom
};

typedef NS_ENUM(NSInteger, SYPSectionViewCellSeparatorStyle) {
    SYPSectionViewCellSeparatorStyleSingleLine,
    SYPSectionViewCellSeparatorStyleNone
};

@interface SYPSectionViewCell : UIView

- (instancetype)initWithStyle:(SYPSectionViewCellStyle) style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;
@property (readonly, assign, nonatomic) SYPSectionViewCellStyle style;
@property (assign, nonatomic) SYPSectionViewCellSeparatorStyle separatorStyle;
@property (strong, nonatomic) NSString *title;


- (void)rotationCellSortIcon:(CGFloat)angle;
- (void)setClickedActive:(void(^)(NSString *title, BOOL isSelect))selectedActive;

@end
