//
//  SYPFilterListView.m
//  报表和MJExtension
//
//  Created by 应明顺 on 2017/12/7.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPFilterListView.h"
#import "SYPConstantString.h"
#import "UIView+Extension.h"
#import "SYPFilterListViewCell.h"

static NSString *cellIdentifer = @"SYPFilterListViewCell";

@interface SYPFilterListView () <UITableViewDataSource, UITableViewDelegate> {
    
    CGFloat originalX;
}

@property (nonatomic, copy) UITableView *tableView;

@end

@implementation SYPFilterListView

- (instancetype)initWithFrame:(CGRect)frame {
    
    originalX = frame.origin.x;
    frame.origin.x = frame.origin.x + frame.size.width;
    if (self = [super initWithFrame:frame]) {       
        
        [self addSubview:self.tableView];
    }
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SYPFilterListViewCell class] forCellReuseIdentifier:cellIdentifer];
    }
    return _tableView;
}

- (void)showFilterListViewWithOptions:(SYPFilterDataModel *)filterDataModel {
    
    self.filterDataModel = filterDataModel;
    
    self.x = self.width;
    [UIView animateWithDuration:SYPAnimationToolDuration animations:^{
        self.x = originalX;
    }];
}

- (void)hiddenFilterListView {
    
    [UIView animateWithDuration:SYPAnimationToolDuration animations:^{
        self.x = self.width;
    }];
}

- (void)reshow {
    self.x = self.width;
    [UIView animateWithDuration:SYPAnimationToolDuration animations:^{
        self.x = originalX;
    }];
}


- (nonnull SYPFilterListViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SYPFilterListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.filterDataModel.data[indexPath.row].name;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filterDataModel.data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYPFilterListViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES animated:YES];
    
    // !!!:点击选中显示下一页
    if (self.delegate && [(id)self.delegate respondsToSelector:@selector(filterListView:selecteOptionWithHierarchyName:index:)]) {
        [self.delegate filterListView:self selecteOptionWithHierarchyName:self.filterDataModel.data[indexPath.row].name index:indexPath.row];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}



@end
