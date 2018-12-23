//
//  AddressCell.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/23.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.indicatorView.layer.borderColor = [UIColor colorWithHexString:@"#555555"].CGColor;
    self.indicatorView.layer.borderWidth = 0.5;
    self.indicatorView.layer.cornerRadius = self.indicatorView.width/2;
    self.indicatorView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
