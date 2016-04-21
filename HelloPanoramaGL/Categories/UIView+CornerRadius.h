//
//  UIView+CornerRadiusForAngles.h
//  Taxi
//
//  Created by Roman on 1/8/15.
//  Copyright (c) 2015 Dancosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CornerRadius)

- (void)setCorner:(UIRectCorner)corners radius:(CGFloat)radius;
- (void)setCorner:(UIRectCorner)corners radiusWithSize:(CGSize)size;
- (void)setCornersRadius:(CGFloat)radius withBorderWidth:(CGFloat)width withBorderColor:(UIColor *)color;

- (void)setCorner:(UIRectCorner)corners radius:(CGFloat)radius withBorderWidth:(CGFloat)width withBorderColor:(UIColor *)color;

@end
