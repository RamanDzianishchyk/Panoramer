//
//  TopBar.h
//  Businer
//
//  Created by Dzmitry on 25/5/15.
//  Copyright (c) 2015 Dancosoft. All rights reserved.
//

@interface TopBar : UIView

@property(nonatomic, copy) void (^onLeftButtonTap)(void);
@property(nonatomic, copy) void (^onRightButtonTap)(void);

// left and right have no default images
@property(nonatomic, strong) IBOutlet UIButton *rightButton;  // default hidden == YES
@property(nonatomic, strong) IBOutlet UIButton *leftButton;   // default hidden == YES
@property(nonatomic, strong) IBOutlet UIView *bottomBorder;

- (void)setTitle:(NSString *)title;
- (void)setTitleColor:(UIColor *)titleColor;
- (void)setAttributedTitle:(NSAttributedString *)attributedTitle;

@end
