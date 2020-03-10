//
//  CollectionViewController.m
//  JAVBus
//
//  Created by mgfjx on 2019/1/3.
//  Copyright © 2019 mgfjx. All rights reserved.
//

#import "CollectionViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "MovieListBaseController.h"
#import "MovieCollectionController.h"
#import "ActressCollectionController.h"
#import "RxWebViewController.h"
#import "MovieCachedController.h"
#import <SafariServices/SafariServices.h>

#define CategoryHeight 40

@interface CollectionViewController ()<JXCategoryViewDelegate, UISearchBarDelegate, SFSafariViewControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView ;
@property (nonatomic, strong) JXCategoryTitleView *categoryView ;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收藏";
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews {
    [self createBarButton];
    [self createScrollView];
    [self createCategoryView];
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
    
    NSArray *titles = @[@"女優", @"影片", @"缓存影片"];
    
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
    
    [self addChildControllers];
}

- (void)addChildControllers {
    
    //子控制器
    NSArray *controllers = @[@"ActressCollectionController", @"MovieCollectionController", @"MovieCachedController"];
    for (int i = 0; i < controllers.count; i++) {
        NSString *vcName = controllers[i];
        UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
        if (i >= 1) {
            MovieListBaseController *baseVC = (MovieListBaseController *)vc;
            baseVC.shouldNotOffset = YES;
        }
        [self addChildViewController:vc];
        if (i == 0) {
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

- (void)createBarButton {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"論壇" style:UIBarButtonItemStylePlain target:self action:@selector(gotoForum)];
    self.navigationItem.rightBarButtonItem = item;
    
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 40, 40);
        [button addTarget:self action:@selector(changeSort) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
        [self.view addSubview:button];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = item;
    }
    
}

- (void)changeSort {
    [GlobalTool shareInstance].descOrder = ![GlobalTool shareInstance].descOrder;
}

- (void)gotoForum {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/forum/forum.php", [GlobalTool shareInstance].baseUrl];
    
    //    RxWebViewController* webViewController = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:url]];
    ////    webViewController.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:webViewController animated:YES];
    
    NSURL *url = [NSURL URLWithString:urlString];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
    safariVC.delegate = self;
    
    
    //    self.navigationController.navigationBarHidden = YES;
//        [self.navigationController pushViewController:safariVC animated:YES];
    // 建议
    [self presentViewController:safariVC animated:YES completion:nil];
    
}

#pragma mark - SFSafariViewControllerDelegate
//加载完成
- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
    
}

//点击左上角的done
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    
}

@end
