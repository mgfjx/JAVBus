//
//  MagneticItemView.m
//  JAVBus
//
//  Created by mgfjx on 2020/3/14.
//  Copyright © 2020 mgfjx. All rights reserved.
//

#import "MagneticItemCell.h"

@interface MagneticItemCell ()

@property (nonatomic, strong) UIImageView *iconView ;
@property (nonatomic, strong) UIImageView *hdImgView ;
@property (nonatomic, strong) UILabel *titleLabel ;
@property (nonatomic, strong) UILabel *dateLabel ;
@property (nonatomic, strong) UILabel *sizeLabel ;

@end

@implementation MagneticItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"magnetIcon"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    self.iconView = imageView;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *dateLabel = [UILabel new];
    dateLabel.textColor = [UIColor colorWithHexString:@"#0179ff"];
    dateLabel.font = [UIFont systemFontOfSize:8];
    [self addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
    UILabel *sizeLabel = [UILabel new];
    sizeLabel.textColor = [UIColor colorWithHexString:@"#0179ff"];
    sizeLabel.font = [UIFont systemFontOfSize:8];
    [self addSubview:sizeLabel];
    self.sizeLabel = sizeLabel;
    
    UIImageView *hdImgView = [[UIImageView alloc] init];
    hdImgView.image = [UIImage imageNamed:@"hd_icon"];
    hdImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:hdImgView];
    self.hdImgView = hdImgView;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(8);
        make.centerY.equalTo(imageView.mas_centerY).offset(-5);
        make.right.equalTo(hdImgView.mas_left).offset(-8);
    }];
    
    [hdImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.equalTo(titleLabel.mas_centerY).offset(0);
        make.width.height.mas_equalTo(18);
    }];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_left);
        make.top.equalTo(titleLabel.mas_bottom).offset(3);
    }];
    
    [sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.equalTo(dateLabel.mas_centerY);
    }];
    
}

- (void)setModel:(MagneticModel *)model {
    _model = model;
    
    self.titleLabel.text = model.text;
    self.dateLabel.text = [NSString stringWithFormat:@"日期: %@", model.date];
    self.sizeLabel.text = [NSString stringWithFormat:@"大小: %@", model.size];
    
    self.hdImgView.hidden = !model.isHD;
    
}

@end
