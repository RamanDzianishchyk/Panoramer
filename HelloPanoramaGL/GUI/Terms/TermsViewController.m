//
//  TermsViewController.m
//  Businer
//
//  Created by Roman on 11/20/15.
//  Copyright © 2015 Dancosoft. All rights reserved.
//

#import "TermsViewController.h"
#import "TopBar.h"

@interface TermsViewController ()
@property(weak, nonatomic) IBOutlet UITextField *titleLvl;
@property(weak, nonatomic) IBOutlet UILabel *termsTV;
@property(weak, nonatomic) IBOutlet UIView *topContainer;
@end

@implementation TermsViewController {
  TopBar *topBar_;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.termsTV setCornersRadius:10 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.titleLvl setCornersRadius:5 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
}

- (void)viewWillDisappear:(BOOL)animated {
  if (self.completion != nil) {
    self.completion();
  }
  [super viewWillDisappear:animated];
}

- (NSString *)title {
  return @"Правила";
}

@end
