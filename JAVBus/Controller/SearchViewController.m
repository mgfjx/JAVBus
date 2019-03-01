//
//  SearchViewController.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/30.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "SearchViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "MovieSearchListController.h"
#import "ActressSearchController.h"
#import "ZHChineseConvert.h"

#define CategoryHeight 40

@interface SearchViewController ()<JXCategoryViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UIScrollView *scrollView ;
@property (nonatomic, strong) JXCategoryTitleView *categoryView ;

@property (nonatomic, strong) UISearchBar *searchBar ;

@end

@implementation SearchViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.searchBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.searchBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews {
    [self createSearchView];
    [self createScrollView];
    [self createCategoryView];
}

- (void)createSearchView {
    
    UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, MainWidth*0.8, 40)];
    search.barStyle = UIBarStyleDefault;
    search.showsScopeBar = YES;
    search.placeholder = @"搜尋 識別碼, 影片, 演員";
    search.delegate = self;
    search.searchBarStyle = UISearchBarStyleProminent;
    [self.navigationController.navigationBar addSubview:search];
    search.centerX = MainWidth/2;
    search.centerY = self.navigationController.navigationBar.height/2;
    
    self.searchBar = search;
    
}

- (void)createScrollView {
    CGRect frame = self.view.bounds ;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)createCategoryView {
    
    JXCategoryTitleView *titleCategoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, MainWidth, CategoryHeight)];
    titleCategoryView.backgroundColor = [UIColor whiteColor];
    titleCategoryView.titleSelectedColor = [UIColor colorWithHexString:@"#0b7be1"];;
    titleCategoryView.titleFont = [UIFont systemFontOfSize:16];
    titleCategoryView.delegate = self;
    
    //    self.categoryView = titleCategoryView;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, titleCategoryView.height - 1, titleCategoryView.width, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [titleCategoryView addSubview:line];
    
    NSArray *titles = @[@"有碼影片", @"無碼影片", @"女優", @"導演", @"製作商", @"發行商", @"系列"];
    
    //------指示器属性配置------//
    //固定宽度
    titleCategoryView.titleColorGradientEnabled = YES;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    //    lineView.indicatorLineWidth = MainWidth/titles.count;
    lineView.indicatorLineViewColor = [UIColor colorWithHexString:@"#0b7be1"];
    titleCategoryView.indicators = @[lineView];
    
    titleCategoryView.titles = titles;
    [self.view addSubview:titleCategoryView];
    self.categoryView = titleCategoryView;
    
    titleCategoryView.contentScrollView = self.scrollView;
    self.scrollView.contentSize = CGSizeMake(titles.count * self.scrollView.width, self.scrollView.height);
    
}

- (void)addChildControllers {
    
    NSMutableArray *array = [NSMutableArray array];
    NSString *searchText = self.searchBar.text;
    searchText = [ZHChineseConvert convertSimplifiedToTraditional:searchText];
    for (int i = 0; i < self.categoryView.titles.count; i++) {
        NSString *url ;
        switch (i) {
            case 0:
                url = [NSString stringWithFormat:@"/search/%@", searchText];
                break;
                
            case 1:
                url = [NSString stringWithFormat:@"/uncensored/search/%@&type=1", searchText];
                break;
                
            case 2:
                url = [NSString stringWithFormat:@"/searchstar/%@", searchText];
                break;
                
            case 3:
                url = [NSString stringWithFormat:@"/search/%@&type=2", searchText];
                break;
                
            case 4:
                url = [NSString stringWithFormat:@"/search/%@&type=3", searchText];
                break;
                
            case 5:
                url = [NSString stringWithFormat:@"/search/%@&type=4", searchText];
                break;
                
            case 6:
                url = [NSString stringWithFormat:@"/search/%@&type=5", searchText];
                break;
                
            default:
                break;
        }
        [array addObject:url];
    }
    
    //子控制器
    NSArray *controllers = @[@"MovieSearchListController", @"MovieSearchListController", @"ActressSearchController", @"MovieSearchListController", @"MovieSearchListController", @"MovieSearchListController", @"MovieSearchListController"];
    for (int i = 0; i < controllers.count; i++) {
        NSString *vcName = controllers[i];
        NSString *url = array[i];
        
        UIViewController *vc ;
        if (i != 2) {
            MovieSearchListController *searchVC = (MovieSearchListController *)[[NSClassFromString(vcName) alloc] init];
            searchVC.url = url;
            searchVC.shouldNotOffset = YES;
            vc = searchVC;
            [self addChildViewController:vc];
        }else{
            ActressSearchController *actorVC = (ActressSearchController *)[[NSClassFromString(vcName) alloc] init];
            actorVC.url = url;
            vc = actorVC;
            [self addChildViewController:vc];
        }
        
        if (i == self.categoryView.selectedIndex) {
            vc.view.frame = CGRectMake(self.scrollView.width*i, CGRectGetMaxY(self.categoryView.frame), self.scrollView.width, self.scrollView.height - kTabBarHeight - CGRectGetMaxY(self.categoryView.frame));
            [self.scrollView addSubview:vc.view];
        }
    }
    
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    NSArray *controllers = self.childViewControllers;
    if (self.childViewControllers.count >= index + 1) {
        UIViewController *vc = controllers[index];
        vc.view.frame = CGRectMake(self.scrollView.width*index, CGRectGetMaxY(self.categoryView.frame), self.scrollView.width, self.scrollView.height - kTabBarHeight - CGRectGetMaxY(self.categoryView.frame));
        [self.scrollView addSubview:vc.view];
    }
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    [self.scrollView removeAllSubViews];
    for (UIViewController *vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    
    [self addChildControllers];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
