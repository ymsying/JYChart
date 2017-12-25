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
#import "SYPFreezeWindowView.h"
#import "SYPHudView.h"
#import "SYPSubSheetView.h"
#import "Masonry.h"

static NSNotificationName const SYPUpdateExcelHeadFrame = @"updateExcelHeadFrame";


static NSString *mainCellID = @"mainCell";
static NSString *sectionCellID = @"sectionCell";
static NSString *rowCellID = @"rowCell";

@interface SYPSheetView () <SYPFreezeWindowViewDelegate, SYPFreezeWindowViewDataSource> {
    
    NSInteger lastSortSection; // 上一步排序列数标志
    BOOL recoverFlag; // YES时箭头向下、降序排列
    
    CGPoint freezePoint;
}

@property (nonatomic, strong) SYPTableConfigModel *sheetModel;
@property (nonatomic, strong) SYPFreezeWindowView *freezeView;

@end

@implementation SYPSheetView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        freezePoint =  CGPointMake(80, kSheetHeadHeight);
        self.clipsToBounds = YES;
        lastSortSection = 0;
        recoverFlag = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSectionViewFrame:) name:@"scrollUpOrDown" object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYPUpdateExcelHeadFrame object:nil];
}

- (void)layoutSubviews {
    
    // 计算首例的宽度
//    NSString *title = self.sheetModel.columnLongestValue[0];
//    CGFloat width = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, freezePoint.y) options:0 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.width;
//    width += SYPDefaultMargin * 2;
//    freezePoint.x = width;
    
    [self initializeSubView];
    [self.freezeView setSignViewWithContent:self.sheetModel.head[0]];
}

- (SYPTableConfigModel *)sheetModel {
    if (!_sheetModel) {
        _sheetModel = (SYPTableConfigModel *)self.moduleModel;
    }
    return _sheetModel;
}

- (SYPFreezeWindowView *)freezeView {
    if (!_freezeView) {
        CGRect frame = self.bounds;
        { //  显示"圆点"的处理
            frame.origin.x += SYPDefaultMargin * 2;
            frame.size.width -= SYPDefaultMargin * 2;
        }
        _freezeView = [[SYPFreezeWindowView alloc] initWithFrame:frame FreezePoint:freezePoint cellViewSize:CGSizeMake(120, kMianCellHeight)];
        _freezeView.delegate = self;
        _freezeView.dataSource = self;
        _freezeView.bounceStyle = SYPFreezeWindowViewBounceStyleNone;
        _freezeView.backgroundColor = [UIColor whiteColor];
    }
    return _freezeView;
}

//- (void)refreshSubViewData {
//    [self initializeSubView];
//    [self.freezeView setSignViewWithContent:self.sheetModel.head[0]];
//}

- (void)initializeSubView {
    
    [self addSubview:self.freezeView];
//    [self.freezeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(SYPDefaultMargin * 2);
//        make.right.mas_equalTo(SYPDefaultMargin * 2);
//        make.top.bottom.mas_equalTo(0);
//    }];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
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
        if (toWindowFrame.origin.y < offset && toWindowFrame.origin.y != 0 && toWindowFrame.origin.y > -(CGRectGetHeight(self.frame) - offset)) {
            //NSLog(@"区域内悬浮 %@", NSStringFromCGRect(toWindowFrame));
            if (toWindowFrame.origin.y == 53) { // 值为53时特殊处理
                return;
            }
            
            [keyWindow addSubview:self.freezeView.sectionView];
            CGRect frame = self.freezeView.sectionView.frame;
            frame.origin.y = offset;
            frame.origin.x = SYPDefaultMargin * 2 + freezePoint.x;
            self.freezeView.sectionView.frame = frame;
            
            [keyWindow addSubview:self.freezeView.signView];
            frame = self.freezeView.signView.frame;
            frame.origin.y = offset;
            frame.origin.x = SYPDefaultMargin * 2;
            self.freezeView.signView.frame = frame;
            //printf("＋＋＋retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self.freezeView.sectionView)));
        }
        else {
            
            //NSLog(@"外部复原");
            [self.freezeView addSubview:self.freezeView.sectionView];
            CGRect frame = self.freezeView.sectionView.frame;
            frame.origin.y = 0;
            frame.origin.x = freezePoint.x;
            self.freezeView.sectionView.frame = frame;
            
            [self.freezeView addSubview:self.freezeView.signView];
            frame = self.freezeView.signView.frame;
            frame.origin.y = 0;
            frame.origin.x = 0;
            self.freezeView.signView.frame = frame;
            //printf("……………………retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self.freezeView.sectionView)));
        }
    }
    else { // 其他页面中进行滑动时复原表头位置
        
        //NSLog(@"外部复原");
        [self.freezeView addSubview:self.freezeView.sectionView];
        CGRect frame = self.freezeView.sectionView.frame;
        frame.origin.y = 0;
        frame.origin.x = freezePoint.x;
        self.freezeView.sectionView.frame = frame;
        
        [self.freezeView addSubview:self.freezeView.signView];
        frame = self.freezeView.signView.frame;
        frame.origin.y = 0;
        frame.origin.x = 0;
        self.freezeView.signView.frame = frame;
        //printf("……………………retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self.freezeView.sectionView)));
    }
}

