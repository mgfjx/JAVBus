//
//  ActressCodeController.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/13.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "ActressCodeController.h"

@interface ActressCodeController ()

@end

@implementation ActressCodeController

- (void)requestData:(BOOL)refresh {
    
    if (refresh) {
        self.page = 1;
    }else{
        self.page ++;
    }
    
    [HTMLTOJSONMANAGER parseActressDataByPage:self.page callback:^(NSArray *array) {
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
