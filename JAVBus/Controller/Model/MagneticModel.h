//
//  MagneticModel.h
//  JAVBus
//
//  Created by mgfjx on 2020/3/14.
//  Copyright © 2020 mgfjx. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MagneticModel : BaseModel

//是否是高清
@property (nonatomic, assign) BOOL isHD ;
@property (nonatomic, strong) NSString *text ;
@property (nonatomic, strong) NSString *date ;
@property (nonatomic, strong) NSString *size ;

@end

NS_ASSUME_NONNULL_END
