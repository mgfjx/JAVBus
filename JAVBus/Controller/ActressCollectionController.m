//
//  ActressCollectionController.m
//  JAVBus
//
//  Created by mgfjx on 2019/1/3.
//  Copyright © 2019 mgfjx. All rights reserved.
//

#import "ActressCollectionController.h"

@interface ActressCollectionController ()

@property (nonatomic, assign) NSInteger pageSize ;

@end

@implementation ActressCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageSize = 0;
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
    NSArray *array = [DBMANAGER queryActressList:self.pageSize];
    if (refresh) {
        self.actressArray = [array copy];
    }else{
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.actressArray];
        [arr addObjectsFromArray:array];
        self.actressArray = [arr copy];
    }
    [self.collectionView stopHeaderRefreshing];
    [self.collectionView stopFooterRefreshing];
    [self.collectionView reloadData];
}

@end
