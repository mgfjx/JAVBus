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

@end

@implementation MovieCachedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieListModel *model = self.dataArray[indexPath.row];
    NSString *name = [NSString stringWithFormat:@"%@.mp4", [Encrypt md5Encrypt32:model.number]];
    NSString *filePath = [[GlobalTool shareInstance].movieCacheDir stringByAppendingPathComponent:name];
    MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
    moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [self presentViewController:moviePlayerController animated:YES completion:nil];
}

@end
