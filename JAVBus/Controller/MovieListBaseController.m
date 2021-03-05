//
//  MovieListBaseController.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/26.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "MovieListBaseController.h"
#import "MovieListModel.h"
#import "MovieDetailController.h"

#define TitleFont [UIFont systemFontOfSize:14]

@interface MovieListBaseController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation MovieListBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    [self requestData:YES];
    [self createCollectionView];
    if (self.showSortBar) {
        [self createBarButton];
    }
    [self.collectionView startHeaderRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)refresh {
    NSString *logo = [NSString stringWithFormat:@"子类必须为实现%@方法", NSStringFromSelector(_cmd)];
    NSAssert(0, logo);
}

- (void)createBarButton {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button addTarget:self action:@selector(changeSort) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    self.sortItem = item;
    
}

//改变列数
- (void)changeSort {
    NSInteger num = [GlobalTool shareInstance].columnNum;
    num = num%3 + 1;
    [GlobalTool shareInstance].columnNum = num;
    LJJWaterFlowLayout *layout = (LJJWaterFlowLayout *)self.collectionView.collectionViewLayout;
    layout.columnNum = [GlobalTool shareInstance].columnNum;
    [self.collectionView reloadData];
}

- (void)createCollectionView {
    
    LJJWaterFlowLayout *layout = [[LJJWaterFlowLayout alloc] init];
    layout.columnNum = [GlobalTool shareInstance].columnNum;
//    layout.sectionInset = <#UIEdgeInsets#>;
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor dynamicProviderWithDarkStr:@"#000000" lightStr:@"#ffffff"];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([ActressDetailCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ActressDetailCell class])];
    
    [self.view addSubview:collection];
    self.collectionView = collection;
    
    CGFloat topOffset = self.shouldNotOffset ? 0 : 0;
    
    [collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topOffset);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
//    layout.headerReferenceSize = CGSizeMake(MainWidth, 30);
    
    collection.canPullUp = YES;
    WeakSelf(weakSelf)
    collection.headerRefreshBlock = ^(UIScrollView *rfScrollView) {
        [weakSelf requestData:YES];
    };
    collection.canPullDown = YES;
    collection.footerRefreshBlock = ^(UIScrollView *rfScrollView) {
        [weakSelf requestData:NO];
    };
    
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ActressDetailCell *cell = (ActressDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ActressDetailCell class]) forIndexPath:indexPath];
    MovieListModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    LJJWaterFlowLayout *layout = (LJJWaterFlowLayout *)collectionView.collectionViewLayout;
    CGFloat itemWidth = layout.itemWidth;
    
    NSString *name = model.title;
    CGFloat height = [name boundingRectWithSize:CGSizeMake(itemWidth - 2*5, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TitleFont} context:nil].size.height;
    height = ceilf(height);
    cell.itemHeight = height;
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(LJJWaterFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieListModel *model = self.dataArray[indexPath.row];
    CGFloat itemWidth = collectionViewLayout.itemWidth;
    
    NSString *name = model.title;
    CGFloat height = [name boundingRectWithSize:CGSizeMake(itemWidth - 2*5, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TitleFont} context:nil].size.height;
    
    height = ceilf(height) + 2*5;
    CGFloat imgHeight = ceilf(200.0/147*itemWidth);
    CGFloat numAndDateHeight = 51;
    CGFloat itemHeight = imgHeight + height + numAndDateHeight;
    
    return CGSizeMake(itemWidth, itemHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieListModel *model = self.dataArray[indexPath.row];
    MovieDetailController *vc = [MovieDetailController new];
    vc.model = model;
//    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
