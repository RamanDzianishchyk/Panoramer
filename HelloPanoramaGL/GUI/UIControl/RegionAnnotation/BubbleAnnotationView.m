//
//  RegionAnnotationView.m
//  LondonTalks
//
//  Created by Dario Banno on 13/02/2013.
//  Copyright (c) 2013 Dario Banno. All rights reserved.
//

#import "BubbleAnnotationView.h"
#import "RegionAnnotation.h"

NSString *const kLTAnnotationViewReuseID = @"kLTAnnotationView";

static CGFloat const kLTAnnotationViewStandardWidth = 32.0f;
static CGFloat const kLTAnnotationViewStandardHeight = 40.0f;
static CGFloat const kLTAnnotationViewExpandOffset = 220.0f;
static CGFloat const kLTAnnotationViewAnimationDuration = 0.25f;
static CGFloat const kLTRotation = 1.25;
static CGFloat const kLTCalloutRadius = 7;
static CGFloat const kLTStandartElementsHorizontalOffset = 15.0f;
static CGFloat const kLTStandartElementsVerticalOffset = 10.0f;
static CGFloat const kLTDefaultCalloutSize = 60;
static NSInteger const kLTMaxTitleLabelLinesCount = 3;

@interface BubbleAnnotationView ()

@property(nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property(nonatomic, assign) AnnotationViewState state;

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIView *pinView;
@property(nonatomic, strong) UIImageView *pinImageView;
@property(nonatomic, strong) UIButton *leftButton;
@property(nonatomic, strong) UIButton *rightButton;
@property(nonatomic, strong) UILabel *pinLabel;
@property(nonatomic, strong) CAShapeLayer *bgLayer;

@property(nonatomic, strong) NSLayoutConstraint *titleViewWidthConstraint;
@property(nonatomic, strong) NSLayoutConstraint *titleViewCenterXConstraint;
@property(nonatomic, strong) NSLayoutConstraint *imageViewHeightConstraint;

@property(nonatomic, strong) ActionBlock leftButtonActionBlock;
@property(nonatomic, strong) ActionBlock rightButtonActionBlock;

- (void)setupView;
- (void)setupPinView;
- (void)setupImageView;
- (void)setupTitleLabel;
- (void)setLayerProperties;
- (void)setupLeftButton;
- (void)setupRightButton;

- (void)updatePinImage;
- (void)updateImageView;
- (void)updateTitleLabel;

- (CGSize)interactivePartSize;
- (BOOL)emptyRegionContaintsPoint:(CGPoint)point;
- (CGPathRef)newBubbleWithRect:(CGRect)rect;

- (void)expand;
- (void)shrink;
- (void)setDetailGroupAlpha:(CGFloat)alpha;
- (void)leftButtonTap;
- (void)rightButtonTap;
- (void)animateBubbleWithDirection:(AnnotationViewAnimationDirection)animationDirection;

@end

@implementation BubbleAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation {
  self = [self initWithAnnotation:annotation mapView:nil];

  return self;
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation mapView:(MKMapView *)mapView {
  self = [super initWithAnnotation:annotation reuseIdentifier:[annotation title]];

  if (self) {
    // override
    self.multipleTouchEnabled = NO;
    self.draggable = NO;
    self.mapView = mapView;
    self.canShowCallout = NO;
    self.frame = CGRectMake(0, 0, kLTAnnotationViewStandardWidth, kLTAnnotationViewStandardHeight);
    self.backgroundColor = [UIColor clearColor];
    self.centerOffset = CGPointMake(0, -kLTAnnotationViewStandardHeight / 2.0f);
    self.state = AnnotationViewStateCollapsed;

    [self setupPinView];
    // custom properties
    self.theAnnotation = (RegionAnnotation *)annotation;
  }

  return self;
}

- (void)setLeftActionButton:(UIButton *)leftButton {
  self.leftButton = leftButton;
}

- (void)setRightActionButton:(UIButton *)rightButton {
  self.rightButton = rightButton;
}

- (void)updateWithAnnotation:(RegionAnnotation *)annotation {
  self.theAnnotation = annotation;
  self.coordinate = annotation.coordinate;
  self.leftButtonActionBlock = annotation.leftButtonActionBlock;
  self.rightButtonActionBlock = annotation.rightButtonActionBlock;
}

#pragma mark - SetupDetailViews
- (void)setupView {
  [self setupPinView];
  [self setLayerProperties];
  [self setupTitleLabel];
  [self setupImageView];
  [self setupLeftButton];
  [self setupRightButton];
  [self setDetailGroupAlpha:0.0f];
}

- (void)setupPinView {
  if (self.pinView != nil) {
    [self updatePinImage];
    return;
  }
  self.pinView = [[UIView alloc] initWithFrame:self.frame];
  [self.pinView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self addSubview:self.pinView];

  self.pinImageView =
      [[UIImageView alloc] initWithFrame:CGRectMake(kLTAnnotationViewStandardWidth / 4, kLTAnnotationViewStandardHeight / 8, self.pinView.frame.size.width,
                                                    self.pinView.frame.size.height - kLTAnnotationViewStandardHeight / 8)];
  [self.pinView addSubview:self.pinImageView];

  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pinView
                                                   attribute:NSLayoutAttributeBottom
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeBottom
                                                  multiplier:1
                                                    constant:0]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pinView
                                                   attribute:NSLayoutAttributeCenterX
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeCenterX
                                                  multiplier:1
                                                    constant:0]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pinView
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:nil
                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                  multiplier:1
                                                    constant:self.pinView.frame.size.width]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pinView
                                                   attribute:NSLayoutAttributeHeight
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:nil
                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                  multiplier:1
                                                    constant:self.pinView.frame.size.height]];

  self.pinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kLTAnnotationViewStandardHeight / 8, 14, 14)];
  [self.pinLabel setCenter:CGPointMake(self.pinView.center.x - 1, self.pinLabel.center.y + 1)];
  [self.pinLabel setTextAlignment:NSTextAlignmentCenter];
  [self.pinView addSubview:self.pinLabel];

  [self updatePinImage];
}

