//
//  SeriesItemListController.h
//  JAVBus
//
//  Created by mgfjx on 2021/2/10.
//  Copyright © 2021 mgfjx. All rights reserved.
//

#import "MovieListBaseController.h"
#import "TitleLinkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseItemListController : MovieListBaseController

@property (nonatomic, strong) TitleLinkModel *model ;

@end

NS_ASSUME_NONNULL_END
