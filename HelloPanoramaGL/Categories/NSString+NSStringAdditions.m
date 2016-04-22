//
//  NSString+NSStringAdditions.m
//  DocSigner
//
//  Created by Dzmitry on 15/08/2013.
//  Copyright (c) 2013 Dancosoft. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "DateFormatter.h"
#import "NSString+NSStringAdditions.h"

static char base64EncodingTable[64] = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',
                                       'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
                                       's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'};

@implementation NSString (NSStringAdditions)

+ (NSString *)base64StringFromData:(NSData *)data length:(int)length {
  unsigned long ixtext, lentext;
  long ctremaining;
  unsigned char input[3], output[4];
  short i, charsonline = 0, ctcopy;
  const unsigned char *raw;
  NSMutableString *result;

  lentext = [data length];
  if (lentext < 1) return @"";
  result = [NSMutableString stringWithCapacity:lentext];
  raw = [data bytes];
  ixtext = 0;

  while (true) {
    ctremaining = lentext - ixtext;
    if (ctremaining <= 0) break;
    for (i = 0; i < 3; i++) {
      unsigned long ix = ixtext + i;
      if (ix < lentext)
        input[i] = raw[ix];
      else
        input[i] = 0;
    }
    output[0] = (input[0] & 0xFC) >> 2;
    output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
    output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
    output[3] = input[2] & 0x3F;
    ctcopy = 4;
    switch (ctremaining) {
      case 1:
        ctcopy = 2;
        break;
      case 2:
        ctcopy = 3;
        break;
    }

    for (i = 0; i < ctcopy; i++) [result appendString:[NSString stringWithFormat:@"%c", base64EncodingTable[output[i]]]];

    for (i = ctcopy; i < 4; i++) [result appendString:@"="];

    ixtext += 3;
    charsonline += 4;

    if ((length > 0) && (charsonline >= length)) charsonline = 0;
  }
  return result;
}

+ (BOOL)isNilOrEmpty:(NSString *)str {
  if (str == nil) {
    return YES;
  }
  if (![str isKindOfClass:[NSString class]]) {
    return YES;
  }
  if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 1) {
    return YES;
  }
  return NO;
}

+ (BOOL)isEqualOrNil:(NSString *)first toString:(NSString *)second {
  if (first == nil && second == nil) {
    return YES;
  } else {
    return [first isEqualIgnoringCase:second];
  }
}

+ (NSString *)textWithoutSpecialChars:(NSString *)str {
  NSMutableString *string = [NSMutableString string];
  char start = '<';
  char finish = '>';
  BOOL inTag = NO;
  for (int i = 0; i < [str length]; i++) {
    if ([str characterAtIndex:i] == start) inTag = YES;
    if (!inTag) {
      [string appendFormat:@"%C", [str characterAtIndex:i]];
    }
    if ([str characterAtIndex:i] == finish) inTag = NO;
  }
  [string replaceOccurrencesOfString:@"&amp;" withString:@"&" options:0 range:NSMakeRange(0, string.length)];
  [string replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:0 range:NSMakeRange(0, string.length)];
  [string replaceOccurrencesOfString:@"&#39;" withString:@"'" options:0 range:NSMakeRange(0, string.length)];
  [string replaceOccurrencesOfString:@"&gt;" withString:@">" options:0 range:NSMakeRange(0, string.length)];
  [string replaceOccurrencesOfString:@"&lt;" withString:@"<" options:0 range:NSMakeRange(0, string.length)];
  [string replaceOccurrencesOfString:@"&#10;" withString:@"\n" options:0 range:NSMakeRange(0, string.length)];
  [string replaceOccurrencesOfString:@"&#10CR" withString:@"\n" options:0 range:NSMakeRange(0, string.length)];
  NSArray *arr = [string componentsSeparatedByString:@"&#"];
  NSMutableString *resultString = [NSMutableString stringWithString:[arr objectAtIndex:0]];
  if ([arr count] > 1) {
    for (NSUInteger index = 1; index < [arr count]; index++) {
      NSString *nextString = [arr objectAtIndex:index];
      NSArray *tempArray = [nextString componentsSeparatedByString:@";"];
      if ([tempArray count] > 1) {
        NSString *firstWord = [tempArray objectAtIndex:0];
        int number = [firstWord intValue];
        if ([[NSString stringWithFormat:@"%d", number] isEqualToString:firstWord]) {
          [resultString appendFormat:@"%d%@", number, [tempArray objectAtIndex:1]];
        } else {
          [resultString appendFormat:@"%@;%@", firstWord, [tempArray objectAtIndex:1]];
        }
        if ([tempArray count] > 2) {
          for (NSUInteger ind = 2; ind < [tempArray count]; ind++) {
            [resultString appendFormat:@";%@", [tempArray objectAtIndex:ind]];
          }
        }
      } else {
        [resultString appendFormat:@"&#%@", nextString];
      }
    }
  }
  return resultString;
}

