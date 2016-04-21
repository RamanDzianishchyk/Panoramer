//
//  PRSceneController.h
//  Panoramer
//
//  Created by Vladimir on 11/29/15.
//  Copyright © 2015 GRSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATMenuBaseController.h"

@class Scene;

@interface PRSceneController : ATMenuBaseController

- (instancetype)initWithScene:(Scene *)scene;

@end
