//
//  SYPExcelView.h
//  各种报表
//
//  Created by niko on 17/5/19.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPBaseComponentView.h"
#import "SYPTablesModel.h"

/**
 Excel页
 */
@interface SYPExcelView : SYPBaseComponentView

/**
 视图高度自适应开关，设置yes后，视图高度随数据多少而变化，与设置的初始值无关，高度可能超过父视图高度
 */
@property (nonatomic, assign) BOOL autoLayoutHeight;


@end
