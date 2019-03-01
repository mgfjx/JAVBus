//
//  CategoryModel.h
//  JAVBus
//
//  Created by mgfjx on 2018/12/27.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "BaseModel.h"

@interface CategoryModel : BaseModel

@property (nonatomic, strong) NSString *title ;
@property (nonatomic, strong) NSArray *items ;

@end

@interface CategoryItemModel : BaseModel

@property (nonatomic, strong) NSString *title ;
@property (nonatomic, strong) NSString *link ;

@end
