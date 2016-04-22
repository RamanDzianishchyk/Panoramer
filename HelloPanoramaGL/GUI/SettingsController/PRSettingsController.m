//
//  PRSettingsController.m
//  Panoramer
//
//  Created by Vladimir on 4/22/16.
//  Copyright © 2016 GRSU. All rights reserved.
//

#import "AppDelegate.h"
#import "PRSettingsController.h"
#import "SettingsCell.h"

CGFloat const kPRDefaultRowHeight = 70;
NSString *const kPRSettingsCellId = @"settingsCellId";

typedef NS_ENUM(NSUInteger, SettingCellType) {
  NotificationsSettingCell,
  WriteToUsSettingCell,
  FAQSettingCell,
  TermsSettingCell,
  AboutSettingCell,
  LogOutSettingCell,
  AllSettingCell
};

@interface PRSettingsController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PRSettingsController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Настройки";

  [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SettingsCell class]) bundle:[NSBundle mainBundle]]
       forCellReuseIdentifier:kPRSettingsCellId];
}

- (void)viewWillDisappear:(BOOL)animated {
  if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
    if (self.completion != nil) {
      self.completion();
    }
  }
  [super viewWillDisappear:animated];
}

#pragma mark - UITableView delegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return AllSettingCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kPRDefaultRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:kPRSettingsCellId];
  [cell.mainLabel setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  __weak typeof(self) weakSelf = self;
  switch (indexPath.row) {
    case NotificationsSettingCell: {
      [cell setType:SettingsCellTypeSwitch];
      [cell.mainLabel setText:@"Нотификации"];
      break;
    }
    case WriteToUsSettingCell: {
      [cell setType:SettingsCellTypeArrow];
      [cell.mainLabel setText:@"Напишите нам"];
      cell.onCellTap = ^{
      };
      break;
    }
    case FAQSettingCell: {
      [cell setType:SettingsCellTypeArrow];
      [cell.mainLabel setText:@"Вопросы-Ответы"];
      cell.onCellTap = ^{
      };
      break;
    }
    case TermsSettingCell: {
      [cell setType:SettingsCellTypeArrow];
      [cell.mainLabel setText:@"Правила ползования"];
      cell.onCellTap = ^{

      };
      break;
    }
    case AboutSettingCell: {
      [cell setType:SettingsCellTypeArrow];
      [cell.mainLabel setText:@"О нас"];
      cell.onCellTap = ^{
      };
      break;
    }
    case LogOutSettingCell: {
      [cell setType:SettingsCellTypePlain];
      [cell.mainLabel setText:@"Выйти"];
      [cell.mainLabel setTextColor:[UIColor redColor]];
      cell.onCellTap = ^{
        [[[UIActionSheet alloc] initWithTitle:@"Вы действиетльно хотите выйти?"
                                     delegate:self
                            cancelButtonTitle:@"Отмена"
                       destructiveButtonTitle:@"Нет"
                            otherButtonTitles:@"Да", nil] showInView:self.view];
      };
      break;
    }

    default:
      break;
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  [(SettingsCell *)cell roundCell];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch (buttonIndex) {
    case 1: {
      AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
      [appDelegate logout];
      break;
    }
    default:
      break;
  }
}

@end
