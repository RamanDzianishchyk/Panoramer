//
//  BZLimitedTFController.m
//  Businer
//
//  Created by Roman on 11/9/15.
//  Copyright © 2015 Dancosoft. All rights reserved.
//

#import "BZLimitedTFController.h"

NSUInteger const kBZDefaultMaxTextLength = 15;

@interface BZLimitedTFController ()<UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UILabel *rightLbl;

- (void)updateControllerForString:(NSString *)string;

@end

@implementation BZLimitedTFController {
  NSInteger maxTextLength_;
  NSCharacterSet *allowedCharSet_;
  NSString *prefix_;
  BOOL showInvalidChars_;
}

+ (BZLimitedTFController *)contollerWithMaxLength:(NSUInteger)maxLength
                                   allowedCharSet:(NSCharacterSet *)allowedCharSet
                                           prefix:(NSString *)prefix
                                 showInvalidChars:(BOOL)showInvalidChars {
  return [[BZLimitedTFController alloc] initWithMaxLength:maxLength allowedCharSet:allowedCharSet prefix:prefix showInvalidChars:showInvalidChars];
}

- (instancetype)init {
  self = [super init];
  if (self != nil) {
    maxTextLength_ = kBZDefaultMaxTextLength;
    showInvalidChars_ = NO;
    allowedCharSet_ = [NSCharacterSet alphanumericCharacterSet];
  }
  return self;
}

- (instancetype)initWithMaxLength:(NSUInteger)maxLength
                   allowedCharSet:(NSCharacterSet *)allowedCharSet
                           prefix:(NSString *)prefix
                 showInvalidChars:(BOOL)showInvalidChars {
  self = [super init];
  if (self != nil) {
    maxTextLength_ = maxLength;
    allowedCharSet_ = allowedCharSet;
    prefix_ = prefix;
    showInvalidChars_ = showInvalidChars;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.mainTF.delegate = self;
  [self updateControllerForString:nil];
}

#pragma mark - Public methods
- (BOOL)isValidString:(NSString *)string takeInAccountTheInvalidSymbols:(BOOL)invalidSymbols {
  if (string == nil) {
    return YES;
  }
  if ([NSString isNilOrEmpty:string] && ![NSString isNilOrEmpty:prefix_]) {
    return NO;
  }

  BOOL hasCorrectLength = (string.length - prefix_.length) <= maxTextLength_;
  BOOL hasCorrectPrefix = ([NSString isNilOrEmpty:prefix_] || [string hasPrefix:prefix_]);
  BOOL hasCorrectSymbols = (invalidSymbols || [[string substringFromIndex:prefix_.length] stringByTrimmingCharactersInSet:allowedCharSet_].length == 0);

  if (hasCorrectLength && hasCorrectPrefix && hasCorrectSymbols) {
    return YES;
  } else {
    return NO;
  }
}

- (void)setPlaceholderText:(NSString *)placeholder {
  [self.mainTF setPlaceholder:placeholder];
}

- (void)setText:(NSString *)text {
  if ([self isValidString:text takeInAccountTheInvalidSymbols:showInvalidChars_]) {
    [self updateControllerForString:text];
  } else {
    [self updateControllerForString:nil];
  }
}

- (NSString *)text {
  return self.mainTF.text;
}

- (void)setTextColor:(UIColor *)textColor {
  [self.mainTF setTextColor:textColor];
}

- (void)setDetailTextColor:(UIColor *)detailTextColor {
  [self.rightLbl setTextColor:detailTextColor];
}

#pragma mark - Private methods
- (void)updateControllerForString:(NSString *)string {
  self.mainTF.text = string;
  if ([NSString isNilOrEmpty:string]) {
    self.rightLbl.text = [NSString stringWithFormat:@"0/%ld", (long)maxTextLength_];
  } else {
    self.rightLbl.text = [NSString stringWithFormat:@"%u/%ld", string.length - prefix_.length, (long)maxTextLength_];
  }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  if (![NSString isNilOrEmpty:prefix_] && ![textField.text hasPrefix:prefix_]) {
    [self updateControllerForString:prefix_];
  }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  NSString *updatedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
  if ([self isValidString:updatedString takeInAccountTheInvalidSymbols:showInvalidChars_]) {
    [self updateControllerForString:updatedString];
    if (self.didEditText != nil) {
      self.didEditText(updatedString);
    }
  }
  return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  if (showInvalidChars_) {
    NSString *stringForReplacing = [self.text substringFromIndex:prefix_.length];
    stringForReplacing = [[stringForReplacing componentsSeparatedByCharactersInSet:[allowedCharSet_ invertedSet]] componentsJoinedByString:@""];
    if (![NSString isNilOrEmpty:prefix_]) {
      stringForReplacing = [prefix_ stringByAppendingString:stringForReplacing];
    }
    [self updateControllerForString:stringForReplacing];
  }
  if (![NSString isNilOrEmpty:prefix_] && textField.text.length == prefix_.length) {
    [self updateControllerForString:nil];
  }

  if (self.didEndEditing != nil) {
    self.didEndEditing(self.text);
  }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

@end
