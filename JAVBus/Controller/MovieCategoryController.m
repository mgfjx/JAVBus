//
//  MovieCategoryController.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/27.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "MovieCategoryController.h"
#import "CategoryModel.h"
#import "MovieMainController.h"
#import "CategoryItemListController.h"

@interface MovieCategoryController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MovieCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    [self.tableView startHeaderRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
    NSString *logo = [NSString stringWithFormat:@"子类必须为实现%@方法", NSStringFromSelector(_cmd)];
    NSAssert(0, logo);
}

- (void)createTableView {
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    
    [self.view addSubview:table];
    self.tableView = table;
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    table.tableFooterView = [UIView new];
    table.canPullDown = YES;
    WeakSelf(weakSelf)
    table.headerRefreshBlock = ^(UIScrollView *rfScrollView) {
        [weakSelf requestData];
    };
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CategoryModel *model = self.dataArray[section];
    return model.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellReuse = NSStringFromClass([UITableViewCell class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellReuse];
    }
    
    CategoryModel *model = self.dataArray[indexPath.section];
    CategoryItemModel *itemModel = model.items[indexPath.row];
    cell.textLabel.text = itemModel.title;
    cell.textLabel.textColor = [UIColor grayColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CategoryModel *model = self.dataArray[indexPath.section];
    CategoryItemModel *itemModel = model.items[indexPath.row];
    
    CategoryItemListController *vc = [CategoryItemListController new];
    vc.model = itemModel;
    vc.hidesBottomBarWhenPushed = YES;
    vc.showSortBar = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    CategoryModel *model = self.dataArray[section];
    return model.title;
}

@end
