//
//  MovieDetailController.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/27.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "MovieDetailController.h"
#import "LinkButton.h"
#import "ActressDetailController.h"
#import "ScreenShotCell.h"
#import "ScreenShotModel.h"
#import "RecommendModel.h"
#import "RecommendCell.h"
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>
#import "CategoryItemListController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface MovieDetailController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView ;
@property (nonatomic, strong) MovieDetailModel *detailModel ;

@property (nonatomic, strong) UICollectionView *screenshotView ;
@property (nonatomic, strong) UICollectionView *recommendView ;

@end

@implementation MovieDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.model.number;
    [self initViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
    
    if ([DBMANAGER isMovieDetailExsit:self.model]) {
        [self.scrollView stopHeaderRefreshing];
        MovieDetailModel *model = [DBMANAGER queryMovieDetail:self.model];
        self.detailModel = model;
        [self createDetailView];
    }else{
        [HTMLTOJSONMANAGER parseMovieDetailByUrl:self.model.link callback:^(MovieDetailModel *model) {
            [self.scrollView stopHeaderRefreshing];
            if (model) {
                //            self.scrollView.canPullDown = NO;
            }
            model.title = self.model.title;
            model.number = self.model.number;
            self.detailModel = model;
            [self createDetailView];
        }];
    }
    
}

- (void)initViews {
    [self createBarbutton];
    [self createScrollView];
}

- (void)createBarbutton {
    
    BOOL isExsit = [DBMANAGER isMovieExsit:self.model];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(collectionActress:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"collection_unselected"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"collection_selected"] forState:UIControlStateSelected];
    button.selected = isExsit;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)collectionActress:(UIButton *)sender {
    if (sender.selected) {
        [DBMANAGER deleteMovie:self.model];
        [DBMANAGER deleteMovieDetail:self.model];
    }else{
        [DBMANAGER insertMovie:self.model];
        [DBMANAGER insertMovieDetail:self.detailModel];
    }
    sender.selected = !sender.selected;
}

- (void)createScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    scrollView.canPullDown = YES;
    WeakSelf(weakSelf)
    scrollView.headerRefreshBlock = ^(UIScrollView *rfScrollView) {
        [weakSelf requestData];
    };
    [scrollView startHeaderRefreshing];
}

