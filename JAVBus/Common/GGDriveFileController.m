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
#import <MBProgressHUD/MBProgressHUD.h>

@interface GGDriveFileController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *fileArray ;
@property (nonatomic, strong) UITableView *tableView ;

@end

@implementation GGDriveFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f7"];
    
    if (self.folderPath.length == 0) {
        self.title = @"/";
    }else{
        self.title = self.folderPath;
    }
    
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
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"同步" style:UIBarButtonItemStylePlain target:self action:@selector(backupToCurrentFolder)];
    self.navigationItem.rightBarButtonItem = item;
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:table];
    self.tableView = table;
    
    [table registerNib:[UINib nibWithNibName:NSStringFromClass([GGDriveFolderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GGDriveFolderCell class])];
    [table registerNib:[UINib nibWithNibName:NSStringFromClass([GGDriveFileCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GGDriveFileCell class])];
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_offset(kNavigationBarHeight);
        make.bottom.mas_equalTo(iPhoneX?-20:0);
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
        cell.file = fileObj;
        WeakSelf(weakSelf);
        cell.recoverCallback = ^(DBFILESFileMetadata * _Nonnull file) {
            [weakSelf recoverBtnClicked:file];
        };
        
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
    return 50;
}

- (void)downloadImage:(NSString *)imagePath {
    
}

//恢复数据库
- (void)recoverBtnClicked:(DBFILESFileMetadata *)file {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    [[DropBoxManager shareManager] recoverDBFile:file progressCallback:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
        });
    } completeCallback:^(BOOL completed) {
        [hud hideAnimated:YES];
    }];
    
}

- (void)backupToCurrentFolder {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    [[DropBoxManager shareManager] syncDBFiles:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
        });
    } completeCallback:^(BOOL completed) {
        [hud hideAnimated:YES];
        [self getData];
    }];
    
}

@end
