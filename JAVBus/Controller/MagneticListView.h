//
//  MagneticListView.h
//  JAVBus
//
//  Created by mgfjx on 2020/3/15.
//  Copyright © 2020 mgfjx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MagneticListView : UIView

@property (nonatomic, strong) NSArray *magneticArray ;
@property (nonatomic, copy) void (^frameChangeCallback)(CGRect frame) ;

@end

NS_ASSUME_NONNULL_END
