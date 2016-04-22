//
//  PRRegistrationController.h
//  Panoramer
//
//  Created by Roman on 4/22/16.
//  Copyright © 2016 GRSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATMenuBaseController.h"
@class User;

@interface PREditUserController : ATMenuBaseController

- (void)configureForUser:(User *)user;

@end
