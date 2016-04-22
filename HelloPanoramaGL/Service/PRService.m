//
//  PRService.m
//  Panoramer
//
//  Created by Vladimir on 11/30/15.
//  Copyright © 2015 GRSU. All rights reserved.
//

#import "Model.h"
#import "PRService.h"

@interface PRService ()

@property(nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation PRService

+ (PRService *)sharedService {
  static PRService *sharedService = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedService = [[PRService alloc] init];
  });
  return sharedService;
}

#pragma mark - Instance Methods
- (instancetype)init {
  self = [super init];
  if (self != nil) {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];

    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSError *error = nil;
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
    NSLog(@"%@", storeURL);

    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    [self.managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
  }

  return self;
}

#pragma mark - Public Interdace
- (void)saveContext {
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}

- (NSManagedObjectContext *)context {
  return self.managedObjectContext;
}

- (NSArray *)fetchObjectsWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext]];
  [fetchRequest setPredicate:predicate];
  [fetchRequest setSortDescriptors:sortDescriptors];
  NSError *error = nil;
  NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
  if (error != nil) {
    NSLog(@"Failed to execute request: %@", error.localizedDescription);
  }
  return fetchedObjects;
}

#pragma mark - Application's Documents directory
- (NSURL *)applicationDocumentsDirectory {
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
