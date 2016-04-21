//
//  UIView+CornerRadiusForAngles.m
//  Taxi
//
//  Created by Roman on 1/8/15.
//  Copyright (c) 2015 Dancosoft. All rights reserved.
//

#import "UIView+CornerRadius.h"

@implementation UIView (CornerRadius)

- (void)setCorner:(UIRectCorner)corners radius:(CGFloat)radius {
  [self setCorner:corners radiusWithSize:CGSizeMake(radius, radius)];
}

- (void)setCorner:(UIRectCorner)corners radiusWithSize:(CGSize)size {
  UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:size];
  [maskPath setLineJoinStyle:kCGLineJoinRound];
  CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
  maskLayer.frame = self.bounds;
  maskLayer.path = maskPath.CGPath;
  self.layer.mask = maskLayer;
  self.clipsToBounds = YES;
}

- (void)setCornersRadius:(CGFloat)radius withBorderWidth:(CGFloat)width withBorderColor:(UIColor *)color {
  [self.layer setBorderWidth:width];
  [self.layer setBorderColor:color.CGColor];
  [self.layer setCornerRadius:radius];
  [self.layer setMasksToBounds:YES];
}

- (void)setCorner:(UIRectCorner)corners radius:(CGFloat)radius withBorderWidth:(CGFloat)width withBorderColor:(UIColor *)color {
  self.layer.mask = nil;

  UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
  maskPath.lineJoinStyle = kCGLineJoinRound;
  CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
  maskLayer.frame = self.bounds;
  maskLayer.path = maskPath.CGPath;

  self.layer.mask = maskLayer;

  CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
  borderLayer.frame = self.bounds;
  borderLayer.path = maskPath.CGPath;
  borderLayer.lineWidth = width;
  borderLayer.strokeColor = color.CGColor;
  borderLayer.fillColor = [UIColor clearColor].CGColor;

  [self.layer addSublayer:borderLayer];
}

@end
