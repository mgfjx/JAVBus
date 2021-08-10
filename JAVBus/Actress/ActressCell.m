//
//  ActressCell.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/13.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "ActressCell.h"

@implementation ActressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.layer.borderColor = [ThemeManager manager].cellBorderColor.CGColor;
//    self.layer.borderWidth = 0.5;
//    self.layer.cornerRadius = 5;
//    self.layer.masksToBounds = YES;
    
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.imageView.backgroundColor = [ThemeManager manager].cellImageBgColor;
    self.backgroundColor = [ThemeManager manager].cellBgColor;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
    
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (self.longPressCallback) {
            self.longPressCallback();
        }
    }
}

@end
