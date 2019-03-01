//
//  MovieCategoryController.h
//  JAVBus
//
//  Created by mgfjx on 2018/12/27.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "BaseViewController.h"

@interface MovieCategoryController : BaseViewController

@property (nonatomic, strong) UIScrollView *scrollView ;
@property (nonatomic, strong) NSArray *dataArray ;

- (void)requestData ;
- (void)createViews ;

@end
