//
//  DateHelper.h


#import <Foundation/Foundation.h>
#import "constants.h"

#define kSecondsIn24Hours 24 * 3600.0

#define kYear @"year"
#define kMonth @"month"
#define kDay @"day"
#define kDayOfWeek @"dayOfWeek"
#define kSourceDate @"sourceDate"
#define kSourceDateFrom @"sourceDateFrom"
#define kSourceDateTo @"sourceDateTo"
#define kMonthLocalizationKeyFormat @"datePeriodMonth_%d"

#define kDaysKey @"days"
#define kTimeKey @"time"

@interface DateHelper : NSObject
{

}

+ (NSDateComponents*) dateComponentsFromDate:(NSDate*)date;

+ (NSInteger) dayOfWeekFromDate:(NSDate*)date;

+ (NSString*) getHumanReadableMonthForNumber:(NSInteger)month;
+ (NSString*) getHumanReadableMatchMonthForNumber:(NSInteger)month;

+ (NSDate*) shortDateFromFullDate:(NSDate*)fullDate;

+ (BOOL) isYearLeap:(NSInteger)year;

+ (NSInteger) numberOfDaysInMonth:(NSInteger)month year:(NSInteger)year;

+ (NSString*) birthdayDescriptionFromDate:(NSDate*)date;

+ (NSString*) localizedShortMonth:(NSInteger)monthNumber;

+ (NSString*) statisticReportDateFromDate:(NSDate*)date;

+ (NSDate*) dateFromString:(NSString*)dateString withDateFormat:(NSString*)dateFormat;
+ (NSDate*) dateFromShortString:(NSString*)dateString;
+ (NSDate*) dateFromStandardString:(NSString*)dateString;

+ (NSString*) serializeDate:(NSDate*)date;
+ (NSDate*) deserializeDate:(NSString*)serializedDate;

+ (NSDictionary*) daysAndTimeFromDate:(NSDate*)date;

@end
