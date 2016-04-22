//
//  ATMenuBaseController.m
//  Training
//
//  Created by Roman on 11/25/15.
//  Copyright © 2015 Senla. All rights reserved.
//

#import "ATMenuBaseController+Protected.h"
#import "ATMenuBaseController.h"
#import "TopBar.h"

@interface ATMenuBaseController ()
@end

@implementation ATMenuBaseController {
  TopBar *topBar_;
}

- (void)viewDidLoad {
  topBar_ = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TopBar class]) owner:self options:nil] firstObject];
  [self.view addSubview:topBar_];
  [topBar_ autoPinEdgeToSuperviewEdge:ALEdgeTop];
  [topBar_ autoPinEdgeToSuperviewEdge:ALEdgeLeft];
  [topBar_ autoPinEdgeToSuperviewEdge:ALEdgeRight];
  [topBar_ autoSetDimension:ALDimensionHeight toSize:kPRTopBarHeight];
}

- (void)viewWillDisappear:(BOOL)animated {
  if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
    if (self.completion != nil) {
      self.completion();
    }
  }
  [super viewWillDisappear:animated];
}

- (void)lockScreen:(BOOL)lock {
  [self.view setUserInteractionEnabled:!lock];
}

#pragma mark - Protected Interfaces
- (void)setTopBarEnabled:(BOOL)enabled {
  [topBar_ setUserInteractionEnabled:enabled];
}

- (UIButton *)rightTopButton {
  return topBar_.rightButton;
}

- (UIButton *)leftTopButton {
  return topBar_.leftButton;
}

- (void)setOnRightTopButtonTapBlock:(void (^)(void))block {
  topBar_.onRightButtonTap = block;
}

- (void)setOnLeftTopButtonTapBlock:(void (^)(void))block {
  topBar_.onLeftButtonTap = block;
}

- (void (^)(void))onLeftTopButtonTapBlock {
  return topBar_.onLeftButtonTap;
}

- (void)setTopBarTitle:(NSString *)title {
  [topBar_ setTitle:title];
}

- (void)setTopBarTitleColor:(UIColor *)color {
  [topBar_ setTitleColor:color];
}

- (void)setTopBarAttributedTitle:(NSAttributedString *)attributedTitle {
  [topBar_ setAttributedTitle:attributedTitle];
}

- (void)setTopBarColor:(UIColor *)color {
  [topBar_ setBackgroundColor:color];
}

- (void)setTopBarBottomBorderColor:(UIColor *)color {
  [topBar_.bottomBorder setBackgroundColor:color];
}

- (void)setTopBarHidden:(BOOL)hidden {
  [topBar_ setHidden:hidden];
}

@end
