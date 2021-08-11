//
//  JXCategoryIndicatorBallView.m
//  JXCategoryView
//
//  Created by jiaxin on 2018/8/21.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "JXCategoryIndicatorBallView.h"
#import "JXCategoryFactory.h"

@interface JXCategoryIndicatorBallView ()
@property (nonatomic, strong) UIView *smallBall;
@property (nonatomic, strong) UIView *bigBall;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation JXCategoryIndicatorBallView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _ballViewSize = CGSizeMake(15, 15);
        _ballScrollOffsetX = 20;
        _ballViewColor = [UIColor redColor];

        _smallBall = [[UIView alloc] init];
        [self addSubview:self.smallBall];

        _bigBall = [[UIView alloc] init];
        [self addSubview:self.bigBall];

        _shapeLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.shapeLayer];
    }
    return self;
}

#pragma mark - JXCategoryComponentProtocol

- (void)jx_refreshState:(CGRect)selectedCellFrame {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.shapeLayer.fillColor = self.ballViewColor.CGColor;
    [CATransaction commit];
    self.smallBall.backgroundColor = self.ballViewColor;
    self.smallBall.layer.cornerRadius = self.ballViewSize.height/2;
    self.bigBall.backgroundColor = self.ballViewColor;
    self.bigBall.layer.cornerRadius = self.ballViewSize.height/2;

    CGFloat x = selectedCellFrame.origin.x + (selectedCellFrame.size.width - self.ballViewSize.width)/2;
    CGFloat y = self.superview.bounds.size.height - self.ballViewSize.height - self.verticalMargin;
    if (self.componentPosition == JXCategoryComponentPosition_Top) {
        y = self.verticalMargin;
    }
    self.smallBall.frame = CGRectMake(x, y, self.ballViewSize.width, self.ballViewSize.height);
    self.bigBall.frame = CGRectMake(x, y, self.ballViewSize.width, self.ballViewSize.height);
}

- (void)jx_contentScrollViewDidScrollWithLeftCellFrame:(CGRect)leftCellFrame rightCellFrame:(CGRect)rightCellFrame selectedPosition:(JXCategoryCellClickedPosition)selectedPosition percent:(CGFloat)percent {

    CGFloat targetXOfBigBall = leftCellFrame.origin.x + (leftCellFrame.size.width - self.ballViewSize.width)/2;
    CGFloat targetXOfSmallBall = leftCellFrame.origin.x + (leftCellFrame.size.width - self.ballViewSize.width)/2;
    CGFloat targetWidthOfSmallBall = self.ballViewSize.width;

    if (percent == 0) {
        targetXOfBigBall = leftCellFrame.origin.x + (leftCellFrame.size.width - self.ballViewSize.width)/2.0;
        targetXOfSmallBall = leftCellFrame.origin.x + (leftCellFrame.size.width - targetWidthOfSmallBall)/2.0;
    }else {
        CGFloat leftX = leftCellFrame.origin.x + (leftCellFrame.size.width - self.ballViewSize.width)/2;
        CGFloat rightX = rightCellFrame.origin.x + (rightCellFrame.size.width - self.ballViewSize.width)/2;

        //前50%，移动bigBall的x，缩小smallBall；后50%，移动bigBall的x，缩小smallBall，移动smallBall的x
        if (percent <= 0.5) {
            targetXOfBigBall = [JXCategoryFactory interpolationFrom:leftX to:(rightX - self.ballScrollOffsetX) percent:percent*2];
            targetWidthOfSmallBall = [JXCategoryFactory interpolationFrom:self.ballViewSize.width to:self.ballViewSize.width/2 percent:percent*2];
        }else {
            targetXOfBigBall = [JXCategoryFactory interpolationFrom:(rightX - self.ballScrollOffsetX) to:rightX percent:(percent - 0.5)*2];
            targetWidthOfSmallBall = [JXCategoryFactory interpolationFrom:self.ballViewSize.width/2 to:0 percent:(percent - 0.5)*2];
            targetXOfSmallBall = [JXCategoryFactory interpolationFrom:leftX to:rightX percent:(percent - 0.5)*2];
        }
    }

    //允许变动frame的情况：1、允许滚动；2、不允许滚动，但是已经通过手势滚动切换一页内容了；
    if (self.scrollEnabled == YES || (self.scrollEnabled == NO && percent == 0)) {
        CGRect bigBallFrame = self.bigBall.frame;
        bigBallFrame.origin.x = targetXOfBigBall;
        self.bigBall.frame = bigBallFrame;
        self.bigBall.layer.cornerRadius = bigBallFrame.size.height/2;

        CGFloat targetYOfSmallBall = self.superview.bounds.size.height - self.ballViewSize.height/2 - targetWidthOfSmallBall/2 - self.verticalMargin;
        if (self.componentPosition == JXCategoryComponentPosition_Top) {
            targetYOfSmallBall = self.ballViewSize.height/2 - targetWidthOfSmallBall/2 + self.verticalMargin;
        }
        self.smallBall.frame = CGRectMake(targetXOfSmallBall, targetYOfSmallBall, targetWidthOfSmallBall, targetWidthOfSmallBall);
        self.smallBall.layer.cornerRadius = targetWidthOfSmallBall/2;

        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.shapeLayer.path = [self getBezierPathWithSmallCir:self.smallBall andBigCir:self.bigBall].CGPath;
        [CATransaction commit];
    }
}

