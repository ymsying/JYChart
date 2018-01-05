//
//  SYPTablesModel.h
//  MJExtension_Using
//
//  Created by 应明顺 on 2017/11/29.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPBaseChartModel.h"
#import "SYPColourPointModel.h"


////////////////////////////////////////////////////////////
#pragma mark - SYPTableRowModel
@interface SYPTableRowModel : SYPBaseChartModel

/**
 每一行中的cell的数据
 */
@property (nonatomic, copy) NSArray <SYPColourPointModel *> *mainData;
@property (nonatomic, copy) NSDictionary *subData;
/**
 每一行中的最长字符串
 */
@property (nonatomic, copy, readonly) NSString *longestValue;
@property (nonatomic, copy, readonly) NSString *rowTitle;

- (NSArray<SYPColourPointModel *> *)allMainData;

@end

////////////////////////////////////////////////////////////
#pragma mark - SYPTableConfigModel

/**
 工作表
 */
@interface SYPTableConfigModel : SYPBaseChartModel

@property (nonatomic, copy) NSString *title;
/**
 表格头标题
 */
@property (nonatomic, copy) NSArray <NSString *> *head;
/**
 左上角标示
 */
@property (nonatomic, copy) NSString *vertexName;
/**
 表格行分组，表格中的 行 集合
 */
@property (nonatomic, copy) NSArray <SYPTableRowModel *> *data;
/**
 表格首列标题
 */
@property (nonatomic, copy, readonly) NSArray <NSString *> *leadLineTitle;
/**
 每列中的最长字符串
 */
@property (nonatomic, copy, readonly) NSArray <NSString *> *columnLongestValue;

- (void)sortMainDataListWithSection:(NSInteger)section ascending:(BOOL)ascending;

@end

////////////////////////////////////////////////////////////
#pragma mark - SYPTableSubSheetModel
@interface SYPTableSubSheetModel : SYPTableConfigModel


@end

////////////////////////////////////////////////////////////////
#pragma mark - SYPTablesModel
/**
 表格
 */
@interface SYPTablesModel : SYPBaseChartModel

@property (nonatomic, copy) NSArray <SYPTableConfigModel *> *config;
@property (nonatomic, copy, readonly) NSArray <NSString *> *configTitles;

@end


