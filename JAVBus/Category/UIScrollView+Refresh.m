//
//  UIScrollView+Refresh.m
//  ThirdLibPackage
//
//  Created by mgfjx on 2017/11/4.
//  Copyright © 2017年 mgfjx. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <objc/runtime.h>
#import <MJRefresh.h>

@implementation UIScrollView (Refresh)

// 属性
static char *canPullDownKey = "canPullDownKey";
- (void)setCanPullDown:(BOOL)canPullDown {
    objc_setAssociatedObject(self, canPullDownKey, @(canPullDown), OBJC_ASSOCIATION_ASSIGN);
    if (canPullDown) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
        header.lastUpdatedTimeLabel.hidden = YES;
        
        self.mj_header = header;
    }else{
        self.mj_header = nil;
    }
}

- (BOOL)canPullDown {
    return objc_getAssociatedObject(self, canPullDownKey);
}

// 属性
static char *canPullUpKey = "canPullUpKey";
- (void)setCanPullUp:(BOOL)canPullUp {
    objc_setAssociatedObject(self, canPullUpKey, @(canPullUp), OBJC_ASSOCIATION_ASSIGN);
    if (canPullUp) {
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
        self.mj_footer = footer;
    }else{
        self.mj_footer = nil;
    }
}

- (BOOL)canPullUp {
    return objc_getAssociatedObject(self, canPullUpKey);
}

// 属性
static char *headerRefreshBlockKey = "headerRefreshBlockKey";
- (void)setHeaderRefreshBlock:(RefreshingBlock)headerRefreshBlock {
    objc_setAssociatedObject(self, headerRefreshBlockKey, headerRefreshBlock, OBJC_ASSOCIATION_COPY);
}

- (RefreshingBlock)headerRefreshBlock {
    return objc_getAssociatedObject(self, headerRefreshBlockKey);
}

// 属性
static char *footerRefreshBlockKey = "footerRefreshBlockKey";
- (void)setFooterRefreshBlock:(RefreshingBlock)footerRefreshBlock {
    objc_setAssociatedObject(self, footerRefreshBlockKey, footerRefreshBlock, OBJC_ASSOCIATION_COPY);
}

- (RefreshingBlock)footerRefreshBlock {
    return objc_getAssociatedObject(self, footerRefreshBlockKey);
}

// 方法
- (void)headerRefreshing {
    if (self.headerRefreshBlock) {
        __block typeof(self) weakSelf = self;
        self.headerRefreshBlock(weakSelf);
    }
}

- (void)footerRefreshing {
    if (self.footerRefreshBlock) {
        __block typeof(self) weakSelf = self;
        self.footerRefreshBlock(weakSelf);
    }
}

- (void)startHeaderRefreshing {
    [self.mj_header beginRefreshing];
}

- (void)startFooterRefreshing {
    [self.mj_footer beginRefreshing];;
}

- (void)stopHeaderRefreshing {
    [self.mj_header endRefreshing];
}

- (void)stopFooterRefreshing {
    [self.mj_footer endRefreshing];
}

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end
