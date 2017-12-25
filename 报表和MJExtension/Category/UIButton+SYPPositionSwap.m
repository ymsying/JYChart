//
//  UIButton+SYPPositionSwap.m
//  报表和MJExtension
//
//  Created by 应明顺 on 12/23/17.
//  Copyright © 2017 应明顺. All rights reserved.
//

#import "UIButton+SYPPositionSwap.h"

@implementation UIButton (SYPPositionSwap)

- (void)updateBtnContentPosition {
    
    // btn中title和image交互位置。偏移时，相对原位置进行移动，保证title、image大小不变
    CGFloat offset = 0;
    CGFloat imageWidth = self.imageView.bounds.size.width;
    CGFloat labelWidth = self.titleLabel.bounds.size.width;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + offset, 0, -labelWidth - offset);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth - 6, 0, imageWidth + 6);
}


@end
