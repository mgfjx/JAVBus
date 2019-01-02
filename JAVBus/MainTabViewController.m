//
//  MainViewController.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/13.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "MainTabViewController.h"
#import "ActressCodeController.h"
#import "AddressSettingController.h"
#import "MovieMainController.h"
#import "MainViewController.h"
#import "SearchViewController.h"
#import "ForumHomeController.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self createBarButton];
//    [self createCategoryView];
    [self configuration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configuration {
    
    UIViewController *nav1 = [[UINavigationController alloc] initWithRootViewController:[[SearchViewController alloc] init]];
    UIViewController *nav2 = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
    UIViewController *nav3 = [[UINavigationController alloc] initWithRootViewController:[[ForumHomeController alloc] init]];
    
    
    CYLTabBarController *tabBarController = self;
    
    {
        NSDictionary *dict1 = @{
                                CYLTabBarItemTitle : @"搜索",
                                CYLTabBarItemImage : @"tabbar_scheduleUnSelected",
                                CYLTabBarItemSelectedImage : @"tabbar_scheduleSelected",
                                };
        NSDictionary *dict2 = @{
                                CYLTabBarItemTitle : @"首頁",
                                CYLTabBarItemImage : @"tabbar_messageUnSelected",
                                CYLTabBarItemSelectedImage : @"tabbar_messageSelected",
                                };
        NSDictionary *dict3 = @{
                                CYLTabBarItemTitle : @"論壇",
                                CYLTabBarItemImage : @"tabbar_workUnSelected",
                                CYLTabBarItemSelectedImage : @"tabbar_workSelected",
                                };
        
        NSArray *tabBarItemsAttributes = @[ dict1, dict2, dict3];
        tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
    }
    
    [tabBarController setViewControllers:@[nav1, nav2, nav3]];
    
    tabBarController.selectedIndex = 2;
    [tabBarController setTintColor:[UIColor colorWithHexString:@"#0099de"]];
    
}

- (void)createBarButton {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(settingClicked)];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)settingClicked {
    AddressSettingController *vc = [AddressSettingController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
