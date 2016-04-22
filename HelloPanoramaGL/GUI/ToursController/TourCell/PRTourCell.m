//
//  PRTourCell.m
//  Panoramer
//
//  Created by Vladimir on 12/6/15.
//  Copyright © 2015 GRSU. All rights reserved.
//

#import "PRTourCell.h"

@interface PRTourCell ()

@property(weak, nonatomic) IBOutlet UIView *containerView;
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewOffsetConstraint;

- (void)playMoveAnimation;

@end

@implementation PRTourCell

- (void)awakeFromNib {
  [super awakeFromNib];
  [self.titleLabel setBackgroundColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
}

#pragma mark - Public Interface
- (void)setImage:(UIImage *)image {
  if (image != nil) {
    [self.imageView setImage:image];
    [self playMoveAnimation];
  }
}

- (void)roundCell {
  [self layoutIfNeeded];
  [self.containerView setCornersRadius:5 withBorderWidth:1 withBorderColor:[UIColor clearColor]];
  [self.titleLabel setCorner:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                      radius:5
             withBorderWidth:1
             withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
}

#pragma mark - Private Interface
- (void)playMoveAnimation {
  int offset = (int)fabsf(self.imageViewOffsetConstraint.constant);
  CGFloat duration = arc4random() % 4 + 2;
  CGFloat delay = arc4random() % 4 + 2;
  int xPos = arc4random() % offset + 1;
  int yPos = arc4random() % offset + 1;
  [UIView animateWithDuration:duration
      animations:^{
        CGRect frame = self.imageView.bounds;
        CGRect offsetFrame = CGRectOffset(frame, xPos - 2 * offset, yPos - 2 * offset);
        self.imageView.frame = offsetFrame;
      }
      completion:^(BOOL finished) {
        if (finished) {
          [self performSelector:@selector(playMoveAnimation) withObject:nil afterDelay:delay];
        }
      }];
}

@end
