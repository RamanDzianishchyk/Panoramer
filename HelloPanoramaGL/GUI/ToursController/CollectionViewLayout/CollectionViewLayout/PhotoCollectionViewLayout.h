//
//  PhotoCollectionViewLayout.h
//  Businer
//
//  Created by Vladimir on 5/29/15.
//  Copyright (c) 2015 Dancosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewLayout : UICollectionViewLayout

- (instancetype)initWithNumberOfColumns:(NSInteger)columns verticalSapcing:(NSInteger)spacing titleHeight:(NSInteger)titleHeight;

@property(nonatomic) UIEdgeInsets itemInsets;
@property(nonatomic) CGSize itemSize;
@property(nonatomic) CGFloat interItemSpacingY;
@property(nonatomic) NSInteger numberOfColumns;
@property(nonatomic) CGFloat titleHeight;

@end
