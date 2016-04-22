//
//  DateFormatter.m
//  SuranceCRM
//
//  Created by Dmitry
//  Copyright 2014 Dancosoft. All rights reserved.
//

#import "DateFormatter.h"

@implementation DateFormatter

NSString *const DFDefaultXmlDateFormat = @"yyyy-MM-dd HH:mm:ss ZZ";

static NSMutableDictionary *dateFormats_ = nil;

#pragma mark - Public methods
+ (NSDate *)dateFromISO8601String:(NSString *)string {
  if ([NSString isNilOrEmpty:string]) {
    return nil;
  }
  struct tm tm;
  time_t t;
  strptime([string cStringUsingEncoding:NSUTF8StringEncoding], "%Y%m%dT%H%M%S%z", &tm);
  t = timegm(&tm);
  return [NSDate dateWithTimeIntervalSince1970:t];
}

+ (NSMutableDictionary *)dateFormatters {
  static NSMutableDictionary *dateFormatters = nil;
  if (dateFormatters == nil) {
    dateFormatters = [NSMutableDictionary new];
  }
  return dateFormatters;
}

+ (NSDateFormatter *)dateFormatter:(NSString *)format formatBehavior:(NSDateFormatterBehavior)formatterBehavior {
  return [DateFormatter dateFormatter:format formatBehavior:formatterBehavior withTimeZone:nil];
}

+ (NSDateFormatter *)dateFormatter:(NSString *)format formatBehavior:(NSDateFormatterBehavior)formatterBehavior withTimeZone:(NSString *)timeZone {
  return [self dateFormatter:format formatBehavior:formatterBehavior withTimeZone:timeZone withDefauleLocale:NO];
}

