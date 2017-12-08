//
//  SYPTabController.h
//  报表和MJExtension
//
//  Created by 应明顺 on 2017/12/7.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYPTabController;

@protocol SYPTabControllerProtocol

- (void)tabController:(SYPTabController *)tabController selecteTabWithHierarchyName:(NSString *)name hierarchyIndex:(NSInteger)index;

@end


/**
 层级控制器，选项卡数量动态根据添加的层级进行改变
 以栈的形式管理层级
 */
@interface SYPTabController : UIView

@property (nonatomic, assign) id <SYPTabControllerProtocol> delegate;
@property (nonatomic, copy, readonly) NSArray <NSString *> *hierarchyName;

/**
 新增一个按钮

 @param name 新按钮上的标题
 */
- (void)addNewTabWithName:(NSString *)name;


@end



