//
//  ActressDetailController.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/16.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "ActressDetailController.h"
#import "LJJWaterFlowLayout.h"
#import "MovieListModel.h"
#import "ActressDetailCell.h"
#import "PageCollectionReusableView.h"

@interface ActressDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *dataArray ;
@property (nonatomic, strong) UICollectionView *collectionView ;
@property (nonatomic, assign) NSInteger page ;

@end

@implementation ActressDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    [self requestData:YES];
    [self createCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)refresh {
    
    if (refresh) {
        self.page = 1;;
    }else{
        self.page ++;
    }
    
    [HTMLTOJSONMANAGER parseActressDetailUrl:self.model.link page:self.page callback:^(NSArray *array) {
        [self.collectionView stopHeaderRefreshing];
        [self.collectionView stopFooterRefreshing];
        NSMutableArray *arr ;
        if (refresh) {
            arr = [NSMutableArray array];
        }else{
            arr = [NSMutableArray arrayWithArray:self.dataArray];
        }
        [arr addObjectsFromArray:array];
        self.dataArray = [arr copy];
        [self.collectionView reloadData];
    }];
    
}

- (void)createCollectionView {
    
    LJJWaterFlowLayout *layout = [[LJJWaterFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake(50, 50);
//    layout.minimumLineSpacing = 10;
//    layout.minimumInteritemSpacing = 10;
//    layout.delegate = self;
//    layout.sectionInset = <#UIEdgeInsets#>;
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor whiteColor];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([ActressDetailCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ActressDetailCell class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([PageCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PageCollectionReusableView class])];
    
    [self.view addSubview:collection];
    self.collectionView = collection;
    
    layout.headerReferenceSize = CGSizeMake(MainWidth, 30);
    
    collection.canPullUp = YES;
    collection.headerRefreshBlock = ^(UIScrollView *rfScrollView) {
        [self requestData:YES];
    };
    collection.canPullDown = YES;
    collection.footerRefreshBlock = ^(UIScrollView *rfScrollView) {
        [self requestData:NO];
    };
    
    [collection startHeaderRefreshing];
    
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
    
    cell.model = self.dataArray[indexPath.item];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieListModel *model = self.dataArray[indexPath.row];
    
    return CGSizeMake(147, 200 + 200/4 + rand()%50);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        PageCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PageCollectionReusableView class]) forIndexPath:indexPath];
        
        
        reusableview = headerView;
    }
    return reusableview;
}

@end
