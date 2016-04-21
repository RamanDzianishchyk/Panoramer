//
//  RegionAnnotation.m
//  LondonTalks
//
//  Created by Dario Banno on 13/02/2013.
//  Copyright (c) 2013 Dario Banno. All rights reserved.
//

#import "RegionAnnotation.h"
#import "BubbleAnnotationView.h"

@interface RegionAnnotation ()

@property(nonatomic, strong) BubbleAnnotationView *view;

@end

@implementation RegionAnnotation

- (MKAnnotationView *)annotationViewInMap:(MKMapView *)mapView {
  if (self.view == nil) {
    self.view = (BubbleAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kLTAnnotationViewReuseID];
    if (self.view == nil) {
      self.view = [[BubbleAnnotationView alloc] initWithAnnotation:self mapView:mapView];
    }
  } else {
    self.view.annotation = self;
  }
  [self updateAnnotationViewAnimated:NO];
  return self.view;
}

- (void)updateAnnotationViewAnimated:(BOOL)animated {
  if (animated) {
    [UIView animateWithDuration:0.33f
                     animations:^{
                       _coordinate = self.coordinate;  // use ivar to avoid triggering setter
                     }];
  } else {
    _coordinate = self.coordinate;  // use ivar to avoid triggering setter
  }

  [self.view updateWithAnnotation:self];
}

@end
