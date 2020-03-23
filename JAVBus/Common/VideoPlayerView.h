//
//  VideoPlayerView.h
//  CoreAnimation
//
//  Created by 谢小龙 on 16/6/13.
//  Copyright © 2016年 xintong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, VideoCompletedBehavior) {
    VideoCompletedNone = 0, //播放完成啥也不干
    VideoCompletedRemove, //播放完成后移除视图
    VideoCompletedLoop, //播放完成后循环播放
};

@protocol VideoPlayerViewDelegate <NSObject>

- (void)onVideoCloseBtnClicked;

@end

@interface VideoPlayerView : UIView

- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSString *)videoURl;

@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, weak) id<VideoPlayerViewDelegate> delegate;

@property (nonatomic, assign) VideoCompletedBehavior behavior ;

@property (nonatomic, copy) void (^onVideoCloseBtnClicked) (void) ;

@end
