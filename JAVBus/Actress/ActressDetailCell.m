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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;


@end

@implementation ActressDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderColor = [UIColor colorWithHexString:@"#f1f2f3"].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    self.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
}

- (void)setModel:(MovieListModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"actressHolder"]];
    self.titleLabel.text = model.title;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

- (void)setItemHeight:(CGFloat)itemHeight {
    _itemHeight = itemHeight;
    self.heightConstraint.constant = itemHeight;
}

@end
