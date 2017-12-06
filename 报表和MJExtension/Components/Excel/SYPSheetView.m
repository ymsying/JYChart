//
//  SYPExcelView.m
//  各种报表
//
//  Created by niko on 17/5/6.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPSheetView.h"

#import "SYPTablesModel.h"
#import "SYPFreezeWindowView.h"
#import "SYPHudView.h"

#import "SYPSubSheetView.h"

#define kFreezePoint (CGPointMake(60, kSheetHeadHeight))

static NSString *mainCellID = @"mainCell";
static NSString *sectionCellID = @"sectionCell";
static NSString *rowCellID = @"rowCell";

@interface SYPSheetView () <SYPFreezeWindowViewDelegate, SYPFreezeWindowViewDataSource> {
    
    NSInteger lastSortSection; // 上一步排序列数标志
    BOOL recoverFlag; // YES时箭头向下、降序排列
}

@property (nonatomic, strong) SYPTableConfigModel *configModel;
@property (nonatomic, strong) SYPFreezeWindowView *freezeView;

@end

@implementation SYPSheetView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        lastSortSection = 0;
        recoverFlag = YES;
    }
    return self;
}

- (void)layoutSubviews {
    
    [self initializeSubView];
    [self.freezeView setSignViewWithContent:self.configModel.leadLineTitle[0]];
}

- (SYPFreezeWindowView *)freezeView {
    if (!_freezeView) {
        _freezeView = [[SYPFreezeWindowView alloc] initWithFrame:self.bounds FreezePoint:kFreezePoint cellViewSize:CGSizeMake(100, kMianCellHeight)];
        _freezeView.flexibleHeight = self.flexibleHeight;
        _freezeView.delegate = self;
        _freezeView.dataSource = self;
        _freezeView.bounceStyle = SYPFreezeWindowViewBounceStyleNone;
    }
    return _freezeView;
}

- (void)initializeSubView {
    
    [self addSubview:self.freezeView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSectionViewFrame:) name:@"scrollUpOrDown" object:nil];
}

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

// 表头悬浮
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
            frame.origin.x = SYPDefaultMargin * 2 + kFreezePoint.x;
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
            frame.origin.x = kFreezePoint.x;
            self.freezeView.sectionView.frame = frame;
            
            [self.freezeView addSubview:self.freezeView.signView];
            frame = self.freezeView.signView.frame;
            frame.origin.y = 0;
            frame.origin.x = 0;
            self.freezeView.signView.frame = frame;
            //printf("……………………retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self.freezeView.sectionView)));
        }
    }
    else {
        
        //NSLog(@"外部复原");
        [self.freezeView addSubview:self.freezeView.sectionView];
        CGRect frame = self.freezeView.sectionView.frame;
        frame.origin.y = 0;
        frame.origin.x = kFreezePoint.x;
        self.freezeView.sectionView.frame = frame;
        
        [self.freezeView addSubview:self.freezeView.signView];
        frame = self.freezeView.signView.frame;
        frame.origin.y = 0;
        frame.origin.x = 0;
        self.freezeView.signView.frame = frame;
        //printf("……………………retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self.freezeView.sectionView)));
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"scrollUpOrDown" object:nil];
}

- (SYPSheetModel *)sheetModel {
    if (!_sheetModel) {
        _sheetModel = (SYPSheetModel *)self.moduleModel;
    }
    return _sheetModel;
}

#pragma mark - <SYPFreezeWindowViewDataSource>
// 横向
- (NSInteger)numberOfSectionsInFreezeWindowView:(SYPFreezeWindowView *)freezeWindowView {
    // TODO: 根据model动态修改
    return self.sheetModel.headNames.count - 1;
}