+ (NSString *)paramValueFromUrl:(NSURL *)url param:(NSString *)param {
  NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
  NSArray *queryItems = urlComponents.queryItems;
  return [NSString valueForKey:param fromQueryItems:queryItems];
}

+ (NSString *)valueForKey:(NSString *)key fromQueryItems:(NSArray *)queryItems {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
  NSURLQueryItem *queryItem = [[queryItems filteredArrayUsingPredicate:predicate] firstObject];
  return queryItem.value;
}

- (NSString *)urlEncode {
  return [self urlEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
  return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef) @"!*'\"();:@&=+$,/?%#[]% ",
                                                                               CFStringConvertNSStringEncodingToEncoding(encoding)));
}

- (BOOL)containsString:(NSString *)string caseSensitive:(BOOL)caseSensitive {
  BOOL isContains = NO;
  if (![NSString isNilOrEmpty:self] && ![NSString isNilOrEmpty:string]) {
    NSRange range;
    if (!caseSensitive) {
      range = [self rangeOfString:string options:NSCaseInsensitiveSearch];
    } else {
      range = [self rangeOfString:string];
    }
    isContains = (range.location != NSNotFound);
  }

  return isContains;
}

+ (NSString *)generateUuidString {
  CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
  NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
  CFRelease(uuid);
  return uuidString;
}

+ (NSString *)checkNull:(NSString *)value {
  if ([NSString isNilOrEmpty:value]) {
    return nil;
  }
  return value;
}

+ (NSDate *)dateWithXMLString:(NSString *)str {
  if ([NSString isNilOrEmpty:str]) {
    return nil;
  } else {
    return [DateFormatter dateFromString:str format:DFDefaultXmlDateFormat];
  }
}

+ (NSString *)xmlStringWithDate:(NSDate *)date {
  if (date == nil) {
    return nil;
  } else {
    return [DateFormatter formatDate:date withFormat:DateFormatterStyleDefaultXml];
  }
}

+ (NSString *)mimeTypeForFileAtPath:(NSString *)path {
  // Borrowed from ASIHTTPRequest
  if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
    return nil;
  }
  // Borrowed from http://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database
  CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
  CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
  CFRelease(UTI);
  if (!MIMEType) {
    return @"application/octet-stream";
  }
  return CFBridgingRelease(MIMEType);
}

- (BOOL)isEqualIgnoringCase:(NSString *)string {
  if ([NSString isNilOrEmpty:string]) {
    return NO;
  }
  return [self caseInsensitiveCompare:string] == NSOrderedSame;
}

- (NSString *)stringByTrimmingWhitespaces {
  return [self stringByTrimmingWhitespaces:NO];
}

- (NSString *)stringByTrimmingWhitespaces:(BOOL)trimNewLine {
  NSCharacterSet *set = nil;
  if (trimNewLine) {
    set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  } else {
    set = [NSCharacterSet whitespaceCharacterSet];
  }
  return [self stringByTrimmingCharactersInSet:set];
}

- (BOOL)isEmailValid {
  // The NSRegularExpression class is currently only available in the Foundation framework of iOS 4
  NSError *error = NULL;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}\\b"
                                                                         options:NSRegularExpressionCaseInsensitive | NSRegularExpressionAnchorsMatchLines
                                                                           error:&error];
  NSUInteger numberOfMatches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];

  if (!error && numberOfMatches > 0) {
    return YES;
  }

  return NO;
}

- (NSString *)emailDomain {
  if ([self isEmailValid]) {
    NSString *fullDomain = [[self componentsSeparatedByString:@"@"] lastObject];
    return [[fullDomain componentsSeparatedByString:@"."] objectAtIndex:0];
  } else {
    return nil;
  }
}

- (NSString *)emailDomainUpperCase {
  NSString *domain = [self emailDomain];
  if (domain) {
    domain = [domain capitalizedString];
  }
  return domain;
}

@end
