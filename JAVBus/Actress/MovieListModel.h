//
//  MovieListModel.h
//  JAVBus
//
//  Created by mgfjx on 2018/12/17.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "BaseModel.h"

@interface MovieListModel : BaseModel

@property (nonatomic, strong) NSString *imgUrl ;
@property (nonatomic, strong) NSString *title ;
@property (nonatomic, strong) NSString *number ;
@property (nonatomic, strong) NSString *dateString ;

@end
