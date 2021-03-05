//
//  TagLinkListController.m
//  JAVBus
//
//  Created by mgfjx on 2021/2/11.
//  Copyright © 2021 mgfjx. All rights reserved.
//

#import "TagLinkListController.h"
#import "TitleLinkModel.h"
#import "CategoryModel.h"
#import "MovieMainController.h"
#import "BaseItemListController.h"
#import "LinkButton.h"

@interface TagLinkListController ()

@end

@implementation TagLinkListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createScrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
    
    [self.scrollView stopHeaderRefreshing];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    {
        CategoryModel *model = [CategoryModel new] ;
        NSArray *array = [DBMANAGER queryTagLinkList:LinkTypeSeries];
        model.items = array;
        model.title = @"系列";
        [arr addObject:model];
    }
    
    {
        CategoryModel *model = [CategoryModel new] ;
        NSArray *array = [DBMANAGER queryTagLinkList:LinkTypeCategory];
        model.items = array;
        model.title = @"分类";
        [arr addObject:model];
    }
    
    {
        CategoryModel *model = [CategoryModel new] ;
        NSArray *array = [DBMANAGER queryTagLinkList:LinkTypeDirector];
        model.items = array;
        model.title = @"導演";
        [arr addObject:model];
    }
    
    {
        CategoryModel *model = [CategoryModel new] ;
        NSArray *array = [DBMANAGER queryTagLinkList:LinkTypeProducer];
        model.items = array;
        model.title = @"製作商";
        [arr addObject:model];
    }
    
    {
        CategoryModel *model = [CategoryModel new] ;
        NSArray *array = [DBMANAGER queryTagLinkList:LinkTypePublisher];
        model.items = array;
        model.title = @"發行商";
        [arr addObject:model];
    }
    
    self.dataArray = [arr copy];
    
    [self createViews];
    
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
        for (TitleLinkModel *item in items) {
            LinkButton *button = [LinkButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(linkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:item.title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor dynamicProviderWithDarkStr:@"#ffffff" lightStr:@"#666666"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor dynamicProviderWithDarkStr:@"#bbbbbb" lightStr:@"#aaaaaa"] forState:UIControlStateHighlighted];
            button.model = item;
            button.backgroundColor = [UIColor colorWithHexString:@"#1d65ee"];
            button.backgroundColor = [UIColor randomColorWithAlpha:0.3];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [bgView addSubview:button];
            [button sizeToFit];
            button.layer.cornerRadius = button.height*0.382;
            button.layer.masksToBounds = YES;
            button.layer.borderColor = [UIColor dynamicProviderWithDarkStr:@"#333333" lightStr:@"#eeeeee"].CGColor;
            button.layer.borderWidth = 0.5;
            button.width = button.width + 2*offset;
            if (xPosition + offset + button.width > bgView.width - offset) {
                xPosition = offset;
                maxHeight = maxHeight + offset + button.height;
            }
            button.x = xPosition + offset;
            button.y = maxHeight;
            
            xPosition = CGRectGetMaxX(button.frame);
            if (item == items.lastObject) {
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
    BaseItemListController *vc = [BaseItemListController new];
    vc.model = model;
    vc.showSortBar = NO;
    [self.navigationController pushViewController:vc animated:YES];
    
    WeakSelf(weakSelf);
    vc.collectionChanged = ^(BOOL isCollected) {
        [weakSelf requestData];
    };
}

@end
