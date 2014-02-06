//
//  UILabel+withDate.m
//  Humans
//
//  Created by julian on 12/27/12.
//  Copyright (c) 2012 nearfuturelaboratory. All rights reserved.
//

#import "UILabel+withDate.h"

@implementation UILabel (withDate)
NSDate *mFirstStatusItemOfTheDay;
NSDate *dateToShow;
NSString *intervalDateToShow;
static NSDateFormatter *formatter;// = [[NSDateFormatter alloc] init];
static NSDateFormatter *formatter_2;// = [[NSDateFormatter alloc]init];


- (id)initWithFrame:(CGRect)frame withDate:(NSDate *)date
{
    self = [super initWithFrame:frame];
    if(formatter_2 == nil || formatter == nil) {
        [UILabel initialize];
    }
    if(self) {
        dateToShow = date;
        [self setText:[self fdateToStringInterval:dateToShow]];
        //LOG_UI(0, @"fdate is %@", [self text]);
     }
    return self;
}

// to reuse?
- (void)setDateToShow:(NSDate *)date
{
    dateToShow = date;
    [self setText:[self fdateToStringInterval:dateToShow]];
}

+(void)initialize
{
    //Optionally for time zone conversions
    //    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    formatter = [[NSDateFormatter alloc] init];
    formatter_2 = [[NSDateFormatter alloc]init];
    //    [formatter setDateFormat:@"MMM d yyyy h a zzz"];
    //[formatter setDateFormat:@"MMM d yyyy ha zzz"];
    [formatter setDateFormat:@"MMM d yyyy"];
    [formatter_2 setDateFormat:@"'A' EEEE"];
}



#pragma mark date utility thing
// cf: http://stackoverflow.com/questions/1854890/comparing-two-nsdates-and-ignoring-the-time-component

- (NSInteger) daysBetweenDate:(NSDate *)firstDate andDate:(NSDate *)secondDate {
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components: NSDayCalendarUnit fromDate: firstDate toDate: secondDate options: 0];
    NSInteger days = [components hour];
    return days;
}

+ (NSString *)dateToStringInterval:(NSDate *)pastDate
{
    NSAssert((pastDate != nil),@"Why is pastDate nil?");

    //! Method to return a string "xxx days ago" based on the difference between pastDate and the current date and time.
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the current date
    NSDate *currentDate = [[NSDate alloc] init];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;

    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:currentDate  toDate:pastDate  options:0];
    
    //NSLog(@"Break down: %dmin %dhours %ddays %dmonths",[breakdownInfo minute], [breakdownInfo hour], [breakdownInfo day], [breakdownInfo month]);
    
    NSString *intervalString;
    if ([breakdownInfo year]) {
        if (-[breakdownInfo year] > 1)
            intervalString = [NSString stringWithFormat:@"%d years ago", -[breakdownInfo month]];
        else
            intervalString = @"1 year ago";
        
    } else if ([breakdownInfo month]) {
        if (-[breakdownInfo month] > 1) {
            if(-[breakdownInfo day] > 1) {
                intervalString = [NSString stringWithFormat:@"%dmo, %dd ago", -[breakdownInfo month], -[breakdownInfo day]];
            } else {
                intervalString = [NSString stringWithFormat:@"%dmo ago", -[breakdownInfo month]];
            }
        }
        else {
            if(-[breakdownInfo day] > 1) {
                intervalString = [NSString stringWithFormat:@"%dmo, %dd ago", -[breakdownInfo month], -[breakdownInfo day]];
            } else {
                intervalString = @"1mo ago";
            }
        }
    }
    else if ([breakdownInfo day]) {
        if (-[breakdownInfo day] > 1)
            intervalString = [NSString stringWithFormat:@"%dd ago", -[breakdownInfo day]];
        else
            intervalString = @"1d ago";
    }
    else if ([breakdownInfo hour]) {
        if (-[breakdownInfo hour] > 1)
            intervalString = [NSString stringWithFormat:@"%dh ago", -[breakdownInfo hour]];
        else
            intervalString = @"1h ago";
    }
    else {
        if (-[breakdownInfo minute] > 1)
            intervalString = [NSString stringWithFormat:@"%dm ago", -[breakdownInfo minute]];
        else
            intervalString = @"1m ago";
    }
    
    return intervalString;

}

