//
//  GGDriveFileCell.h
//  JAVBus
//
//  Created by mgfjx on 2020/3/12.
//  Copyright © 2020 mgfjx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GGDriveFileCell : UITableViewCell

@property (strong, nonatomic) DBFILESFileMetadata *file;
@property (nonatomic, copy) void (^recoverCallback) (DBFILESFileMetadata *file) ;

@end

NS_ASSUME_NONNULL_END
