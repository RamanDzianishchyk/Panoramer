//
//  PRTourController.h
//  Panoramer
//
//  Created by Vladimir on 12/6/15.
//  Copyright © 2015 GRSU. All rights reserved.
//

#import "ATMenuBaseController.h"

@class Tour;

@interface PRTourController : ATMenuBaseController

@property(nonatomic, copy) void( (^completion)(void));

- (instancetype)initWithTour:(Tour *)tour;

@end