- (void)setupImageView {
  if (self.imageView != nil) {
    [self updateImageView];
    return;
  }
  self.imageView = [[UIImageView alloc] initWithImage:self.theAnnotation.image];
  self.imageView.contentMode = UIViewContentModeScaleAspectFill;
  [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  self.imageView.layer.cornerRadius = 4.0f;
  self.imageView.layer.masksToBounds = YES;
  self.imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
  self.imageView.layer.borderWidth = 0.5f;
  [self addSubview:self.imageView];

  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                   attribute:NSLayoutAttributeLeft
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeLeft
                                                  multiplier:1
                                                    constant:kLTStandartElementsVerticalOffset]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                   attribute:NSLayoutAttributeRight
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeRight
                                                  multiplier:1
                                                    constant:-kLTStandartElementsVerticalOffset]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeTop
                                                  multiplier:1
                                                    constant:kLTStandartElementsVerticalOffset]];
  [self updateImageView];
}

- (void)setupTitleLabel {
  if (self.titleLabel != nil) {
    [self updateTitleLabel];
    return;
  }
  self.titleLabel = [[UILabel alloc] init];
  [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
  self.titleLabel.textColor = [UIColor whiteColor];
  self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
  self.titleLabel.adjustsFontSizeToFitWidth = YES;
  self.titleLabel.minimumScaleFactor = 0.5f;
  self.titleLabel.numberOfLines = kLTMaxTitleLabelLinesCount;
  [self addSubview:self.titleLabel];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                   attribute:NSLayoutAttributeHeight
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:nil
                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                  multiplier:1
                                                    constant:[self interactivePartSize].height]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                   attribute:NSLayoutAttributeBottom
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeBottom
                                                  multiplier:1
                                                    constant:-(1.2 * kLTAnnotationViewStandardHeight + kLTStandartElementsVerticalOffset)]];
  [self updateTitleLabel];
}

