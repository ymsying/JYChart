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

#import "SYPPartView.h"

@interface SYPPageView ()

@property (nonatomic, strong) SYPCursor *cursor;
@property (nonatomic, strong) NSMutableArray <SYPPartView *> *statementView;

@end

@implementation SYPPageView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self addSubview:self.cursor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.cursor];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 此时的height是设置nav的高，固定高度是45
    self.cursor.frame = CGRectMake(0, 0, SYPViewWidth, 45);
    //设置根滚动视图的高度，然后更新整个Cursor的高度
    self.cursor.rootScrollViewHeight = SYPViewHeight - (45);
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

- (NSMutableArray<SYPPartView *> *)statementView {
    if (!_statementView) {
        _statementView = [NSMutableArray array];
        for (SYPPartModel *model in self.pageModel.filteredPartList) {
            SYPPartView *statementView = [[SYPPartView alloc] init];
            statementView.partModel = model;
            [_statementView addObject:statementView];
        }
    }
    return _statementView;
}

- (void)setPageModel:(SYPPageModel *)pageModel {
    if (![_pageModel isEqual:pageModel]) {
        _pageModel = pageModel;
        [self refreshSubViewData];
    }
}


- (void)refreshSubViewData {
    
    self.cursor.pageViews = self.statementView;
    self.cursor.titles = self.pageModel.tabControl;
}



@end
