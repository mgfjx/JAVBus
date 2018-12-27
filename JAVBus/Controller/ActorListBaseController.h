//
//  ActorListBaseController.h
//  JAVBus
//
//  Created by mgfjx on 2018/12/27.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "BaseViewController.h"

@interface ActorListBaseController : BaseViewController

@property (nonatomic, strong) UICollectionView *collectionView ;
@property (nonatomic, strong) NSArray *actressArray ;
@property (nonatomic, assign) NSInteger page ;

//子类实现
- (void)requestData:(BOOL)refresh ;

@end
