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
#import "Masonry.h"

#define kFilterViewHeight 40

@interface SYPPageView () <SYPFilterViewProtocol> {
    NSString *currentFilterString;
    CGFloat cursorNavBarH;
    CGFloat cursorY;
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

- (void)updateConstraints {
    [super updateConstraints];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kFilterViewHeight);
    }];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.cursor.navBarH = cursorNavBarH;
    // 此时的height是设置nav的高，固定高度是45
    self.cursor.frame = CGRectMake(0, cursorY, SYPViewWidth, cursorNavBarH);
    //设置根滚动视图的高度，然后更新整个Cursor的高度
    CGFloat rootScrollViewHeight = SYPViewHeight - (cursorNavBarH + cursorY);
    if ([[UIDevice currentDevice].systemVersion floatValue] <= 10.0) {
//        rootScrollViewHeight -= self.navH;
    }
    self.cursor.rootScrollViewHeight = rootScrollViewHeight;
}

- (SYPFilterView *)filterView {
    if (!_filterView) {
        
        _filterView = [[SYPFilterView alloc] init];//WithFrame:CGRectMake(SYPDefaultMargin * 2, 0, SYPViewWidth - SYPDefaultMargin * 4, 39 * SYPScreenRatio)
        _filterView.backgroundColor = SYPColor_BackgroudColor_White;
        _filterView.delegate = self;
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
            statementView.offsetExcelHead = cursorNavBarH + cursorY;
            statementView.partModel = model;
            [_partViews addObject:statementView];
        }
    }
    return _partViews;
}

- (void)setPageModel:(SYPPageModel *)pageModel {
    if (![_pageModel isEqual:pageModel]) {
        _pageModel = pageModel;
        
        self.filterView.filterModel = _pageModel.filter;
        [self refreshSubViewData];
    }
}


- (void)refreshSubViewData {
    // 1. 计算表头偏移量
    cursorNavBarH = (self.pageModel.tabControl.count > 1) ? 45 : 0;
    cursorY = self.pageModel.filter.display.length > 1 ? (kFilterViewHeight) : self.filterView.y;
    // 2. 设置多页及选项卡
    self.cursor.titles = self.pageModel.tabControl;
    self.cursor.pageViews = self.partViews;
    // 3. 记录当前过滤关键字
    currentFilterString = self.pageModel.filter.display;
}


#pragma mark - <SYPFilterViewProtocol>
- (void)filterView:(SYPFilterView *)filterView selecteResult:(NSString *)result {
    self.pageModel.filter.display = result;
    [self refreshSubViewData];
    [self layoutSubviews];
}


@end
