//
//  ATMenuBaseController+Protected.h
//  Training
//
//  Created by Roman on 11/26/15.
//  Copyright (c) 2015 Senla. All rights reserved.
//

#import "ATMenuBaseController.h"

@interface ATMenuBaseController (Protected)

- (void)setTopBarTitle:(NSString *)title;
- (void)setTopBarTitleColor:(UIColor *)color;
- (void)setTopBarAttributedTitle:(NSAttributedString *)attributedTitle;
- (void)setOnRightTopButtonTapBlock:(void (^)(void))block;
- (void)setOnLeftTopButtonTapBlock:(void (^)(void))block;
- (UIButton *)rightTopButton;
- (UIButton *)leftTopButton;
- (void (^)(void))onLeftTopButtonTapBlock;
- (void)setTopBarColor:(UIColor *)color;
- (void)setTopBarBottomBorderColor:(UIColor *)color;
- (void)setTopBarEnabled:(BOOL)enabled;

@end
