//
//  InfoHotspot+CoreDataProperties.h
//  Panoramer
//
//  Created by Vladimir on 12/16/15.
//  Copyright © 2015 GRSU. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "InfoHotspot.h"

NS_ASSUME_NONNULL_BEGIN

@interface InfoHotspot (CoreDataProperties)

@property (nullable, nonatomic, retain) Image *image;

@end

NS_ASSUME_NONNULL_END
