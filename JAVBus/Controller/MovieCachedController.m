//
//  MovieCachedController.m
//  JAVBus
//
//  Created by mgfjx on 2019/1/8.
//  Copyright © 2019 mgfjx. All rights reserved.
//

#import "MovieCachedController.h"
#import "VideoPlayerManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MovieCachedController ()

@property (nonatomic, strong) MovieListModel *currentModel ;
@property (nonatomic, assign) NSInteger pageSize ;

@end

@implementation MovieCachedController

- (void)viewDidLoad {
    self.pageSize = 0;
    [super viewDidLoad];
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)refresh {
    if (refresh) {
        self.pageSize = 0;
    }else{
        self.pageSize++;
    }
    
    NSArray *array = [DBMANAGER queryMovieCacheList:self.pageSize];
    if (refresh) {
        self.dataArray = [array copy];
    }else{
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.dataArray];
        [arr addObjectsFromArray:array];
        self.dataArray = [arr copy];
    }
    [self.collectionView stopHeaderRefreshing];
    [self.collectionView stopFooterRefreshing];
    [self.collectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ActressDetailCell *cell = (ActressDetailCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    cell.showOperation = YES;
    WeakSelf(weakSelf)
    cell.actionCallback = ^(MovieListModel *model) {
        [weakSelf showFuncSelection];
        weakSelf.currentModel = model;
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieListModel *model = self.dataArray[indexPath.row];
    
    NSString *code = model.number;
    NSString *name = [NSString stringWithFormat:@"%@.mp4", [Encrypt md5Encrypt32:model.number]];
    NSString *filePath = [[GlobalTool shareInstance].movieCacheDir stringByAppendingPathComponent:name];
    
    BOOL isFileExsit = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if ([DBMANAGER isMovieCacheExsit:model] && isFileExsit) {
        [[VideoPlayerManager shareManager] showPlayerWithUrl:filePath];
    }else {
        [PublicDialogManager showWaittingInView:self.view];
        [HTTPMANAGER getVideoByCode:code SuccessCallback:^(NSDictionary *resultDict) {
            BOOL isSuccess = [resultDict[@"success"] boolValue];
            if (isSuccess) {
                NSDictionary *response = resultDict[@"response"];
                NSArray *array = response[@"videos"];
                if (array.count > 0) {
                    NSDictionary *video = array.firstObject;
                    NSString *preview_url = video[@"preview_video_url"];
                    
                    [HTTPMANAGER downloadFile:preview_url progress:^(NSProgress * _Nonnull downloadProgress) {
                        float progress = downloadProgress.completedUnitCount*1.0 / downloadProgress.totalUnitCount*1.0;
                        NSLog(@"progress: %f", progress);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                            hud.mode = MBProgressHUDModeDeterminate;
                            hud.progressObject = downloadProgress;
                        });
                    } completion:^(NSURL * _Nullable filePath, NSError * _Nullable error) {
                        if (error) {
                            [PublicDialogManager showText:@"获取预览失败, 请检查VPN, 稍后重试" inView:self.view duration:2.0];
                            return ;
                        }
                        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                        hud.customView = imageView;
                        hud.mode = MBProgressHUDModeCustomView;
                        [hud hideAnimated:YES afterDelay:2.f];
                        
                        NSString *path = [GlobalTool shareInstance].movieCacheDir;
                        NSString *md5Str = [Encrypt md5Encrypt32:model.number];
                        NSString *name = [NSString stringWithFormat:@"/%@.mp4", md5Str];
                        NSString *savePath = [path stringByAppendingPathComponent:name];
                        if ([[NSFileManager defaultManager] fileExistsAtPath:savePath]) {
                            [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
                        }
                        [[NSFileManager defaultManager] moveItemAtPath:filePath.path toPath:savePath error:&error];
                        
                        if (error) {
                            NSLog(@"%@", error);
                        }else {
                            [[VideoPlayerManager shareManager] showPlayerWithUrl:savePath];
                        }
                    }];
                }else{
                    [PublicDialogManager hideWaittingInView:self.view];
                    [PublicDialogManager showText:@"未查询到相关预览视频" inView:self.view duration:1.0];
                }
            }else {
                [PublicDialogManager hideWaittingInView:self.view];
                [PublicDialogManager showText:@"未查询到相关预览视频" inView:self.view duration:1.0];
            }
            
        } FailCallback:^(NSError *error) {
            [PublicDialogManager hideWaittingInView:self.view];
            [PublicDialogManager showText:@"服务出错" inView:self.view duration:1.0];
        }];
    }
    
}

- (void)showFuncSelection {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"操作" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self shareWithActivityItems:self.currentModel];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action2];
    [alert addAction:action1];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)shareWithActivityItems:(MovieListModel *)model {
    
    // 自定义的CustomActivity，继承自UIActivity
    UIActivity *customActivity = [[UIActivity alloc] init];
    NSArray *activityArray = @[customActivity];
    
    NSString *name = [NSString stringWithFormat:@"%@.mp4", [Encrypt md5Encrypt32:model.number]];
    NSString *filePath = [[GlobalTool shareInstance].movieCacheDir stringByAppendingPathComponent:name];
    NSURL *urlToShare = [NSURL fileURLWithPath:filePath];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[model.title, urlToShare] applicationActivities:activityArray];
    // 根据需要指定不需要分享的平台
    activityVC.excludedActivityTypes = @[UIActivityTypeMail,UIActivityTypePostToTwitter,UIActivityTypeMessage,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks];
    // >=iOS8.0系统用这个方法
    activityVC.completionWithItemsHandler = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
    {
        if (completed) { // 确定分享
        }
        else {
        }
    };
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
