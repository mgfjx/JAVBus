//
//  LikeButton.h
//  JAVBus
//
//  Created by mgfjx on 2018/12/28.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleLinkModel.h"

@interface LinkButton : UIButton

@property (nonatomic, strong) TitleLinkModel *model ;

@end

@interface LinkLabel : UILabel

@property (nonatomic, strong) TitleLinkModel *model ;

@property (nonatomic, copy) void(^tapLabel)(LinkLabel *label) ;
@property (nonatomic, copy) void(^longPressLabel)(LinkLabel *label) ;

@end
