//
//  GlobalTool.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/22.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "GlobalTool.h"

@implementation GlobalTool

@synthesize columnNum = _columnNum;
@synthesize baseUrl = _baseUrl;
@synthesize ips = _ips;
@synthesize descOrder = _descOrder;

SingletonImplement(Instance)

- (void)setColumnNum:(NSUInteger)columnNum {
    _columnNum = columnNum;
    [[NSUserDefaults standardUserDefaults] setInteger:columnNum forKey:@"kColumnNumber"];
}

- (NSUInteger)columnNum {
    NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:@"kColumnNumber"];
    if (num < 1) {
        num = 3;
    }
    return num;
}

- (void)setBaseUrl:(NSString *)baseUrl {
    _baseUrl = baseUrl;
    [[NSUserDefaults standardUserDefaults] setObject:baseUrl forKey:@"kBaseUrl"];
}

- (NSString *)baseUrl {
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"kBaseUrl"];
    if (!url || url.length == 0) {
        url = @"https://www.javbus.com";
    }
    return url;
}

- (void)setIps:(NSArray *)ips {
    _ips = ips;
    [[NSUserDefaults standardUserDefaults] setObject:ips forKey:@"kHTTPAdress"];
}

- (NSArray *)ips {
    NSArray *ips = [[NSUserDefaults standardUserDefaults] objectForKey:@"kHTTPAdress"];
    if (!ips || ips.count == 0) {
        ips = @[
                @"https://www.javbus.pw",
                @"https://www.javbus.com",
                @"https://www.busdmm.cc",
                @"https://www.dmmbus.co",
                @"https://www.seedmm.co",
                @"https://www.dmmsee.cloud",
                @"https://www.cdnbus.cloud",
                @"https://www.busjav.cloud",
                ];
    }
    return ips;
}

- (NSString *)movieCacheDir {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [document stringByAppendingPathComponent:@"/MovieCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

- (BOOL)descOrder {
    _descOrder = [[NSUserDefaults standardUserDefaults] boolForKey:@"kCollectionDescending"];
    return _descOrder;
}

- (void)setDescOrder:(BOOL)descOrder {
    [[NSUserDefaults standardUserDefaults] setBool:descOrder forKey:@"kCollectionDescending"];
}

@end
