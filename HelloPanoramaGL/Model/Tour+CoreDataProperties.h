//
//  Tour+CoreDataProperties.h
//  Panoramer
//
//  Created by Vladimir on 12/16/15.
//  Copyright © 2015 GRSU. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Tour.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tour (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *aboutDescription;
@property (nullable, nonatomic, retain) NSNumber *idProp;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) Location *location;
@property (nullable, nonatomic, retain) Image *preview;
@property (nullable, nonatomic, retain) NSOrderedSet<Scene *> *scenes;

@end

@interface Tour (CoreDataGeneratedAccessors)

- (void)insertObject:(Scene *)value inScenesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromScenesAtIndex:(NSUInteger)idx;
- (void)insertScenes:(NSArray<Scene *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeScenesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInScenesAtIndex:(NSUInteger)idx withObject:(Scene *)value;
- (void)replaceScenesAtIndexes:(NSIndexSet *)indexes withScenes:(NSArray<Scene *> *)values;
- (void)addScenesObject:(Scene *)value;
- (void)removeScenesObject:(Scene *)value;
- (void)addScenes:(NSOrderedSet<Scene *> *)values;
- (void)removeScenes:(NSOrderedSet<Scene *> *)values;

@end

NS_ASSUME_NONNULL_END
