//
//  SYPExcelView.h
//  各种报表
//
//  Created by niko on 17/5/6.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPBaseComponentView.h"

#define kMianCellHeight (44)
#define kSheetHeadHeight (40)

extern NSNotificationName const SYPUpdateExcelHeadFrame;

/**
 Excel中的工作表
 */
@interface SYPSheetView : SYPBaseComponentView

@property (nonatomic, assign) BOOL flexibleHeight;

@end
