//
//  PRSceneCell.m
//  Panoramer
//
//  Created by Vladimir on 12/6/15.
//  Copyright © 2015 GRSU. All rights reserved.
//

#import "PRSceneCell.h"

@interface PRSceneCell ()

@property(weak, nonatomic) IBOutlet UIImageView *previewImage;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewOffsetConstraint;
@property(weak, nonatomic) IBOutlet UIView *baseContainer;
@property(weak, nonatomic) IBOutlet UIView *previewContainer;

- (void)playMoveAnimation;

@end

@implementation PRSceneCell

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setBackgroundColor:[UIColor clearColor]];
  [self.contentView setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - Public Interface
- (void)setImage:(UIImage *)image {
  if (image != nil) {
    [self.previewImage setImage:image];
    [self playMoveAnimation];
  }
}

- (void)roundCell {
  [self.baseContainer setCornersRadius:5 withBorderWidth:0 withBorderColor:nil];
  [self.previewContainer setCorner:(UIRectCornerTopLeft | UIRectCornerBottomLeft)radius:5 withBorderWidth:1 withBorderColor:[UIColor whiteColor]];
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
        CGRect frame = self.previewImage.bounds;
        CGRect offsetFrame = CGRectOffset(frame, xPos - 2 * offset, yPos - 2 * offset);
        self.previewImage.frame = offsetFrame;
      }
      completion:^(BOOL finished) {
        if (finished) {
          [self performSelector:@selector(playMoveAnimation) withObject:nil afterDelay:delay];
        }
      }];
}

@end
