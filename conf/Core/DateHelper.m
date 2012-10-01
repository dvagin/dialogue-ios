//
//  DateHelper.m


#import "DateHelper.h"
#import "MyDebug.h"
#import "constants.h"

#define kSerializeDateFormat @"yyyy-MM-dd HH:mm:ss ZZZ"

@implementation DateHelper

+ (NSCalendar*) calendar
{
	static NSCalendar* __calendar = nil;
	
	if (!__calendar)
		__calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	return __calendar;
}

+ (NSDateComponents*) dateComponentsFromDate:(NSDate*)date
{
	unsigned units = units = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit |
						     NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
	return [[DateHelper calendar] components:units fromDate:date];
}
/*
+ (NSArray*) daysOfWeek
{
	static NSMutableArray* __days = nil;
	
	if (!__days)
	{
		__days = [NSMutableArray new];
		
		for (int day = 1; day <= 7; ++day)
		{
			NSString* key = [NSString stringWithFormat:kDayOfWeekLanguageKeyPrefix, day];
			[__days addObject:NSLocalizedString(key, nil)];
		}
	}
	
	return __days;
}*/

+ (NSInteger) dayOfWeekFromDate:(NSDate*)date
{
	return [[[DateHelper calendar] components:NSDayCalendarUnit fromDate:date] weekday];	
}

+ (NSString*) getHumanReadableMonthForNumber:(NSInteger)month
{
    NSString* name = nil;
    
    switch (month)
    {
        case 1:
            name = @"января";
            break;
            
        case 2:
            name = @"февраля";
            break;
            
        case 3:
            name = @"марта";
            break;
            
        case 4:
            name = @"апреля";
            break;
            
        case 5:
            name = @"мая";
            break;
            
        case 6:
            name = @"июня";
            break;
            
        case 7:
            name = @"июля";
            break;
            
        case 8:
            name = @"августа";
            break;
            
        case 9:
            name = @"сентября";
            break;
            
        case 10:
            name = @"октября";
            break;
            
        case 11:
            name = @"ноября";
            break;
            
        case 12:
            name = @"декабря";
            break;
            
        default:
            break;
    }
    
    return name;
}

+ (NSString*) getHumanReadableMatchMonthForNumber:(NSInteger)month
{
    NSString* name = nil;
    
    switch (month)
    {
        case 1:
            name = @"Январь";
            break;
            
        case 2:
            name = @"Февраль";
            break;
            
        case 3:
            name = @"Март";
            break;
            
        case 4:
            name = @"Апрель";
            break;
            
        case 5:
            name = @"Май";
            break;
            
        case 6:
            name = @"Июнь";
            break;
            
        case 7:
            name = @"Июль";
            break;
            
        case 8:
            name = @"Август";
            break;
            
        case 9:
            name = @"Сентябрь";
            break;
            
        case 10:
            name = @"Октябрь";
            break;
            
        case 11:
            name = @"Ноябрь";
            break;
            
        case 12:
            name = @"Декабрь";
            break;
            
        default:
            break;
    }
    
    return name;
}

