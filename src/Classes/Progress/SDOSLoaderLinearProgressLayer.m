//
//  SDOSLoaderLinearProgressLayer.m
//
//  Copyright © 2018 SDOS. All rights reserved.
//

#import "SDOSLoaderLinearProgressLayer.h"
#import "UIViewSDOSLoaderHelper.h"
#import <UIKit/UIKit.h>

#define kSDOSLoaderPrimaryAnimationKey @"primaryAnimation"
#define kSDOSLoaderSecondaryAnimationKey @"secondaryAnimation"

@interface SDOSLoaderLinearProgressLayer ()
@property(nonatomic) CAShapeLayer *progressLayer;
@property(nonatomic) CAShapeLayer *secondaryProgressLayer;
@property(nonatomic) CAShapeLayer *trackLayer;
@property(nonatomic) CAShapeLayer *maskLayer;

@end

@implementation SDOSLoaderLinearProgressLayer

- (instancetype)initWithSuperLayer:(CALayer *)superLayer {
  if (self = [super initWithSuperLayer:superLayer]) {
  }
  return self;
}

- (void)initContents {
  CGPoint centerInParent = CGRectCenter(self.superLayer.bounds);

  self.frame = CGRectMake(0, centerInParent.y - self.trackWidth / 2,
                          self.superLayer.bounds.size.width, self.trackWidth);

  UIBezierPath *linePath = [UIBezierPath bezierPath];
  [linePath moveToPoint:CGPointMake(0, CGRectGetMidY(self.bounds))];
  [linePath addLineToPoint:CGPointMake(self.bounds.size.width,
                                       CGRectGetMidY(self.bounds))];

  self.progressLayer = [CAShapeLayer layer];
  self.progressLayer.strokeColor = self.progressColor.CGColor;
  self.progressLayer.fillColor = nil;
  self.progressLayer.lineWidth = self.trackWidth;
  self.progressLayer.path = linePath.CGPath;
  self.progressLayer.strokeStart = 0.f;
  self.progressLayer.strokeEnd = 0.f;

  self.secondaryProgressLayer = [CAShapeLayer layer];
  self.secondaryProgressLayer.strokeColor = self.progressColor.CGColor;
  self.secondaryProgressLayer.fillColor = nil;
  self.secondaryProgressLayer.lineWidth = self.trackWidth;
  self.secondaryProgressLayer.path = linePath.CGPath;
  self.secondaryProgressLayer.strokeStart = 0.f;
  self.secondaryProgressLayer.strokeEnd = 0.f;

  self.trackLayer = [CAShapeLayer layer];
  self.trackLayer.strokeColor = self.trackColor.CGColor;
  self.trackLayer.fillColor = nil;
  self.trackLayer.lineWidth = self.trackWidth;
  self.trackLayer.path = linePath.CGPath;
  self.trackLayer.strokeStart = 0.f;
  self.trackLayer.strokeEnd = 1.f;

  self.trackLayer.frame = self.bounds;
  self.progressLayer.frame = self.bounds;

  [self addSublayer:self.trackLayer];
  [self addSublayer:self.progressLayer];
  [self addSublayer:self.secondaryProgressLayer];
}

- (void)setProgressColor:(UIColor *)progressColor {
  [super setProgressColor:progressColor];
  self.progressLayer.strokeColor = self.progressColor.CGColor;
  self.secondaryProgressLayer.strokeColor = self.progressColor.CGColor;
}

- (void)setTrackColor:(UIColor *)trackColor {
  [super setTrackColor:trackColor];
  self.trackLayer.strokeColor = self.trackColor.CGColor;
}

- (void)setTrackWidth:(float)trackWidth {
  [super setTrackWidth:trackWidth];
  self.progressLayer.lineWidth = self.trackWidth;
  self.secondaryProgressLayer.lineWidth = self.trackWidth;
  self.trackLayer.lineWidth = self.trackWidth;
}

- (void)setDeterminate:(BOOL)determinate {
  [super setDeterminate:determinate];
  if (self.determinate) {
    [self stopAnimating];
  } else {
    [self startAnimating];
  }
}

- (void)setProgress:(float)progress {
  [super setProgress:progress];
  if (!self.determinate)
    return;

  self.progressLayer.strokeEnd = self.progress;
}

