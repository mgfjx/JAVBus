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
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *operationBtn;

@end

@implementation ActressDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderColor = [UIColor colorWithHexString:@"#f1f2f3"].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    self.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    self.numberLabel.layer.cornerRadius = self.numberLabel.height/8;
    self.numberLabel.layer.masksToBounds = YES;
    
    self.imageView.clipsToBounds = YES;
    
    self.operationBtn.cornerRadius = self.operationBtn.height/2;
    self.operationBtn.hidden = YES;
    
}

- (void)setModel:(MovieListModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:MovieListPlaceHolder];
    self.titleLabel.text = model.title;
    self.numberLabel.text = model.number;
    self.timeLabel.text = model.dateString;
    
    CGFloat width = [self.numberLabel.text boundingRectWithSize:CGSizeMake(self.titleLabel.width, self.numberLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.numberLabel.font} context:nil].size.width;
    CGFloat superWidth = self.titleLabel.width;
    if (width + 5*2 > superWidth - 2*5) {
        width = superWidth;
    }else{
        width = width + 2*5;
    }
    self.numberWidthConstraint.constant = width;
    
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

- (void)setItemHeight:(CGFloat)itemHeight {
    _itemHeight = itemHeight;
    self.heightConstraint.constant = itemHeight;
}

- (void)setFontSizeThatFits:(UILabel*)label {
    CGFloat fontSizeThatFits;
    [label.text sizeWithFont:label.font
                 minFontSize:8.0
              actualFontSize:&fontSizeThatFits
                    forWidth:label.bounds.size.width
               lineBreakMode:NSLineBreakByWordWrapping];
    label.font = [label.font fontWithSize:fontSizeThatFits];
}

- (void)setShowOperation:(BOOL)showOperation {
    _showOperation = showOperation;
    self.operationBtn.hidden = !showOperation;
}

- (IBAction)operationBtnClicked:(UIButton *)sender {
    if (self.actionCallback) {
        self.actionCallback(self.model);
    }
}

@end
