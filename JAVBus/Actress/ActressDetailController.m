//
//  ActressDetailController.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/16.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "ActressDetailController.h"

@interface ActressDetailController ()
@end

@implementation ActressDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.name;
    [self createBarbutton];
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

- (void)createBarbutton {
    
    BOOL isExsit = [DBMANAGER isActressExsit:self.model];
    
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
        [DBMANAGER deleteActress:self.model];
    }else{
        [DBMANAGER insertActress:self.model];
    }
    sender.selected = !sender.selected;
}

@end
