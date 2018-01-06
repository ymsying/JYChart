//
//  XCMultiTableView.h
//  XCMultiTableDemo
//
//  Created by Kingiol on 13-7-20.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class XCMultiTableViewBGScrollView;

typedef NS_ENUM(NSUInteger, SortColumnType) {
    SortColumnTypeInteger,
    SortColumnTypeFloat,
    SortColumnTypeDate,
};

typedef NS_ENUM(NSUInteger, AlignHorizontalPosition) {
    AlignHorizontalPositionLeft = 0,
    AlignHorizontalPositionCenter,
    AlignHorizontalPositionRight,
};

typedef NS_ENUM(NSUInteger, MultiTableViewType) {
    MultiTableViewTypeLeft = 0,
    MultiTableViewTypeRight,
};

typedef NS_ENUM(NSUInteger, TableColumnSortType) {
    TableColumnSortTypeAsc = 0,
    TableColumnSortTypeDesc,
    TableColumnSortTypeNone
};

@protocol XCMultiTableViewDataSource;
@protocol XCMultiTableViewDelegate;

@interface XCMultiTableView : UIView

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat topHeaderHeight;
@property (nonatomic, assign) CGFloat leftHeaderWidth;
@property (nonatomic, assign) CGFloat sectionHeaderHeight;
@property (nonatomic, assign) CGFloat boldSeperatorLineWidth;
@property (nonatomic, assign) CGFloat normalSeperatorLineWidth;

@property (nonatomic, strong) UIColor *flagContentColor;
@property (nonatomic, strong) UIColor *boldSeperatorLineColor;
@property (nonatomic, strong) UIColor *normalSeperatorLineColor;

@property (nonatomic, assign) BOOL leftHeaderEnable;

@property (nonatomic, weak) id<XCMultiTableViewDataSource> datasource;
@property (nonatomic, weak) id<XCMultiTableViewDelegate> delegate;

@property (nonatomic, strong, readonly) XCMultiTableViewBGScrollView *topHeaderScrollView;
@property (nonatomic, strong, readonly) UIView *vertexView;

- (void)reloadData;

@end

@protocol XCMultiTableViewDelegate <NSObject>

- (void)tableViewWithType:(MultiTableViewType)tableViewType didSelectRowAtIndexPath:(NSIndexPath *)indexPath InColumn:(NSInteger)column;
- (void)tableView:(XCMultiTableView *)tableView didSelectHeadColumnAtIndexPath:(NSIndexPath *)indexPath sortType:(TableColumnSortType)type;

@end

@protocol XCMultiTableViewDataSource <NSObject>

@required
- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView;
- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section;
- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section;

@optional
- (NSUInteger)numberOfSectionsInTableView:(XCMultiTableView *)tableView;
- (CGFloat)tableView:(XCMultiTableView *)tableView contentTableCellWidth:(NSUInteger)column;
- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section;
- (UIColor *)tableView:(XCMultiTableView *)tableView contentColorInRow:(NSUInteger)row InSection:(NSUInteger)section;
- (CGFloat)topHeaderHeightInTableView:(XCMultiTableView *)tableView;
- (UIColor *)tableView:(XCMultiTableView *)tableView bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column;
- (UIColor *)tableView:(XCMultiTableView *)tableView headerBgColorInColumn:(NSUInteger)column;
- (AlignHorizontalPosition)tableView:(XCMultiTableView *)tableView inColumn:(NSInteger)column;
- (NSString *)vertexName;

@end