- (void)jx_selectedCell:(CGRect)cellFrame clickedRelativePosition:(JXCategoryCellClickedPosition)clickedRelativePosition {

    CGFloat x = cellFrame.origin.x + (cellFrame.size.width - self.ballViewSize.width)/2;
    CGFloat y = self.superview.bounds.size.height - self.ballViewSize.height - self.verticalMargin;
    if (self.componentPosition == JXCategoryComponentPosition_Top) {
        y = self.verticalMargin;
    }
    CGRect toFrame = CGRectMake(x, y, self.ballViewSize.width, self.ballViewSize.height);

    if (self.scrollEnabled) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.smallBall.frame = toFrame;
            self.bigBall.frame = toFrame;
            self.smallBall.layer.cornerRadius = self.ballViewSize.height/2;
            self.bigBall.layer.cornerRadius = self.ballViewSize.height/2;
        } completion:^(BOOL finished) {

        }];
    }else {
        self.smallBall.frame = toFrame;
        self.bigBall.frame = toFrame;
        self.smallBall.layer.cornerRadius = self.ballViewSize.height/2;
        self.bigBall.layer.cornerRadius = self.ballViewSize.height/2;
    }
}

- (UIBezierPath *)getBezierPathWithSmallCir:(UIView *)smallCir andBigCir:(UIView *)bigCir{
    //    获取最小的圆
    if (bigCir.frame.size.width < smallCir.frame.size.width) {
        UIView *view = bigCir;
        bigCir = smallCir;
        smallCir = view;
    }
    //    获取小圆的信息
    CGFloat d = self.bigBall.center.x - self.smallBall.center.x;
    if (d == 0) {
        return nil;
    }
    CGFloat x1 = smallCir.center.x;
    CGFloat y1 = smallCir.center.y;
    CGFloat r1 = smallCir.bounds.size.width/2;

    //    获取大圆的信息
    CGFloat x2 = bigCir.center.x;
    CGFloat y2 = bigCir.center.y;
    CGFloat r2 = bigCir.bounds.size.width/2;

    //    获取三角函数
    CGFloat sinA = (y2 - y1)/d;
    CGFloat cosA = (x2 - x1)/d;

    //    获取矩形四个点
    CGPoint pointA = CGPointMake(x1 - sinA*r1, y1 + cosA * r1);
    CGPoint pointB = CGPointMake(x1 + sinA*r1, y1 - cosA * r1);
    CGPoint pointC = CGPointMake(x2 + sinA*r2, y2 - cosA * r2);
    CGPoint pointD = CGPointMake(x2 - sinA*r2, y2 + cosA * r2);

    //    获取控制点，以便画出曲线
    CGPoint pointO = CGPointMake(pointA.x + d / 2 * cosA , pointA.y + d / 2 * sinA);
    CGPoint pointP =  CGPointMake(pointB.x + d / 2 * cosA , pointB.y + d / 2 * sinA);

    //    创建路径
    UIBezierPath *path =[UIBezierPath bezierPath];
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    [path addLineToPoint:pointD];
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    return path;
}

@end
