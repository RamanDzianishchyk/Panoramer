//
//  FAQController.m
//  Businer
//
//  Created by Roman on 11/19/15.
//  Copyright © 2015 Dancosoft. All rights reserved.
//

#import "FAQController.h"
#import "TopBar.h"

@interface FAQController ()
@property(weak, nonatomic) IBOutlet UILabel *praesentLbl;
@property(weak, nonatomic) IBOutlet UILabel *donneLbl;
@property(weak, nonatomic) IBOutlet UILabel *nullaLbl;
@property(weak, nonatomic) IBOutlet UILabel *donecLblb;
@property(weak, nonatomic) IBOutlet UILabel *crasLbl;
@property(weak, nonatomic) IBOutlet UILabel *crasLblb;
@property(weak, nonatomic) IBOutlet UILabel *frusceLbl;
@property(weak, nonatomic) IBOutlet UIView *topContainer;
@end

@implementation FAQController {
  TopBar *topBar_;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.praesentLbl setCornersRadius:5 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.donneLbl setCornersRadius:5 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.nullaLbl setCornersRadius:5 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.donecLblb setCornersRadius:5 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.crasLbl setCornersRadius:5 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.crasLblb setCornersRadius:5 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.frusceLbl setCornersRadius:5 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
}

- (void)viewWillDisappear:(BOOL)animated {
  if (self.completion != nil) {
    self.completion();
  }
  [super viewWillDisappear:animated];
}

- (NSString *)title {
  return @"Вопросы-Ответы";
}

@end
