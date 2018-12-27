//
//  ActressUncensoredListController.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/27.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "ActressUncensoredListController.h"

@interface ActressUncensoredListController ()

@end

@implementation ActressUncensoredListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)refresh {
    
    if (refresh) {
        self.page = 1;
    }else{
        self.page ++;
    }
    
    [HTMLTOJSONMANAGER parseActressUncensoredListByPage:self.page callback:^(NSArray *array) {
        if (refresh) {
            self.actressArray = array;
        }else{
            NSMutableArray *arr1 = [NSMutableArray arrayWithArray:self.actressArray];
            [arr1 addObjectsFromArray:array];
            self.actressArray = [arr1 copy];
        }
        [self.collectionView stopHeaderRefreshing];
        [self.collectionView stopFooterRefreshing];
        [self.collectionView reloadData];
    }];
    
}

@end
