//
//  ATMenuBaseController.h
//  Training
//
//  Created by Roman on 11/25/15.
//  Copyright © 2015 Senla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATMenuBaseController : UIViewController

@property(nonatomic, copy) void( (^completion)(void));

- (void)lockScreen:(BOOL)lock;

@end
