//
//  StartVC.m
//  报表和MJExtension
//
//  Created by 钱宝峰 on 2018/1/10.
//  Copyright © 2018年 应明顺. All rights reserved.
//

#import "StartVC.h"
#import "StartVCAPI.h"
#import "ListPage.h"
#import "ViewController.h"

@interface StartVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *guideTableView;
@property (nonatomic, strong) ListPageList *listPageList;

@end

@implementation StartVC


#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getData];
    self.guideTableView.frame = self.view.frame;
    [self.view addSubview:self.guideTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listPageList.listpage.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listPageList.listpage[section].listData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ListItem *item = self.listPageList.listpage[indexPath.section].listData[indexPath.row];
    cell.textLabel.text = item.listName;
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ViewController *viewCtrl = [[ViewController alloc]init];
    viewCtrl.listItem = self.listPageList.listpage[indexPath.section].listData[indexPath.row];
    [self.navigationController pushViewController:viewCtrl animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Network

-(void)getData {
    
    StartVCAPI *startVCAPI = [[StartVCAPI alloc]init];
    [startVCAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"成功");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: request.responseData options:NSJSONReadingAllowFragments error:nil];
        if (dict) {
            NSArray<ListPageList*> *array= [MTLJSONAdapter modelsOfClass:ListPageList.class fromJSONArray:dict[@"data"] error:nil];
            if (array.count >= 1) {
                self.listPageList = [array[0] copy];
                [self.guideTableView reloadData];
            }
            NSLog(@"okokok");
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"失败");
    }];
}


#pragma mark - Getter/Setter

-(UITableView *)guideTableView {
    if (!_guideTableView) {
        _guideTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _guideTableView.dataSource = self;
        _guideTableView.delegate = self;
        _guideTableView.rowHeight = 60;
        [_guideTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _guideTableView;
}


-(ListPageList *)listPageList {
    if (!_listPageList) {
        _listPageList = [ListPageList new];
    }
    return _listPageList;
}

@end
