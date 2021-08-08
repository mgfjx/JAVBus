//
//  ThemeManager.h
//  JAVBus
//
//  Created by mgfjx on 2021/7/19.
//  Copyright © 2021 mgfjx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThemeManager : NSObject

+ (instancetype)manager ;

/// controller 背景色
@property (nonatomic, strong, readonly) UIColor *pageBgColor ;
/// 导航栏颜色
@property (nonatomic, strong, readonly) UIColor *navColor ;
/// tabbar颜色
@property (nonatomic, strong, readonly) UIColor *tabBarBgColor ;

@end

NS_ASSUME_NONNULL_END
