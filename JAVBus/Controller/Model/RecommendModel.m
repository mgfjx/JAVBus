//
//  RecommendModel.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/28.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "RecommendModel.h"

@implementation RecommendModel

- (NSString *)link {
    if (!_link) {
        _link = @"";
    }
    return _link;
}

- (NSString *)title {
    if (!_title) {
        _title = @"";
    }
    return _title;
}

- (NSString *)imgUrl {
    if (!_imgUrl) {
        _imgUrl = @"";
    }
    return _imgUrl;
}

@end
