//
//  AddressSettingController.h
//  JAVBus
//
//  Created by mgfjx on 2018/12/23.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, AddressType) {
    AddressTypeFailed = 0,
    AddressTypeSuccess,
    AddressTypeLoading
};

@interface AddressSettingController : BaseViewController

@end

@interface AddressModel : NSObject

@property (nonatomic, assign) BOOL selected ;
@property (nonatomic, strong) NSString *ipAddress ;
@property (nonatomic, assign) AddressType type ;

@end
