//
//  ForumHomeController.m
//  JAVBus
//
//  Created by mgfjx on 2019/1/1.
//  Copyright © 2019 mgfjx. All rights reserved.
//

#import "ForumHomeController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface ForumHomeController ()

@end

@implementation ForumHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self createCycleScrollView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor randomColor];
    
    [self.view addSubview:button];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
    
    [HTMLTOJSONMANAGER parseForumHomeDataCallback:^(NSArray *array) {
        
    }];
    
    
    
}

- (void)createCycleScrollView {
    
    NSArray *urls = @[
                      @"https://www.javbus.pw/forum/data/attachment/block/2b/2b53893e8a11488153ee53b2c2c05844.jpg",
                      @"https://www.javbus.pw/forum/data/attachment/block/50/50c90e0dc4aca811e3e4c7a0b3eb3643.jpg",
                      @"https://www.javbus.pw/forum/data/attachment/block/01/0121821ac5eab37c551e617394bb24a3.jpg",
                      @"https://www.javbus.pw/forum/data/attachment/block/db/db466834392ca04eb9d5a477c856cd4a.jpg",
                      @"https://www.javbus.pw/forum/data/attachment/block/e7/e7f481ec623ed808e6fc5e9bac552a99.jpg",
                      ];
    
    // 网络加载图片的轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, kNavigationBarHeight, MainWidth, 250) delegate:self placeholderImage:[UIImage imageNamed:@""]];
    cycleScrollView.imageURLStringsGroup = urls;
    
    [self.view addSubview:cycleScrollView];
}

@end
