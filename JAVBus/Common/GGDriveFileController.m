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

@property (nonatomic, strong) NSArray *fileArray ;
@property (nonatomic, strong) UITableView *tableView ;

@end

@implementation GGDriveFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"DropBox";
    
    [self initViews];
    
    [self getData];
}

- (void)getData {
    
    if (!self.folderPath) {
        self.folderPath = @"";
    }
    
    [PublicDialogManager showWaittingInView:self.view];
    [[DropBoxManager shareManager] getAllFiles:self.folderPath callback:^(NSArray<DBFILESMetadata *> * _Nonnull fileList) {
        [PublicDialogManager hideWaittingInView:self.view];
        self.fileArray = fileList;
        [self.tableView reloadData];
    }];
}

- (void)initViews {
    
    UIView *controlView = [[UIView alloc] init];
    controlView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:controlView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(backupToCurrentFolder) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"备份到当前目录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#006be3"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#6d9cea"] forState:UIControlStateHighlighted];
    [controlView addSubview:button];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [controlView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(iPhoneX?60:40);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(iPhoneX?-20:0);
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
        make.left.right.mas_equalTo(0);
        make.top.mas_offset(kNavigationBarHeight);
        make.bottom.equalTo(controlView.mas_top).offset(0);
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
    
    DBFILESMetadata *file = self.fileArray[indexPath.row];
    if ([file isKindOfClass:[DBFILESFolderMetadata class]]) {
        DBFILESFolderMetadata *folder = (DBFILESFolderMetadata *)file;
        
        GGDriveFileController *vc = [GGDriveFileController new];
        vc.folderPath = folder.pathDisplay;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        DBFILESFileMetadata *fileObj = (DBFILESFileMetadata *)file;
        [self downloadImage:fileObj.pathDisplay];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)downloadImage:(NSString *)imagePath {
    
}

- (void)backupToCurrentFolder {
    
    
    
}

@end
