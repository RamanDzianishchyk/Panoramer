//
//  PRSceneCell.h
//  Panoramer
//
//  Created by Vladimir on 12/6/15.
//  Copyright © 2015 GRSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRSceneCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UILabel *mainTitle;
- (void)setImage:(UIImage *)image;
- (void)roundCell;
@end
