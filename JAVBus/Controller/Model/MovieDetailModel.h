//
//  MovieDetailModel.h
//  JAVBus
//
//  Created by mgfjx on 2018/12/28.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "BaseModel.h"

@interface MovieDetailModel : BaseModel

@property (nonatomic, strong) NSString *title ;
@property (nonatomic, strong) NSString *number ;
@property (nonatomic, strong) NSString *coverImgUrl ;
@property (nonatomic, strong) NSArray *infoArray ;
@property (nonatomic, strong) NSArray *screenshots ;
@property (nonatomic, strong) NSArray *recommends ;
@property (nonatomic, strong) NSArray *magneticArray ;

@end
