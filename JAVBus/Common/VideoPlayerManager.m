//
//  VideoPlayerManager.m
//  JAVBus
//
//  Created by mgfjx on 2020/3/9.
//  Copyright © 2020 mgfjx. All rights reserved.
//

#import "VideoPlayerManager.h"
#import "VideoPlayerView.h"

@interface VideoPlayerManager ()

@property (nonatomic, strong) VideoPlayerView *playerView ;

@end

@implementation VideoPlayerManager

SingletonImplement(Manager);

- (void)showPlayerWithUrl:(NSString *)videoUrl {
    
    if (self.playerView) {
        self.playerView.videoPath = videoUrl;
        return;
    }
    
    VideoPlayerView *videoView = [[VideoPlayerView alloc] initWithFrame:CGRectZero videoURL:videoUrl];
    videoView.behavior = VideoCompletedLoop;
    [[UIApplication sharedApplication].keyWindow addSubview:videoView];
    self.playerView = videoView;
    
    videoView.onVideoCloseBtnClicked = ^{
        self.playerView = nil;
    };
    
}

@end
