//
//  MovieCollectionController.m
//  JAVBus
//
//  Created by mgfjx on 2019/1/3.
//  Copyright © 2019 mgfjx. All rights reserved.
//

#import "MovieCollectionController.h"

@interface MovieCollectionController ()

@property (nonatomic, assign) NSInteger pageSize ;

@end

@implementation MovieCollectionController

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
    NSArray *array = [DBMANAGER queryMovieList:self.pageSize];
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

@end
