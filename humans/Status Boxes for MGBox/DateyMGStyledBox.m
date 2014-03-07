//
//  DateyMGStyledBox.m
//  Humans
//
//  Created by julian on 8/11/12.
//
//

#import "DateyMGStyledBox.h"

@implementation DateyMGStyledBox

@synthesize dateLabel;
@synthesize dateToShow;

static NSDateFormatter *formatter;// = [[NSDateFormatter alloc] init];
static NSDateFormatter *formatter_2;// = [[NSDateFormatter alloc]init];
NSDate *mFirstStatusItemOfTheDay;


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

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    if(formatter == nil || formatter_2 == nil) {
        [DateyMGStyledBox initialize];
    }
    mFirstStatusItemOfTheDay = [NSDate distantFuture];//[[NSDate alloc]init];
    dateLabel = [[UILabel alloc]initWithFrame:(CGRectMake(200, 0, 100, 25))];
    [dateLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    //[dateLabel setText:stringFromDate];
}

- (void)setDateToShow:(NSDate *)_dateToShow
{
    dateToShow = _dateToShow;
    NSString *stringFromDate = [formatter stringFromDate:dateToShow];
    [dateLabel setText:stringFromDate];
}

#pragma mark -
#pragma mark date utility thing
// cf: http://stackoverflow.com/questions/1854890/comparing-two-nsdates-and-ignoring-the-time-component

-(NSInteger) daysBetweenDate:(NSDate *)firstDate andDate:(NSDate *)secondDate {
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components: NSDayCalendarUnit fromDate: firstDate toDate: secondDate options: 0];
    NSInteger days = [components hour];
    return days;
}

- (NSString *)fdateToStringInterval:(NSDate *)pastDate {
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
        if (-[breakdownInfo month] > 1)
            intervalString = [NSString stringWithFormat:@"%d months ago", -[breakdownInfo month]];
        else
            intervalString = @"1 month ago";
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
    NSString *stringTimeAgo = [self fdateToStringInterval:([self dateToShow])];
    
    [UIView animateWithDuration:2 animations:^{
        [dateLabel setAlpha:1.0];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:2 animations:^{
            [dateLabel setText:stringDayFromDate];
            [dateLabel setAlpha:0.75];
        } completion:^(BOOL finished) {
            [dateLabel setText:stringTimeAgo];
            [dateLabel setAlpha:0.5];
            
        }];
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
