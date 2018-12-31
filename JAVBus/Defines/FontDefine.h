//
//  FontDefine.h
//  ProjectTools
//
//  Created by mgfjx on 2018/12/5.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#ifndef FontDefine_h
#define FontDefine_h

/**
 *  极细体
 */
static NSString *const MHPingFangSC_Ultralight = @"PingFangSC-Ultralight";
/**
 *  常规体
 */
static NSString *const MHPingFangSC_Regular = @"PingFangSC-Regular";
/**
 *  中粗体
 */
static NSString *const MHPingFangSC_Semibold = @"PingFangSC-Semibold";
/**
 *  纤细体
 */
static NSString *const MHPingFangSC_Thin = @"PingFangSC-Thin";
/**
 *  细体
 */
static NSString *const MHPingFangSC_Light = @"PingFangSC-Light";
/**
 *  中黑体
 */
static NSString *const MHPingFangSC_Medium = @"PingFangSC-Medium";

#define MHIOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

/**设置系统的字体大小（YES：粗体 NO：常规）*/
#define MHFont(__size__,__bold__) ((__bold__)?([UIFont boldSystemFontOfSize:__size__]):([UIFont systemFontOfSize:__size__]))


/** 极细体 */
#define MHUltralightFont(__size__) [UIFont fontWithName:MHPingFangSC_Ultralight size:__size__]


/** 纤细体 */
#define MHThinFont(__size__)      [UIFont fontWithName:MHPingFangSC_Thin size:__size__]

/** 细体 */
#define MHLightFont(__size__)      [UIFont fontWithName:MHPingFangSC_Light size:__size__]



// 主要使用以下三种字体
// 中等 中黑体
#define MHMediumFont(__size__)     ((MHIOSVersion<9.0)?MHFont(__size__ , YES): [UIFont fontWithName:MHPingFangSC_Medium size:__size__])

// 常规
#define MHRegularFont(__size__)    ((MHIOSVersion<9.0)?MHFont(__size__ , NO):[UIFont fontWithName:MHPingFangSC_Regular size:__size__])

/** 中粗体 */
#define MHSemiboldFont(__size__)   ((MHIOSVersion<9.0)?MHFont(__size__ , YES):[UIFont fontWithName:MHPingFangSC_Semibold size:__size__])


#endif /* FontDefine_h */
