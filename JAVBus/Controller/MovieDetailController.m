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
#import "MagneticModel.h"
#import "RecommendCell.h"
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>
#import "CategoryItemListController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <AVKit/AVKit.h>
#import "VideoPlayerManager.h"
#import "MagneticListView.h"
#import <SafariServices/SafariServices.h>

#define kMainTextColor @"#333333"

@interface MovieDetailController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView ;
@property (nonatomic, strong) MovieDetailModel *detailModel ;

@property (nonatomic, strong) NSArray *magneticList ;

@property (nonatomic, strong) UICollectionView *screenshotView ;
@property (nonatomic, strong) UICollectionView *recommendView ;
@property (nonatomic, strong) AVPlayerViewController *playerVC ;

@property (nonatomic, strong) MagneticListView *magneticView;
@property (nonatomic, strong) UIView *recommendContainer;

@property (nonatomic, strong) UIButton *refreshCollectionBtn;

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
    
    BOOL isListCollected = [DBMANAGER isMovieExsit:self.model];
    BOOL isDetailCollected = [DBMANAGER isMovieDetailExsit:self.model];
    
    if (isListCollected) {
        self.refreshCollectionBtn.hidden = NO;
    }
    
    if (isDetailCollected) {
        [self.scrollView stopHeaderRefreshing];
        MovieDetailModel *model = [DBMANAGER queryMovieDetail:self.model];
        self.detailModel = model;
        [self createDetailView];
        self.magneticView.magneticArray = model.magneticArray;
    }else{
        [HTMLTOJSONMANAGER parseMovieDetailByUrl:self.model.link detailCallback:^(MovieDetailModel *model) {
            [self.scrollView stopHeaderRefreshing];
            model.title = self.model.title;
            model.number = self.model.number;
            self.detailModel = model;
            [self createDetailView];
            if (isListCollected && !isDetailCollected) {
                [DBMANAGER insertMovieDetail:self.detailModel];
            }
        } magneticCallback:^(NSArray *magneticList) {
            self.magneticList = magneticList;
            self.detailModel.magneticArray = magneticList;
            self.magneticView.magneticArray = magneticList;
            if (isListCollected && !isDetailCollected) {
                [DBMANAGER updateMovieDetail:self.detailModel];
            }
        }];
    }
    
}

- (void)initViews {
    [self createBarbutton];
    [self createScrollView];
    [self createRefreshButton];
}

- (void)createRefreshButton {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(refreshCollection) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"movie_refresh"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.hidden = YES;
    self.refreshCollectionBtn = button;
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(-20);
        make.height.width.mas_equalTo(30);
    }];
    
}

