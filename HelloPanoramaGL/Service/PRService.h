//
//  PRService.h
//  Panoramer
//
//  Created by Vladimir on 11/30/15.
//  Copyright © 2015 GRSU. All rights reserved.
//

@interface PRService : NSObject

+ (PRService *)sharedService;

- (void)saveContext;
- (NSManagedObjectContext *)context;
- (NSArray *)fetchObjectsWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors;

@end
