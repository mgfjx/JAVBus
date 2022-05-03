//
//  ScreenShotModel.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/28.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "ScreenShotModel.h"

@implementation ScreenShotModel

- (NSString *)bigFullPicUrl {
    NSString *shortUrl = self.bigPicUrl;
    if (shortUrl.length > 0 && ![shortUrl hasPrefix:@"http"]) {
        shortUrl = [NSString stringWithFormat:@"%@%@", [GlobalTool shareInstance].baseUrl, shortUrl];
    }
    return shortUrl;
}

@end
