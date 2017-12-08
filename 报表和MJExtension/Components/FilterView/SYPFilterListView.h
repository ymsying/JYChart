//
//  SYPFilterListView.h
//  报表和MJExtension
//
//  Created by 应明顺 on 2017/12/7.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPFilterModel.h"

@class SYPFilterListView;
@protocol SYPFilterListViewProtocol

- (void)filterListView:(SYPFilterListView *)filterListView selecteOptionWithHierarchyName:(NSString *)name index:(NSInteger)index;

@end


@interface SYPFilterListView : UIView

@property (nonatomic, strong) SYPFilterDataModel *filterDataModel;
@property (nonatomic, weak) id <SYPFilterListViewProtocol> delegate;

- (void)showFilterListViewWithOptions:(SYPFilterDataModel *)filterDataModel;
- (void)hiddenFilterListView;
- (void)reshow;



@end
