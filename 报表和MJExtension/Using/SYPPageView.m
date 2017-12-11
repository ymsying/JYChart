//
//  SYPModuleTwoView.m
//  各种报表
//
//  Created by niko on 17/5/21.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPPageView.h"
#import "SYPConstantSize.h"
#import "SYPCursor.h"
#import "SYPPageModel.h"
#import "SYPFilterView.h"
#import "UIView+Extension.h"
#import "SYPPartView.h"

@interface SYPPageView () <SYPFilterViewProtocol> {
    NSString *currentFilterString;
    CGFloat cursorNavBarH;
    BOOL isLayout;
}

@property (nonatomic, copy) SYPFilterView *filterView;
@property (nonatomic, strong) SYPCursor *cursor;
@property (nonatomic, strong) NSMutableArray <SYPPartView *> *partViews;

@end

@implementation SYPPageView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = SYPColor_SepLineColor_LightGray;
        [self addSubview:self.filterView];
        [self addSubview:self.cursor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = SYPColor_SepLineColor_LightGray;
        [self addSubview:self.filterView];
        [self addSubview:self.cursor];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat cursorY = 0;
    if (self.pageModel.filter.display) {
        cursorY = self.filterView.y + self.filterView.height;
    }
    
    self.cursor.navBarH = cursorNavBarH;
    // 此时的height是设置nav的高，固定高度是45
    self.cursor.frame = CGRectMake(0, cursorY, SYPViewWidth, cursorNavBarH);
    //设置根滚动视图的高度，然后更新整个Cursor的高度
    self.cursor.rootScrollViewHeight = SYPViewHeight - (cursorNavBarH) - self.navH;
    
}

- (SYPFilterView *)filterView {
    if (!_filterView) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYPViewWidth, 40 * SYPScreenRatio)];
        bgView.backgroundColor = SYPColor_BackgroudColor_White;
        [self addSubview:bgView];
        
        _filterView = [[SYPFilterView alloc] initWithFrame:CGRectMake(SYPDefaultMargin * 2, 0, SYPViewWidth - SYPDefaultMargin * 4, 39 * SYPScreenRatio)];
        _filterView.backgroundColor = SYPColor_BackgroudColor_White;
        _filterView.delegate = self;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _filterView.y + _filterView.height, SYPViewWidth, 1)];
        line.backgroundColor = SYPColor_SepLineColor_LightGray;
        [self addSubview:line];
    }
    return _filterView;
}

- (SYPCursor *)cursor {
    if (!_cursor) {
        _cursor = [[SYPCursor alloc] init];        //是否显示排序按钮
        //_cursor.showSortbutton = YES;
        //默认的最小值是5，小于默认值的话按默认值设置
        _cursor.minFontSize = 15;
        _cursor.navItemAlignmentCenter = YES;
        //默认的最大值是25，小于默认值的话按默认值设置，大于默认值按设置的值处理
        _cursor.maxFontSize = 15;
        _cursor.backgroudSelectedColor = SYPColor_ThemeColor_LightGreen;
        _cursor.titleSelectedColor = SYPColor_BackgroudColor_White;
        _cursor.titleNormalColor = SYPColor_TextColor_Chief;
//        // 此时的height是设置nav的高，固定高度是45
//        _cursor.frame = CGRectMake(0, 0, SYPViewWidth, 45);
//        //设置根滚动视图的高度，然后更新整个Cursor的高度
//        _cursor.rootScrollViewHeight = SYPViewHeight - (45);
    }
    return _cursor;
}

- (NSMutableArray<SYPPartView *> *)partViews {
    if (!_partViews || ![currentFilterString isEqualToString:self.pageModel.filter.display]) {
        _partViews = [NSMutableArray array];
        
        for (SYPPartModel *model in self.pageModel.filteredPartList) {
            SYPPartView *statementView = [[SYPPartView alloc] init];
            statementView.offsetExcelHead = cursorNavBarH;
            statementView.partModel = model;
            [_partViews addObject:statementView];
        }
    }
    return _partViews;
}

- (void)setPageModel:(SYPPageModel *)pageModel {
    if (![_pageModel isEqual:pageModel]) {
        _pageModel = pageModel;
        [self refreshSubViewData];
    }
}


- (void)refreshSubViewData {
    
    cursorNavBarH = (self.pageModel.tabControl.count > 1) ? 45 : 0;
    
    self.filterView.filterModel = self.pageModel.filter;
    self.cursor.titles = self.pageModel.tabControl;
    self.cursor.pageViews = self.partViews;
    
    currentFilterString = self.pageModel.filter.display;
}


#pragma mark - <SYPFilterViewProtocol>
- (void)filterView:(SYPFilterView *)filterView selecteResult:(NSString *)result {
    self.pageModel.filter.display = result;
    [self refreshSubViewData];
}


@end
