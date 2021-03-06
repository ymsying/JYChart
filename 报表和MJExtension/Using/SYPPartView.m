//
//  SYPPartView.m
//  各种报表
//
//  Created by niko on 17/5/20.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "SYPPartView.h"
#import "SYPPageView.h"
#import "SYPConstantString.h"
#import "SYPBaseChartModel.h"
#import "SYPTablesModel.h"
#import "SYPPartViewCell.h"
#import "UIView+Extension.h"
#import "SYPSheetView.h"
#import "Masonry.h"

@interface SYPPartView () <UITableViewDelegate, UITableViewDataSource, SYPModuleTwoCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SYPPartViewCell *moduleTwoCell;


@end

@implementation SYPPartView

- (void)layoutSubviews {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
//    [self.tableView reloadData];
}

//- (void)setPartModel:(SYPPartModel *)partModel {
//    if (![_partModel isEqual:partModel]) {
//        _partModel = partModel;
//        [self addSubview:self.tableView];
//    }
//}

- (SYPPartViewCell *)moduleTwoCell {
    if (!_moduleTwoCell) {
        _moduleTwoCell = [[SYPPartViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SYPModuleTwoCell"];
    }
    return _moduleTwoCell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SYPViewWidth, SYPViewHeight) style:UITableViewStylePlain];
        [_tableView registerClass:[SYPPartViewCell class] forCellReuseIdentifier:@"SYPModuleTwoCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = SYPColor_SepLineColor_LightGray;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.partModel.chartList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYPPartViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYPModuleTwoCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    SYPBaseChartModel *model = self.partModel.chartList[indexPath.section];
//    if (model.chartType == SYPChartTypeTables) {
//        SYPTablesModel *excelModel = (SYPTablesModel *)model;
//        cell.viewModel = excelModel;
//    }
//    else {
        cell.viewModel = model;//self.partModel.chartList[indexPath.section];
//    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    
    SYPBaseChartModel *model = self.partModel.chartList[indexPath.section];
//    if (model.chartType == SYPChartTypeTables) {
//        SYPTablesModel *excelModel = (SYPTablesModel *)model;
//        height = [self.moduleTwoCell cellHeightWithModel:excelModel];
//    }
//    else {
        height = [self.moduleTwoCell cellHeightWithModel:model];//self.partModel.chartList[indexPath.section]
//    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SYPDefaultMargin;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offset = self.offsetExcelHead ? (self.offsetExcelHead) : 0;
//    offset += self.navStsH;
    SYPPageView *pageView = nil;
    NSInteger maxLoop = 10;
    [self getPageView:&pageView startView:self maxLoop:&maxLoop];
    [[NSNotificationCenter defaultCenter] postNotificationName:SYPUpdateExcelHeadFrame object:pageView userInfo:@{@"origin": [NSString stringWithFormat:@"{0,%lf}", offset], @"PartView": self}];
}

- (void)getPageView:(UIView **)view startView:(UIView *)startView maxLoop:(NSInteger *)maxLoop{
    if (maxLoop > 0) {
        if ([startView isKindOfClass:[SYPPageView class]] && startView) {
            *view = startView;
        } else {
            maxLoop--;
            [self getPageView:view startView:startView.superview maxLoop:maxLoop];
        }
    }
}

#pragma mark - <SYPModuleTwoCellDelegate>
- (void)moduleTwoCell:(SYPPartViewCell *)moduleTwoCell didSelectedAtBaseView:(SYPBaseChartModel *)baseView Index:(NSInteger)idx data:(id)data {
    //NSLog(@"self %@ = %p", [self class], self);
    //NSLog(@"view %@ data %@", baseView, data);
}



@end