- (void)refreshCollection {
    [self.scrollView startHeaderRefreshing];
    [HTMLTOJSONMANAGER parseMovieDetailByUrl:self.model.link detailCallback:^(MovieDetailModel *model) {
        [self.scrollView stopHeaderRefreshing];
        model.title = self.model.title;
        model.number = self.model.number;
        self.detailModel = model;
        [self createDetailView];
        [DBMANAGER updateMovieDetail:self.detailModel];
    } magneticCallback:^(NSArray *magneticList) {
        self.magneticList = magneticList;
        self.detailModel.magneticArray = magneticList;
        self.magneticView.magneticArray = magneticList;
        [DBMANAGER updateMovieDetail:self.detailModel];
    }];
    
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
        [DBMANAGER deleteMovieDetail:self.detailModel];
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
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kTabBarHeight);
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
        label.textColor = [UIColor colorWithHexString:kMainTextColor];
        label.numberOfLines = 0;
        [bgView addSubview:label];
        [label sizeToFit];
        label.x = offset;
        label.y = maxHeight + offset;
        label.size = size;
        maxHeight = CGRectGetMaxY(label.frame);
    }
    
    //简介
    {
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, maxHeight, bgView.width, 0)];
        [bgView addSubview:container];
        
        NSArray *infos = model.infoArray;
        
        CGFloat heightRecord = 0;
        for (int i = 0; i < infos.count; i++) {
            heightRecord += offset;
            
            NSDictionary *dict = infos[i];
            NSString *title = dict.allKeys.firstObject;
            NSArray *items = [dict objectForKey:title];
            
            UILabel *label = [[UILabel alloc] init];
            label.text = title;
            label.textColor = [UIColor colorWithHexString:kMainTextColor];
            label.font = MHMediumFont(14);
            [container addSubview:label];
            [label sizeToFit];
            label.x = offset;
            label.y = heightRecord + offset;
            
            heightRecord = CGRectGetMaxY(label.frame);
            CGFloat currentMiddle = label.centerY;
            
            CGFloat xPosition = CGRectGetMaxX(label.frame) + offset;
            for (TitleLinkModel *item in items) {
                LinkLabel *button = [LinkLabel new];
                button.model = item;
                button.text = item.title;
                button.textColor = [UIColor whiteColor];
                button.textAlignment = NSTextAlignmentCenter;
                button.backgroundColor = [UIColor colorWithHexString:@"#febe00"];
                button.font = [UIFont systemFontOfSize:12];
                [container addSubview:button];
                [button sizeToFit];
                button.layer.cornerRadius = button.height/4;
                button.layer.masksToBounds = YES;
                button.width = button.width + 2*offset;
                button.height = button.height + 2*offset;
                if (xPosition + offset + button.width > scrollView.width - offset) {
                    xPosition = 0;
                    heightRecord = heightRecord + offset + button.height;
                    currentMiddle = heightRecord + offset - button.height/2;
                }
                button.x = xPosition + offset;
                button.centerY = currentMiddle;
                
                xPosition = CGRectGetMaxX(button.frame);
                if (item == items.lastObject) {
                    heightRecord = CGRectGetMaxY(button.frame);
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
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, heightRecord+10, bgView.width, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [container addSubview:line];
        heightRecord = CGRectGetMaxY(line.frame);
        
        container.height = heightRecord;
        
        maxHeight = CGRectGetMaxY(container.frame);
    }
    
    maxHeight += offset;
    //截图
    {
        if (model.screenshots.count > 0) {
            
            UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, maxHeight, bgView.width, 0)];
            [bgView addSubview:container];
            
            CGFloat heightRecord = 0;
            
            UILabel *label = [[UILabel alloc] init];
            label.text = @"樣品圖像";
            label.font = MHMediumFont(14);
            label.textColor = [UIColor colorWithHexString:kMainTextColor];
            [container addSubview:label];
            [label sizeToFit];
            label.x = offset;
            label.y = heightRecord + offset;
            heightRecord = CGRectGetMaxY(label.frame);
            
            CGFloat offset = 8;
            CGFloat itemSize = 90;
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.itemSize = CGSizeMake(itemSize*4.0/3, itemSize);
            layout.minimumLineSpacing = offset;
            layout.minimumInteritemSpacing = offset;
            layout.sectionInset = UIEdgeInsetsMake(offset, offset, offset, offset);
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
            UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, heightRecord + offset, scrollView.width, itemSize) collectionViewLayout:layout];
            collection.delegate = self;
            collection.dataSource = self;
            collection.backgroundColor = [UIColor clearColor];
            collection.showsHorizontalScrollIndicator = NO;
            [collection registerNib:[UINib nibWithNibName:NSStringFromClass([ScreenShotCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ScreenShotCell class])];
            
            [container addSubview:collection];
            self.screenshotView = collection;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(collection.frame) + offset, bgView.width, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
            [container addSubview:line];
            
            heightRecord = CGRectGetMaxY(line.frame);
            container.height = heightRecord;
            
            maxHeight = CGRectGetMaxY(container.frame);
        }
    }
    
    //磁力链接
    {
        
        CGFloat itemHeight = 40;
        MagneticListView *container = [[MagneticListView alloc] initWithFrame:CGRectMake(20, maxHeight+10, bgView.width - 2*20, itemHeight)];
        container.clipsToBounds = YES;
        container.layer.cornerRadius = 8;
        container.layer.borderColor = [UIColor colorWithHexString:@"#f2f2f7"].CGColor;
        container.layer.borderWidth = 1.0f;
        [bgView addSubview:container];
        self.magneticView = container;
        
        WeakSelf(weakSelf)
        container.frameChangeCallback = ^(CGRect frame) {
            [UIView animateWithDuration:0.15 animations:^{
                weakSelf.magneticView.frame = frame;
                weakSelf.recommendContainer.y = CGRectGetMaxY(frame);
                weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.scrollView.width, CGRectGetMaxY(weakSelf.recommendContainer.frame));
                bgView.height = CGRectGetMaxY(weakSelf.recommendContainer.frame);
            } completion:^(BOOL finished) {
                
            }];
        };
        
        maxHeight = CGRectGetMaxY(container.frame);
    }
    
    maxHeight += offset;
    //推荐
    {
        if (model.recommends.count > 0) {
            
            UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, maxHeight, bgView.width, 0)];
            [bgView addSubview:container];
            self.recommendContainer = container;
            
            CGFloat heightRecord = 0;
            
            UILabel *label = [[UILabel alloc] init];
            label.text = @"同類影片";
            label.textColor = [UIColor colorWithHexString:kMainTextColor];
            label.font = MHMediumFont(14);
            [container addSubview:label];
            [label sizeToFit];
            label.x = offset;
            label.y = heightRecord + offset;
            heightRecord = CGRectGetMaxY(label.frame);
            
            CGFloat offset = 8;
            CGFloat itemSize = 147;
            CGFloat itemHeight = 200/147.0*itemSize + 45;
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.itemSize = CGSizeMake(itemSize, itemHeight);
            layout.minimumLineSpacing = offset;
            layout.minimumInteritemSpacing = offset;
            layout.sectionInset = UIEdgeInsetsMake(offset, offset, offset, offset);
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
            UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, heightRecord + offset, scrollView.width, itemHeight) collectionViewLayout:layout];
            collection.delegate = self;
            collection.dataSource = self;
            collection.backgroundColor = [UIColor clearColor];
            collection.showsHorizontalScrollIndicator = NO;
            [collection registerNib:[UINib nibWithNibName:NSStringFromClass([RecommendCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([RecommendCell class])];
            
            [container addSubview:collection];
            
            self.recommendView = collection;
            
            heightRecord = CGRectGetMaxY(collection.frame);
            
            container.height = heightRecord;
            maxHeight = CGRectGetMaxY(container.frame);
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
        
        NSString *name = [NSString stringWithFormat:@"%@.mp4", [Encrypt md5Encrypt32:self.model.number]];
        NSString *filePath = [[GlobalTool shareInstance].movieCacheDir stringByAppendingPathComponent:name];
        BOOL isFileExsit = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        
        if ([DBMANAGER isMovieCacheExsit:self.model] && isFileExsit) {
            [self playWithUrl:filePath];
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
                                [self playWithUrl:savePath];
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
    
}

- (void)playWithUrl:(NSString *)url {
    [[VideoPlayerManager shareManager] showPlayerWithUrl:url];
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
        cell.titleLabel.textColor = [UIColor colorWithHexString:kMainTextColor];
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
        
        if ([listModel.number containsString:@"forum.php?"]) {
            NSString *urlString = [NSString stringWithFormat:@"%@/forum/%@", [GlobalTool shareInstance].baseUrl, listModel.number];
            NSURL *url = [NSURL URLWithString:urlString];
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
            [self presentViewController:safariVC animated:YES completion:nil];
        }else {
            MovieDetailController *vc = [MovieDetailController new];
            vc.model = listModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
