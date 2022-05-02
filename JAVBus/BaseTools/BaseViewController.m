//
//  BaseViewController.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/13.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)){
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [ThemeManager manager].pageBgColor;
    // 自动滚动调整，默认为YES
   self.automaticallyAdjustsScrollViewInsets = YES;
    // Bar的模糊效果，默认为YES
    self.navigationController.navigationBar.translucent = NO;
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
        //添加背景色
        appperance.backgroundColor = [ThemeManager manager].navColor;
        appperance.shadowImage = [[UIImage alloc]init];
        appperance.shadowColor = nil;
        self.navigationController.navigationBar.standardAppearance = appperance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
    } else {
        self.navigationController.navigationBar.barTintColor = [ThemeManager manager].navColor;
    }
    
//    self.view.height = self.view.height - kTabBarHeight;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"[%@ dealloc]", NSStringFromClass([self class]));
}

@end
