//
//  PRRegistrationController.m
//  Panoramer
//
//  Created by Roman on 4/22/16.
//  Copyright © 2016 GRSU. All rights reserved.
//

#import <UIKit/UIImagePickerController.h>
#import "ATMenuBaseController+Protected.h"
#import "BZLimitedTFController.h"
#import "FXKeychain.h"
#import "PREditUserController.h"
#import "PRService.h"
#import "PRSettingsController.h"
#import "User.h"

@interface PREditUserController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                                   UIActionSheetDelegate>
@property(nonatomic, strong) User *user;

@property(weak, nonatomic) IBOutlet UIView *avatarContainer;
@property(weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property(weak, nonatomic) IBOutlet UIImageView *avatarBackgroundImgView;

@property(weak, nonatomic) IBOutlet UIView *nicknameContiainer;
@property(weak, nonatomic) IBOutlet UIView *firstNameContainer;
@property(weak, nonatomic) IBOutlet UIView *passwordContainer;
@property(weak, nonatomic) IBOutlet UIView *cityContainer;
@property(weak, nonatomic) IBOutlet UITableView *autosuggestsTableView;
@property(weak, nonatomic) IBOutlet UIView *lockerView;

@property(nonatomic, strong) BZLimitedTFController *nicknameController;
@property(nonatomic, strong) BZLimitedTFController *firstNameController;
@property(nonatomic, strong) BZLimitedTFController *passwordController;
@property(nonatomic, strong) BZLimitedTFController *cityController;

@property(weak, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)onAvatarBtnTap:(id)sender;
- (IBAction)onDoneBtnTap:(id)sender;

- (void)configureInputController;
- (void)openImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType;
@end

@implementation PREditUserController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Профиль";
  [self.avatarContainer setCornersRadius:CGRectGetWidth(self.avatarContainer.bounds) / 2.0
                         withBorderWidth:1
                         withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.doneButton setBackgroundColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.doneButton setCornersRadius:5 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsBtnTap)];
  [anotherButton setImage:[UIImage imageNamed:@"settingsIcon.png"]];
  self.navigationItem.rightBarButtonItem = anotherButton;
  [self.lockerView setBackgroundColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self configureInputController];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.user = [PRService sharedService].currentUser;
  [self.lockerView setHidden:self.user != nil];
  if (![self.user.managedObjectContext hasChanges]) {
    [self.nicknameController setText:self.user.nickname];
    [self.firstNameController setText:self.user.firstName];
    [self.passwordController setText:[[[[FXKeychain defaultKeychain] objectForKey:kPRAuthKeychainKey] allValues] firstObject]];
    [self.cityController setText:self.user.city];
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (self.view.alpha == 0) {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5
                     animations:^{
                       [weakSelf.view setAlpha:1.0];
                     }];
  }
}

#pragma mark - Actions
- (IBAction)onAvatarBtnTap:(id)sender {
  [[[UIActionSheet alloc] initWithTitle:@"Использовать:"
                               delegate:self
                      cancelButtonTitle:@"Отмена"
                 destructiveButtonTitle:nil
                      otherButtonTitles:@"Галерею", @"Камеру", nil] showInView:self.view];
}

- (IBAction)onDoneBtnTap:(id)sender {
  // TODO: Send results to server
  self.user.nickname = self.nicknameController.text;
  self.user.firstName = self.firstNameController.text;
  if (![NSString isNilOrEmpty:self.passwordController.text]) {
    [[FXKeychain defaultKeychain] setObject:@{ self.user.email : self.passwordController.text } forKey:kPRAuthKeychainKey];
  }
  self.user.city = self.cityController.text;
  [self.user.managedObjectContext save:nil];
  [self.view endEditing:YES];
  [[[UIAlertView alloc] initWithTitle:nil message:@"Изменения сохранены" delegate:nil cancelButtonTitle:@"Ок" otherButtonTitles:nil] show];
}

- (void)onSettingsBtnTap {
  PRSettingsController *vc = [PRSettingsController new];
  __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:0.1
      animations:^{
        [weakSelf.view setAlpha:0.0];
      }
      completion:^(BOOL finished) {
        if (finished) {
          vc.completion = ^{
            [weakSelf.tabBarController.tabBar setAlpha:1.0];
          };
          [UIView animateWithDuration:0.5
                           animations:^{
                             [weakSelf.tabBarController.tabBar setAlpha:0.0];
                           }];
          [weakSelf.navigationController pushViewController:vc animated:YES];
        }
      }];
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
  [self.nicknameContiainer setCornersRadius:5 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
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
  [self.firstNameContainer setCornersRadius:5 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
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
  [self.passwordContainer setCornersRadius:5 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.passwordController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
  [self.passwordController setPlaceholderText:@"Пароль"];
  [self.passwordController setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.passwordController setDetailTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.passwordController.mainTF setSecureTextEntry:YES];

  self.cityController = [[BZLimitedTFController alloc] initWithMaxLength:kPRCityMaxLength
                                                          allowedCharSet:[NSMutableCharacterSet alphanumericCharacterSet]
                                                                  prefix:nil
                                                        showInvalidChars:YES];
  [self.cityContainer setCornersRadius:5 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self addChildViewController:self.cityController];
  [self.cityContainer addSubview:self.cityController.view];
  [self.cityController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
  [self.cityController setPlaceholderText:@"Город"];
  [self.cityController setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.cityController setDetailTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
}

- (void)openImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
  UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
  imagePickerController.navigationBar.barStyle = UIBarStyleBlackOpaque;
  [imagePickerController.navigationBar setTintColor:[UIColor whiteColor]];
  [imagePickerController.navigationBar setBackgroundColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  imagePickerController.sourceType = sourceType;
  imagePickerController.delegate = self;
  [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
  if (image == nil) {
    image = [info valueForKey:UIImagePickerControllerOriginalImage];
  }
  [self.avatarImageView setImage:image];
  [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch (buttonIndex) {
    case 0: {
      [self openImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
      break;
    }
    case 1: {
      [self openImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
      break;
    }
    default:
      break;
  }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return nil;
}

@end
