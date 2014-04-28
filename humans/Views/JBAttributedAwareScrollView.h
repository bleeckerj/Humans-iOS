//
//  JBTestScrollView.h
//  TestTTTAttributedLabel
//
//  Created by Julian Bleecker on 4/10/14.
//  Copyright (c) 2014 Julian Bleecker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import <TTTAttributedLabel.h>
#import <UIColor+Crayola.h>
@interface JBAttributedAwareScrollView : UIView
@property (strong, nonatomic) TTTAttributedLabel *label;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIFont *font;
- (void)boldText:(NSString *)str withFont:(UIFont *)boldFont;
- (void)setTextColor:(UIColor *)_color;

@end
