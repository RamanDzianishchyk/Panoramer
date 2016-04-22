//
//  TermsViewController.m
//  Businer
//
//  Created by Roman on 11/20/15.
//  Copyright © 2015 Dancosoft. All rights reserved.
//

#import "TopBar.h"
#import "WriteToUs.h"

NSInteger const kBZMessageLength = 300;
CGFloat const kBZMinimalKeybaordHieght = 224;

@interface WriteToUs ()<UITextViewDelegate>
@property(weak, nonatomic) IBOutlet UILabel *iconLabel;
@property(weak, nonatomic) IBOutlet UILabel *titleContainerLabel;
@property(weak, nonatomic) IBOutlet UILabel *messageLengthLabel;
@property(weak, nonatomic) IBOutlet UITextView *textView;
@property(weak, nonatomic) IBOutlet UIButton *sendBtn;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *sendBtnBottomConstraint;
@property(weak, nonatomic) IBOutlet UIView *borderView;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(weak, nonatomic) IBOutlet UIView *containerView;

- (void)setSendButtonHidden:(BOOL)hidden animationDuration:(CGFloat)duration;

@end

@implementation WriteToUs {
  CGFloat currentKeyboardHeight_;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.containerView setCornersRadius:10 withBorderWidth:1 withBorderColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.sendBtn setBackgroundColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self setSendButtonHidden:YES animationDuration:0.0];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [self.titleContainerLabel setText:@"Ваше сообщение:"];
  [self.iconLabel setText:@"*"];
  self.messageLengthLabel.text = [NSString stringWithFormat:@"0/%li", (long)kBZMessageLength];
  [self.textView setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.messageLengthLabel setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.titleContainerLabel setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.iconLabel setTextColor:UIColorFromHexRGB(kPRMainThemeColor, 1.0)];
  [self.borderView setBackgroundColor:UIColorFromHexRGB(kPRMainThemeColor, 0.5)];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
}

- (NSString *)title {
  return @"Напишите нам";
}

#pragma mark - Private Interface
- (void)setSendButtonHidden:(BOOL)hidden animationDuration:(CGFloat)duration {
  CGFloat offset = (hidden) ? -self.sendBtn.frame.size.height : currentKeyboardHeight_;
  if (offset != self.sendBtnBottomConstraint.constant) {
    self.sendBtnBottomConstraint.constant = offset;
    [UIView animateWithDuration:duration
                     animations:^{
                       [self.view layoutIfNeeded];
                     }];
  }
}

#pragma mark - Actions
- (IBAction)onSendBtnTap:(UIButton *)sender {
}
- (IBAction)endEditingBtnTap:(UIButton *)sender {
  [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  NSString *resultString = [textView.text stringByReplacingCharactersInRange:range withString:text];
  if ([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    return NO;
  }
  if (resultString.length <= kBZMessageLength) {
    [self.messageLengthLabel setText:[NSString stringWithFormat:@"%lu/%li", (unsigned long)resultString.length, (long)kBZMessageLength]];
    return YES;
  } else {
    return NO;
  }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
  currentKeyboardHeight_ = kBZMinimalKeybaordHieght;
  [self setSendButtonHidden:NO animationDuration:0.2];
  return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
  currentKeyboardHeight_ = 0;
  [self setSendButtonHidden:([textView.text length] == 0) animationDuration:0.1];
  [self.scrollView setContentOffset:CGPointZero animated:YES];
  return YES;
}

#pragma mark - Keyboard Notifications
- (void)keyboardWillShow:(NSNotification *)aNotification {
  currentKeyboardHeight_ = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
  CGFloat duration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
  [self setSendButtonHidden:NO animationDuration:duration];
}

@end
