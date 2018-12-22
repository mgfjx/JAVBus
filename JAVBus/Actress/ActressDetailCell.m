//
//  ActressDetailCell.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/17.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "ActressDetailCell.h"

@interface ActressDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation ActressDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
}

- (void)setModel:(MovieListModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
    self.titleLabel.text = model.title;
}

@end
