//
//  VideoPlayerView.m
//  CoreAnimation
//
//  Created by 谢小龙 on 16/6/13.
//  Copyright © 2016年 xintong. All rights reserved.
//

#import "VideoPlayerView.h"

@interface VideoPlayerView(){
    
    BOOL isControlViewShow;
    CGFloat contentOffsetX;
    CGFloat contentOffsetY;
    
    UIButton *closeBtn;
    UIButton *playBtn;
    
    CGSize videoSize;
    
}

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UIView *controlView;
@property (nonatomic, strong) AVAsset *asset;

@property (nonatomic, strong) UIProgressView *progressView ;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation VideoPlayerView

static CGFloat controlView_heightScale = 0.15;

- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSString *)videoPath{
    self = [super initWithFrame:frame];
    if (self) {
        
        isControlViewShow = YES;
        
        self.clipsToBounds = YES;
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"closeIcon"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        closeBtn = closeButton;
        
        //initControl views
        UIView *controlView = [[UIView alloc] init];
        controlView.backgroundColor = [UIColor colorWithRed:0.990 green:0.996 blue:0.990 alpha:0.35];
        [self addSubview:controlView];
        self.controlView = controlView;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(playAndPause:) forControlEvents:UIControlEventTouchUpInside];
        [controlView addSubview:button];
        playBtn = button;
        
        UISlider *sliderView = [[UISlider alloc] init];
        sliderView.continuous = NO;
        sliderView.minimumTrackTintColor = [UIColor blackColor];
        sliderView.maximumTrackTintColor = [UIColor lightGrayColor];
        [controlView addSubview:sliderView];
        [sliderView setThumbImage:[UIImage imageNamed:@"slider_btn"] forState:UIControlStateNormal];
        [sliderView addTarget:self action:@selector(progressSlider:) forControlEvents:UIControlEventValueChanged];
        self.slider = sliderView;
        
        UIProgressView *progressView = [[UIProgressView alloc] init];
        progressView.progress = 0.0f;
        progressView.backgroundColor = [UIColor randomColorWithAlpha:0.5];
        [controlView addSubview:progressView];
        self.progressView = progressView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToShowControlView:)];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
        [self addGestureRecognizer:pan];
        
        self.videoPath = videoPath;
    }
    return self;
}

- (void)setVideoPath:(NSString *)videoPath{
    _videoPath = videoPath;
    
    NSURL *url = [NSURL fileURLWithPath:videoPath];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    
    self.asset = asset;
    
    [asset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (asset.playable) {
                NSArray *array = self.asset.tracks;
                for (AVAssetTrack *track in array) {
                    if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
                        [self loadedResourceForPlay];
                    }
                }
            }
        });
    }];
    
}

#pragma mark - AVAsset loaded method
- (void)loadedResourceForPlay{
    
    NSArray *array = self.asset.tracks;
    
    for (AVAssetTrack *track in array) {
        NSLog(@"mediaType:%@",track.mediaType);
        NSLog(@"naturalSize:%@",NSStringFromCGSize(track.naturalSize));
        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            videoSize = track.naturalSize;
        }
    }
    
    if (self.player || self.playerLayer) {
        [self.playerLayer removeFromSuperlayer];
        self.playerLayer = nil;
        [self.player pause];
        self.player = nil;
    }
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:self.asset];
    
    AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
    
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    
    NSLog(@"playerlayer == %@",NSStringFromCGRect(layer.frame));
    
    [self.layer addSublayer:layer];
    
    self.playerLayer = layer;
    self.player = player;
    
    [self initViewsFrame];
    
    WeakSelf(weakSelf);
    [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.25, NSEC_PER_SEC) queue:NULL usingBlock:^(CMTime time) {
        //进度 当前时间/总时间
        CGFloat progress = CMTimeGetSeconds(self.player.currentItem.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
        
        if (weakSelf.slider.state != UIControlStateHighlighted) {
            [weakSelf.slider setValue:progress animated:YES];
        }
        //在这里截取播放进度并处理
        if (progress == 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf dealWithCompletedPlay];
            });
        }
    }];
    
}

- (void)initViewsFrame{
    
    self.backgroundColor = [UIColor blackColor];
    
    CGFloat width = MainWidth - 20;
    CGFloat height = 100;
    
    if (videoSize.width > videoSize.height) {
        height = width/videoSize.width * videoSize.height;
    }else{
        width = height/videoSize.height * videoSize.width;
    }
    
    CGFloat controlView_height = height * controlView_heightScale;
    
    closeBtn.frame = CGRectMake(0, 0, 30, 30);
    [self bringSubviewToFront:closeBtn];
    
    self.frame = CGRectMake((MainWidth - width)/2, kNavigationBarHeight, width, height);
    self.playerLayer.frame = self.bounds;
    
    _controlView.frame = CGRectMake(0, height - controlView_height, width, controlView_height);
    [self bringSubviewToFront:_controlView];
    playBtn.frame = CGRectMake(5, 0, controlView_height, controlView_height);
    playBtn.selected = YES;
    
    self.slider.frame = CGRectMake(CGRectGetMaxX(playBtn.frame), 0, CGRectGetWidth(_controlView.frame) - CGRectGetMaxX(playBtn.frame) - 10, 10);
    self.slider.center = CGPointMake(self.slider.center.x, CGRectGetMidY(_controlView.bounds));
    
    [self.player play];
}

