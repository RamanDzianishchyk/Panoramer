//
//  PRMapAnnotation.h
//  Panoramer
//
//  Created by Vladimir on 12/15/15.
//  Copyright © 2015 GRSU. All rights reserved.
//

#import <MapKit/MKAnnotation.h>

@interface PRMapAnnotation : NSObject<MKAnnotation>

@property(nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) UIImage *image;

@end
