//
//  CensoredCategoryController.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/27.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "CensoredCategoryController.h"

@interface CensoredCategoryController ()

@end

@implementation CensoredCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
    
    [HTMLTOJSONMANAGER parseCensoredCategoryListCallback:^(NSArray *array) {
        [self.tableView stopHeaderRefreshing];
        
        if (array.count == 0) {
            return ;
        }
        self.dataArray = [array copy];
        [self.tableView reloadData];
    }];
    
}

@end