- (void)setupLeftButton {
  if (self.leftButton == nil || self.leftButton.constraints.count > 0) {
    return;
  }
  [self.leftButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.leftButton addTarget:self action:@selector(leftButtonTap) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:self.leftButton];

  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftButton
                                                   attribute:NSLayoutAttributeLeft
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeLeft
                                                  multiplier:1
                                                    constant:kLTStandartElementsHorizontalOffset]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftButton
                                                   attribute:NSLayoutAttributeCenterY
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.titleLabel
                                                   attribute:NSLayoutAttributeCenterY
                                                  multiplier:1
                                                    constant:0]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftButton
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:nil
                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                  multiplier:1
                                                    constant:self.leftButton.frame.size.width]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftButton
                                                   attribute:NSLayoutAttributeHeight
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:nil
                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                  multiplier:1
                                                    constant:self.leftButton.frame.size.height]];
}

- (void)setupRightButton {
  if (self.rightButton == nil || self.rightButton.constraints.count > 0) {
    return;
  }
  [self.rightButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.rightButton addTarget:self action:@selector(rightButtonTap) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:self.rightButton];

  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButton
                                                   attribute:NSLayoutAttributeRight
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeRight
                                                  multiplier:1
                                                    constant:-kLTStandartElementsHorizontalOffset]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButton
                                                   attribute:NSLayoutAttributeCenterY
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.titleLabel
                                                   attribute:NSLayoutAttributeCenterY
                                                  multiplier:1
                                                    constant:0]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButton
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:nil
                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                  multiplier:1
                                                    constant:25]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButton
                                                   attribute:NSLayoutAttributeHeight
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:nil
                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                  multiplier:1
                                                    constant:25]];
}

- (void)setLayerProperties {
  if (self.bgLayer != nil) {
    return;
  }
  self.bgLayer = [CAShapeLayer layer];
  CGPathRef path = [self newBubbleWithRect:self.bounds];
  self.bgLayer.path = path;
  CFRelease(path);
  self.bgLayer.fillColor = UIColorFromHexRGB(kPRMainThemeColor, 1.0).CGColor;

  self.bgLayer.shadowColor = [UIColor blackColor].CGColor;
  self.bgLayer.shadowOffset = CGSizeMake(0.0f, 3.0f);
  self.bgLayer.shadowRadius = 2.0f;
  self.bgLayer.shadowOpacity = 0.5f;

  self.bgLayer.masksToBounds = NO;
  self.bgLayer.hidden = YES;

  [self.layer insertSublayer:self.bgLayer atIndex:0];
}

#pragma mark - Size
- (CGSize)interactivePartSize {
  NSString *titleText = self.theAnnotation.title;
  CGFloat leftButtonWidth = (self.leftButton == nil) ? 0 : kLTStandartElementsHorizontalOffset + 25;
  CGFloat rightButtonWidth = (self.rightButton == nil) ? 0 : kLTStandartElementsHorizontalOffset + 25;
  CGFloat maxTitleLabelWidth = kLTAnnotationViewStandardWidth + kLTAnnotationViewExpandOffset * kLTRotation - leftButtonWidth - rightButtonWidth -
                               2 * kLTStandartElementsHorizontalOffset;

  CGSize size = CGSizeMake(leftButtonWidth + rightButtonWidth + 2 * kLTStandartElementsHorizontalOffset, 0);
  UIFont *font = [UIFont boldSystemFontOfSize:17];

  CGSize titleSize = [titleText boundingRectWithSize:CGSizeMake(maxTitleLabelWidth, kLTMaxTitleLabelLinesCount * font.lineHeight)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{
                                            NSFontAttributeName : font
                                          }
                                             context:nil]
                         .size;

  return CGSizeMake(ceil(titleSize.width + size.width), 1.5 * ceil(titleSize.height));
}

#pragma mark - Updating
- (void)updatePinImage {
  UIImage *image = [UIImage imageNamed:@"pinRed"];
  [self.pinImageView setImage:image];
}

- (void)updateImageView {
  CGFloat imageViewHeight =
      self.frame.size.height - kLTAnnotationViewStandardHeight - 3 * kLTStandartElementsVerticalOffset - [self interactivePartSize].height;
  if (self.theAnnotation.image == nil) {
    imageViewHeight = 0;
  }
  if (self.imageViewHeightConstraint == nil) {
    self.imageViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1
                                                                   constant:imageViewHeight];
    [self addConstraint:self.imageViewHeightConstraint];
  } else {
    self.imageViewHeightConstraint.constant = imageViewHeight;
  }
  [self.imageView setImage:self.theAnnotation.image];
}

