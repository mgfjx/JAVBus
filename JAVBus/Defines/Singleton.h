//
//  Singleton.h
//  singleton
//
//  Created by mgfjx on 2017/8/16.
//  Copyright © 2017年 XXL. All rights reserved.
//

// .h 文件实现
#define SingletonDeclare(methodName) + (instancetype)share##methodName;

// .m 文件实现(并判断MRC和ARC)
#if __has_feature(objc_arc)

#define SingletonImplement(methodName)\
\
static id singleton = nil;\
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
    if (!singleton) {\
        static dispatch_once_t onceToken;\
        dispatch_once(&onceToken, ^{\
            singleton = [super allocWithZone:zone];\
        });\
    }\
    return singleton;\
}\
\
- (instancetype)init{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        singleton = [super init];\
    });\
    return singleton;\
}\
\
+ (instancetype)share##methodName{\
    return [[self alloc] init];\
}\
\
- (id)copyWithZone:(NSZone *)zone{\
    return singleton;\
}\
\
- (id)mutableCopyWithZone:(NSZone *)zone{\
    return singleton;\
}\

#else

#define SingletonImplement(methodName)\
\
static id singleton = nil;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
    if (!singleton) {\
        static dispatch_once_t onceToken;\
        dispatch_once(&onceToken, ^{\
            singleton = [super allocWithZone:zone];\
        });\
    }\
    return singleton;\
}\
\
- (instancetype)init{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        singleton = [super init];\
    });\
    return singleton;\
}\
\
- (oneway void)release{\
}\
\
- (instancetype)retain{\
    return self;\
}\
\
- (NSUInteger)retainCount{\
    return 1;\
}\
\
+ (instancetype)share##methodName{\
    return [[self alloc] init];\
}\
\
- (id)copyWithZone:(NSZone *)zone{\
    return singleton;\
}\
\
- (id)mutableCopyWithZone:(NSZone *)zone{\
    return singleton;\
}\

#endif

