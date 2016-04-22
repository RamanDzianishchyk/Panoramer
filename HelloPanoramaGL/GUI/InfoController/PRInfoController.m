//
//  PRInfoController.m
//  Panoramer
//
//  Created by Vladimir on 12/13/15.
//  Copyright © 2015 GRSU. All rights reserved.
//

#import "PRInfoController.h"

@interface PRInfoController ()<UIScrollViewDelegate>

@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property(weak, nonatomic) IBOutlet UIImageView *imagView;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(weak, nonatomic) IBOutlet UIButton *closeButton;
@property(weak, nonatomic) IBOutlet UITextView *textView;
@property(weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *pageControlConstraintHeight;

@end

@implementation PRInfoController {
  BOOL isImageInfo_;
}

- (instancetype)initForImageInfo:(BOOL)imageInfo {
  self = [super init];
  if (self != nil) {
    isImageInfo_ = imageInfo;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.scrollView setAlpha:(isImageInfo_) ? 1.0 : 0.0];
  [self.textView setAlpha:(!isImageInfo_) ? 1.0 : 0.0];

  [self.textView setCornersRadius:10 withBorderWidth:1 withBorderColor:[UIColor whiteColor]];
  [self.titleLabel setTextColor:[UIColor whiteColor]];
  [self.textView setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1)];
  [self.view setCornersRadius:10 withBorderWidth:1 withBorderColor:[UIColor clearColor]];
  [self.view setBackgroundColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.closeButton setCornersRadius:10 withBorderWidth:1 withBorderColor:[UIColor whiteColor]];

  if (self.image != nil && self.mainDescriprion.length > 0) {
    self.pageControlConstraintHeight.constant = 40;
    [self.pageControl setHidden:NO];
  } else {
    self.pageControlConstraintHeight.constant = 0;
    [self.pageControl setHidden:YES];
  }
}

- (void)setImage:(UIImage *)image {
  _image = image;
  [self.imagView setImage:self.image];
  [self.scrollView setZoomScale:1];
  [self.scrollView setContentOffset:CGPointZero];

  if (self.image != nil && self.mainDescriprion.length > 0) {
    self.pageControlConstraintHeight.constant = 40;
    [self.pageControl setHidden:NO];
  } else {
    self.pageControlConstraintHeight.constant = 0;
    [self.pageControl setHidden:YES];
  }
}

- (void)setMainTitle:(NSString *)mainTitle {
  _mainTitle = mainTitle;
  [self.titleLabel setText:self.mainTitle];
}

- (void)setMainDescriprion:(NSString *)mainDescriprion {
  _mainDescriprion = mainDescriprion;
  [self.textView setText:self.mainDescriprion];

  if (self.image != nil && self.mainDescriprion.length > 0) {
    self.pageControlConstraintHeight.constant = 40;
    [self.pageControl setHidden:NO];
  } else {
    self.pageControlConstraintHeight.constant = 0;
    [self.pageControl setHidden:YES];
  }
}

#pragma mark - Acitons
- (IBAction)onCloseButtonTap:(UIButton *)sender {
  if (self.onCloseButtonTap != nil) {
    self.onCloseButtonTap();
  }
}

- (IBAction)pageControlChangedValue:(UIPageControl *)sender {
  if (sender.currentPage == 0) {
    isImageInfo_ = YES;
  } else {
    isImageInfo_ = NO;
  }
  [UIView animateWithDuration:0.2
                   animations:^{
                     [self.scrollView setAlpha:(isImageInfo_) ? 1.0 : 0.0];
                     [self.textView setAlpha:(!isImageInfo_) ? 1.0 : 0.0];
                   }];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.imagView;
}

@end
