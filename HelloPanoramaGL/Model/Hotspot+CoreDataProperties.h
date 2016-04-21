//
//  Hotspot+CoreDataProperties.h
//  Panoramer
//
//  Created by Vladimir on 12/16/15.
//  Copyright © 2015 GRSU. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Hotspot.h"

NS_ASSUME_NONNULL_BEGIN

@interface Hotspot (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *aboutDescription;
@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) NSNumber *idProp;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *width;
@property (nullable, nonatomic, retain) NSNumber *x;
@property (nullable, nonatomic, retain) NSNumber *y;

@end

NS_ASSUME_NONNULL_END
