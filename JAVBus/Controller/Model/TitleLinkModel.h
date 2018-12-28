//
//  TitleLinkModel.h
//  JAVBus
//
//  Created by mgfjx on 2018/12/27.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger, LinkType) {
    LinkTypeNone = 0,
    LinkTypeNormal,
    LinkTypeActor,
    LinkTypeCategory,
};

@interface TitleLinkModel : BaseModel

@property (nonatomic, strong) NSString *title ;
@property (nonatomic, strong) NSString *link ;
@property (nonatomic, assign) LinkType type ;

@end
