//
//  PublicDefines.h
//  test
//
//  Created by mgfjx on 2018/10/21.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#ifndef PublicDefines_h
#define PublicDefines_h

#ifdef DEBUG
    #define NSLog(FORMAT, ...) fprintf(stderr, "%s:%d\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else
    #define NSLog(FORMAT, ...) nil
#endif

#define MainWidth [UIScreen mainScreen].bounds.size.width
#define MainHeight [UIScreen mainScreen].bounds.size.height
#define iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
#define kStatusBarHeight (iPhoneX  ? 44  : 20)
#define kNavigationBarHeight (kStatusBarHeight + 44)
#define kTabBarHeight (iPhoneX  ? (49+34)  : 49)

#define WeakSelf(weakSelf)      __weak __typeof(&*self)    weakSelf  = self;
#define HTTPMANAGER [HttpManager manager]
#define HTMLTOJSONMANAGER [HtmlToJsonManager manager]
#define DBMANAGER [DBManager manager]

#define MovieListPlaceHolder [UIImage imageNamed:@"movie_placeholder"]

#endif /* PublicDefines_h */
