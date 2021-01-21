//
//  ActressCell.h
//  JAVBus
//
//  Created by mgfjx on 2018/12/13.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActressCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, copy) void (^longPressCallback)() ;

@end
