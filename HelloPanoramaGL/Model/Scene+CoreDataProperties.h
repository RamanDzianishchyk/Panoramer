//
//  Scene+CoreDataProperties.h
//  Panoramer
//
//  Created by Vladimir on 12/16/15.
//  Copyright © 2015 GRSU. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Scene.h"

NS_ASSUME_NONNULL_BEGIN

@interface Scene (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *aboutDescription;
@property (nullable, nonatomic, retain) NSNumber *idProp;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSSet<Hotspot *> *hotspots;
@property (nullable, nonatomic, retain) NSSet<Image *> *images;
@property (nullable, nonatomic, retain) Image *preview;
@property (nullable, nonatomic, retain) Tour *tour;

@end

@interface Scene (CoreDataGeneratedAccessors)

- (void)addHotspotsObject:(Hotspot *)value;
- (void)removeHotspotsObject:(Hotspot *)value;
- (void)addHotspots:(NSSet<Hotspot *> *)values;
- (void)removeHotspots:(NSSet<Hotspot *> *)values;

- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet<Image *> *)values;
- (void)removeImages:(NSSet<Image *> *)values;

@end

NS_ASSUME_NONNULL_END
