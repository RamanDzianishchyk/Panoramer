//
//  MapController.m
//  Panoramer
//
//  Created by Vladimir on 4/18/16.
//  Copyright © 2016 GRSU. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ATMenuBaseController+Protected.h"
#import "BubbleAnnotationView.h"
#import "Image.h"
#import "Location.h"
#import "MapController.h"
#import "PRService.h"
#import "PRTourController.h"
#import "RegionAnnotation.h"
#import "Tour.h"

@interface MapController ()<CLLocationManagerDelegate, MKMapViewDelegate>

@property(weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) NSArray *tours;

@end

@implementation MapController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Карта";
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  [self.locationManager startUpdatingLocation];

  NSString *template = kPRTilesTemplate;
  MKTileOverlay *overlay = [[MKTileOverlay alloc] initWithURLTemplate:template];
  overlay.canReplaceMapContent = YES;
  [self.mapView addOverlay:overlay level:MKOverlayLevelAboveLabels];

  self.tours = [[PRService sharedService] fetchObjectsWithEntityName:NSStringFromClass([Tour class])
                                                           predicate:nil
                                                  andSortDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES] ]];
  for (Tour *tour in self.tours) {
    RegionAnnotation *annotation = [[RegionAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(tour.location.latitude.floatValue, tour.location.longitude.floatValue);
    annotation.title = tour.title;
    annotation.image = [UIImage imageNamed:tour.preview.path];
    annotation.tourId = tour.idProp;
    [self.mapView addAnnotation:annotation];
  }
}

#pragma mark - MKMapViewDelegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id)overlay {
  if ([overlay isKindOfClass:[MKTileOverlay class]]) {
    return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
  } else {
    return nil;
  }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  if ([annotation conformsToProtocol:@protocol(RegionAnnotationProtocol)]) {
    BubbleAnnotationView *view = (BubbleAnnotationView *)[((NSObject<RegionAnnotationProtocol> *)annotation) annotationViewInMap:mapView];

    //    UIButton *tourStartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [tourStartButton setFrame:CGRectMake(0, 0, 30, 30)];
    //    [tourStartButton setCornersRadius:tourStartButton.frame.size.height / 2 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1)];
    //    [tourStartButton setContentMode:UIViewContentModeScaleAspectFit];
    //    [tourStartButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
    //    [view setLeftActionButton:tourStartButton];
    //    __weak typeof(self) weakSelf = self;
    //    view.theAnnotation.leftButtonActionBlock = ^{
    //      Tour *tour =
    //          [weakSelf.tours filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"idProp == %@", ((RegionAnnotation
    //          *)annotation).tourId]].firstObject;
    //      if (tour != nil) {
    //        PRTourController *vc = [[PRTourController alloc] initWithTour:tour];
    //        [self presentViewController:vc animated:YES completion:nil];
    //      }
    //    };

    [view updateWithAnnotation:(RegionAnnotation *)annotation];
    return view;
  } else {
    return nil;
  }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
  if (![view isKindOfClass:[BubbleAnnotationView class]]) {
    return;
  }
  if ([view conformsToProtocol:@protocol(AnnotationViewProtocol)]) {
    [((NSObject<AnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
  }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
  if (![view isKindOfClass:[BubbleAnnotationView class]]) {
    return;
  }
  if ([view conformsToProtocol:@protocol(AnnotationViewProtocol)]) {
    [((NSObject<AnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
  }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if (status != kCLAuthorizationStatusNotDetermined && [CLLocationManager locationServicesEnabled]) {
    [defaults setBool:YES forKey:kLMRequestedUserAuthorizationKey];
  } else if (status == kCLAuthorizationStatusNotDetermined) {
    BOOL alreadyAskedAboutAuthorization = NO;
    alreadyAskedAboutAuthorization = [defaults boolForKey:kLMRequestedUserAuthorizationKey];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
      [self.locationManager requestAlwaysAuthorization];
    }
  }
  [defaults synchronize];

  BOOL allowed = (status == kCLAuthorizationStatusAuthorizedAlways) || (status == kCLAuthorizationStatusAuthorizedWhenInUse);
  if (allowed) {
    [self.locationManager startUpdatingLocation];
  }
}

@end
