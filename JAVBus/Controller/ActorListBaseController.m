//
//  ActorListBaseController.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/27.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "ActorListBaseController.h"
#import "HtmlToJsonManager.h"
#import "ActressCell.h"
#import "ActressModel.h"
#import "RxWebViewController.h"
#import "ActressDetailController.h"

@interface ActorListBaseController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation ActorListBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self initCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCollectionView {
    
    CGFloat width = MainWidth;
    
    CGFloat offset = 4;
    CGFloat itemWidth = floorf((width - 5*offset)/3);
    CGFloat itemHeight = itemWidth + itemWidth*1/3;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = offset;
    layout.minimumInteritemSpacing = offset;
    layout.sectionInset = UIEdgeInsetsMake(offset, offset, offset, offset);
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor whiteColor];
    //    [collection registerClass:[ActressCell class] forCellWithReuseIdentifier:NSStringFromClass([ActressCell class])];
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([ActressCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ActressCell class])];
    
    [self.view addSubview:collection];
    self.collectionView = collection;
    
    [collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    collection.canPullDown = YES;
    collection.canPullUp = YES;
    WeakSelf(weakSelf)
    collection.headerRefreshBlock = ^(UIScrollView *rfScrollView) {
        [weakSelf requestData:YES];
    };
    collection.footerRefreshBlock = ^(UIScrollView *rfScrollView) {
        [weakSelf requestData:NO];
    };
    
    [collection startHeaderRefreshing];
    
}

- (void)requestData:(BOOL)refresh {
    NSString *logo = [NSString stringWithFormat:@"子类必须为实现%@方法", NSStringFromSelector(_cmd)];
    NSAssert(0, logo);
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.actressArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ActressCell *cell = (ActressCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ActressCell class]) forIndexPath:indexPath];
    
    ActressModel *model = self.actressArray[indexPath.item];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"actressHolder"]];
    cell.titleLabel.text = model.name;
    
    WeakSelf(weakSelf);
    cell.longPressCallback = ^{
        [weakSelf unCollectionActor:model];
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ActressModel *model = self.actressArray[indexPath.item];
    
    ActressDetailController *vc = [[ActressDetailController alloc] init];
    vc.model = model;
//    vc.hidesBottomBarWhenPushed = YES;
    vc.showSortBar = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 取消收藏
- (void)unCollectionActor:(ActressModel *)model {
    NSLog(@"%@", model.name);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"操作" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"取消收藏" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [DBMANAGER deleteActress:model];
        NSMutableArray *array = [self.actressArray mutableCopy];
        [array removeObject:model];
        self.actressArray = [array copy];
        [self.collectionView reloadData];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:confirm];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
