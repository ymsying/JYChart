//
//  SYPRootScrollViewCell.m
//  SYPRootScrollView
//
//  Created by haha on 15/7/23.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "SYPRootScrollViewCell.h"
#import "SYPRootScrollView.h"

@interface SYPRootScrollViewCell()

@end

@implementation SYPRootScrollViewCell

+ (id)cellWithRootScrollView:(SYPRootScrollView *)rootScrollView{
    static NSString *cellID = @"CELL";
    SYPRootScrollViewCell *cell = [rootScrollView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[SYPRootScrollViewCell alloc] init];
        cell.identifier = cellID;
        //cell.backgroundColor = [UIColor yellowColor];
    }
    return cell;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setpageViewInCell:(UIView *)pageView{
    if (self.subviews.count) {
       [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self addSubview:pageView];
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    if (self.subviews.count > 0) {
        UIView *pageView = self.subviews[0];
        pageView.frame = self.bounds;
    }
}
@end