- (NSString *)fdateToStringInterval:(NSDate *)pastDate {
    //! Method to return a string "xxx days ago" based on the difference between pastDate and the current date and time.
    // Get the system calendar
    return [UILabel dateToStringInterval:pastDate];
    
    /*
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the current date
    NSDate *currentDate = [[NSDate alloc] init];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:currentDate  toDate:pastDate  options:0];
    
    //NSLog(@"Break down: %dmin %dhours %ddays %dmonths",[breakdownInfo minute], [breakdownInfo hour], [breakdownInfo day], [breakdownInfo month]);
    
    NSString *intervalString;
    if ([breakdownInfo year]) {
        if (-[breakdownInfo year] > 1) {
            if (-[breakdownInfo month] > 0) {
                intervalString = [NSString stringWithFormat:@"%u years %d months ago", -[breakdownInfo year], -[breakdownInfo month]];
            } else {
                intervalString = [NSString stringWithFormat:@"%u years ago", -[breakdownInfo year]];
            }
        }
        else {
            intervalString = @"A year ago";
        }
        
    } else if ([breakdownInfo month]) {
        if (-[breakdownInfo month] > 1) {
            if(-[breakdownInfo day] > 1) {
                intervalString = [NSString stringWithFormat:@"%d months %d days ago", -[breakdownInfo month], -[breakdownInfo day]];
            } else {
                intervalString = [NSString stringWithFormat:@"%d months ago", -[breakdownInfo month]];
            }
        }
        else {
            if(-[breakdownInfo day] > 1) {
                intervalString = [NSString stringWithFormat:@"%d month %d days ago", -[breakdownInfo month], -[breakdownInfo day]];
            } else {
                intervalString = @"1 month ago";
            }
        }
    }
    else if ([breakdownInfo day]) {
        if (-[breakdownInfo day] > 1)
            intervalString = [NSString stringWithFormat:@"%d days ago", -[breakdownInfo day]];
        else
            intervalString = @"1 day ago";
    }
    else if ([breakdownInfo hour]) {
        if (-[breakdownInfo hour] > 1)
            intervalString = [NSString stringWithFormat:@"%d hours ago", -[breakdownInfo hour]];
        else
            intervalString = @"1 hour ago";
    }
    else {
        if (-[breakdownInfo minute] > 1)
            intervalString = [NSString stringWithFormat:@"%d minutes ago", -[breakdownInfo minute]];
        else
            intervalString = @"1 minute ago";
    }
    
    return intervalString;
 */
}

-(BOOL) areMinuteHourMonthYearIdenticalBetweenDate:(NSDate *)firstDate andDate:(NSDate *)secondDate {
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    //NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *firstDateComps;
    NSDateComponents *secondDateComps;
    
    [currentCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    
    firstDateComps = [currentCalendar components:unitFlags fromDate:firstDate];
    secondDateComps = [currentCalendar components:unitFlags fromDate:secondDate];
    
    BOOL result = NO;
    
    // same day different minute, same hour
    if(
       ([firstDateComps day] == [secondDateComps day]) &&
       ([firstDateComps minute] != [secondDateComps minute]) &&
       ([firstDateComps hour] == [firstDateComps hour]))
        
    {
        return NO;
    }
    
    // samd day different hour
    if(
       ([firstDateComps day] == [secondDateComps day]) &&
       ([firstDateComps hour] != [secondDateComps hour]))
        
    {
        return NO;
    }
    
    // same day, who cares?
    if([firstDateComps day] == [secondDateComps day]) {
        result = YES;
    }
    /*
     if(compare == NSOrderedSame) {
     result = YES;
     }
     */
    //iOSSLog(@"%d == %@ %@", result, truncFirst, truncSecond);
    
    return result;
    
}

- (void)animateDate
{
    NSString *stringDayFromDate = [formatter_2 stringFromDate:dateToShow];
    //NSDate *hCurrentStatusItemDate = [self dateToShow];
    NSString *stringTimeAgo = [self fdateToStringInterval:dateToShow];
    
    [UIView animateWithDuration:1 animations:^{
        [self setAlpha:0.75];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:2 animations:^{
            [self setText:stringDayFromDate];
            [self setAlpha:1.0];
        } completion:^(BOOL finished) {
            [self setText:stringTimeAgo];
            [self setAlpha:1.0];
            
        }];
    }];
}




@end
