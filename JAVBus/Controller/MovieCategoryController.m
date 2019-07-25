//
//  MovieCategoryController.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/27.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "MovieCategoryController.h"
#import "CategoryModel.h"
#import "MovieMainController.h"
#import "CategoryItemListController.h"
#import "LinkButton.h"

@interface MovieCategoryController ()

@end

@implementation MovieCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createScrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
    NSString *logo = [NSString stringWithFormat:@"子类必须为实现%@方法", NSStringFromSelector(_cmd)];
    NSAssert(0, logo);
}

- (void)createScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    scrollView.canPullDown = YES;
    WeakSelf(weakSelf)
    scrollView.headerRefreshBlock = ^(UIScrollView *rfScrollView) {
        [weakSelf requestData];
    };
    [scrollView startHeaderRefreshing];
}

- (void)createViews {
    
    CGFloat maxHeight = 0;
    CGFloat offset = 5*3/2.0;
    NSArray *infos = self.dataArray ;
    
    UIScrollView *scrollView = self.scrollView;
    UIView *view = [scrollView viewWithTag:100];
    if (view) {
        [view removeFromSuperview];
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.height)];
    bgView.tag = 100;
    [scrollView addSubview:bgView];
    
    for (int i = 0; i < infos.count; i++) {
        maxHeight += offset;
        
        CategoryModel *caModel = infos[i];
        NSString *title = caModel.title;
        NSArray *items = caModel.items;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.font = [UIFont systemFontOfSize:18];
        [bgView addSubview:label];
        [label sizeToFit];
        label.x = offset;
        label.y = maxHeight + offset;
        
        maxHeight = CGRectGetMaxY(label.frame) + offset;
        
        CGFloat xPosition = offset;
        for (CategoryItemModel *cateItem in items) {
            TitleLinkModel *item = [TitleLinkModel new];
            item.title = cateItem.title;
            item.link = cateItem.link;
            LinkButton *button = [LinkButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(linkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:item.title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#aaaaaa"] forState:UIControlStateHighlighted];
            button.model = item;
            button.backgroundColor = [UIColor colorWithHexString:@"#1d65ee"];
            button.backgroundColor = [UIColor randomColorWithAlpha:0.2];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [bgView addSubview:button];
            [button sizeToFit];
            button.layer.cornerRadius = button.height/4;
            button.layer.masksToBounds = YES;
            button.layer.borderColor = [UIColor colorWithHexString:@"#aaaaaa"].CGColor;
            button.layer.borderWidth = 0.5;
            button.width = button.width + 2*offset;
            if (xPosition + offset + button.width > bgView.width - offset) {
                xPosition = offset;
                maxHeight = maxHeight + offset + button.height;
            }
            button.x = xPosition + offset;
            button.y = maxHeight;
            
            xPosition = CGRectGetMaxX(button.frame);
            if (cateItem == items.lastObject) {
                maxHeight = CGRectGetMaxY(button.frame);
            }
        }
        
        maxHeight += offset;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, maxHeight - 0.5, bgView.width, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#aaaaaa"];
        [bgView addSubview:line];
    }
    scrollView.contentSize = CGSizeMake(scrollView.width, maxHeight);
    bgView.height = scrollView.contentSize.height;
}

- (void)linkBtnClicked:(LinkButton *)sender {
    TitleLinkModel *model = sender.model;
    CategoryItemModel *itemModel = [CategoryItemModel new];
    itemModel.title = model.title;
    itemModel.link = model.link;
    CategoryItemListController *vc = [CategoryItemListController new];
    vc.model = itemModel;
    vc.showSortBar = YES;
//    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