- (void)createDetailView {
    
    UIScrollView *scrollView = self.scrollView;
    scrollView.contentSize = CGSizeMake(scrollView.width, scrollView.height);
    
    UIView *view = [scrollView viewWithTag:100];
    if (view) {
        [view removeFromSuperview];
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, 0)];
    bgView.tag = 100;
    [scrollView addSubview:bgView];
    
    CGFloat maxHeight = 0;
    CGFloat offset = 5;
    
    MovieDetailModel *model = self.detailModel;
    
    UIImageView *imgView;
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.width*0.6)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.coverImgUrl] placeholderImage:MovieListPlaceHolder];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        [bgView addSubview:imageView];
        imgView = imageView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCorver)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        
        maxHeight = CGRectGetMaxY(imgView.frame);
    }
    
    {
        NSString *content = model.title;
        UIFont *font = MHMediumFont(18);
        CGSize size = [content boundingRectWithSize:CGSizeMake(MainWidth - 2*offset, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
        
        UILabel *label = [[UILabel alloc] init];
        label.font = font;
        label.text = content;
        label.numberOfLines = 0;
        [bgView addSubview:label];
        [label sizeToFit];
        label.x = offset;
        label.y = maxHeight + offset;
        label.size = size;
        maxHeight = CGRectGetMaxY(label.frame);
    }
    
    {
        NSArray *infos = model.infoArray;
        
        for (int i = 0; i < infos.count; i++) {
            maxHeight += offset;
            
            NSDictionary *dict = infos[i];
            NSString *title = dict.allKeys.firstObject;
            NSArray *items = [dict objectForKey:title];
            
            UILabel *label = [[UILabel alloc] init];
            label.text = title;
            label.font = MHMediumFont(14);
            [bgView addSubview:label];
            [label sizeToFit];
            label.x = offset;
            label.y = maxHeight + offset;
            
            maxHeight = CGRectGetMaxY(label.frame);
            CGFloat currentMiddle = label.centerY;
            
            CGFloat xPosition = CGRectGetMaxX(label.frame) + offset;
            for (TitleLinkModel *item in items) {
                LinkLabel *button = [LinkLabel new];
                button.model = item;
                button.text = item.title;
                button.textColor = [UIColor whiteColor];
                button.textAlignment = NSTextAlignmentCenter;
                button.backgroundColor = [UIColor colorWithHexString:@"#1d65ee"];
                button.font = [UIFont systemFontOfSize:12];
                [bgView addSubview:button];
                [button sizeToFit];
                button.layer.cornerRadius = button.height/4;
                button.layer.masksToBounds = YES;
                button.width = button.width + 2*offset;
                button.height = button.height + 2*offset;
                if (xPosition + offset + button.width > scrollView.width - offset) {
                    xPosition = 0;
                    maxHeight = maxHeight + offset + button.height;
                    currentMiddle = maxHeight + offset - button.height/2;
                }
                button.x = xPosition + offset;
                button.centerY = currentMiddle;
                
                xPosition = CGRectGetMaxX(button.frame);
                if (item == items.lastObject) {
                    maxHeight = CGRectGetMaxY(button.frame);
                }
                
                WeakSelf(weakSelf)
                button.tapLabel = ^(LinkLabel *label) {
                    [weakSelf linkBtnClicked:label];
                };
                button.longPressLabel = ^(LinkLabel *label) {
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = label.text;
                    [PublicDialogManager showText:@"已复制" inView:weakSelf.view duration:1.5];
                };
                
            }
            
        }
    }
    
    maxHeight += offset;
    //截图
    {
        if (model.screenshots.count > 0) {
            
            UILabel *label = [[UILabel alloc] init];
            label.text = @"樣品圖像";
            label.font = MHMediumFont(14);
            [bgView addSubview:label];
            [label sizeToFit];
            label.x = offset;
            label.y = maxHeight + offset;
            maxHeight = CGRectGetMaxY(label.frame);
            
            CGFloat offset = 8;
            CGFloat itemSize = 150;
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.itemSize = CGSizeMake(itemSize, itemSize);
            layout.minimumLineSpacing = offset;
            layout.minimumInteritemSpacing = offset;
            layout.sectionInset = UIEdgeInsetsMake(offset, offset, offset, offset);
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
            UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, maxHeight + offset, scrollView.width, itemSize) collectionViewLayout:layout];
            collection.delegate = self;
            collection.dataSource = self;
            collection.backgroundColor = [UIColor clearColor];
            collection.showsHorizontalScrollIndicator = NO;
            [collection registerNib:[UINib nibWithNibName:NSStringFromClass([ScreenShotCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ScreenShotCell class])];
            
            [bgView addSubview:collection];
            self.screenshotView = collection;
            
            maxHeight = CGRectGetMaxY(collection.frame);
        }
    }
    
    maxHeight += offset;
    //推荐
    {
        if (model.recommends.count > 0) {
            
            UILabel *label = [[UILabel alloc] init];
            label.text = @"同類影片";
            label.font = MHMediumFont(14);
            [bgView addSubview:label];
            [label sizeToFit];
            label.x = offset;
            label.y = maxHeight + offset;
            maxHeight = CGRectGetMaxY(label.frame);
            
            CGFloat offset = 8;
            CGFloat itemSize = 147;
            CGFloat itemHeight = 200/147.0*itemSize + 45;
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.itemSize = CGSizeMake(itemSize, itemHeight);
            layout.minimumLineSpacing = offset;
            layout.minimumInteritemSpacing = offset;
            layout.sectionInset = UIEdgeInsetsMake(offset, offset, offset, offset);
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
            UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, maxHeight + offset, scrollView.width, itemHeight) collectionViewLayout:layout];
            collection.delegate = self;
            collection.dataSource = self;
            collection.backgroundColor = [UIColor clearColor];
            collection.showsHorizontalScrollIndicator = NO;
            [collection registerNib:[UINib nibWithNibName:NSStringFromClass([RecommendCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([RecommendCell class])];
            
            [bgView addSubview:collection];
            
            self.recommendView = collection;
            
            maxHeight = CGRectGetMaxY(collection.frame);
        }
    }
    
    maxHeight = maxHeight + offset;
    bgView.height = maxHeight;
    scrollView.contentSize = CGSizeMake(scrollView.width, bgView.height);
}

- (void)linkBtnClicked:(LinkLabel *)sender {
    TitleLinkModel *model = sender.model;
    
    if (model.type == LinkTypeActor) {
        ActressDetailController *vc = [ActressDetailController new];
        vc.showSortBar = YES;
        ActressModel *actor = [ActressModel new];
        actor.name = model.title;
        actor.link = model.link;
        vc.model = actor;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (model.type == LinkTypeCategory || model.type == LinkTypeNormal) {
        CategoryItemModel *itemModel = [CategoryItemModel new];
        itemModel.title = model.title;
        itemModel.link = model.link;
        CategoryItemListController *vc = [CategoryItemListController new];
        vc.model = itemModel;
        vc.showSortBar = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (model.type == LinkTypeNumber) {
        NSString *code = model.title;
        if (code.length == 0) {
            code = @"";
        }
        
        if ([DBMANAGER isMovieCacheExsit:self.model]) {
            NSString *name = [NSString stringWithFormat:@"%@.mp4", [Encrypt md5Encrypt32:self.model.number]];
            NSString *filePath = [[GlobalTool shareInstance].movieCacheDir stringByAppendingPathComponent:name];
            MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
            moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
            [self presentViewController:moviePlayerController animated:YES completion:nil];
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
                            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                            UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                            hud.customView = imageView;
                            hud.mode = MBProgressHUDModeCustomView;
                            [hud hideAnimated:YES afterDelay:2.f];
                            
                            NSString *path = [GlobalTool shareInstance].movieCacheDir;
                            NSString *md5Str = [Encrypt md5Encrypt32:self.model.number];
                            NSString *name = [NSString stringWithFormat:@"/%@.mp4", md5Str];
                            NSString *savePath = [path stringByAppendingPathComponent:name];
                            if ([[NSFileManager defaultManager] fileExistsAtPath:savePath]) {
                                [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
                            }
                            [[NSFileManager defaultManager] moveItemAtPath:filePath.path toPath:savePath error:&error];
                            MovieListModel *mvModel = self.model;
                            [DBMANAGER insertMovieCache:mvModel];
                            
                            if (error) {
                                NSLog(@"%@", error);
                            }else {
                                MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:savePath]];
                                moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
                                [self presentViewController:moviePlayerController animated:YES completion:nil];
                            }
                        }];
                    }else{
                        [PublicDialogManager showText:@"未查询到相关预览视频" inView:self.view duration:1.0];
                    }
                }else {
                    [PublicDialogManager showText:@"未查询到相关预览视频" inView:self.view duration:1.0];
                }
                
            } FailCallback:^(NSError *error) {
                [PublicDialogManager hideWaittingInView:self.view];
                [PublicDialogManager showText:@"服务出错" inView:self.view duration:1.0];
            }];
        }
        
    }
    
}

