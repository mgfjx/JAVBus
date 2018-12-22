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

@end