- (void)dealWithCompletedPlay {
    
    if (self.behavior == VideoCompletedLoop) {
        CMTime dragedCMTime = CMTimeMake(0, 1);
        
        [_player pause];
        [_player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
            [self->_player play];
            self->playBtn.selected = YES;
        }];
    } else if (self.behavior == VideoCompletedRemove) {
        [self closeBtnClicked: nil];
    } else {
        playBtn.selected = NO;
    }
}

#pragma mark - slider滑动事件
- (void)progressSlider:(UISlider *)sliderView
{
    //拖动改变视频播放进度
    if (_player.status == AVPlayerStatusReadyToPlay) {
        
        //计算出拖动的当前秒数
        CGFloat total = (CGFloat)self.player.currentItem.duration.value / self.player.currentItem.duration.timescale;
        
        NSInteger dragedSeconds = floorf(total * sliderView.value);
        
        //        NSLog(@"dragedSeconds:%ld",dragedSeconds);
        
        //转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        
        [_player pause];
        
        [_player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
            
            [self->_player play];
            self->playBtn.selected = YES;
            
        }];
        
    }
}

#pragma mark - button event
- (void)closeBtnClicked:(UIButton *)sender{
    
    //    [self.playerLayer removeFromSuperlayer];
    //    self.playerLayer = nil;
    //    [self.player pause];
    //    self.player = nil;
    //
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onVideoCloseBtnClicked)]) {
        [self.delegate onVideoCloseBtnClicked];
    }
    
    if (self.onVideoCloseBtnClicked) {
        self.onVideoCloseBtnClicked();
    }
    
}

- (void)playAndPause:(UIButton *)sender{
    
    if (!self.asset.isPlayable) {
        return;
    }
    
    if (sender.selected) {
        [self.player pause];
    }else{
        CGFloat progress = CMTimeGetSeconds(self.player.currentItem.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
        if (progress >= 1.0f) {
            CMTime dragedCMTime = CMTimeMake(0, 1);
            
            [_player pause];
            [_player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
                [self->_player play];
                self->playBtn.selected = YES;
            }];
        }else{
            [self.player play];
        }
    }
    
    sender.selected = !sender.selected;
}

#pragma mark - UIGestureRecognizer method
- (void)tapToShowControlView:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:self];
    if (!CGRectContainsPoint(_controlView.frame, point)) {
        CGFloat controlView_height = self.frame.size.height * controlView_heightScale;
        
        CGRect controlViewFrame = self.controlView.frame;
        //        NSLog(@"controlViewFrame == %@",NSStringFromCGRect(controlViewFrame));
        controlViewFrame.origin.y = controlViewFrame.origin.y + controlView_height * (isControlViewShow ? 1 : -1);
        [UIView animateWithDuration:0.25 animations:^{
            
            self.controlView.frame = controlViewFrame;
            
        }];
        
        isControlViewShow = !isControlViewShow;
    }
}

- (void)panHandle:(UIPanGestureRecognizer *)pan{
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        CGPoint origin = [pan locationInView:pan.view];
        
        contentOffsetX = origin.x;
        contentOffsetY = origin.y;
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan locationInView:self.superview];
        CGRect frame = pan.view.frame;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat x = point.x - contentOffsetX;
        CGFloat y = point.y - contentOffsetY;
        CGFloat offset = 50;
        if (x + self.frame.size.width <= offset) {
            x = offset - self.frame.size.width;
        }
        if (x >= width - offset) {
            x = width - offset;
        }
        if (y + self.frame.size.height <= kNavigationBarHeight + offset) {
            y = kNavigationBarHeight + offset - self.frame.size.height;
        }
        if (y >= height - offset) {
            y = height - offset;
        }
        frame.origin = CGPointMake(x, y);
        pan.view.frame = frame;
    }
    
    
}


#pragma mark - KVO 
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration = [_player.currentItem duration];
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        
        [self.progressView setProgress:timeInterval / totalDuration animated:NO];
    }
    
}

//缓存进度计算
- (NSTimeInterval)availableDuration{
    
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;
    
    return result;
}

#pragma mark - dealloc
- (void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}


@end
