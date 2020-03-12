//
//  GGDriveFileController.m
//  JAVBus
//
//  Created by mgfjx on 2020/3/12.
//  Copyright © 2020 mgfjx. All rights reserved.
//

#import "GGDriveFileController.h"
#import "GoogleDriveManager.h"
#import "GGDriveFolderCell.h"
#import "GGDriveFileCell.h"

@interface GGDriveFileController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *folderArray ;
@property (nonatomic, strong) NSArray *fileArray ;
@property (nonatomic, strong) UITableView *tableView ;

@end

@implementation GGDriveFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.folderArray = @[@1,@1,@1,@1,@1,];
    self.fileArray = @[@1,@1,@1,@1,@1,];
    
    [self initViews];
    
    [self getData];
}

- (void)getData {
    
    [[GoogleDriveManager shareManager] getAllFileList:^(NSArray<GTLRDrive_File *> * _Nonnull fileList) {
        [self.tableView reloadData];
    }];
    
}

- (void)initViews {
    
    CGFloat navHeight = iPhoneX?88:64;
    
    UIView *naviView = [[UIView alloc] init];
    naviView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviView];
    
    [naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(navHeight);
    }];
    
    //返回
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(completeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [naviView addSubview:button];
    [button sizeToFit];
    
    //標題
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Google Drive";
    titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [naviView addSubview:titleLabel];
    
    //右側功能按鈕
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(completeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [naviView addSubview:rightBtn];
    [rightBtn sizeToFit];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [naviView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-8);
        make.centerY.equalTo(titleLabel.mas_centerY).offset(0);
        make.height.mas_equalTo(button.height);
        make.width.mas_equalTo(button.width);
    }];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(titleLabel.mas_centerY).offset(0);
        make.height.mas_equalTo(rightBtn.height);
        make.width.mas_equalTo(rightBtn.width);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button.mas_right).offset(8);
        make.right.equalTo(rightBtn.mas_left).offset(-8);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    
    [self.view addSubview:table];
    self.tableView = table;
    
    [table registerNib:[UINib nibWithNibName:NSStringFromClass([GGDriveFolderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GGDriveFolderCell class])];
    [table registerNib:[UINib nibWithNibName:NSStringFromClass([GGDriveFileCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GGDriveFileCell class])];
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(naviView.mas_bottom).offset(0);
    }];
    
}

- (void)completeClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.folderArray.count + self.fileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.folderArray.count) {
        NSString *cellReuse = NSStringFromClass([GGDriveFolderCell class]);
        GGDriveFolderCell *cell = (GGDriveFolderCell *)[tableView dequeueReusableCellWithIdentifier:cellReuse];
        
        return cell;
    }else {
        NSString *cellReuse = NSStringFromClass([GGDriveFileCell class]);
        GGDriveFileCell *cell = (GGDriveFileCell *)[tableView dequeueReusableCellWithIdentifier:cellReuse];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end
