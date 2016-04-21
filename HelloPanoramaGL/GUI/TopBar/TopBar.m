//
//  TopBar.m
//  Businer
//
//  Created by Dzmitry on 25/5/15.
//  Copyright (c) 2015 Dancosoft. All rights reserved.
//

#import "TopBar.h"

@interface TopBar ()

- (IBAction)onLeftButtonTap:(UIButton *)sender;
- (IBAction)onRightButtonTap:(UIButton *)sender;

@end

@implementation TopBar {
  IBOutlet UILabel *titleLabel_;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Private methods
- (IBAction)onLeftButtonTap:(UIButton *)sender {
  if (self.onLeftButtonTap != nil) {
    self.onLeftButtonTap();
  }
}

- (IBAction)onRightButtonTap:(UIButton *)sender {
  if (self.onRightButtonTap != nil) {
    self.onRightButtonTap();
  }
}

#pragma mark - Public methods
- (void)setTitle:(NSString *)title {
  [titleLabel_ setText:title];
}

- (void)setTitleColor:(UIColor *)titleColor {
  [titleLabel_ setTextColor:titleColor];
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle {
  [titleLabel_ setAttributedText:attributedTitle];
}

@end
