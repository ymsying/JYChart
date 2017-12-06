//
//  SYPFreezeViewCell.h
//  各种报表
//
//  Created by niko on 17/5/6.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SYPFreezeViewCellStyle) {
    SYPFreezeViewCellStyleDefault,
    SYPFreezeViewCellStyleCustom
};

typedef NS_ENUM(NSInteger, SYPRowViewCellSeparatorStyle) {
    SYPFreezeViewCellSeparatorStyleSingleLine,
    SYPFreezeViewCellSeparatorStyleNone
};


@interface SYPFreezeViewCell : UIView


- (instancetype)initWithStyle:(SYPFreezeViewCellStyle) style reuseIdentifier:(NSString *)reuseIdentifier;


@property (nonatomic, readonly, copy) NSString *reuseIdentifier;
@property (strong, nonatomic) NSString *title;
@property (readonly, assign, nonatomic) SYPFreezeViewCellStyle style;
@property (assign, nonatomic) SYPRowViewCellSeparatorStyle separatorStyle;
@property (nonatomic, assign) BOOL showFlagPoint;

- (void)setClickedActive:(void(^)(NSString *title))selectedActive;



@end
