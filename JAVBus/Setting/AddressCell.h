//
//  AddressCell.h
//  JAVBus
//
//  Created by mgfjx on 2018/12/23.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *indicatorView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;


@end
