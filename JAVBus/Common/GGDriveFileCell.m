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
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@end

@implementation GGDriveFileCell

- (void)setFile:(DBFILESFileMetadata *)file {
    _file = file;
    
    _titleLabel.text = file.name;
    NSDate *date = file.clientModified;
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    formate.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.dateLabel.text = [formate stringFromDate:date];
    NSInteger size = [file.size integerValue];
    NSString *text = [NSString stringWithFormat:@"%.1fm", size*1.0/(1024*1024)];
    self.sizeLabel.text = text;
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
