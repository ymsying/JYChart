//
//  SYPFilterView.h
//  报表和MJExtension
//
//  Created by 应明顺 on 2017/12/7.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPFilterModel.h"


@class SYPFilterView;

@protocol SYPFilterViewProtocol

- (void)filterView:(SYPFilterView *)filterView selecteResult:(NSString *)result;

@end

@interface SYPFilterView : UIView

@property (nonatomic, strong) SYPFilterModel *filterModel;
@property (nonatomic, weak) id <SYPFilterViewProtocol> delegate;

@end
