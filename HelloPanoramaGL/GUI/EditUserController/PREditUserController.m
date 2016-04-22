//
//  PRRegistrationController.m
//  Panoramer
//
//  Created by Roman on 4/22/16.
//  Copyright © 2016 GRSU. All rights reserved.
//

#import "ATMenuBaseController+Protected.h"
#import "BZLimitedTFController.h"
#import "PREditUserController.h"
#import "User.h"

@interface PREditUserController ()<UITableViewDelegate, UITableViewDataSource>
@property(weak, nonatomic) IBOutlet UIView *avatarContainer;
@property(weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property(weak, nonatomic) IBOutlet UIImageView *avatarBackgroundImgView;

@property(weak, nonatomic) IBOutlet UIView *nicknameContiainer;
@property(weak, nonatomic) IBOutlet UIView *firstNameContainer;
@property(weak, nonatomic) IBOutlet UIView *passwordContainer;
@property(weak, nonatomic) IBOutlet UIView *cityContainer;
@property(weak, nonatomic) IBOutlet UITableView *autosuggestsTableView;

@property(nonatomic, strong) BZLimitedTFController *nicknameController;
@property(nonatomic, strong) BZLimitedTFController *firstNameController;
@property(nonatomic, strong) BZLimitedTFController *passwordController;
@property(nonatomic, strong) BZLimitedTFController *cityController;

@property(weak, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)onAvatarBtnTap:(id)sender;
- (IBAction)onDoneBtnTap:(id)sender;

- (void)configureInputController;
@end

@implementation PREditUserController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Профиль";
  [self configureInputController];
}

#pragma mark - Public methods
- (void)configureForUser:(User *)user {
}

#pragma mark - Actions
- (IBAction)onAvatarBtnTap:(id)sender {
}

- (IBAction)onDoneBtnTap:(id)sender {
  // TODO: Send results to server
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
}

#pragma mark - Private Methods
- (void)configureInputController {
  self.nicknameController = [[BZLimitedTFController alloc] initWithMaxLength:kPRNicknameMaxLength
                                                              allowedCharSet:[NSMutableCharacterSet alphanumericCharacterSet]
                                                                      prefix:nil
                                                            showInvalidChars:YES];
  [self addChildViewController:self.nicknameController];
  [self.nicknameContiainer addSubview:self.nicknameController.view];
  [self.nicknameController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
  [self.nicknameController setPlaceholderText:@"Никнейм"];
  [self.nicknameController setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.nicknameController setDetailTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];

  self.firstNameController = [[BZLimitedTFController alloc] initWithMaxLength:kPRFirstNameMaxLength
                                                               allowedCharSet:[NSMutableCharacterSet letterCharacterSet]
                                                                       prefix:nil
                                                             showInvalidChars:YES];
  [self addChildViewController:self.firstNameController];
  [self.firstNameContainer addSubview:self.firstNameController.view];
  [self.firstNameController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
  [self.firstNameController setPlaceholderText:@"Имя"];
  [self.firstNameController setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.firstNameController setDetailTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];

  self.passwordController = [[BZLimitedTFController alloc] initWithMaxLength:kPRPasswordMaxLength
                                                              allowedCharSet:[[NSMutableCharacterSet newlineCharacterSet] invertedSet]
                                                                      prefix:nil
                                                            showInvalidChars:YES];
  [self addChildViewController:self.passwordController];
  [self.passwordContainer addSubview:self.passwordController.view];
  [self.passwordController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
  [self.passwordController setPlaceholderText:@"Пароль"];
  [self.passwordController setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.passwordController setDetailTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];

  self.cityController = [[BZLimitedTFController alloc] initWithMaxLength:kPRCityMaxLength
                                                          allowedCharSet:[NSMutableCharacterSet alphanumericCharacterSet]
                                                                  prefix:nil
                                                        showInvalidChars:YES];
  [self addChildViewController:self.cityController];
  [self.cityContainer addSubview:self.cityController.view];
  [self.cityController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
  [self.cityController setPlaceholderText:@"Город"];
  [self.cityController setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.cityController setDetailTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 0;
}

@end