+ (NSDateFormatter *)dateFormatter:(NSString *)format
                    formatBehavior:(NSDateFormatterBehavior)formatterBehavior
                      withTimeZone:(NSString *)timeZone
                 withDefauleLocale:(BOOL)defaultLocale {
  NSMutableString *key = [NSMutableString stringWithString:format];
  switch (formatterBehavior) {
    case NSDateFormatterBehavior10_4:
      [key appendString:@"_1040_"];
      break;
    case NSDateFormatterBehaviorDefault:
      [key appendString:@"_0_"];
      break;
    default: {
      [key appendString:@"_"];
      [key appendString:[NSString stringWithFormat:@"%@", @(formatterBehavior)]];
      [key appendString:@"_"];
      break;
    }
  }
  if (timeZone != nil) {
    [key appendString:timeZone];
  }

  if (defaultLocale) {
    [key appendString:@"_default_"];
  }
  NSDateFormatter *dateFormatter = [[self dateFormatters] objectForKey:key];
  if (dateFormatter == nil) {
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:format];
    [dateFormatter setFormatterBehavior:formatterBehavior];
    if (defaultLocale) {
      NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
      dateFormatter.locale = locale;
    }
    if ([NSString isNilOrEmpty:timeZone]) {
      [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    } else {
      [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
    }
    [[self dateFormatters] setObject:dateFormatter forKey:key];
  }
  return dateFormatter;
}

+ (NSDateFormatter *)dateFormatter:(NSString *)format {
  return [self dateFormatter:format withDefauleLocale:NO];
}

+ (NSDateFormatter *)dateFormatter:(NSString *)format withDefauleLocale:(BOOL)defaultLocale {
  return [DateFormatter dateFormatter:format formatBehavior:NSDateFormatterBehaviorDefault withTimeZone:nil withDefauleLocale:defaultLocale];
}

+ (NSString *)stringToDate:(NSString *)str withFormat:(DateFormatterStyle)format {
  NSDate *date = [DateFormatter dateFromString:str format:DFDefaultXmlDateFormat];
  NSString *result = nil;
  if (date != nil) {
    result = [DateFormatter formatDate:date withFormat:format];
  }
  return result;
}

+ (NSDate *)dateFromString:(NSString *)strDate format:(NSString *)format {
  return [self dateFromString:strDate format:format withDefauleLocale:NO];
}

+ (NSDate *)dateFromString:(NSString *)strDate format:(NSString *)format withDefauleLocale:(BOOL)defaultLocale {
  return [[DateFormatter dateFormatter:format withDefauleLocale:defaultLocale] dateFromString:strDate];
}

+ (BOOL)isToday:(NSDate *)date {
  NSCalendar *calendar = [DateFormatter defaultCalendar];
  NSDateComponents *checkComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
  return [DateFormatter isToday:checkComponents forCalendar:calendar];
}

+ (BOOL)isTomorrow:(NSDate *)date {
  NSCalendar *calendar = [DateFormatter defaultCalendar];
  NSDateComponents *checkComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
  return [DateFormatter isTomorrow:checkComponents forCalendar:calendar];
}

+ (NSCalendar *)defaultCalendar {
  return [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
}

+ (BOOL)isToday:(NSDateComponents *)components forCalendar:(NSCalendar *)calendar {
  NSDateComponents *curComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
  return (([curComponents year] == [components year]) && ([curComponents month] == [components month]) && ([curComponents day] == [components day]));
}

+ (BOOL)isTomorrow:(NSDateComponents *)components forCalendar:(NSCalendar *)calendar {
  NSDateComponents *curComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
  // set tomorrow
  NSInteger day = [curComponents day];
  day++;
  [curComponents setDay:day];
  return (([curComponents year] == [components year]) && ([curComponents month] == [components month]) && ([curComponents day] == [components day]));
}

+ (NSString *)formatPatternDateTime {
  NSDateFormatter *dateFormatter = [DateFormatter dateFormatter:@"DateTime" formatBehavior:NSDateFormatterBehavior10_4];
  if ([dateFormatter timeStyle] != NSDateFormatterShortStyle || [dateFormatter dateStyle] != NSDateFormatterShortStyle) {
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
  }
  return [dateFormatter dateFormat];
}

+ (NSString *)formatPatternDate {
  NSDateFormatter *dateFormatter = [DateFormatter dateFormatter:@"Date" formatBehavior:NSDateFormatterBehavior10_4];
  if ([dateFormatter timeStyle] != NSDateFormatterNoStyle || [dateFormatter dateStyle] != NSDateFormatterShortStyle) {
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
  }
  return [dateFormatter dateFormat];
}

+ (NSString *)formatPatternTime {
  NSDateFormatter *dateFormatter = [DateFormatter dateFormatter:@"Time" formatBehavior:NSDateFormatterBehavior10_4];
  if ([dateFormatter timeStyle] != NSDateFormatterShortStyle || [dateFormatter dateStyle] != NSDateFormatterNoStyle) {
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
  }
  return [dateFormatter dateFormat];
}

+ (NSString *)formatDate:(NSDate *)date withFormat:(DateFormatterStyle)format timeZone:(NSString *)timeZone {
  // copy input date value, add device timezone
  NSString *dateFormat = nil;
  switch (format) {
    case DateFormatterStyleDateWithTime:
      dateFormat = @"EEE, MMM d, yyyy hh:mm a";
      break;
    case DateFormatterStyleLongDate:
      dateFormat = @"EEE, MMM d, yyyy";
      break;
    case DateFormatterStyleDayMonthYear:
      dateFormat = @"dd-MMM-yyyy";
      break;
    case DateFormatterStyleDayMonthShortYear:
      dateFormat = @"dd-MMM-yy";
      break;
    case DateFormatterStyleEndOfToday:
      dateFormat = @"yyyy-MM-dd 23:59:59 ZZ";
      break;
    case DateFormatterStyleMonthYear:
      dateFormat = @"MMM yy";
      break;
    case DateFormatterStyleShortDateOrTodaysTime:
      dateFormat = [DateFormatter isToday:date] ? [DateFormatter formatPatternTime] : @"MMM dd";
      break;
    case DateFormatterStyleShortDateOrTodaysTomorrowsTime: {
      NSCalendar *calendar = [DateFormatter defaultCalendar];
      NSDateComponents *checkComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
      if ([DateFormatter isToday:checkComponents forCalendar:calendar] || [DateFormatter isTomorrow:checkComponents forCalendar:calendar]) {
        dateFormat = [DateFormatter formatPatternTime];
      } else {
        dateFormat = @"MMM dd";
      }
      break;
    }
    case DateFormatterStyleDateOrTodaysTime:
      dateFormat = [DateFormatter isToday:date] ? [DateFormatter formatPatternTime] : [DateFormatter formatPatternDate];
      break;
    case DateFormatterStyleDateWithTime12:
      dateFormat = @"MMM d hh:mm a";
      break;
    case DateFormatterStyleDateOnly:
      dateFormat = [DateFormatter formatPatternDate];
      break;
    case DateFormatterStyleShortDateMonthYear:
      dateFormat = @"MMM d, yyyy";
      break;
    case DateFormatterStyleFullDateAndTimeWithoutZone:
      dateFormat = @"dd-MMM-yyyy hh:mm:ss";
      break;
    case DateFormatterStyleFullDateAndTimeWithoutZoneAndSeconds:
      dateFormat = @"dd-MMM-yyyy hh:mm";
      break;
    case DateFormatterStyleDefaultXml:
      dateFormat = DFDefaultXmlDateFormat;
      break;
    default:
      dateFormat = [NSString string];
  }

  // Set time format as per device settings
  if ([dateFormat rangeOfString:@":mm"].length != 0) {
    if ([self is24HourFormat]) {
      dateFormat = [dateFormat stringByReplacingOccurrencesOfString:@" a" withString:@""];
      dateFormat = [dateFormat stringByReplacingOccurrencesOfString:@"a" withString:@""];
      dateFormat = [dateFormat stringByReplacingOccurrencesOfString:@"h" withString:@"H"];
    }
  }
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChanged) name:NSCurrentLocaleDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChanged) name:NSSystemTimeZoneDidChangeNotification object:nil];
  });
  // localize
  // dateFormat = [self dateFormatFromTemplate:dateFormat options:0 locale:[NSLocale currentLocale]];

  NSDateFormatter *formatter;
  if ([NSString isNilOrEmpty:timeZone]) {
    formatter = [DateFormatter dateFormatter:dateFormat formatBehavior:NSDateFormatterBehavior10_4];
  } else {
    formatter = [DateFormatter dateFormatter:dateFormat formatBehavior:NSDateFormatterBehavior10_4 withTimeZone:timeZone];
  }

  return [formatter stringFromDate:date];
}

