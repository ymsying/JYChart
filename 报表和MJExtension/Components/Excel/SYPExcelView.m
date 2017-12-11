//
//  SYPExcelView.m
//  各种报表
//
//  Created by niko on 17/5/19.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPExcelView.h"

#import "SYPCursor.h"
#import "SYPSheetView.h"

#define kCursorNavHeight (45)

@interface SYPExcelView () {
    CGFloat cursorScrollHeight;
}

@property (nonatomic, strong) SYPCursor *cursor;
@property (nonatomic, strong) NSMutableArray <SYPSheetView *> *sheetViewList;
//@property (nonatomic, strong) NSArray <SYPSheetModel *> *sheetModelList;
@property (nonatomic, strong) SYPTablesModel *excelModel;

@end

@implementation SYPExcelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        cursorScrollHeight = SYPViewHeight - kCursorNavHeight;
        [self addSubview:self.cursor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self addSubview:self.cursor];
    }
    return self;
}

- (SYPTablesModel *)excelModel {
    if (!_excelModel) {
        _excelModel = (SYPTablesModel *)self.moduleModel;
    }
    return _excelModel;
}

- (SYPCursor *)cursor {
    if (!_cursor) {
        
        cursorScrollHeight = 0;
        
        _cursor = [[SYPCursor alloc]init];
        // 此时设置的高度是顶部的导航栏的高度，默认高度是45，不等45时可以控制下半部分滚动视图的顶部位置
        _cursor.frame = CGRectMake(0, 0, SYPViewWidth, kCursorNavHeight);
        //设置下半部分根滚动视图的高度
        _cursor.rootScrollViewHeight = SYPViewHeight - kCursorNavHeight;
        _cursor.navBarX = SYPDefaultMargin * 2;
        //默认值是白色
        _cursor.titleNormalColor = SYPColor_TextColor_Chief;
        //默认值是白色
        _cursor.titleSelectedColor = SYPColor_ThemeColor_LightGreen;
        _cursor.navItemAutoAdjustContent = YES;
        _cursor.navItemShowIndicator = YES;
        //默认的最小值是5，小于默认值的话按默认值设置
        _cursor.minFontSize = _cursor.maxFontSize = 15;
        [self addSubview:_cursor];
    }
    return _cursor;
}

- (NSMutableArray<SYPSheetView *> *)sheetViewList {
    if (!_sheetViewList) {
        _sheetViewList = [NSMutableArray array];
        for (SYPTableConfigModel *sheetModel in self.excelModel.config) {
            SYPSheetView *sheetView = [[SYPSheetView alloc] init];
            sheetView.flexibleHeight = YES;
            sheetView.moduleModel = sheetModel;
            [_sheetViewList addObject:sheetView];
        }
    }
    return _sheetViewList;
}

- (void)setAutoLayoutHeight:(BOOL)autoLayoutHeight {
    
    _autoLayoutHeight = autoLayoutHeight;
    // 高度相同时，可以保证Excel列表纵向不进行滑动
    for (SYPTableConfigModel *sheetModel in self.excelModel.config) {
        SYPSheetView *tempSheetView = [[SYPSheetView alloc] init];
        CGFloat height = [tempSheetView estimateViewHeight:sheetModel];
        cursorScrollHeight  = (height > cursorScrollHeight ? height : cursorScrollHeight);
    }
    self.cursor.rootScrollViewHeight = cursorScrollHeight;
}


- (void)refreshSubViewData {
    
    self.cursor.titles = self.excelModel.configTitles;
    self.cursor.pageViews = self.sheetViewList;
    
    if (self.autoLayoutHeight) {
        // 高度相同时，可以保证Excel列表纵向不进行滑动
        for (SYPTableConfigModel *sheetModel in self.excelModel.config) {
            SYPSheetView *tempSheetView = [[SYPSheetView alloc] init];
            CGFloat height = [tempSheetView estimateViewHeight:sheetModel];
            cursorScrollHeight  = (height > cursorScrollHeight ? height : cursorScrollHeight);
        }
        self.cursor.rootScrollViewHeight = cursorScrollHeight;
    }
}

- (CGFloat)estimateViewHeight:(SYPBaseChartModel *)model {
    
    // 使用所有数据中的最高的高度
    if (cursorScrollHeight == 0) {
        for (SYPTableConfigModel *sheetModel in ((SYPTablesModel *)model).config) {
            SYPSheetView *tempSheetView = [[SYPSheetView alloc] init];
            tempSheetView.flexibleHeight = YES;
            CGFloat height = [tempSheetView estimateViewHeight:sheetModel];
            height += kCursorNavHeight;
            cursorScrollHeight  = (height > cursorScrollHeight ? height : cursorScrollHeight);
        }
    }
    return cursorScrollHeight;
}

@end
