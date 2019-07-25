//
//  BaseModel.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/13.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

@synthesize link = _link;

- (NSString *)link {
    if (!_link) {
        _link = @"";
    }
    return _link;
}

- (void)setLink:(NSString *)link {
    //替换某个字符
    NSString *baseUrl = [GlobalTool shareInstance].baseUrl;
    link = [link stringByReplacingOccurrencesOfString:baseUrl withString:@""];
    _link = link;
}

@end
