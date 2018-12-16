//
//  UIView+SetFrame.h
//  CoreTextDemo
//
//  Created by mgfjx on 16/6/28.
//  Copyright © 2016年 XXL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AddFunc)

/**
 @brief Create a snapshot image of view
 */
- (nullable UIImage *)snapshotImage;

/**
 @brief set view's layer shadow
 
 @param color	Shadow color
 @param offset	Shadow offset
 @param radius	Shadow radius
 */
- (void)setLayerShadow:(nullable UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

/**
 @brief remove all subviews
 */
- (void)removeAllSubViews;

/**
 @brief Returns the view's view controller (may be nil).
 */
@property (nullable, nonatomic, readonly) UIViewController *viewController;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@end