- (void)updateTitleLabel {
  self.titleLabel.text = self.theAnnotation.title;
  CGFloat actionButtonWidth = kLTStandartElementsHorizontalOffset + 25;
  CGFloat titleLabelWidth = self.frame.size.width - 2 * kLTStandartElementsHorizontalOffset - 2 * actionButtonWidth;
  CGFloat centerOffset = 0;

  if (self.titleViewWidthConstraint == nil) {
    self.titleViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:titleLabelWidth];
    [self addConstraint:self.titleViewWidthConstraint];
  } else if (self.titleViewWidthConstraint.constant != titleLabelWidth) {
    self.titleViewWidthConstraint.constant = titleLabelWidth;
  }

  if (self.titleViewCenterXConstraint == nil) {
    self.titleViewCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1
                                                                    constant:centerOffset];
    [self addConstraint:self.titleViewCenterXConstraint];
  } else if (self.titleViewCenterXConstraint.constant != centerOffset) {
    self.titleViewCenterXConstraint.constant = centerOffset;
  }
}

#pragma mark - AnnotationViewProtocol
- (void)didSelectAnnotationViewInMap:(MKMapView *)mapView {
  // Center map at annotation point
  if (self.theAnnotation.image == nil) {
    [mapView setCenterCoordinate:self.coordinate animated:YES];
  } else {
    CGPoint point = [mapView convertCoordinate:self.coordinate toPointToView:mapView];
    point.y -= (kLTAnnotationViewExpandOffset + 1.2 * kLTAnnotationViewStandardHeight) / 2;
    CLLocationCoordinate2D coordinate = [mapView convertPoint:point toCoordinateFromView:mapView];
    [mapView setCenterCoordinate:coordinate animated:YES];
  }

  [self expand];
}

- (void)didDeselectAnnotationViewInMap:(MKMapView *)mapView {
  [self shrink];
}

#pragma mark - Geometry
- (CGPathRef)newBubbleWithRect:(CGRect)rect {
  CGFloat radius = kLTCalloutRadius;
  CGMutablePathRef path = CGPathCreateMutable();
  CGFloat parentX = rect.origin.x + rect.size.width / 2.0f;

  // Create Callout Bubble Path
  CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
  CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - radius);
  CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI_2, 1);
  CGPathAddLineToPoint(path, NULL, parentX - 2 * radius, rect.origin.y + rect.size.height);
  CGPathAddLineToPoint(path, NULL, parentX, rect.origin.y + rect.size.height + 2 * radius);
  CGPathAddLineToPoint(path, NULL, parentX + 2 * radius, rect.origin.y + rect.size.height);
  CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height);
  CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI_2, 0.0f, 1.0f);
  CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + radius);
  CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI_2, 1.0f);
  CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
  CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI_2, M_PI, 1.0f);
  CGPathCloseSubpath(path);
  return path;
}

#pragma mark - Animations
- (void)setDetailGroupAlpha:(CGFloat)alpha {
  self.rightButton.alpha = alpha;
  self.leftButton.alpha = alpha;
  self.imageView.alpha = alpha;
  self.titleLabel.alpha = alpha;
}

- (void)expand {
  if (self.state != AnnotationViewStateCollapsed) {
    return;
  }

  self.state = AnnotationViewStateAnimating;
  CGFloat height = 1.2 * kLTAnnotationViewStandardHeight + kLTAnnotationViewExpandOffset;
  CGFloat width = kLTAnnotationViewStandardWidth + kLTAnnotationViewExpandOffset * kLTRotation;
  if (self.theAnnotation.image == nil) {
    CGSize size = [self interactivePartSize];
    width = size.width;
    height = size.height + 2 * kLTStandartElementsVerticalOffset + 1.2 * kLTAnnotationViewStandardHeight;
  }

  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
  self.centerOffset = CGPointMake(0, -self.frame.size.height / 2.0f);

  [self setupView];
  [self layoutIfNeeded];
  if (self.bgLayer.superlayer == nil) {
    [self.layer insertSublayer:self.bgLayer atIndex:0];
  }
  self.bgLayer.hidden = NO;
  [self animateBubbleWithDirection:AnnotationViewAnimationDirectionGrow];

  [UIView animateWithDuration:1.5 * kLTAnnotationViewAnimationDuration
      animations:^{
        [self setDetailGroupAlpha:1.0f];
      }
      completion:^(BOOL finished) {
        if (self.state == AnnotationViewStateAnimating) {
          self.state = AnnotationViewStateExpanded;
        }
      }];
}