- (void)tapCorver {
    NSArray *photos = [IDMPhoto photosWithURLs:@[[NSURL URLWithString:self.detailModel.coverImgUrl]]];
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    [self presentViewController:browser animated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.screenshotView) {
        return self.detailModel.screenshots.count;
    }else{
        return self.detailModel.recommends.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.screenshotView) {
        ScreenShotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ScreenShotCell class]) forIndexPath:indexPath];
        ScreenShotModel *model = self.detailModel.screenshots[indexPath.item];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.smallPicUrl] placeholderImage:MovieListPlaceHolder];
        return cell;
    }else {
        RecommendCell *cell = (RecommendCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RecommendCell class]) forIndexPath:indexPath];
        RecommendModel *model = self.detailModel.recommends[indexPath.item];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:MovieListPlaceHolder];
        cell.titleLabel.text = model.title;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.screenshotView) {
        NSMutableArray *photos = [NSMutableArray new];
        
        for (ScreenShotModel *item in self.detailModel.screenshots) {
            IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:item.bigPicUrl]];
            [photos addObject:photo];
        }
        
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
        [browser setInitialPageIndex:indexPath.item];
        [self presentViewController:browser animated:YES completion:nil];
        
    }else {
        MovieListModel *listModel = [MovieListModel new];
        RecommendModel *model = self.detailModel.recommends[indexPath.item];
        listModel.title = model.title;
        listModel.number = [model.link lastPathComponent];
        listModel.link  = model.link;
        listModel.imgUrl = model.imgUrl;
        
        NSArray *infos = self.detailModel.infoArray;
        for (int i = 0; i < infos.count; i++) {
            NSDictionary *dict = infos[i];
            NSString *title = dict.allKeys.firstObject;
            if ([title isEqualToString:@"發行日期:"]) {
                NSArray *items = [dict objectForKey:title];
                TitleLinkModel *item = items.firstObject;
                listModel.dateString = item.title;
                break;
            }
        }
        
        MovieDetailController *vc = [MovieDetailController new];
        vc.model = listModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
