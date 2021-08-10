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


///女优cell，影片cell
///背景
@property (nonatomic, strong, readonly) UIColor *cellBgColor ;
///图片背景
@property (nonatomic, strong, readonly) UIColor *cellImageBgColor ;
///边框
@property (nonatomic, strong, readonly) UIColor *cellBorderColor ;

@end

NS_ASSUME_NONNULL_END
