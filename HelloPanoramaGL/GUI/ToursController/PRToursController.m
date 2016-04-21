//
//  PRToursController.m
//  Panoramer
//
//  Created by Vladimir on 12/6/15.
//  Copyright © 2015 GRSU. All rights reserved.
//

#import "ATMenuBaseController+Protected.h"
#import "AppDelegate.h"
#import "Image.h"
#import "Location.h"
#import "PRMapAnnotation.h"
#import "PRService.h"
#import "PRTourCell.h"
#import "PRTourController.h"
#import "PRToursController.h"
#import "PhotoCollectionViewLayout.h"
#import "RegionAnnotation.h"
#import "Tour.h"

@interface PRToursController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) PhotoCollectionViewLayout *collectionViewLayout;
@property(nonatomic, strong) NSArray *tours;

@end

@implementation PRToursController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.collectionView setBackgroundColor:UIColorFromHexRGB(kPRMainThemeColor, 1)];
  [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PRTourCell class]) bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:kPRPhotoCellIdentifier];
  [self setTopBarBottomBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  self.collectionViewLayout = [[PhotoCollectionViewLayout alloc] initWithNumberOfColumns:2 verticalSapcing:30 titleHeight:0];
  [self.collectionView setCollectionViewLayout:self.collectionViewLayout];
  self.tours = [[PRService sharedService] fetchObjectsWithEntityName:NSStringFromClass([Tour class])
                                                           predicate:nil
                                                  andSortDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES] ]];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.collectionView reloadData];
}

#pragma mark - UiCollectionViewDelegate/Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return [self.tours count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  Tour *tour = [self.tours objectAtIndex:indexPath.section];
  PRTourCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPRPhotoCellIdentifier forIndexPath:indexPath];
  [cell setImage:[UIImage imageNamed:tour.preview.path]];
  [cell.titleLabel setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1)];
  [cell.titleLabel setText:tour.title];
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
  [(PRTourCell *)cell roundCell];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  Tour *tour = [self.tours objectAtIndex:indexPath.section];
  PRTourController *vc = [[PRTourController alloc] initWithTour:tour];
  [self presentViewController:vc animated:YES completion:nil];
}

@end
