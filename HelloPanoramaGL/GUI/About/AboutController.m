//
//  AboutController.m
//  Businer
//
//  Created by Roman on 7/2/15.
//  Copyright (c) 2015 Dancosoft. All rights reserved.
//

#import "AboutController.h"
#import "TopBar.h"

@interface AboutController ()
@property(weak, nonatomic) IBOutlet UIView *topBarContainer;
@property(weak, nonatomic) IBOutlet UIView *separator;

@property(weak, nonatomic) IBOutlet UILabel *versionTitleLbl;
@property(weak, nonatomic) IBOutlet UILabel *licenseTitleLbl;
@property(weak, nonatomic) IBOutlet UILabel *websiteTitleLbl;
@property(weak, nonatomic) IBOutlet UILabel *forumTitleLbl;
@property(weak, nonatomic) IBOutlet UILabel *emailTitleLbl;
@property(weak, nonatomic) IBOutlet UILabel *copyrightTitleLbl;
@property(weak, nonatomic) IBOutlet UILabel *developerTitleLbl;

@property(weak, nonatomic) IBOutlet UILabel *versionValueLbl;
@property(weak, nonatomic) IBOutlet UILabel *licenseValueLbl;
@property(weak, nonatomic) IBOutlet UILabel *websiteValueLbl;
@property(weak, nonatomic) IBOutlet UILabel *forumValueLbl;
@property(weak, nonatomic) IBOutlet UILabel *emailValueLbl;
@property(weak, nonatomic) IBOutlet UILabel *copyrightValueLbl;
@property(weak, nonatomic) IBOutlet UITextView *developersValueTV;
@property(weak, nonatomic) IBOutlet UIView *topContainer;

- (void)configureColorScheme;
- (void)fillController;
@end

@implementation AboutController {
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self configureColorScheme];
  [self fillController];
}

- (void)viewWillDisappear:(BOOL)animated {
  if (self.completion != nil) {
    self.completion();
  }
  [super viewWillDisappear:animated];
}

- (NSString *)title {
  return @"О нас";
}

- (void)configureColorScheme {
  [self.topContainer setBackgroundColor:[UIColor whiteColor]];
  [self.topContainer setCornersRadius:10 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];

  [self.versionTitleLbl setTextColor:UIColorFromHexRGB(kPRPlaceholderColor, 1.0)];
  [self.licenseTitleLbl setTextColor:UIColorFromHexRGB(kPRPlaceholderColor, 1.0)];
  [self.websiteTitleLbl setTextColor:UIColorFromHexRGB(kPRPlaceholderColor, 1.0)];
  [self.forumTitleLbl setTextColor:UIColorFromHexRGB(kPRPlaceholderColor, 1.0)];
  [self.emailTitleLbl setTextColor:UIColorFromHexRGB(kPRPlaceholderColor, 1.0)];
  [self.copyrightTitleLbl setTextColor:UIColorFromHexRGB(kPRPlaceholderColor, 1.0)];
  [self.developerTitleLbl setTextColor:UIColorFromHexRGB(kPRPlaceholderColor, 1.0)];

  [self.versionValueLbl setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.licenseValueLbl setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.websiteValueLbl setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.forumValueLbl setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.emailValueLbl setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.copyrightValueLbl setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.developersValueTV setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
}

- (void)fillController {
  NSString *colon = @":";
  [self.versionTitleLbl setText:[@"Версия" stringByAppendingString:colon]];
  [self.licenseTitleLbl setText:[@"Лицензия" stringByAppendingString:colon]];
  [self.websiteTitleLbl setText:[@"Веб-сайт" stringByAppendingString:colon]];
  [self.forumTitleLbl setText:[@"Форум" stringByAppendingString:colon]];
  [self.emailTitleLbl setText:[@"Почта" stringByAppendingString:colon]];
  [self.copyrightTitleLbl setText:[@"Права" stringByAppendingString:colon]];
  [self.developerTitleLbl setText:[@"Разработчики" stringByAppendingString:colon]];

  [self.versionValueLbl setText:kPRAboutVersion];
  [self.licenseValueLbl setText:kPRAboutLicense];
  [self.websiteValueLbl setText:kPRAboutWebsite];
  [self.forumValueLbl setText:kPRAboutForum];
  [self.emailValueLbl setText:kPRAboutEmail];
  [self.copyrightValueLbl setText:kPRAboutCopyright];
  [self.developersValueTV setText:kPRAboutDevelopers];
}

@end
