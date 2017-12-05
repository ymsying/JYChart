//
//  SYPSubSheetView.h
//  各种报表
//
//  Created by niko on 17/5/18.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPSheetModel.h"


/**
 下窜页
 */
@interface SYPSubSheetView : UIView

@property (nonatomic, strong) SYPSheetModel *sheetModel;

- (void)showSubSheetView;

@end