- (void)startAnimating {
  if (self.isAnimating || self.determinate)
    return;

  [self.progressLayer
      addAnimation:[SDOSLoaderLinearProgressLayer primaryIndeterminateAnimation]
            forKey:kSDOSLoaderPrimaryAnimationKey];
  [self.secondaryProgressLayer
      addAnimation:[SDOSLoaderLinearProgressLayer secondaryIndeterminateAnimation]
            forKey:kSDOSLoaderSecondaryAnimationKey];
  self.isAnimating = true;
}

- (void)stopAnimating {
  if (!self.isAnimating)
    return;

  [self.progressLayer removeAllAnimations];
  [self.secondaryProgressLayer removeAllAnimations];
  self.isAnimating = false;
}

- (void)superLayerDidResize {

  CGPoint centerInParent = CGRectCenter(self.superLayer.bounds);
  self.frame = CGRectMake(0, centerInParent.y - self.trackWidth / 2,
                          self.superLayer.bounds.size.width, self.trackWidth);
  self.trackLayer.frame = self.bounds;
  self.progressLayer.frame = self.bounds;
  self.secondaryProgressLayer.frame = self.bounds;
  UIBezierPath *linePath = [UIBezierPath bezierPath];
  [linePath moveToPoint:CGPointMake(0, CGRectGetMidY(self.bounds))];
  [linePath addLineToPoint:CGPointMake(self.bounds.size.width,
                                       CGRectGetMidY(self.bounds))];
  self.trackLayer.path = linePath.CGPath;
  self.progressLayer.path = linePath.CGPath;
  self.secondaryProgressLayer.path = linePath.CGPath;
}

+ (CAAnimationGroup *)primaryIndeterminateAnimation {
  static CAAnimationGroup *animationGroups = nil;
  if (!animationGroups) {
    CABasicAnimation *headInAnimation =
        [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    headInAnimation.duration = .8f;
    headInAnimation.fromValue = @(0.f);
    headInAnimation.toValue = @(1.0f);
    headInAnimation.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

    CABasicAnimation *tailInAnimation =
        [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    tailInAnimation.duration = 1.2f;
    tailInAnimation.fromValue = @(-0.1f);
    tailInAnimation.toValue = @(1.0f);
    tailInAnimation.timingFunction =
        [CAMediaTimingFunction functionWithControlPoints:.3f:.3f:0.9f:.5f];
    CABasicAnimation *headOutAnimation =
        [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    headOutAnimation.beginTime = .8f;
    headOutAnimation.duration = .4f;
    headOutAnimation.fromValue = @(1.f);
    headOutAnimation.toValue = @(1.f);
    headOutAnimation.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    animationGroups = [CAAnimationGroup animation];
    [animationGroups
        setAnimations:@[ headInAnimation, tailInAnimation, headOutAnimation ]];
    [animationGroups setRepeatCount:INFINITY];
    animationGroups.duration = 1.8f;
    animationGroups.removedOnCompletion = false;
    animationGroups.fillMode = kCAFillModeForwards;
  }

  return animationGroups;
}

+ (CAAnimationGroup *)secondaryIndeterminateAnimation {
  static CAAnimationGroup *animationGroups = nil;
  if (!animationGroups) {
    CABasicAnimation *headInAnimation =
        [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    headInAnimation.beginTime = 1.0f;
    headInAnimation.duration = .6f;
    headInAnimation.fromValue = @(0.f);
    headInAnimation.toValue = @(1.0f);
    headInAnimation.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

    CABasicAnimation *tailInAnimation =
        [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    tailInAnimation.beginTime = 1.2f;
    tailInAnimation.duration = 0.6f;
    tailInAnimation.fromValue = @(-0.f);
    tailInAnimation.toValue = @(1.2f);
    tailInAnimation.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    CABasicAnimation *headOutAnimation =
        [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    headOutAnimation.beginTime = 1.6f;
    headOutAnimation.duration = .2f;
    headOutAnimation.fromValue = @(1.f);
    headOutAnimation.toValue = @(1.f);
    headOutAnimation.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    animationGroups = [CAAnimationGroup animation];
    [animationGroups
        setAnimations:@[ headInAnimation, tailInAnimation, headOutAnimation ]];
    [animationGroups setRepeatCount:INFINITY];
    animationGroups.duration = 1.8f;
    animationGroups.removedOnCompletion = false;
    animationGroups.fillMode = kCAFillModeForwards;
  }

  return animationGroups;
}

@end
