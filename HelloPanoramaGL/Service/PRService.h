//
//  PRService.h
//  Panoramer
//
//  Created by Vladimir on 11/30/15.
//  Copyright © 2015 GRSU. All rights reserved.
//

@class User;

@interface PRService : NSObject

@property(nonatomic, strong) User *currentUser;

+ (PRService *)sharedService;

- (void)saveContext;
- (NSManagedObjectContext *)context;
- (NSArray *)fetchObjectsWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors;

@end
