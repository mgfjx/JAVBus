//
//  ScreenShotModel.h
//  JAVBus
//
//  Created by mgfjx on 2018/12/28.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "BaseModel.h"

@interface ScreenShotModel : BaseModel

@property (nonatomic, strong) NSString *title ;
@property (nonatomic, strong) NSString *smallPicUrl ;
@property (nonatomic, strong) NSString *bigPicUrl ;
@property (nonatomic, strong, readonly) NSString *bigFullPicUrl ;

@end
