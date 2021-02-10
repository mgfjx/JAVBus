//
//  SeriesItemListController.m
//  JAVBus
//
//  Created by mgfjx on 2021/2/10.
//  Copyright © 2021 mgfjx. All rights reserved.
//

#import "BaseItemListController.h"

@interface BaseItemListController ()

@end

@implementation BaseItemListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.model.title ;
    
    [self createBarbutton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createBarbutton {
    
//    BOOL isExsit = [DBMANAGER isMovieExsit:self.model];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(collectionSeries:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"collection_unselected"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"collection_selected"] forState:UIControlStateSelected];
//    button.selected = isExsit;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)requestData:(BOOL)refresh {
    if (refresh) {
        self.page = 1;;
    }else{
        self.page ++;
    }
    
    [HTMLTOJSONMANAGER parseCategoryListUrl:self.model.link page:self.page callback:^(NSArray *array) {
        [self.collectionView stopHeaderRefreshing];
        [self.collectionView stopFooterRefreshing];
        
        if (array.count == 0) {
            return ;
        }
        
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

- (void)collectionSeries:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
