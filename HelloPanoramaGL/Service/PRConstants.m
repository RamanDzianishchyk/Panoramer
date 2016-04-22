//
//  PRConstants.m
//  Panoramer
//
//  Created by Vladimir on 12/6/15.
//  Copyright © 2015 GRSU. All rights reserved.
//

#import "PRConstants.h"

#pragma mark - Keys
NSString *const kPRFirstRunKey = @"kBZFirstRunKey";
NSString *const kPRAuthKeychainKey = @"kBZAuthKeychainKey";

#pragma mark - Default values
NSInteger const kPRTopBarHeight = 64;

#pragma mark - Colors
NSUInteger const kPRMainThemeColor = 0x40B14E;
NSUInteger const kPRPlaceholderColor = 0xa9b6bc;
NSUInteger const kPRTextColor = 0x546e7a;

#pragma mark - Limits
NSInteger const kPRNicknameMaxLength = 15;
NSInteger const kPRFirstNameMaxLength = 15;
NSInteger const kPRPasswordMaxLength = 15;
NSInteger const kPRCityMaxLength = 20;

#pragma mark - Collection View Layout
CGFloat const kPRHorizontalSpacingInterItems = 8;
CGFloat const kPRVerticalSpacingInterItems = 8;
CGFloat const kPRHorizontalSpacingInterItemLeftWall = 18;
CGFloat const kPRHorizontalSpacingInterItemRightWall = 18;
CGFloat const kPRVerticalSpacingInterItemTopWall = 15;
CGFloat const kPRVerticalSpacingInterItemBottomWall = 10;
CGFloat const kPRTourCellTitleHeight = 40;

#pragma mark - CollectionView Cells identifiers
NSString *const kPRPhotoCellIdentifier = @"photoCell";

#pragma mark - LocationManager
NSString *const kLMRequestedUserAuthorizationKey = @"requestAuthorizationKey";

#pragma mark - Map
NSString *const kPRTilesTemplate = @"http://tile.openstreetmap.org/{z}/{x}/{y}.png";

#pragma mark - Settings -> About
NSString *const kPRAboutVersion = @"1.0";
NSString *const kPRAboutLicense = @"Freeware";
NSString *const kPRAboutWebsite = @"www.example.com";
NSString *const kPRAboutForum = @"www.example.com/forum";
NSString *const kPRAboutEmail = @"mail@some.mail";
NSString *const kPRAboutCopyright = @"© 2016 Panoramer Application";
NSString *const kPRAboutDevelopers = @"Raman Dzianishchyk Uladzimir Basko";
NSString *const kPRAboutDesignTeam = @"© 2016 Example Studio";
