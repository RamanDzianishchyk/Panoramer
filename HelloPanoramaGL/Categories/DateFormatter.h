//
//  DateFormatter.h
//  SuranceCRM
//
//  Created by Dmitry
//  Copyright 2014 Dancosoft. All rights reserved.
//

typedef enum {
  DateFormatterStyleDateWithTime = 0,
  DateFormatterStyleDayMonthYear,
  DateFormatterStyleDayMonthShortYear,
  DateFormatterStyleEndOfToday,
  DateFormatterStyleMonthYear,
  DateFormatterStyleLongDate,
  DateFormatterStyleShortDateOrTodaysTime,
  DateFormatterStyleShortDateOrTodaysTomorrowsTime,
  DateFormatterStyleDateOrTodaysTime,
  DateFormatterStyleDateOnly,
  DateFormatterStyleShortDateMonthYear,
  DateFormatterStyleDateWithTime12,
  DateFormatterStyleFullDateAndTimeWithoutZone,
  DateFormatterStyleFullDateAndTimeWithoutZoneAndSeconds,
  DateFormatterStyleDefaultXml
} DateFormatterStyle;

extern NSString *const DFDefaultXmlDateFormat;

@interface DateFormatter : NSObject {
}

+ (NSString *)formatDate:(NSDate *)date withFormat:(DateFormatterStyle)format;
+ (NSString *)stringToDate:(NSString *)str withFormat:(DateFormatterStyle)format;
+ (NSString *)formatDate:(NSDate *)date withFormat:(DateFormatterStyle)format timeZone:(NSString *)timeZone;
+ (NSDateFormatter *)dateFormatter:(NSString *)format formatBehavior:(NSDateFormatterBehavior)formatterBehavior withTimeZone:(NSString *)timeZone;
+ (NSDateFormatter *)dateFormatter:(NSString *)format formatBehavior:(NSDateFormatterBehavior)formatterBehavior;
+ (NSDateFormatter *)dateFormatter:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)strDate format:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)strDate format:(NSString *)format withDefauleLocale:(BOOL)defaultLocale;
+ (NSDate *)dateTimeNow;
+ (BOOL)is24HourFormat;

+ (NSDate *)dateFromISO8601String:(NSString *)string;
+ (BOOL)isToday:(NSDate *)date;
+ (BOOL)isTomorrow:(NSDate *)date;
+ (NSCalendar *)defaultCalendar;
+ (BOOL)isToday:(NSDateComponents *)components forCalendar:(NSCalendar *)calendar;
+ (BOOL)isTomorrow:(NSDateComponents *)components forCalendar:(NSCalendar *)calendar;

+ (NSString *)formatPatternDateTime;
+ (NSString *)formatPatternDate;
+ (NSString *)formatPatternTime;

@end
