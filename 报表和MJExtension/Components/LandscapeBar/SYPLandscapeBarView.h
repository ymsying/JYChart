//
//  SYPLandscapeBarView.h
//  各种报表
//
//  Created by niko on 17/5/6.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPBaseComponentView.h"
#import "SYPBargraphModel.h"


/**
 条状横向
 包含文字说明栏
 */
@interface SYPLandscapeBarView : SYPBaseComponentView

/**
  视图高度自适应开关，设置yes后，视图高度随数据多少而变化，与设置的初始值无关
 */
@property (nonatomic, assign) BOOL autoLayoutHeight;

@end
