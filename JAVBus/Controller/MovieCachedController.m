//
//  MovieCachedController.m
//  JAVBus
//
//  Created by mgfjx on 2019/1/8.
//  Copyright © 2019 mgfjx. All rights reserved.
//

#import "MovieCachedController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MovieCachedController ()

@property (nonatomic, strong) MovieListModel *currentModel ;

@end

@implementation MovieCachedController

- (void)viewDidLoad {
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
    NSArray *array = [DBMANAGER queryMovieCacheList];
    self.dataArray = [array copy];
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
    NSString *name = [NSString stringWithFormat:@"%@.mp4", [Encrypt md5Encrypt32:model.number]];
    NSString *filePath = [[GlobalTool shareInstance].movieCacheDir stringByAppendingPathComponent:name];
    MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
    moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [self presentViewController:moviePlayerController animated:YES completion:nil];
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
