//
//  SettingsCell.m
//  Businer
//
//  Created by Roman on 7/13/15.
//  Copyright (c) 2015 Dancosoft. All rights reserved.
//

#import "SettingsCell.h"

@implementation SettingsCell {
  __weak IBOutlet UISwitch *switch_;
  __weak IBOutlet UIImageView *imageView_;
  __weak IBOutlet UIButton *mainButton_;
  __weak IBOutlet UIView *mainContainer_;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [mainContainer_ setBackgroundColor:[UIColor whiteColor]];
}

- (void)setType:(SettingsCellType)type {
  switch (type) {
    case SettingsCellTypeSwitch: {
      [switch_ setHidden:NO];
      [mainButton_ setHidden:YES];
      [imageView_ setHidden:YES];
      break;
    }
    case SettingsCellTypeArrow: {
      [switch_ setHidden:YES];
      [mainButton_ setHidden:NO];
      [imageView_ setHidden:NO];
      break;
    }
    case SettingsCellTypePlain:
    default: {
      [switch_ setHidden:YES];
      [mainButton_ setHidden:NO];
      [imageView_ setHidden:YES];
      break;
    }
  }
}

- (void)setSwitchState:(BOOL)on {
  switch_.on = on;
  UIColor *thumbColor = switch_.isOn ? UIColorFromHexRGB(kPRMainThemeColor, 1.0) : [UIColor grayColor];
  [switch_ setThumbTintColor:thumbColor];
}

- (IBAction)onMainButtonTap:(id)sender {
  if (self.onCellTap != nil) {
    self.onCellTap();
  }
}

- (IBAction)didChangeSwitchState:(UISwitch *)sender {
  UIColor *thumbColor = switch_.isOn ? UIColorFromHexRGB(kPRMainThemeColor, 1.0) : [UIColor grayColor];
  [switch_ setThumbTintColor:thumbColor];
  if (self.changeSwitchState != nil) {
    self.changeSwitchState(sender.on);
  }
}

- (void)roundCell {
  [self layoutIfNeeded];
  [mainContainer_ setCornersRadius:mainContainer_.frame.size.height / 3 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
}

@end
