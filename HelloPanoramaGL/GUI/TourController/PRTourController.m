//
//  PRTourController.m
//  Panoramer
//
//  Created by Vladimir on 12/6/15.
//  Copyright © 2015 GRSU. All rights reserved.
//

#import "PRTourController.h"
#import "ATMenuBaseController+Protected.h"
#import "PRSceneCell.h"
#import "PRSceneController.h"
#import "Tour.h"
#import "Scene.h"
#import "Image.h"
#import "PRInfoController.h"

CGFloat const kPRSceneCellHeight = 100;

@interface PRTourController ()<UITableViewDelegate, UITableViewDataSource>
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet UIButton *startTourBtn;
@property(nonatomic, strong) Tour *tour;
@property(weak, nonatomic) IBOutlet UIView *infoContainer;
@property(nonatomic, strong) PRInfoController *infoController;

- (IBAction)onStartBtnTap:(id)sender;
- (void)showSceneControllerWithScene:(Scene *)scene;

@end

@implementation PRTourController

- (instancetype)initWithTour:(Tour *)tour {
  self = [super init];
  if (self != nil) {
    self.tour = tour;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PRSceneCell class]) bundle:[NSBundle mainBundle]]
       forCellReuseIdentifier:NSStringFromClass([PRSceneCell class])];

  [self.infoContainer setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
  self.infoController = [[PRInfoController alloc] initForImageInfo:NO];
  [self addChildViewController:self.infoController];
  [self.infoContainer addSubview:self.infoController.view];
  [self.infoController.view setCornersRadius:10 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1)];
  [self.infoController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(96, 32, 32, 32)];
  self.infoController.mainTitle = @"Информация";
  self.infoController.mainDescriprion = self.tour.aboutDescription;
  [self.infoContainer setAlpha:0.0];

  __weak typeof(self) weakSelf = self;
  self.infoController.onCloseButtonTap = ^{
    [UIView animateWithDuration:0.2
                     animations:^{
                       [weakSelf.rightTopButton setAlpha:1.0];
                       [weakSelf setTopBarColor:[UIColor whiteColor]];
                       [weakSelf.infoContainer setAlpha:0.0];
                     }];
    [weakSelf.infoContainer setUserInteractionEnabled:NO];

  };

  [self setTopBarTitle:self.tour.title];
  [self.view setBackgroundColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.leftTopButton setHidden:NO];
  [self.leftTopButton setTitle:@"<" forState:UIControlStateNormal];
  [self.leftTopButton setTitleColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0) forState:UIControlStateNormal];
  [self setTopBarTitleColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self setTopBarBottomBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];

  [self setOnLeftTopButtonTapBlock:^{
    [weakSelf dismissViewControllerAnimated:YES completion:nil];
  }];

  [[self rightTopButton] setHidden:NO];
  [[self rightTopButton] setTitle:@"i" forState:UIControlStateNormal];
  [[self rightTopButton] setTitleColor:UIColorFromHexRGB(kPRMainThemeColor, 1) forState:UIControlStateNormal];
  [self setOnRightTopButtonTapBlock:^{
    [UIView animateWithDuration:0.2
                     animations:^{
                       [weakSelf.rightTopButton setAlpha:0.0];
                       [weakSelf setTopBarColor:weakSelf.infoContainer.backgroundColor];
                       [weakSelf.infoContainer setAlpha:1.0];
                     }];
    [weakSelf.infoContainer setUserInteractionEnabled:YES];
  }];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
  [self lockScreen:NO];
  [super viewDidDisappear:animated];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.tour.scenes count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kPRSceneCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  Scene *scene = [self.tour.scenes objectAtIndex:indexPath.row];
  PRSceneCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PRSceneCell class]) forIndexPath:indexPath];
  [cell setImage:[UIImage imageNamed:scene.preview.path]];
  [cell.mainTitle setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [cell.mainTitle setText:scene.title];
  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  [(PRSceneCell *)cell roundCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self lockScreen:YES];
  Scene *scene = [self.tour.scenes objectAtIndex:indexPath.row];
  [self showSceneControllerWithScene:scene];
}

#pragma mark - Actions
- (IBAction)onStartBtnTap:(id)sender {
  [self lockScreen:YES];
  [self showSceneControllerWithScene:[self.tour.scenes firstObject]];
}

- (void)showSceneControllerWithScene:(Scene *)scene {
  PRSceneController *vc = [[PRSceneController alloc] initWithScene:scene];
  [self presentViewController:vc animated:YES completion:nil];
}
@end
