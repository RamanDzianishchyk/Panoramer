//
//  PRInfoController.h
//  Panoramer
//
//  Created by Vladimir on 12/13/15.
//  Copyright © 2015 GRSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRInfoController : UIViewController

@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSString *mainTitle;
@property(nonatomic, strong) NSString *mainDescriprion;
@property(nonatomic, copy) void (^onCloseButtonTap)(void);

- (instancetype)initForImageInfo:(BOOL)imageInfo;

@end
