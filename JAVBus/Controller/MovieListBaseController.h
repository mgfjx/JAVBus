//
//  MovieListController.h
//  JAVBus
//
//  Created by mgfjx on 2018/12/26.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "BaseViewController.h"

@interface MovieListBaseController : BaseViewController

@property (nonatomic, strong) NSArray *dataArray ;
@property (nonatomic, strong) UICollectionView *collectionView ;
@property (nonatomic, assign) NSInteger page ;

@property (nonatomic, assign) UIBarButtonItem *sortItem ;

@property (nonatomic, assign) BOOL showSortBar ;
@property (nonatomic, assign) BOOL shouldNotOffset ;

//子类实现获取数据方法
- (void)requestData:(BOOL)refresh ;

@end
