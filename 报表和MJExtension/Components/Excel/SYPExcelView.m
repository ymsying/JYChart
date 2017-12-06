//
//  SYPExcelView.m
//  各种报表
//
//  Created by niko on 17/5/19.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPExcelView.h"

#import "SYPTablesModel.h"
#import "SYPCursor.h"
#import "SYPSheetView.h"

@interface SYPExcelView () {
    CGFloat cursorScrollHeight;
}

@property (nonatomic, strong) SYPCursor *cursor;
@property (nonatomic, strong) NSMutableArray <SYPSheetView *> *sheetViewList;
@property (nonatomic, strong) NSArray <SYPSheetModel *> *sheetModelList;
@property (nonatomic, strong) SYPExcelModel *excelModel;

@end

@implementation SYPExcelView


- (NSArray<SYPSheetModel *> *)sheetModelList {
    if (!_sheetModelList) {
        _sheetModelList = ((SYPExcelModel *)self.moduleModel).sheetList;
    }
    return _sheetModelList;
}

- (SYPExcelModel *)excelModel {
    if (!_excelModel) {
        _excelModel = (SYPExcelModel *)self.moduleModel;
    }
    return _excelModel;
}

- (SYPCursor *)cursor {
    if (!_cursor) {
        
        cursorScrollHeight = 0;
        
        _cursor = [[SYPCursor alloc]init];
        _cursor.frame = CGRectMake(-SYPDefaultMargin * 2, 0, self.frame.size.width + SYPDefaultMargin * 4, 45 + SYPDefaultMargin);
        _cursor.titles = self.excelModel.sheetNames;
        _cursor.pageViews = self.sheetViewList;
        //设置根滚动视图的高度
        _cursor.rootScrollViewHeight = self.frame.size.height - (64);
        //默认值是白色
        _cursor.titleNormalColor = SYPColor_TextColor_Chief;
        //默认值是白色
        _cursor.titleSelectedColor = SYPColor_ThemeColor_LightGreen;
        //是否显示排序按钮
        //_cursor.showSortbutton = YES;
        //默认的最小值是5，小于默认值的话按默认值设置
        _cursor.minFontSize = _cursor.maxFontSize = 15;
        //默认的最大值是25，小于默认值的话按默认值设置，大于默认值按设置的值处理
        //cursor.maxFontSize = 30;
        //cursor.isGraduallyChangFont = NO;
        //在isGraduallyChangFont为NO的时候，isGraduallyChangColor不会有效果
        //cursor.isGraduallyChangColor = NO;
        [self addSubview:_cursor];
    }
    return _cursor;
}

- (NSMutableArray<SYPSheetView *> *)sheetViewList {
    if (!_sheetViewList) {
        _sheetViewList = [NSMutableArray array];
        for (SYPSheetModel *sheetModel in self.sheetModelList) {
            SYPSheetView *sheetView = [[SYPSheetView alloc] init];
            sheetView.moduleModel = sheetModel;
            [_sheetViewList addObject:sheetView];
        }
    }
    return _sheetViewList;
}

- (void)refreshSubViewData {
    [self addSubview:self.cursor];
    for (SYPSheetModel *sheetModel in ((SYPExcelModel *)self.excelModel).sheetList) {
        SYPSheetView *tempSheetView = [[SYPSheetView alloc] init];
        CGFloat height = [tempSheetView estimateViewHeight:sheetModel];
        cursorScrollHeight  = (height > cursorScrollHeight ? height : cursorScrollHeight);
    }
    //NSLog(@"cursorScrollHeight : %f", cursorScrollHeight);
    self.cursor.rootScrollViewHeight = cursorScrollHeight;
}

- (CGFloat)estimateViewHeight:(SYPModuleTwoBaseModel *)model {
    
    // 使用所有数据中的最高的高度
    if (cursorScrollHeight == 0) {
        for (SYPSheetModel *sheetModel in ((SYPExcelModel *)model).sheetList) {
            SYPSheetView *tempSheetView = [[SYPSheetView alloc] init];
            CGFloat height = [tempSheetView estimateViewHeight:sheetModel];
            cursorScrollHeight  = (height > cursorScrollHeight ? height : cursorScrollHeight) + 25;
        }
    }
    //NSLog(@"cursorScroll ---> Height : %f", cursorScrollHeight);
    return cursorScrollHeight;
}

@end
