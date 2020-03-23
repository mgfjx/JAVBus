//
//  AddressCell.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/23.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "AddressCell.h"

@interface AddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *indicatorView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;

@end

@implementation AddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.indicatorView.layer.borderColor = [UIColor colorWithHexString:@"#555555"].CGColor;
    self.indicatorView.layer.borderWidth = 0.5;
    self.indicatorView.layer.cornerRadius = self.indicatorView.width/2;
    self.indicatorView.layer.masksToBounds = YES;
    
}

- (void)setModel:(AddressModel *)model {
    _model = model;
    
    self.selectImageView.hidden = !model.selected;
    self.titleLabel.text = model.ipAddress;
    
    if (model.type == AddressTypeFailed) {
        self.indicatorView.backgroundColor = [UIColor colorWithHexString:@"#e82220"];
        [self.loadingView stopAnimating];
        self.loadingView.hidden = YES;
        self.indicatorView.hidden = NO;
    }else if (model.type == AddressTypeSuccess) {
        self.indicatorView.backgroundColor = [UIColor colorWithHexString:@"#00a600"];
        [self.loadingView stopAnimating];
        self.loadingView.hidden = YES;
        self.indicatorView.hidden = NO;
    }else if (model.type == AddressTypeLoading) {
        self.indicatorView.hidden = YES;
        self.loadingView.hidden = NO;
        [self.loadingView startAnimating];
    }
    
}

@end
