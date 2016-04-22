//
//  BZLimitedTFController.h
//  Businer
//
//  Created by Roman on 11/9/15.
//  Copyright © 2015 Dancosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BZLimitedTFController : UIViewController

@property(weak, nonatomic) IBOutlet UITextField *mainTF;
@property(nonatomic, copy) void (^didEditText)(NSString *text);
@property(nonatomic, copy) void (^didEndEditing)(NSString *text);

+ (BZLimitedTFController *)contollerWithMaxLength:(NSUInteger)maxLength
                                   allowedCharSet:(NSCharacterSet *)allowedCharSet
                                           prefix:(NSString *)prefix
                                 showInvalidChars:(BOOL)showInvalidChars;

- (instancetype)initWithMaxLength:(NSUInteger)maxLength
                   allowedCharSet:(NSCharacterSet *)allowedCharSet
                           prefix:(NSString *)prefix
                 showInvalidChars:(BOOL)showInvalidChars;

- (BOOL)isValidString:(NSString *)string takeInAccountTheInvalidSymbols:(BOOL)invalidSymbols;

- (void)setPlaceholderText:(NSString *)placeholder;
- (void)setText:(NSString *)text;
- (NSString *)text;

- (void)setTextColor:(UIColor *)textColor;
- (void)setDetailTextColor:(UIColor *)detailTextColor;

@end