+ (NSDate*) shortDateFromFullDate:(NSDate*)fullDate
{
	if (!fullDate)
	{
		MethodError(@"shortDateFromFullDate", @"An input argument is nil.");
		return nil;
	}

	NSDateFormatter* dateFormatter = [NSDateFormatter new];
	[dateFormatter setDateFormat:@"YYYY-MM-dd"];
	
	NSString* shortDateString = [NSString stringWithFormat:@"%@ 00:00:01", [dateFormatter stringFromDate:fullDate]];
	
	[dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
	NSDate* shortDate = [dateFormatter dateFromString:shortDateString];
	
	[dateFormatter release];
	
	return shortDate;
}

+ (BOOL) isYearLeap:(NSInteger)year
{
	BOOL isLeap = NO;
	
	if (year % 400 == 0)
		isLeap = YES;
	else if (year % 100 == 0)
		isLeap = NO;
	else if (year % 4 == 0)
		isLeap = YES;
				
	return isLeap;
}

+ (NSInteger) numberOfDaysInMonth:(NSInteger)month year:(NSInteger)year
{
	static NSDateFormatter* numberOfDaysDateFormatter = nil;
	
	if (!numberOfDaysDateFormatter)
	{
		numberOfDaysDateFormatter= [NSDateFormatter new];
		[numberOfDaysDateFormatter setDateFormat:@"YYYY-MM-dd"];
	}
	
	NSCalendar *c = [NSCalendar currentCalendar];
	NSRange days = [c rangeOfUnit:NSDayCalendarUnit 
						   inUnit:NSMonthCalendarUnit 
						  forDate:[numberOfDaysDateFormatter dateFromString:[NSString stringWithFormat:@"%.4d-%.2d-01", year, month]]];
	return days.length;
}

+ (NSString*) birthdayDescriptionFromDate:(NSDate*)date
{
	static NSDateFormatter* birthdayOfDaysDateFormatter = nil;
	
	if (!birthdayOfDaysDateFormatter)
	{
		birthdayOfDaysDateFormatter = [NSDateFormatter new];
		[birthdayOfDaysDateFormatter setDateFormat:@"d, YYYY"];
	}
	
	NSString* month = [NSString stringWithFormat:@"datePeriodMonth_%d", [DateHelper dateComponentsFromDate:date].month];
	return [NSString stringWithFormat:@"%@ %@", NSLocalizedString(month, nil), [birthdayOfDaysDateFormatter stringFromDate:date]];
}

+ (NSString*) localizedShortMonth:(NSInteger)monthNumber
{
	NSString* key = [NSString stringWithFormat:kMonthLocalizationKeyFormat, monthNumber];
	return NSLocalizedString(key, nil);
}

+ (NSString*) statisticReportDateFromDate:(NSDate*)date
{
	NSDateComponents* dateComponents = [DateHelper dateComponentsFromDate:date];
	NSString* monthKey = [NSString stringWithFormat:@"dateMonth_%d", dateComponents.month];
	return [NSString stringWithFormat:@"%d %@ %dг. %.2d:%.2d:%.2d", dateComponents.day,
						NSLocalizedString(monthKey, nil), dateComponents.year,
						dateComponents.hour, dateComponents.minute, dateComponents.second];
}

+ (NSDate*) dateFromString:(NSString*)dateString withDateFormat:(NSString*)dateFormat
{
    static NSDateFormatter* dateFormatter = nil;
    
    if (!dateFormatter)
    {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    
    dateFormatter.dateFormat = dateFormat;    
    if (dateString && dateString.length > 0)
        return [dateFormatter dateFromString:dateString];
    
    return nil;
}

+ (NSDate*) dateFromShortString:(NSString*)dateString
{
    return [self dateFromString:dateString withDateFormat:@"dd-MM-yyy"];
}

+ (NSDate*) dateFromStandardString:(NSString*)dateString
{
    
    return [self dateFromString:dateString withDateFormat:@"dd-MM-yyyy HH:mm:ss Z"]; // 06-11-2011 16:00:00 +0300
}

+ (NSString*) serializeDate:(NSDate*)date
{
    if (!date)
        return nil;
    
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = kSerializeDateFormat;
    NSString* serializedDate = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    
    return serializedDate;
}

+ (NSDate*) deserializeDate:(NSString*)serializedDate
{
    if (!serializedDate)
        return nil;
    
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = kSerializeDateFormat;
    NSDate* date = [dateFormatter dateFromString:serializedDate];
    [dateFormatter release];
    
    return date;
}

+ (NSString*) suffixForDays:(NSInteger)days
{
    NSInteger days_div_100 = days % 100;
    
    if (days_div_100 >= 10 && days_div_100 < 20)
        return @"дней";
    
    NSString* suffix = nil;
        
    switch (days % 10)
    {
        case 1:
            suffix = @"день";
            break;
            
        case 2:
        case 3:
        case 4:
            suffix = @"дня";
            break;
            
        default:
            suffix = @"дней";
            break;
    }
    
    return suffix;
}

+ (NSDictionary*) daysAndTimeFromDate:(NSDate*)date
{
    if (!date)
        return nil;

    NSTimeInterval delta = [date timeIntervalSince1970]; 
   
    NSInteger seconds = floor((int)delta % 60);
    NSInteger minutes = floor(((int)delta / 60) % 60);
    NSInteger hours = floor(((int)delta / 3600) % 24);
    NSInteger daysCount = floor(delta / (kSecondsIn24Hours));
    
    NSString* time = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", hours, minutes, seconds];
    NSString* days = (daysCount <= 0 ? @"" : [NSString stringWithFormat:@"%d %@", daysCount, [self suffixForDays:daysCount]]);
    
    return [NSDictionary dictionaryWithObjectsAndKeys:time, kTimeKey, days, kDaysKey, nil];
}

@end
