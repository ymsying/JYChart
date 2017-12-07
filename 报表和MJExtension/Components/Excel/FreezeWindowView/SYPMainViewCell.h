//
//  SYPMainViewCell.h
//  SYPFreezeWindowView
//
//  Created by niko on 17/5/4.
//  Copyright © 2015年 YMS All rights reserved.
//

#import "SYPFreezeViewCell.h"


typedef NS_ENUM(NSInteger, SYPMainViewCellStyle) {
    SYPMainViewCellStyleDefault,
    SYPMainViewCellStyleCustom
};

typedef NS_ENUM(NSInteger, SYPMainViewCellSeparatorStyle) {
    SYPMainViewCellSeparatorStyleSingleLine,
    SYPMainViewCellSeparatorStyleNone
};

@interface SYPMainViewCell : UIView


- (instancetype)initWithStyle:(SYPMainViewCellStyle) style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIColor *titleColor;
@property (readonly, assign, nonatomic) SYPMainViewCellStyle style;
@property (assign, nonatomic) SYPMainViewCellSeparatorStyle separatorStyle;
@property (assign, nonatomic) NSInteger rowNumber;
@property (assign, nonatomic) NSInteger sectionNumber;

@end
