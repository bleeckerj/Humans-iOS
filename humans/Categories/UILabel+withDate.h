//
//  UILabel+withDate.h
//  Humans
//
//  Created by julian on 12/27/12.
//  Copyright (c) 2012 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defines.h"
#import "LoggerClient.h"

@interface UILabel (withDate)
//@property (nonatomic, retain) UILabel *dateLabel;
//@property (nonatomic, retain) NSDate *dateToShow;
- (id)initWithFrame:(CGRect)frame withDate:(NSDate *)date;
- (void)animateDate;
+ (NSString *)dateToStringInterval:(NSDate *)pastDate;
- (void)setDateToShow:(NSDate *)date;

@end