// 纵向
- (NSInteger)numberOfRowsInFreezeWindowView:(SYPFreezeWindowView *)freezeWindowView {
    // TODO: 根据model动态修改
    return self.sheetModel.mainDataModelList.count;
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
    if (section < 1 || section >= self.sheetModel.headNames.count) {
        section = 1;
    }
    NSString *title = self.sheetModel.headNames[section];
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
            NSLog(@"显示 %@", title);
            CGSize size = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, kFreezePoint.y) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
            if (size.width > kFreezePoint.x) {
                [SYPHudView showHUDWithTitle:title];
            }
            [weakSelf showSubSheetView:row];
        }];
    }
    
    if (row < 0 || row >= self.sheetModel.mainDataModelList.count) {
        row = 0;
    }
    NSString *title = self.sheetModel.mainDataModelList[row].dataList[0];
    //NSString *title = [NSString stringWithFormat:@"R %zi", row];
    //NSLog(@"%@", title);
    cell.showFlagPoint = self.sheetModel.mainDataModelList[row].subDataList.count > 0;
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
    if (row < 0 || row >= self.sheetModel.mainDataModelList.count) {
        row = 0;
    }
    if (section < 1 || section >= self.sheetModel.mainDataModelList[row].dataList.count) {
        section = 1;
    }
    
    //NSString *unit = [self.sheetModel.mainDataModelList[row].dataList[section] floatValue] > 0 ? @"+" : @"";
    //NSString *title = [NSString stringWithFormat:@"%@%0.2f", unit, [self.sheetModel.mainDataModelList[row].dataList[section] floatValue]];
    NSString *title = [NSString stringWithFormat:@"%@", self.sheetModel.mainDataModelList[row].dataList[section]];
    //NSLog(@"%@", cell.title);
    cell.title = title;
    return cell;
}

#pragma mark - <SYPFreezeWindowViewDelegate>
- (void)freezeWindowView:(SYPFreezeWindowView *)freezeWindowView didSelectMainZoneIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"%@", [NSString stringWithFormat:@"did seleced at section %zi row %zi", indexPath.section, indexPath.row]);
    //NSLog(@"%@", [NSString stringWithFormat:@"需要修改为点击下钻事件"]);
    //[self showSubSheetView:indexPath.row];
    NSInteger row = indexPath.row, section = indexPath.section + 1;
    if (row < 0 || row >= self.sheetModel.mainDataModelList.count) {
        row = 0;
    }
    if (section < 1 || section >= self.sheetModel.mainDataModelList[row].dataList.count) {
        section = 1;
    }
    NSString *title = [NSString stringWithFormat:@"%@", self.sheetModel.mainDataModelList[row].dataList[section]];
    [SYPHudView showHUDWithTitle:title];
}

- (void)showSubSheetView:(NSInteger)row {
    if (self.sheetModel.mainDataModelList[row].subDataList.count > 0) {
        
        NSMutableArray *headTitle = [self.sheetModel.headNames mutableCopy];
        [headTitle replaceObjectAtIndex:0 withObject:@"商行"];
        NSMutableArray *data = [NSMutableArray array];
        for (SYPSubDataModlel *subDataModel in self.sheetModel.mainDataModelList[row].subDataList) {
            [data addObject:subDataModel.params];
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:headTitle forKey:@"head"];
        [params setObject:data forKey:@"data"];
        SYPSheetModel *subSheetModel = [SYPSheetModel modelWithParams:params];
        subSheetModel.sheetTitle = self.sheetModel.mainDataModelList[row].dataList[0];
        
        SYPSubSheetView *subView = [[SYPSubSheetView alloc] initWithFrame:CGRectMake(0,0,SYPScreenWidth,SYPScreenHeight)];
        subView.sheetModel = subSheetModel;
        [subView showSubSheetView];
    }
}

- (void)refreshSubViewData {
//    [self initializeSubView];
//    [self.freezeView setSignViewWithContent:self.sheetModel.headNames[0]];
}

- (CGFloat)estimateViewHeight:(SYPModuleTwoBaseModel *)model {
    // TODO: 根据model动态修改，将表格全部展示完。提供给父视图的高度正好展示完，本身所在的scrollview不进行滑动
    return ((SYPSheetModel *)model).mainDataModelList.count * kMianCellHeight + kSheetHeadHeight;
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
