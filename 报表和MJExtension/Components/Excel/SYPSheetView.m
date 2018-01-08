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
#import "UIView+Extension.h"

NSNotificationName const SYPUpdateExcelHeadFrame = @"updateExcelHeadFrame";


static NSString *mainCellID = @"mainCell";
static NSString *sectionCellID = @"sectionCell";
static NSString *rowCellID = @"rowCell";

@interface SYPSheetView () <XCMultiTableViewDataSource, XCMultiTableViewDelegate> {
    UIWindow *freezeWindow;
}

@property (nonatomic, strong) SYPTableConfigModel *sheetModel;
@property (nonatomic, strong) XCMultiTableView *multiTableView;

@end

@implementation SYPSheetView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        freezeWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SYPViewWidth, kSheetHeadHeight)];
        freezeWindow.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSectionViewFrame:) name:SYPUpdateExcelHeadFrame object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYPUpdateExcelHeadFrame object:nil];
    
    [freezeWindow removeFromSuperview];
    freezeWindow = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview == nil || !newSuperview) {
        [(UIScrollView *)self.multiTableView.topHeaderScrollView setHidden:YES];
        [(UIView *)self.multiTableView.vertexView setHidden:YES];
        [self.multiTableView setHidden:YES];
    }
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
        _multiTableView.topHeaderHeight = kSheetHeadHeight;
        _multiTableView.clipsToBounds = YES;
        [self addSubview:_multiTableView];
        [_multiTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _multiTableView;
}

#pragma mark - 表头悬浮处理
- (void)canBeScroller:(UIView *)view canBeScroll:(BOOL *)scroll{
    for (UIView *subView in view.subviews) {
        if ([subView.subviews containsObject:self]) {
            *scroll = YES;
            break;
        }
        else {
            [self canBeScroller:subView canBeScroll:scroll];
        }
    }
}

// 需要在特定的scrollview的滚动事件代理方法中设置通知源
- (void)refreshSectionViewFrame:(NSNotification *)nt {
    
    UIScrollView *topHeaderView = (UIScrollView *)self.multiTableView.topHeaderScrollView;
    UIView *vertexView = self.multiTableView.vertexView;
    if ([@"stop scroll" isEqualToString:[nt.userInfo objectForKey:@"status"]]) {
        freezeWindow.hidden = YES;
        return;
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect toWindowFrame = [self convertRect:self.frame toView:keyWindow];
    CGFloat offset = CGPointFromString([nt.userInfo objectForKey:@"origin"]).y;
    BOOL canScroll = NO;
    [self canBeScroller:(UIView *)nt.object canBeScroll:&canScroll];
    //NSLog(@"can scroll:%d", canScroll);
    if (canScroll) { // 防止在其他报表中滑动时影响self
        //NSLog(@"%@", NSStringFromCGRect(toWindowFrame));
        
        // 在toWindowFrame.origin.y 小于默认偏移时才开启悬浮
        // 当视图还未进入视觉区域时，由于视图已经贴在屏幕上了，所以 toWindowFrame.origin.y == 0，此时不应将表头悬浮
        // 当视图向上滑动toWindowFrame.origin.y会变成负无穷大，所以在大于本身高度后，取消悬浮
        if (toWindowFrame.origin.y < offset && toWindowFrame.origin.y != 0 && toWindowFrame.origin.y > -(CGRectGetHeight(self.frame) - offset) && toWindowFrame.origin.x >= 0) {
            //NSLog(@"区域内悬浮 %@", NSStringFromCGRect(toWindowFrame));
            if (toWindowFrame.origin.y == 53) { // 值为53时特殊处理
                return;
            }
            
            CGRect frame = freezeWindow.frame;
            frame.origin.y = offset;
            freezeWindow.frame = frame;
            [freezeWindow addSubview:topHeaderView];
            
            [freezeWindow addSubview:vertexView];
            
            freezeWindow.hidden = NO;
            [freezeWindow makeKeyAndVisible];
//            printf("＋＋＋retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(topHeaderView)));
        }
        else {
            [freezeWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            //NSLog(@"超出边界复原");
            
            [self.multiTableView addSubview:topHeaderView];
            CGRect frame = topHeaderView.frame;
            frame.origin.y = 0;
            topHeaderView.frame = frame;
            
            [self.multiTableView addSubview:vertexView];
            frame = vertexView.frame;
            frame.origin.y = 0;
            frame.origin.x = 0;
            vertexView.frame = frame;
//            printf("*****retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(topHeaderView)));
        }
    }
    else { // 其他页面中进行滑动时复原表头位置
        [freezeWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        //NSLog(@"外部复原");
        
        [self.multiTableView addSubview:topHeaderView];
        CGRect frame = topHeaderView.frame;
        frame.origin.y = 0;
        topHeaderView.frame = frame;
        
        [self.multiTableView addSubview:vertexView];
        frame = vertexView.frame;
        frame.origin.y = 0;
        frame.origin.x = 0;
        vertexView.frame = frame;
//        printf("………………retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(topHeaderView)));
    }
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
    return ((SYPTableConfigModel *)model).data.count * kMianCellHeight + kSheetHeadHeight + 2;
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

- (void)tableView:(XCMultiTableView *)tableView didSelectHeadColumnAtIndexPath:(NSIndexPath *)indexPath sortType:(TableColumnSortType)type{
    
    // 1.排序
    // 降序/升序排序
    [self.sheetModel sortMainDataListWithSection:indexPath.row sortType:(int)type];
    // 2.刷新页面
    [self.multiTableView reloadData];
    
}


@end
