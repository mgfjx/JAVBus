//
//  LinkButton.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/28.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "LinkButton.h"

@implementation LinkButton

@end

@implementation LinkLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configuration];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configuration];
    }
    return self;
}

- (void)configuration {
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
    [self addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressSelf:)];
    longPress.minimumPressDuration = 0.8;
    [self addGestureRecognizer:longPress];
    
}

- (void)tapSelf {
    if (self.tapLabel) {
        self.tapLabel(self);
    }
}

- (void)longPressSelf:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (self.longPressLabel) {
            self.longPressLabel(self);
        }
    }
}

@end
