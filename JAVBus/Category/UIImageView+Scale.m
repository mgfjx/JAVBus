//
//  UIImageView+Scale.m
//  Unity
//
//  Created by mgfjx on 2017/4/6.
//  Copyright © 2017年 XXL. All rights reserved.
//

#import "UIImageView+Scale.h"
#import <objc/runtime.h>

@interface UIImageView()<UIGestureRecognizerDelegate>

@end

@implementation UIImageView (Scale)

// 定义关联的key
static const char *key = "enableScale";

- (void)setEnableScale:(BOOL)enableScale{
    objc_setAssociatedObject(self, key, @(enableScale), OBJC_ASSOCIATION_ASSIGN);
    if (enableScale) {
        [self enableGestureOnView:self];
    }else{
        for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
            [self removeGestureRecognizer:gesture];
        }
    }
}

- (BOOL)enableScale{
    return objc_getAssociatedObject(self, key);
}

#pragma mark - View Gesture Process

- (void)enableGestureOnView:(UIView *)view{
    [view setUserInteractionEnabled:YES];
    // create and configure the pinch gesture
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureDetected:)];
    pinchGestureRecognizer.delegate = self;
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    // create and configure the rotation gesture
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureDetected:)];
    rotationGestureRecognizer.delegate = self;
    [view addGestureRecognizer:rotationGestureRecognizer];
    
    // creat and configure the pan gesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    panGestureRecognizer.delegate = self;
    [view addGestureRecognizer:panGestureRecognizer];
    
}

- (void)pinchGestureDetected:(UIPinchGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat scale = [recognizer scale];
        recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, scale, scale);
        recognizer.scale = 1.0;
    }
}

- (void)rotationGestureDetected:(UIRotationGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat rotation = [recognizer rotation];
        recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, rotation);
        recognizer.rotation = 0;
    }
}

- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        recognizer.view.transform = CGAffineTransformTranslate(recognizer.view.transform, translation.x, translation.y);
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}

@end
