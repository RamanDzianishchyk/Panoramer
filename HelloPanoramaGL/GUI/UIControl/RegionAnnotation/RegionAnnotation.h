//
//  RegionAnnotation.h
//  LondonTalks
//
//  Created by Dario Banno on 13/02/2013.
//  Copyright (c) 2013 Dario Banno. All rights reserved.
//

#import <MapKit/MKAnnotation.h>
#import <MapKit/MKMapView.h>

typedef void (^ActionBlock)();

@protocol RegionAnnotationProtocol<NSObject>

- (MKAnnotationView *)annotationViewInMap:(MKMapView *)mapView;

@end

@interface RegionAnnotation : NSObject<MKAnnotation, RegionAnnotationProtocol>

@property(nonatomic, strong) NSNumber *tourId;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, copy) ActionBlock leftButtonActionBlock;
@property(nonatomic, copy) ActionBlock rightButtonActionBlock;
@property(nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;

@end
