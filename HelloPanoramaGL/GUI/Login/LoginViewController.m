//
//  LoginViewController.m
//  LondonTalks
//
//  Created by Vladimir on 10/1/15.
//  Copyright (c) 2015 Dario Banno. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property(strong, nonatomic) MBProgressHUD *progressHUD;

@property(weak, nonatomic) IBOutlet UIButton *skipButton;
@property(weak, nonatomic) IBOutlet UIButton *sigInButton;
@property(weak, nonatomic) IBOutlet UITextField *passwordTF;
@property(weak, nonatomic) IBOutlet UITextField *emailTF;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *loginImageHeightConstraint;
@property(weak, nonatomic) IBOutlet UIView *interactiveContainer;
@property(weak, nonatomic) IBOutlet UIView *bonusImagecontainer;

@end

@implementation LoginViewController

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  self.skipButton.layer.cornerRadius = 5;
  self.sigInButton.layer.cornerRadius = 5;
  self.loginImageHeightConstraint.constant =
      self.view.frame.size.height - self.interactiveContainer.frame.size.height - self.bonusImagecontainer.frame.size.height;
}

- (void)viewDidDisappear:(BOOL)animated {
  [self.progressHUD setHidden:YES];
  [super viewDidDisappear:animated];
}

#pragma mark - Actions
- (IBAction)tapOnSignInButton:(UIButton *)sender {
  NSString *password = self.passwordTF.text;
  NSString *email = self.emailTF.text;

  if (self.didLoginBlock != nil) {
    self.didLoginBlock(email, password);
  }

  [self.emailTF resignFirstResponder];
  [self.passwordTF resignFirstResponder];
}

- (IBAction)tapOnSkipBtn:(UIButton *)sender {
  if (self.onSkipButtonTapBlock != nil) {
    [self.progressHUD setHidden:NO];
    self.onSkipButtonTapBlock();
  }
}

#pragma mark - Private Methods

#pragma mark - Setters/Getters
- (MBProgressHUD *)progressHUD {
  if (!_progressHUD) {
    _progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressHUD.labelText = NSLocalizedString(@"Loading", @"Loading");
    [_progressHUD setHidden:YES];
  }

  return _progressHUD;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.passwordTF) {
    [self tapOnSignInButton:self.sigInButton];
  }
  [textField resignFirstResponder];
  return YES;
}

@end
