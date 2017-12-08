//
//  SYPFilterListView.h
//  报表和MJExtension
//
//  Created by 应明顺 on 2017/12/7.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPFilterModel.h"

typedef void(^SYPFilterResultHandler)(NSString *result);

@interface SYPFilterPopView : UIView

+ (void)showFilterListViewWithFilter:(SYPFilterModel *)filter completionHandler:(SYPFilterResultHandler)handler;

@end
