//
//  SYPSubSheetView.h
//  各种报表
//
//  Created by niko on 17/5/18.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPTablesModel.h"


/**
 下窜页
 */
@interface SYPSubSheetView : UIView

@property (nonatomic, strong) SYPTableConfigModel *sheetModel;

- (void)showSubSheetView;

@end
