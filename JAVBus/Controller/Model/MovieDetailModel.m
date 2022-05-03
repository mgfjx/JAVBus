//
//  MovieDetailModel.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/28.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "MovieDetailModel.h"

@implementation MovieDetailModel

- (NSString *)coverFullImgUrl {
    //处理url
    NSString *shortUrl = self.coverImgUrl;
    if (shortUrl.length > 0 && ![shortUrl hasPrefix:@"http"]) {
        shortUrl = [NSString stringWithFormat:@"%@%@", [GlobalTool shareInstance].baseUrl, shortUrl];
    }
    return shortUrl;
}

@end
