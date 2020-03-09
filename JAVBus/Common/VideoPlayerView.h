//
//  VideoPlayerView.h
//  CoreAnimation
//
//  Created by 谢小龙 on 16/6/13.
//  Copyright © 2016年 xintong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol VideoPlayerViewDelegate <NSObject>

- (void)onVideoCloseBtnClicked;

@end

@interface VideoPlayerView : UIView

- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSString *)videoURl;

@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, weak) id<VideoPlayerViewDelegate> delegate;

@end