- (void)shrink {
  if (self.state == AnnotationViewStateCollapsed) {
    return;
  }
  if (self.state == AnnotationViewStateAnimating) {
    [self.layer removeAllAnimations];
  }
  self.state = AnnotationViewStateAnimating;
  [self.bgLayer removeFromSuperlayer];
  [self setDetailGroupAlpha:0.0f];
  CGFloat originX = self.frame.origin.x + self.frame.size.width / 2 - kLTAnnotationViewStandardWidth / 2;
  CGFloat originY = self.frame.origin.y + self.frame.size.height - kLTAnnotationViewStandardHeight;
  self.frame = CGRectMake(originX, originY, kLTAnnotationViewStandardWidth, kLTAnnotationViewStandardHeight);
  self.centerOffset = CGPointMake(0, -self.frame.size.height / 2.0f);
  self.state = AnnotationViewStateCollapsed;
}

- (void)animateBubbleWithDirection:(AnnotationViewAnimationDirection)animationDirection {
  BOOL growing = (animationDirection == AnnotationViewAnimationDirectionGrow);

  // Bubble
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];

  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  animation.repeatCount = 1;
  animation.removedOnCompletion = NO;
  animation.fillMode = kCAFillModeForwards;
  animation.duration = kLTAnnotationViewAnimationDuration;

  // Stroke & Shadow From/To Values
  CGPathRef fromPath =
      [self newBubbleWithRect:growing ? CGRectMake(self.frame.size.width / 2 - kLTDefaultCalloutSize / 2, self.frame.size.height - kLTDefaultCalloutSize,
                                                   kLTDefaultCalloutSize, kLTDefaultCalloutSize)
                                      : self.frame];
  animation.fromValue = (__bridge id)fromPath;
  CGPathRelease(fromPath);
  CGPathRef toPath =
      [self newBubbleWithRect:growing ? CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 1.2 * kLTAnnotationViewStandardHeight) : self.bounds];
  animation.toValue = (__bridge id)toPath;
  CGPathRelease(toPath);

  [self.bgLayer addAnimation:animation forKey:animation.keyPath];
}

#pragma mark - Buttons Action
- (void)leftButtonTap {
  if (self.leftButtonActionBlock != nil) {
    self.leftButtonActionBlock();
  }
}

- (void)rightButtonTap {
  if (self.rightButtonActionBlock != nil) {
    self.rightButtonActionBlock();
  }
}

- (BOOL)emptyRegionContaintsPoint:(CGPoint)point {
  CGRect leftRegion = CGRectMake(0, self.frame.size.height - kLTAnnotationViewStandardHeight, (self.frame.size.width - kLTAnnotationViewStandardWidth) / 2,
                                 kLTAnnotationViewStandardHeight);
  CGRect rightRect = CGRectMake((self.frame.size.width + kLTAnnotationViewStandardWidth) / 2, self.frame.size.height - kLTAnnotationViewStandardHeight,
                                (self.frame.size.width - kLTAnnotationViewStandardWidth) / 2, kLTAnnotationViewStandardHeight);
  if (CGRectContainsPoint(leftRegion, point) || CGRectContainsPoint(rightRect, point)) {
    return YES;
  }

  return NO;
}

#pragma mark - Touches
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  UIView *hitView = [super hitTest:point withEvent:event];
  if (hitView == self && self.isSelected && [self emptyRegionContaintsPoint:point]) {
    [self.mapView deselectAnnotation:self.annotation animated:YES];
  } else if (hitView != nil) {
    [self.superview bringSubviewToFront:self];
  }
  return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
  CGRect rect = self.bounds;
  BOOL isInside = CGRectContainsPoint(rect, point);
  if (!isInside) {
    for (UIView *view in self.subviews) {
      isInside = CGRectContainsPoint(view.frame, point);
      if (isInside) break;
    }
  }
  return isInside;
}

@end
