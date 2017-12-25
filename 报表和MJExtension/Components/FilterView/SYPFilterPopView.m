//
//  SYPFilterListView.m
//  报表和MJExtension
//
//  Created by 应明顺 on 2017/12/7.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPFilterPopView.h"
#import "SYPConstantColor.h"
#import "SYPConstantSize.h"
#import "SYPConstantString.h"
#import "UIView+Extension.h"
#import "SYPTabController.h"
#import "SYPFilterListView.h"
#import "Masonry.h"

@interface SYPFilterPopView () <SYPTabControllerProtocol, SYPFilterListViewProtocol> {
    NSMutableArray <SYPFilterListView *> *filterListViewAry;
    UIView *bgView;
}

@property (nonatomic, strong) SYPFilterModel *filter;
@property (nonatomic, strong) SYPTabController *tabContorller;
@property (nonatomic, copy) SYPFilterResultHandler filterCompletionHandler;

@end

@implementation SYPFilterPopView

#pragma mark - Initialize Method
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIView *bgBlack = [[UIView alloc] initWithFrame:self.bounds];
        bgBlack.backgroundColor = [SYPColor_AlertBackgroudColor_BlackGray appendAlpha:0.2];
        bgBlack.tag = -1000;
        [self addSubview:bgBlack];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
        tap.view.tag = -1000;
        [bgBlack addGestureRecognizer:tap];
        
        filterListViewAry = [NSMutableArray array];
        
        bgView = [[UIView alloc] init];//WithFrame:CGRectMake(0, SYPViewHeight/2, SYPViewWidth, SYPViewHeight/2)
        bgView.backgroundColor = SYPColor_BackgroudColor_White;
        bgView.tag = -1001;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_bottom).multipliedBy(0.5);
            make.left.bottom.right.mas_equalTo(0);
        }];
        
        UILabel *title = [[UILabel alloc] init];//WithFrame:CGRectMake(0, 0, 200, 48)
        title.centerX = bgView.centerX;
        title.text = @"所在地区";
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = SYPColor_TextColor_Minor;
        [bgView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            //make.width.mas_equalTo(200);
            make.height.mas_equalTo(48);
        }];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //closeBtn.frame = CGRectMake(SYPViewWidth - 48, 0, 48, 48);
        [closeBtn setImage:[UIImage imageNamed:@"btn_empty"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(hiddenFilterListView) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(0);
            make.width.height.mas_equalTo(48);
        }];
        //WithFrame:CGRectMake(0, 48, SYPViewWidth, 32)
        [bgView addSubview:self.tabContorller];
        [self.tabContorller mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(title.mas_bottom);
            make.height.mas_equalTo(32);
        }];
        
        UIView *btmLine = [[UIView alloc] init];//WithFrame:CGRectMake(0, self.tabContorller.y + self.tabContorller.height - 1, SYPViewWidth, 1)
        btmLine.backgroundColor = SYPColor_TextColor_Minor;
        [bgView addSubview:btmLine];
        [btmLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.tabContorller.mas_bottom).mas_equalTo(-2);
            make.height.mas_equalTo(1);
        }];
        
    }
    return self;
}

#pragma mark - Lazy
- (SYPTabController *)tabContorller {
    if (!_tabContorller) {
        _tabContorller = [[SYPTabController alloc] init];//WithFrame:CGRectMake(0, 48, SYPViewWidth, 32)
        _tabContorller.delegate = self;
    }
    return _tabContorller;
}

#pragma mark - Setter
// 该方法仅在第一次初始化调用
- (void)setFilter:(SYPFilterModel *)filter {
    if (![filter isEqual:_filter]) {
        _filter = filter;
        
        // 选项卡绑定数据
        [self.tabContorller addNewTabWithName:@"请选择"];
        
        // 选项页显示，并绑定数据
        SYPFilterListView *listView = [[SYPFilterListView alloc] init];//WithFrame:CGRectMake(0, self.tabContorller.y + self.tabContorller.height, self.width, bgView.height - (self.tabContorller.y + self.tabContorller.height))
        SYPFilterDataModel *filterData = [[SYPFilterDataModel alloc] init];
        filterData.data = self.filter.data;
        [listView showFilterListViewWithOptions:filterData];
        listView.delegate = self;
        [bgView addSubview:listView];
        [listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tabContorller.mas_bottom);
            make.left.right.bottom.mas_equalTo(0);
        }];
        
        [filterListViewAry addObject:listView];
    }
}


#pragma mark - Interface implementation
+ (void)showFilterListViewWithFilter:(SYPFilterModel *)filter completionHandler:(SYPFilterResultHandler)handler{
    
    SYPFilterPopView *filterListView = [[SYPFilterPopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    filterListView.filter = filter;
    filterListView.filterCompletionHandler = handler;
    [[[UIApplication sharedApplication] keyWindow] addSubview:filterListView];
}

#pragma mark - logic
- (void)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.view.tag == -1000) {
        [self hiddenFilterListView];
    }
}

- (void)newFilterList:(SYPFilterDataModel *)filterDataModel {
    
    // 选项页显示，并绑定数据
    SYPFilterListView *listView = [[SYPFilterListView alloc] init];//WithFrame:CGRectMake(0, self.tabContorller.y + self.tabContorller.height, self.width, bgView.height - (self.tabContorller.y + self.tabContorller.height))
    [listView showFilterListViewWithOptions:filterDataModel];
    listView.delegate = self;
    [bgView addSubview:listView];
    [listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tabContorller.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [filterListViewAry addObject:listView];
}

- (void)hiddenFilterListView {
    
    [UIView animateWithDuration:SYPAnimationToolDuration animations:^{
        [self viewWithTag:-1001].y = SYPViewHeight;
    } completion:^(BOOL finished) {
        [[self viewWithTag:-1001] removeFromSuperview];
        
        [self removeFromSuperview];
    }];
}

#pragma mark - protocol
#pragma mark <SYPTabControllerProtocol>
- (void)tabController:(SYPTabController *)tabController selecteTabWithHierarchyName:(NSString *)name hierarchyIndex:(NSInteger)index {
    
    NSRange range = NSMakeRange(index + 1, filterListViewAry.count - 1 - index);
    [[filterListViewAry subarrayWithRange:range] enumerateObjectsUsingBlock:^(SYPFilterListView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [filterListViewAry removeObjectsInRange:range];
    
    [filterListViewAry[index] reshow];
    
}


#pragma mark <SYPFilterListViewProtocol>
- (void)filterListView:(SYPFilterListView *)filterListView selecteOptionWithHierarchyName:(NSString *)name index:(NSInteger)index {
    
    // 选择可选项后tab添加标签
    NSString *nextHierarchy = filterListView.filterDataModel.data[index].name;
    [self.tabContorller addNewTabWithName:nextHierarchy];
    
    // 判断是否还有下一级菜单，没有的不进行下一步展示了
    if (!filterListView.filterDataModel.data[index].data.count) {
        NSString *result = [self.tabContorller.hierarchyName componentsJoinedByString:@"||"];
        result = [result stringByReplacingOccurrencesOfString:@"请选择||" withString:@""];
        NSLog(@"%@", result);
        [self hiddenFilterListView];
        self.filterCompletionHandler(result);
        return;
    }
    
    // 增加备选列表
    [self newFilterList:filterListView.filterDataModel.data[index]];
}


@end
