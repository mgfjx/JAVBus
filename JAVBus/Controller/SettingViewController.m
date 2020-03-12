//
//  SettingViewController.m
//  JAVBus
//
//  Created by mgfjx on 2019/1/4.
//  Copyright © 2019 mgfjx. All rights reserved.
//

#import "SettingViewController.h"
#import "AddressSettingController.h"
#import "GoogleDriveController.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray ;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    NSArray *dataArray = @[
        @[
            @{@"title":@"备份", @"imgName": @"tabbar_setting_unselected"},
        ],
        @[
            @{@"title":@"清除缓存图片", @"imgName": @"clear_icon"},
            @{@"title":@"删除女优收藏", @"imgName": @"clear_icon"},
            @{@"title":@"删除影片收藏", @"imgName": @"clear_icon"},
            @{@"title":@"删除影片缓存", @"imgName": @"clear_icon"},
        ],
        @[
            @{@"title":@"选择域名", @"imgName": @"tabbar_setting_unselected"}
        ],
    ];
    self.dataArray = dataArray;
    
    [self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTableView {
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor colorWithHexString:@"#ecedee"];
    
    [self.view addSubview:table];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    table.tableFooterView = [UIView new];
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellReuse = NSStringFromClass([UITableViewCell class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellReuse];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    NSArray *dataArray = self.dataArray[indexPath.section];
    
    NSDictionary *dict = dataArray[indexPath.row];
    
    NSString *title = dict[@"title"] ;
    NSString *imgName = dict[@"imgName"] ;
    
    cell.textLabel.text = title;
    cell.imageView.image = [UIImage imageNamed:imgName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        GoogleDriveController *vc = [GoogleDriveController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 2) {
        
        AddressSettingController * vc = [AddressSettingController new];
        //        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            //获取缓存图片的大小(字节)
            NSUInteger bytesCache = [[SDImageCache sharedImageCache] getSize];
            //换算成 MB (注意iOS中的字节之间的换算是1000不是1024)
            float MBCache = bytesCache/1000/1000;
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                NSString *text = [NSString stringWithFormat:@"已清理%.2fMB缓存",MBCache];
                [PublicDialogManager showText:text inView:self.view duration:2.0];
            }];
        }
        
        if (indexPath.row == 1) {
            [DBMANAGER deleteAllActress];
            [PublicDialogManager showText:@"删除成功" inView:self.view duration:1.0];
        }
        
        if (indexPath.row == 2) {
            [DBMANAGER deleteAllMovie];
            [PublicDialogManager showText:@"删除成功" inView:self.view duration:1.0];
        }
        
        if (indexPath.row == 3) {
            [DBMANAGER deleteAllCacheMovie];
            [PublicDialogManager showText:@"删除成功" inView:self.view duration:1.0];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

@end