+ (void)localeDidChanged {
  [dateFormats_ removeAllObjects];
  [[self dateFormatters] removeAllObjects];
}

+ (NSString *)dateFormatFromTemplate:(NSString *)tmplate options:(NSUInteger)opts locale:(NSLocale *)locale {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dateFormats_ = [NSMutableDictionary new];
  });
  NSString *result = [dateFormats_ objectForKey:tmplate];
  if (result == nil) {
    result = [NSDateFormatter dateFormatFromTemplate:tmplate options:0 locale:[NSLocale currentLocale]];
    [dateFormats_ setObject:result forKey:tmplate];
  }
  return result;
}

+ (NSString *)formatDate:(NSDate *)date withFormat:(DateFormatterStyle)format {
  if (date == nil || [date isEqual:[NSNull null]]) {
    return @"";
  }
  return [DateFormatter formatDate:date withFormat:format timeZone:nil];
}

+ (BOOL)is24HourFormat {  // TODO: find another implementation for defining time format from settings
  NSString *key = @"is24HourFormat";
  NSDateFormatter *formatter = [[self dateFormatters] objectForKey:key];
  if (formatter == nil) {
    formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [[self dateFormatters] setObject:formatter forKey:key];
  }

  NSString *dateString = [formatter stringFromDate:[NSDate date]];
  NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
  NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
  BOOL is24Hour = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
  return is24Hour;
}

+ (NSDate *)dateTimeNow {
  NSDate *savedDate = [NSDate date];
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  unsigned components = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
  NSDateComponents *comps = [gregorian components:components fromDate:savedDate];
  return [gregorian dateFromComponents:comps];
}

@end