#pragma mark - <SYPFreezeWindowViewDataSource>
// 横向
- (NSInteger)numberOfSectionsInFreezeWindowView:(SYPFreezeWindowView *)freezeWindowView {
    // TODO: 根据model动态修改
    return self.sheetModel.head.count - 1;
}

// 纵向
- (NSInteger)numberOfRowsInFreezeWindowView:(SYPFreezeWindowView *)freezeWindowView {
    // TODO: 根据model动态修改
    return self.sheetModel.data.count;
}
// 横向
- (SYPSectionViewCell *)freezeWindowView:(SYPFreezeWindowView *)freezeWindowView cellAtSection:(NSInteger)section {
    
    __weak typeof(self) weakSelf = self;
    SYPSectionViewCell *cell = [freezeWindowView  dequeueReusableSectionCellWithIdentifier:sectionCellID forSection:section];
    if (!cell) {
        cell = [[SYPSectionViewCell alloc] initWithStyle:SYPSectionViewCellStyleDefault reuseIdentifier:sectionCellID];
        [cell setClickedActive:^(NSString *title, BOOL isSelect) {
            
            // 做排序处理
            NSLog(@"model中重新排列 %@", title);
            // 根据所在列进行排序
            [weakSelf rotationSectionCellSortIcon:section select:isSelect];
        }];
    }
    section += 1;
    if (section < 1 || section >= self.sheetModel.head.count) {
        section = 1;
    }
    NSString *title = self.sheetModel.head[section];
    //NSString *title = [NSString stringWithFormat:@"S %zi", section];
    //NSLog(@"%@", title);
    cell.title = title;
    return cell;
}

// 纵向
- (SYPRowViewCell *)freezeWindowView:(SYPFreezeWindowView *)freezeWindowView cellAtRow:(NSInteger)row {
    
    SYPRowViewCell *cell = [freezeWindowView dequeueReusableRowCellWithIdentifier:rowCellID forRow:row];
    if (!cell) {
        cell = [[SYPRowViewCell alloc] initWithStyle:SYPFreezeViewCellStyleDefault reuseIdentifier:rowCellID];
        __weak typeof(self) weakSelf = self;
        [cell setClickedActive:^(NSString *title) {
            // !!!: 在显示不全时，显示完整名称
            NSLog(@"显示完整名称: %@", title);
            CGFloat width = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, freezePoint.y) options:0 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.width;
            if (width > freezePoint.x) {
                [SYPHudView showHUDWithTitle:title];
            }
            if (weakSelf.sheetModel.data[row].subData.allKeys > 0) {
                [weakSelf showSubSheetView:row];
            }
        }];
    }
    
    if (row < 0 || row >= self.sheetModel.data.count) {
        row = 0;
    }
    NSString *title = self.sheetModel.leadLineTitle[row];
    //NSString *title = [NSString stringWithFormat:@"R %zi", row];
    //NSLog(@"%@", title);
    cell.showFlagPoint = self.sheetModel.data[row].subData.count > 0;
    cell.title = title;
    return cell;
}

// mianCell
- (SYPMainViewCell *)freezeWindowView:(SYPFreezeWindowView *)freezeWindowView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYPMainViewCell *cell = [freezeWindowView dequeueReusableMainCellWithIdentifier:mainCellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[SYPMainViewCell alloc] initWithStyle:SYPMainViewCellStyleDefault reuseIdentifier:mainCellID];
    }
    
    NSInteger row = indexPath.row, section = indexPath.section + 1;
    if (row < 0 || row >= self.sheetModel.data.count) {
        row = 0;
    }
    if (section < 1 || section >= self.sheetModel.data[row].mainData.count) {
        section = 1;
    }
    
    //NSString *unit = [self.sheetModel.mainDataModelList[row].dataList[section] floatValue] > 0 ? @"+" : @"";
    //NSString *title = [NSString stringWithFormat:@"%@%0.2f", unit, [self.sheetModel.mainDataModelList[row].dataList[section] floatValue]];
    
    cell.title = self.sheetModel.data[row].mainData[section].value;
    cell.titleColor = self.sheetModel.data[row].mainData[section].color1;
    return cell;
}

#pragma mark - <SYPFreezeWindowViewDelegate>
- (void)freezeWindowView:(SYPFreezeWindowView *)freezeWindowView didSelectMainZoneIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row, section = indexPath.section + 1;
    if (row < 0 || row >= self.sheetModel.data.count) {
        row = 0;
    }
    if (section < 1 || section >= self.sheetModel.data[row].mainData.count) {
        section = 1;
    }
    [SYPHudView showHUDWithTitle:self.sheetModel.data[row].mainData[section].value];
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
    [self.freezeView reloadData];
    // 3.对特殊cell(被点击cell)进行处理、图标旋转
    SYPSectionViewCell *cell = [self.freezeView dequeueReusableSectionCellWithIdentifier:sectionCellID forSection:section];
    [cell rotationCellSortIcon:M_PI * recoverFlag];
    
    // 记录最近一次排序的所在列
    lastSortSection = section;
}

@end
