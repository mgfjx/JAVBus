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
#import "CollectionViewController.h"
#import "SettingViewController.h"

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
    
    UIViewController *nav1 = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
    UIViewController *nav2 = [[UINavigationController alloc] initWithRootViewController:[[SearchViewController alloc] init]];
    UIViewController *nav3 = [[UINavigationController alloc] initWithRootViewController:[[CollectionViewController alloc] init]];
    UIViewController *nav4 = [[UINavigationController alloc] initWithRootViewController:[[SettingViewController alloc] init]];
    
    
    CYLTabBarController *tabBarController = self;
    
    {
        NSDictionary *dict1 = @{
//                                CYLTabBarItemTitle : @"首頁",
                                CYLTabBarItemImage : @"tabbar_home",
                                CYLTabBarItemSelectedImage : @"tabbar_home_selected",
                                };
        NSDictionary *dict2 = @{
//                                CYLTabBarItemTitle : @"搜索",
                                CYLTabBarItemImage : @"tabbar_search",
                                CYLTabBarItemSelectedImage : @"tabbar_search_selected",
                                };
        NSDictionary *dict3 = @{
//                                CYLTabBarItemTitle : @"收藏",
                                CYLTabBarItemImage : @"tabbar_collection_unselected",
                                CYLTabBarItemSelectedImage : @"tabbar_collection_selected",
                                };
        
        NSDictionary *dict4 = @{
//                                CYLTabBarItemTitle : @"设置",
                                CYLTabBarItemImage : @"tabbar_setting_unselected",
                                CYLTabBarItemSelectedImage : @"tabbar_setting_selected",
                                };
        
        NSArray *tabBarItemsAttributes = @[ dict1, dict2, dict3, dict4];
        tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
    }
    
    [tabBarController setViewControllers:@[nav1, nav2, nav3, nav4]];
    
    tabBarController.selectedIndex = 3;
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
