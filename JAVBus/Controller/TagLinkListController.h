//
//  TagLinkListController.h
//  JAVBus
//
//  Created by mgfjx on 2021/2/11.
//  Copyright © 2021 mgfjx. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TagLinkListController : BaseViewController

@property (nonatomic, strong) UIScrollView *scrollView ;
@property (nonatomic, strong) NSArray *dataArray ;

- (void)requestData ;
- (void)createViews ;

@end

NS_ASSUME_NONNULL_END
