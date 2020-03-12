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
#import "DropBoxManager.h"

@interface GGDriveFileController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *fileArray ;
@property (nonatomic, strong) UITableView *tableView ;
@property (nonatomic, strong) UIActivityIndicatorView *indicator ;

@end

@implementation GGDriveFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initViews];
    
    [self getData];
}

- (void)getData {
    
    [self.indicator startAnimating];
    [[DropBoxManager shareManager] getAllFiles:^(NSArray<DBFILESMetadata *> * _Nonnull fileList) {
        self.fileArray = fileList;
        [self.tableView reloadData];
        [self.indicator stopAnimating];
    }];
}

- (void)initViews {
    
    CGFloat navHeight = 44 ;
    if (self.modalPresentationStyle == UIModalPresentationFullScreen) {
        navHeight = iPhoneX?88:64;
    }
    
    UIView *naviView = [[UIView alloc] init];
    naviView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviView];
    
    [naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(navHeight);
    }];
    
    //返回
    /*
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(completeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor colorWithHexString:@"#005fe1"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#7497e8"] forState:UIControlStateHighlighted];
    [naviView addSubview:button];
    [button sizeToFit];
     */
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    indicator.backgroundColor = [UIColor randomColor];
    [naviView addSubview:indicator];
    self.indicator = indicator;
    
    //標題
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Google Drive";
    titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
//    titleLabel.backgroundColor = [UIColor randomColorWithAlpha:0.5];
    [naviView addSubview:titleLabel];
    
    //右側功能按鈕
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(completeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#005fe1"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#7497e8"] forState:UIControlStateHighlighted];
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
    
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(titleLabel.mas_centerY).offset(0);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(titleLabel.mas_centerY).offset(0);
        make.height.mas_equalTo(rightBtn.height);
        make.width.mas_equalTo(rightBtn.width);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(indicator.mas_right).offset(8);
        make.right.equalTo(rightBtn.mas_left).offset(-8);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor colorWithHexString:@"#f2f2f7"];
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
    return self.fileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DBFILESMetadata *file = self.fileArray[indexPath.row];
    
    if ([file isKindOfClass:[DBFILESFolderMetadata class]]) {
        
        DBFILESFolderMetadata *folder = (DBFILESFolderMetadata *)file;
        
        NSString *cellReuse = NSStringFromClass([GGDriveFolderCell class]);
        GGDriveFolderCell *cell = (GGDriveFolderCell *)[tableView dequeueReusableCellWithIdentifier:cellReuse];
        cell.titleLabel.text = folder.name;
        return cell;
    }else {
        DBFILESFileMetadata *fileObj = (DBFILESFileMetadata *)file;
        
        NSString *cellReuse = NSStringFromClass([GGDriveFileCell class]);
        GGDriveFileCell *cell = (GGDriveFileCell *)[tableView dequeueReusableCellWithIdentifier:cellReuse];
        cell.titleLabel.text = fileObj.name;
        
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
