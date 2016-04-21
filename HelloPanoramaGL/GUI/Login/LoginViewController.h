//
//  LoginViewController.h
//  LondonTalks
//
//  Created by Vladimir on 10/1/15.
//  Copyright (c) 2015 Dario Banno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property(nonatomic, copy) void (^onSkipButtonTapBlock)(void);
@property(nonatomic, copy) void (^didLoginBlock)(NSString *login, NSString *password);

@end
