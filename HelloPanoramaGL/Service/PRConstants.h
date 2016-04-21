//
//  PRConstants.h
//  Panoramer
//
//  Created by Vladimir on 12/6/15.
//  Copyright © 2015 GRSU. All rights reserved.
//

#define UIColorFromHexRGB(rgbValue, alphaValue)                        \
  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
                  green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0    \
                   blue:((float)(rgbValue & 0xFF)) / 255.0             \
                  alpha:alphaValue]
#define CGColorFromHexRGB(rgbValue, a) [UIColorFromHexRGB(rgbValue, a) CGColor]

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define SYSTEM_DEVICE_TYPE_IS(UIUserInterfaceIdiom) ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiom)

typedef NS_ENUM(NSInteger, SceneType) { SceneTypeCubic, SceneTypeCylindrical, SceneTypeSphere };

#pragma mark - Default values
extern NSInteger const kPRTopBarHeight;

#pragma mark - Colors
extern NSUInteger const kPRMainThemeColor;

#pragma mark - Collection View Layout
extern CGFloat const kPRHorizontalSpacingInterItems;
extern CGFloat const kPRVerticalSpacingInterItems;
extern CGFloat const kPRHorizontalSpacingInterItemLeftWall;
extern CGFloat const kPRHorizontalSpacingInterItemRightWall;
extern CGFloat const kPRVerticalSpacingInterItemTopWall;
extern CGFloat const kPRVerticalSpacingInterItemBottomWall;
extern CGFloat const kPRTourCellTitleHeight;

#pragma mark - CollectionView Cells identifiers
extern NSString *const kPRPhotoCellIdentifier;

#pragma mark - LocationManager
extern NSString *const kLMRequestedUserAuthorizationKey;

#pragma mark - Map
extern NSString *const kPRTilesTemplate;
