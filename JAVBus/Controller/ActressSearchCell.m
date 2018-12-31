//
//  ActressSearchCell.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/31.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "ActressSearchCell.h"

@implementation ActressSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderColor = [UIColor colorWithHexString:@"#eeeeee"].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    self.codeLabel.layer.cornerRadius = self.codeLabel.height/8;
    self.codeLabel.layer.masksToBounds = YES;
    
    self.titleLabel.backgroundColor = [UIColor colorWithHexString:@"#606060"];
    self.backgroundColor = [UIColor colorWithHexString:@"#606060"];
    
}

@end
