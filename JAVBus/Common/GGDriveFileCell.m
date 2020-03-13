//
//  GGDriveFileCell.m
//  JAVBus
//
//  Created by mgfjx on 2020/3/12.
//  Copyright © 2020 mgfjx. All rights reserved.
//

#import "GGDriveFileCell.h"

@interface GGDriveFileCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *recoverBtn;

@end

@implementation GGDriveFileCell

- (void)setFile:(DBFILESFileMetadata *)file {
    _file = file;
    
    _titleLabel.text = file.name;
    if ([file.name isEqualToString:@"JavBus.db"]) {
        self.recoverBtn.hidden = NO;
    }else{
        self.recoverBtn.hidden = YES;
    }
    
}
- (IBAction)recoverBtnClicked:(UIButton *)sender {
    
    if (self.recoverCallback) {
        self.recoverCallback(self.file);
    }
    
}

@end
