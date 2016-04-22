//
//  SettingsCell.h
//  Businer
//
//  Created by Roman on 7/13/15.
//  Copyright (c) 2015 Dancosoft. All rights reserved.
//

typedef NS_ENUM(NSInteger, SettingsCellType) { SettingsCellTypeSwitch, SettingsCellTypeArrow, SettingsCellTypePlain };

@interface SettingsCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIView *border;
@property(nonatomic, copy) void (^changeSwitchState)(BOOL on);
@property(nonatomic, copy) void (^onCellTap)(void);

@property(weak, nonatomic) IBOutlet UILabel *mainLabel;

- (void)setType:(SettingsCellType)type;
- (void)setSwitchState:(BOOL)on;
- (void)roundCell;

@end
