//
//  PRConstants.m
//  Panoramer
//
//  Created by Vladimir on 12/6/15.
//  Copyright © 2015 GRSU. All rights reserved.
//

#import "PRConstants.h"

#pragma mark - Default values
NSInteger const kPRTopBarHeight = 64;

#pragma mark - Colors
NSUInteger const kPRMainThemeColor = 0x0396D7;

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
