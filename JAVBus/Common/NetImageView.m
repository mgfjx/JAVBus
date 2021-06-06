//
//  NetImageView.m
//  JAVBus
//
//  Created by mgfjx on 2021/6/6.
//  Copyright © 2021 mgfjx. All rights reserved.
//

#import "NetImageView.h"

@implementation NetImageView

- (void)setImage:(UIImage *)image {
    [super setImage:image];
}

- (void)sd_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder {
    //处理url
    NSString *shortUrl = url.absoluteString;
    NSLog(@"shortUrl: %@", shortUrl);
    if (shortUrl.length > 0 && ![shortUrl hasPrefix:@"http"]) {
        shortUrl = [NSString stringWithFormat:@"%@%@", [GlobalTool shareInstance].baseUrl, shortUrl];
    }
    NSLog(@"resultUrl: %@", shortUrl);
    url = [NSURL URLWithString:shortUrl];
    [super sd_setImageWithURL:url placeholderImage:placeholder];
}

@end
