//
//  MovieDetailController.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/27.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "MovieDetailController.h"

@interface MovieDetailController ()

@property (nonatomic, strong) UIScrollView *scrollView ;

@end

@implementation MovieDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.model.number;
    [self initViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
    
    [HTMLTOJSONMANAGER parseMovieDetailByNumber:self.model.number callback:^(NSArray *array) {
        
    }];
    
}

- (void)initViews {
    [self createScrollView];
}

- (void)createScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    scrollView.canPullDown = YES;
    WeakSelf(weakSelf)
    scrollView.headerRefreshBlock = ^(UIScrollView *rfScrollView) {
        [weakSelf requestData];
    };
    [scrollView startHeaderRefreshing];
}

@end
