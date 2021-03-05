//
//  GGDriveFolderCell.m
//  JAVBus
//
//  Created by mgfjx on 2020/3/12.
//  Copyright © 2020 mgfjx. All rights reserved.
//

#import "GGDriveFolderCell.h"

@interface GGDriveFolderCell ()

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation GGDriveFolderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor dynamicProviderWithDarkStr:@"#111111" lightStr:@"#fffff"];
    self.lineView.backgroundColor = [UIColor dynamicProviderWithDarkStr:@"#333333" lightStr:@"#ececec"];
    
    self.titleLabel.textColor = [UIColor dynamicProviderWithDarkStr:@"#ffffff" lightStr:@"#000000"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
