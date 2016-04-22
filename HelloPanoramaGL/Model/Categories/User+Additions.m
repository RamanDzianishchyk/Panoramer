//
//  User+Additions.m
//  Panoramer
//
//  Created by Roman on 4/22/16.
//  Copyright © 2016 GRSU. All rights reserved.
//

#import "User+Additions.h"

@implementation User (Additions)
- (NSString *)name {
  NSMutableString *name = [NSMutableString string];
  if (![NSString isNilOrEmpty:self.nickname]) {
    [name appendString:self.nickname];
  }
  if (![NSString isNilOrEmpty:self.firstName]) {
    NSString *fName = (name.length > 0) ? [NSString stringWithFormat:@" (%@)", self.firstName] : self.firstName;
    [name appendFormat:@"%@", fName];
  }
  if (![NSString isNilOrEmpty:self.email] && name.length == 0) {
    [name appendString:self.email];
  }
  return name;
}
@end
