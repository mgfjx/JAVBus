//
//  SettingViewController.m
//  JAVBus
//
//  Created by mgfjx on 2019/1/4.
//  Copyright © 2019 mgfjx. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
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
    
    [self.view addSubview:table];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    table.tableFooterView = [UIView new];
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellReuse = NSStringFromClass([UITableViewCell class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellReuse];
    }
    
    NSString *title ;
    NSString *imgName ;
    switch (indexPath.row) {
        case 0:
            title = @"清除缓存";
            imgName = @"clear_icon";
            break;
            
        default:
            break;
    }
    
    cell.textLabel.text = title;
    cell.imageView.image = [UIImage imageNamed:imgName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

@end
