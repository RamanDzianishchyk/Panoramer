//
//  RegionAnnotationView.h
//  LondonTalks
//
//  Created by Dario Banno on 13/02/2013.
//  Copyright (c) 2013 Dario Banno. All rights reserved.
//

#import <MapKit/MapKit.h>

@class RegionAnnotation;

extern NSString *const kLTAnnotationViewReuseID;

typedef NS_ENUM(NSInteger, AnnotationViewAnimationDirection) {
  AnnotationViewAnimationDirectionGrow,
  AnnotationViewAnimationDirectionShrink,
};

typedef NS_ENUM(NSInteger, AnnotationViewState) {
  AnnotationViewStateCollapsed,
  AnnotationViewStateExpanded,
  AnnotationViewStateAnimating,
};

@protocol AnnotationViewProtocol<NSObject>

- (void)didSelectAnnotationViewInMap:(MKMapView *)mapView;
- (void)didDeselectAnnotationViewInMap:(MKMapView *)mapView;

@end

@interface BubbleAnnotationView : MKAnnotationView<AnnotationViewProtocol>

@property(nonatomic, assign) MKMapView *mapView;
@property(nonatomic, assign) RegionAnnotation *theAnnotation;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation;
- (id)initWithAnnotation:(id<MKAnnotation>)annotation mapView:(MKMapView *)mapView;
- (void)updateWithAnnotation:(RegionAnnotation *)annotation;
- (void)setLeftActionButton:(UIButton *)leftButton;
- (void)setRightActionButton:(UIButton *)rightButton;

@end
