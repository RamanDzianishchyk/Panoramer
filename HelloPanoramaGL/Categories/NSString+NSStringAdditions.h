//
//  NSString+NSStringAdditions.h
//  DocSigner
//
//  Created by Dzmitry on 15/08/2013.
//  Copyright (c) 2013 Dancosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringAdditions)

+ (NSString *)base64StringFromData:(NSData *)data length:(int)length;
+ (BOOL)isNilOrEmpty:(NSString *)str;
+ (BOOL)isEqualOrNil:(NSString *)first toString:(NSString *)second;
+ (NSString *)textWithoutSpecialChars:(NSString *)str;
+ (NSString *)generateUuidString;
+ (NSString *)checkNull:(NSString *)value;
+ (NSString *)mimeTypeForFileAtPath:(NSString *)path;
+ (NSString *)paramValueFromUrl:(NSURL *)url param:(NSString *)param;
+ (NSString *)valueForKey:(NSString *)key fromQueryItems:(NSArray *)queryItems;

- (NSString *)urlEncode;
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
- (BOOL)containsString:(NSString *)string caseSensitive:(BOOL)caseSensitive;
- (BOOL)isEqualIgnoringCase:(NSString *)string;
- (NSString *)stringByTrimmingWhitespaces;
- (NSString *)stringByTrimmingWhitespaces:(BOOL)trimNewLine;
- (BOOL)isEmailValid;
- (NSString *)emailDomain;
- (NSString *)emailDomainUpperCase;

@end
