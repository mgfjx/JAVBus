//
//  JXCategoryListScrollView.h
//  JXCategoryView
//
//  Created by jiaxin on 2018/9/12.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 使用方法参照demo工程的LoadDataViewController文件
 */
@interface JXCategoryListVCContainerView : UIView

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray <UIViewController *> *listVCArray;
@property (nonatomic, assign) NSInteger defaultSelectedIndex;

- (void)reloadData;

- (void)scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio;

- (void)didClickSelectedItemAtIndex:(NSInteger)index;

- (void)didScrollSelectedItemAtIndex:(NSInteger)index;

- (void)parentVCWillAppear:(BOOL)animated;

- (void)parentVCDidAppear:(BOOL)animated;

- (void)parentVCWillDisappear:(BOOL)animated;

- (void)parentVCDidDisappear:(BOOL)animated;

@end
