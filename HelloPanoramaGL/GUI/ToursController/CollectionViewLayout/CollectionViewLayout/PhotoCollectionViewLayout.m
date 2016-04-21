//
//  PhotoCollectionViewLayout.m
//  Businer
//
//  Created by Vladimir on 5/29/15.
//  Copyright (c) 2015 Dancosoft. All rights reserved.
//

#import "PhotoCollectionViewLayout.h"

@interface PhotoCollectionViewLayout ()

- (CGRect)frameCellAtIndexPath:(NSIndexPath *)indexPath;
- (CGRect)frameTitleAtIndexPath:(NSIndexPath *)indexPath;

@property(nonatomic, strong) NSDictionary *layoutInfo;

@end

@implementation PhotoCollectionViewLayout

#pragma mark - Setters
- (void)setItemInsets:(UIEdgeInsets)itemInsets {
  if (UIEdgeInsetsEqualToEdgeInsets(_itemInsets, itemInsets)) return;

  _itemInsets = itemInsets;

  [self invalidateLayout];
}

- (void)setItemSize:(CGSize)itemSize {
  if (CGSizeEqualToSize(_itemSize, itemSize)) return;

  _itemSize = itemSize;

  [self invalidateLayout];
}

- (void)setInterItemSpacingY:(CGFloat)interItemSpacingY {
  if (_interItemSpacingY == interItemSpacingY) return;

  _interItemSpacingY = interItemSpacingY;

  [self invalidateLayout];
}

- (void)setNumberOfColumns:(NSInteger)numberOfColumns {
  if (_numberOfColumns == numberOfColumns) return;

  _numberOfColumns = numberOfColumns;

  [self invalidateLayout];
}

- (void)setTitleHeight:(CGFloat)titleHeight {
  if (_titleHeight == titleHeight) return;

  _titleHeight = titleHeight;

  [self invalidateLayout];
}

#pragma mark - Instance Method
- (instancetype)initWithNumberOfColumns:(NSInteger)columns verticalSapcing:(NSInteger)spacing titleHeight:(NSInteger)titleHeight {
  self = [super init];
  if (self != nil) {
    self.numberOfColumns = columns;
    self.interItemSpacingY = spacing;
    self.titleHeight = titleHeight;
    self.itemInsets = UIEdgeInsetsMake(kPRVerticalSpacingInterItemTopWall, kPRHorizontalSpacingInterItemLeftWall, kPRVerticalSpacingInterItemBottomWall,
                                       kPRHorizontalSpacingInterItemRightWall);
    CGFloat width =
        ([UIScreen mainScreen].bounds.size.width - self.itemInsets.left - self.itemInsets.right - (columns - 1) * kPRHorizontalSpacingInterItems) / columns;
    self.itemSize = CGSizeMake(width, width + kPRTourCellTitleHeight);
  }
  return self;
}

#pragma mark - Layout
- (void)prepareLayout {
  NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
  NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];

  NSInteger sectionCount = [self.collectionView numberOfSections];
  NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];

  for (NSInteger section = 0; section < sectionCount; section++) {
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];

    for (NSInteger item = 0; item < itemCount; item++) {
      indexPath = [NSIndexPath indexPathForItem:item inSection:section];

      UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
      itemAttributes.frame = [self frameCellAtIndexPath:indexPath];

      cellLayoutInfo[indexPath] = itemAttributes;
    }
  }

  newLayoutInfo[kPRPhotoCellIdentifier] = cellLayoutInfo;

  self.layoutInfo = newLayoutInfo;
}

- (CGSize)collectionViewContentSize {
  NSInteger rowCount = [self.collectionView numberOfSections] / self.numberOfColumns;
  if ([self.collectionView numberOfSections] % self.numberOfColumns >= 1) {
    rowCount++;
  }

  CGFloat spacingInterItem = [self.collectionView numberOfSections] % 2 == 0 ? self.interItemSpacingY : 0;
  CGFloat height = self.itemInsets.top + rowCount * self.itemSize.height + (rowCount - 1) * kPRVerticalSpacingInterItems + spacingInterItem + self.titleHeight +
                   self.itemInsets.bottom;

  if (height <= CGRectGetHeight([UIScreen mainScreen].bounds) - kPRTopBarHeight - kPRTopBarHeight) {
    height = CGRectGetHeight([UIScreen mainScreen].bounds) - kPRTopBarHeight - kPRVerticalSpacingInterItemTopWall - kPRVerticalSpacingInterItems;
  }

  return CGSizeMake(self.collectionView.bounds.size.width, height);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];

  [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier, NSDictionary *elementsInfo, BOOL *stop) {
    [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *innerStop) {
      if (CGRectIntersectsRect(rect, attributes.frame)) {
        [allAttributes addObject:attributes];
      }
    }];
  }];

  return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  return self.layoutInfo[kPRPhotoCellIdentifier][indexPath];
}

#pragma mark - Private Interface
- (CGRect)frameCellAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = indexPath.section / self.numberOfColumns;
  NSInteger column = indexPath.section % self.numberOfColumns;
  CGFloat spacingX = kPRHorizontalSpacingInterItems;
  if (self.numberOfColumns > 1) {
    spacingX = spacingX / (self.numberOfColumns - 1);
  }
  CGFloat originX = floorf(self.itemInsets.left + (self.itemSize.width + spacingX) * column);
  CGFloat originY = floor(self.itemInsets.top + (self.itemSize.height + kPRVerticalSpacingInterItems) * row);
  if (indexPath.section % 2 != 0) {
    originY = originY + self.interItemSpacingY;
  }

  return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

- (CGRect)frameTitleAtIndexPath:(NSIndexPath *)indexPath {
  CGRect frame = [self frameCellAtIndexPath:indexPath];
  frame.origin.y -= self.titleHeight;
  frame.size.height = self.titleHeight;

  return indexPath.section == 1 ? frame : CGRectNull;
}

@end
