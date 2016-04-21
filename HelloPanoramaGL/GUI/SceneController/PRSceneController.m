//
//  PRSceneController.m
//  Panoramer
//
//  Created by Vladimir on 11/29/15.
//  Copyright © 2015 GRSU. All rights reserved.
//

#import "PRSceneController.h"
#import "PLView.h"
#import "ATMenuBaseController+Protected.h"
#import "Scene.h"
#import "Image.h"
#import "Hotspot.h"
#import "TransitionHotspot.h"
#import "InfoHotspot.h"
#import "PRService.h"
#import "PRInfoController.h"

@interface PRSceneController ()<PLViewDelegate>

@property(weak, nonatomic) IBOutlet PLView *sceneView;
@property(weak, nonatomic) IBOutlet UIView *infoContainer;
@property(nonatomic, strong) Scene *scene;
@property(nonatomic, strong) PRInfoController *infoController;

- (void)setUpPanoramaWithSceneId:(NSNumber *)sceneId;

@end

@implementation PRSceneController

- (instancetype)initWithScene:(Scene *)scene {
  self = [super init];
  if (self != nil) {
    self.scene = scene;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.infoContainer setAlpha:0.0];
  [self.infoContainer setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];

  self.infoController = [[PRInfoController alloc] initForImageInfo:YES];
  [self addChildViewController:self.infoController];
  [self.infoContainer addSubview:self.infoController.view];
  [self.infoController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(96, 32, 32, 32)];
  [self.infoController.view setCornersRadius:10 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1)];

  __weak typeof(self) weakSelf = self;
  self.infoController.onCloseButtonTap = ^{
    [UIView animateWithDuration:0.2
                     animations:^{
                       [weakSelf.infoContainer setAlpha:0.0];
                       [weakSelf setTopBarColor:[UIColor whiteColor]];
                     }];
    [weakSelf.sceneView setUserInteractionEnabled:YES];
    [weakSelf.infoContainer setUserInteractionEnabled:NO];
  };

  [[self leftTopButton] setHidden:NO];
  [[self leftTopButton] setTitle:@"<" forState:UIControlStateNormal];
  [[self leftTopButton] setTitleColor:UIColorFromHexRGB(kPRMainThemeColor, 1) forState:UIControlStateNormal];

  [self setOnLeftTopButtonTapBlock:^{
    weakSelf.sceneView.delegate = nil;
    [weakSelf dismissViewControllerAnimated:YES completion:nil];
  }];
  [self setTopBarTitleColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self setTopBarTitle:self.scene.title];
  [self setTopBarBottomBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];

  [self setUpPanoramaWithSceneId:self.scene.idProp];
}

#pragma mark - Private Interface
- (void)setUpPanoramaWithSceneId:(NSNumber *)sceneId {
  Scene *scene = [[[PRService sharedService] fetchObjectsWithEntityName:NSStringFromClass([Scene class])
                                                              predicate:[NSPredicate predicateWithFormat:@"idProp == %@", sceneId]
                                                     andSortDescriptors:nil] firstObject];
  self.sceneView.delegate = self;

  PLPanoramaBase *panorama = nil;

  switch (scene.type.integerValue) {
    case SceneTypeCubic:
      break;
    case SceneTypeCylindrical: {
      PLCylindricalPanorama *cylindricalPanorama = [PLCylindricalPanorama panorama];
      Image *image = [[scene.images allObjects] firstObject];
      NSArray *imageResources = [image.path componentsSeparatedByString:@"."];
      [cylindricalPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:[imageResources firstObject]
                                                                                                                         ofType:[imageResources lastObject]]]]];
      panorama = cylindricalPanorama;
    } break;
    case SceneTypeSphere: {
      PLSphericalPanorama *spherePanorama = [PLSphericalPanorama panorama];
      Image *image = [[scene.images allObjects] firstObject];
      NSArray *imageResources = [image.path componentsSeparatedByString:@"."];
      [spherePanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:[imageResources firstObject]
                                                                                                                    ofType:[imageResources lastObject]]]]];
      panorama = spherePanorama;
    } break;
    default:
      break;
  }

  for (Hotspot *hotspot in scene.hotspots) {
    NSString *hotspotImagePath = @"hotspot_blue";
    if ([hotspot isKindOfClass:[TransitionHotspot class]]) {
      hotspotImagePath = @"hotspot_red";
    }
    PLTexture *hotspotTexture = [PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:hotspotImagePath ofType:@"png"]]];
    PLHotspot *hotspotView = [PLHotspot hotspotWithId:hotspot.idProp.longLongValue
                                              texture:hotspotTexture
                                                  atv:hotspot.y.floatValue
                                                  ath:hotspot.x.floatValue
                                                width:hotspot.width.floatValue
                                               height:hotspot.height.floatValue];
    [panorama addHotspot:hotspotView];
  }
  [self.sceneView setPanorama:panorama];
  if (self.scene != scene) {
    self.scene = scene;
  }
}

- (void)view:(UIView<PLIView> *)pView didClickHotspot:(PLHotspot *)hotspot screenPoint:(CGPoint)point scene3DPoint:(PLPosition)position {
  Hotspot *modelHotspot = [[[PRService sharedService] fetchObjectsWithEntityName:NSStringFromClass([Hotspot class])
                                                                       predicate:[NSPredicate predicateWithFormat:@"idProp == %@", @(hotspot.identifier)]
                                                              andSortDescriptors:nil] firstObject];
  if ([modelHotspot isKindOfClass:[InfoHotspot class]]) {
    self.infoController.image = [UIImage imageNamed:((InfoHotspot *)modelHotspot).image.path];
    self.infoController.mainTitle = modelHotspot.title;
    self.infoController.mainDescriprion = modelHotspot.aboutDescription;

    [self.sceneView setUserInteractionEnabled:NO];
    [self.infoContainer setUserInteractionEnabled:YES];

    [UIView animateWithDuration:0.2
                     animations:^{
                       [self setTopBarColor:self.infoContainer.backgroundColor];
                       [self.infoContainer setAlpha:1.0];
                     }];

  } else {
    [self setUpPanoramaWithSceneId:((TransitionHotspot *)modelHotspot).sceneId];
  }
}

@end
