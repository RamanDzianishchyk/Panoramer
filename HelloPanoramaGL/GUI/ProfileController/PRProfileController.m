//
//  PRProfileController.m
//  Panoramer
//
//  Created by Vladimir on 4/22/16.
//  Copyright © 2016 GRSU. All rights reserved.
//

#import "ATMenuBaseController+Protected.h"
#import "PRProfileController.h"
#import "PRSettingsController.h"

@interface PRProfileController ()

- (void)onSettingsBtnTap;

@end

@implementation PRProfileController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Профиль";

  UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsBtnTap)];
  [anotherButton setImage:[UIImage imageNamed:@"settingsIcon.png"]];
  self.navigationItem.rightBarButtonItem = anotherButton;
}

#pragma mark - Actions
- (void)onSettingsBtnTap {
  PRSettingsController *vc = [PRSettingsController new];
  __weak typeof(self) weakSelf = self;
  vc.completion = ^{
    [weakSelf.tabBarController.tabBar setAlpha:1.0];
  };
  [UIView animateWithDuration:0.5
                   animations:^{
                     [weakSelf.tabBarController.tabBar setAlpha:0.0];
                   }];
  [self.navigationController pushViewController:vc animated:YES];
}

@end
