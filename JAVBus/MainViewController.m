//
//  MainViewController.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/13.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "MainViewController.h"
#import "ActressCodeController.h"
#import "AddressSettingController.h"
#import "MovieMainController.h"
#import <JXCategoryView/JXCategoryView.h>

#define CategoryHeight 40

@interface MainViewController ()<JXCategoryViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView ;
@property (nonatomic, strong) JXCategoryTitleView *categoryView ;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews {
    [self createScrollView];
    [self createBarButton];
    [self createCategoryView];
}

- (void)createScrollView {
    CGRect frame = self.view.bounds ;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - kNavigationBarHeight - kTabBarHeight)];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)createBarButton {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(settingClicked)];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)createCategoryView {
    
    JXCategoryTitleView *titleCategoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, CategoryHeight)];
    titleCategoryView.backgroundColor = [UIColor dynamicProviderWithDarkStr:@"#171717" lightStr:@"#ffffff"];
    titleCategoryView.titleSelectedColor = [UIColor dynamicProviderWithDarkStr:@"#ffffff" lightStr:@"#0b7be1"];
    titleCategoryView.titleColor = [UIColor dynamicProviderWithDarkStr:@"#b8b8b8" lightStr:@"#0b7be1"];
    titleCategoryView.titleFont = [UIFont systemFontOfSize:16];
    titleCategoryView.delegate = self;
    
//    self.categoryView = titleCategoryView;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, titleCategoryView.height - 1, titleCategoryView.width, 1)];
    line.backgroundColor = [UIColor dynamicProviderWithDarkStr:@"#000000" lightStr:@"#e8e8e8"];
    [titleCategoryView addSubview:line];
    
    NSArray *titles = @[@"有碼", @"無碼", @"歐美", @"有碼類別", @"無碼類別", @"有碼女優", @"無碼女優"];
    
    //------指示器属性配置------//
    //固定宽度
    titleCategoryView.titleColorGradientEnabled = YES;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
//    lineView.indicatorLineWidth = MainWidth/titles.count;
    lineView.indicatorLineViewColor = [UIColor dynamicProviderWithDarkStr:@"#ffffff" lightStr:@"#0b7be1"];
    titleCategoryView.indicators = @[lineView];
    
    titleCategoryView.titles = titles;
    [self.view addSubview:titleCategoryView];
    self.categoryView = titleCategoryView;
    
    titleCategoryView.contentScrollView = self.scrollView;
    self.scrollView.contentSize = CGSizeMake(titles.count * self.scrollView.width, self.scrollView.height);
    
    //子控制器
    NSArray *controllers = @[@"MovieMainController", @"MovieUncensoredController", @"MovieXvideoController", @"CensoredCategoryController", @"UnCensoredCategoryController", @"ActressCodeController", @"ActressUncensoredListController"];
    for (int i = 0; i < controllers.count; i++) {
        NSString *vcName = controllers[i];
        UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
        if (i == 0 || i == 1 || i == 2) {
            MovieListBaseController *baseVC = (MovieListBaseController *)vc;
            baseVC.shouldNotOffset = YES;
        }
        [self addChildViewController:vc];
        if (i == 0) {
            vc.view.frame = CGRectMake(self.scrollView.width*i, CGRectGetMaxY(self.categoryView.frame), self.scrollView.width, self.scrollView.height - CGRectGetMaxY(self.categoryView.frame));
            [self.scrollView addSubview:vc.view];
        }
    }
    
}

- (void)settingClicked {
    AddressSettingController *vc = [AddressSettingController new];
//    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    NSArray *controllers = self.childViewControllers;
    UIViewController *vc = controllers[index];
    vc.view.frame = CGRectMake(self.scrollView.width*index, CGRectGetMaxY(self.categoryView.frame), self.scrollView.width, self.scrollView.height - CGRectGetMaxY(self.categoryView.frame));
    [self.scrollView addSubview:vc.view];
}

@end
