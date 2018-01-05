//
//  SYPExcelView.m
//  各种报表
//
//  Created by niko on 17/5/6.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPSheetView.h"
#import "SYPConstantString.h"
#import "SYPTablesModel.h"
#import "XCMultiSortTableView.h"
#import "SYPHudView.h"
#import "SYPSubSheetView.h"
#import "Masonry.h"

NSNotificationName const SYPUpdateExcelHeadFrame = @"updateExcelHeadFrame";


static NSString *mainCellID = @"mainCell";
static NSString *sectionCellID = @"sectionCell";
static NSString *rowCellID = @"rowCell";

@interface SYPSheetView () <XCMultiTableViewDataSource, XCMultiTableViewDelegate> {
    
    NSInteger lastSortSection; // 上一步排序列数标志
    BOOL recoverFlag; // YES时箭头向下、降序排列
    
    CGPoint freezePoint;
}

@property (nonatomic, strong) SYPTableConfigModel *sheetModel;
@property (nonatomic, strong) XCMultiTableView *multiTableView;

@end

@implementation SYPSheetView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        freezePoint =  CGPointMake(80, kSheetHeadHeight);
        self.clipsToBounds = YES;
        lastSortSection = 0;
        recoverFlag = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSectionViewFrame:) name:SYPUpdateExcelHeadFrame object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYPUpdateExcelHeadFrame object:nil];
}

- (SYPTableConfigModel *)sheetModel {
    if (!_sheetModel) {
        _sheetModel = (SYPTableConfigModel *)self.moduleModel;
    }
    return _sheetModel;
}

- (XCMultiTableView *)multiTableView {
    if (!_multiTableView) {
        _multiTableView = [[XCMultiTableView alloc] init];
        _multiTableView.datasource = self;
        _multiTableView.delegate = self;
        _multiTableView.leftHeaderEnable = YES;
        _multiTableView.clipsToBounds = YES;
        [self addSubview:_multiTableView];
        [_multiTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _multiTableView;
}

// 需要在特定的scrollview的滚动事件代理方法中设置通知源
- (void)refreshSectionViewFrame:(NSNotification *)nt {
    
}

- (void)showSubSheetView:(NSInteger)row {
    if (self.sheetModel.data[row].subData.allKeys.count > 0) {
        
         SYPTableSubSheetModel *subSheetModel = [SYPTableSubSheetModel mj_objectWithKeyValues:self.sheetModel.data[row].subData];
        subSheetModel.title = self.sheetModel.data[row].rowTitle;
        SYPSubSheetView *subView = [[SYPSubSheetView alloc] initWithFrame:CGRectMake(0,0,SYPScreenWidth,SYPScreenHeight)];
        subView.sheetModel = subSheetModel;
        [subView showSubSheetView];
    }
}

#pragma mark - 外部接口实现
- (CGFloat)estimateViewHeight:(SYPBaseChartModel *)model {
    // TODO: 根据model动态修改，将表格全部展示完。提供给父视图的高度正好展示完，本身所在的scrollview不进行滑动
    return ((SYPTableConfigModel *)model).data.count * kMianCellHeight + kSheetHeadHeight;
}

- (void)rotationSectionCellSortIcon:(NSInteger)section select:(BOOL)isSelected {
    
    // 0.处理标志信息
    if (section == lastSortSection) {
        recoverFlag = !recoverFlag;
    }
    else {
        recoverFlag = NO;
    }
    // 1.排序
    // 降序/升序排序
    [self.sheetModel sortMainDataListWithSection:section ascending:!recoverFlag];
    // 2.刷新页面
//    [self.freezeView reloadData];
    // 3.对特殊cell(被点击cell)进行处理、图标旋转
//    SYPSectionViewCell *cell = [self.freezeView dequeueReusableSectionCellWithIdentifier:sectionCellID forSection:section];
//    [cell rotationCellSortIcon:M_PI * recoverFlag];
    
    // 记录最近一次排序的所在列
    lastSortSection = section;
}

- (void)refreshSubViewData {
    [self.multiTableView reloadData];
}

#pragma mark - <XCMultiTableViewDataSource>
- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView {
    return self.sheetModel.head;
}
- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return self.sheetModel.leadLineTitle;
}

- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return self.sheetModel.data;
}


- (NSUInteger)numberOfSectionsInTableView:(XCMultiTableView *)tableView {
    return 1;
}

- (AlignHorizontalPosition)tableView:(XCMultiTableView *)tableView inColumn:(NSInteger)column {
    
    return AlignHorizontalPositionCenter;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView contentTableCellWidth:(NSUInteger)column {
    
    return [self.sheetModel.columnLongestValue[column] boundingRectWithSize:CGSizeMake(100, 30) options:0 attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.width + 10 + SYPDefaultMargin * 4;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section {
    
    return 44.f;
}

- (UIColor *)tableView:(XCMultiTableView *)tableView contentColorInRow:(NSUInteger)row InSection:(NSUInteger)section {
    if (self.sheetModel.data[row].subData.count > 0) {
        return SYPColor_LineColor_LightBlue;
    }
    else {
        return [UIColor colorWithWhite:74/255.0f alpha:1.0];
    }
}

- (NSString *)vertexName {
    return self.sheetModel.vertexName;
}

#pragma mark - <XCMultiTableViewDelegate>
- (void)tableViewWithType:(MultiTableViewType)tableViewType didSelectRowAtIndexPath:(NSIndexPath *)indexPath InColumn:(NSInteger)column{
    if (MultiTableViewTypeLeft == tableViewType) { // 首列
        if (self.sheetModel.data[indexPath.row].subData.count > 0) {
            SYPTableSubSheetModel *subSheetModel = [SYPTableSubSheetModel mj_objectWithKeyValues:self.sheetModel.data[indexPath.row].subData];
            subSheetModel.title = self.sheetModel.leadLineTitle[indexPath.row];
            SYPSubSheetView *subView = [[SYPSubSheetView alloc] initWithFrame:CGRectMake(0,0,SYPScreenWidth,SYPScreenHeight)];
            subView.sheetModel = subSheetModel;
            [subView showSubSheetView];
        } else {
            
            [SYPHudView showHUDWithTitle:self.sheetModel.leadLineTitle[indexPath.row]];
        }
    } else {// 数据区域
        
        NSInteger row = indexPath.row, section = indexPath.section;
        if (row < 0 || row >= self.sheetModel.data.count) {
            row = 0;
        }
        if (section < 1 || section >= self.sheetModel.data[row].mainData.count) {
            section = 1;
        }
        [SYPHudView showHUDWithTitle:self.sheetModel.data[row].mainData[column].value];
    }
}

- (void)tableView:(XCMultiTableView *)tableView didSelectHeadColumnAtIndexPath:(NSIndexPath *)indexPath {
    // 0.处理标志信息
    if (indexPath.section == lastSortSection) {
        recoverFlag = !recoverFlag;
    }
    else {
        recoverFlag = NO;
    }
    // 1.排序
    // 降序/升序排序
    [self.sheetModel sortMainDataListWithSection:indexPath.section ascending:!recoverFlag];
    // 2.刷新页面
    [self.multiTableView reloadData];
    
    // 记录最近一次排序的所在列
    lastSortSection = indexPath.section;
}


@end
