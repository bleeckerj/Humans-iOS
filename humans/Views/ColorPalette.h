//
//  ColorPalette.h
//  Pods
//
//  Created by Julian Bleecker on 7/8/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "StatusView.h"
#import "UIColor+FPBrandColor.h"

@interface ColorPalette : NSObject

@property (strong, nonatomic) UIColor *dateViewColor;
@property (strong, nonatomic) UIColor *dateViewText;
@property (strong, nonatomic) UIFont *dateViewFont;
@property (strong, nonatomic) NSNumber *dateViewHeight;
@property NSTextAlignment dateLabelAlignment;

@property (strong, nonatomic) UIColor *locViewColor;
@property (strong, nonatomic) UIColor *locViewText;
@property (strong, nonatomic) UIFont *locViewFont;
@property (strong, nonatomic) NSNumber *locViewHeight;
@property NSTextAlignment locLabelAlignment;

@property (strong, nonatomic) UIColor *nameViewColor;
@property (strong, nonatomic) UIColor *nameViewText;
@property (strong, nonatomic) UIFont *nameViewFont;
@property (strong, nonatomic) NSNumber *nameViewHeight;
@property NSTextAlignment nameLabelAlignment;

@property (strong, nonatomic) UIColor *statusViewColor;
@property (strong, nonatomic) UIColor *statusViewTextColor;
@property (strong, nonatomic) UIFont *statusViewFont;

@property (strong, nonatomic) UIColor *activityViewColor;

@property (strong, nonatomic) UIColor *replyLabelColor;
@property (strong, nonatomic) UIFont *replyLabelFont;

//@property (strong, nonatomic) NSNumber *replyUserViewHeight;
@property (strong, nonatomic) UIColor *replyUserLabelColor;
@property (strong, nonatomic) UIColor *replyUserLabelTextColor;
@property (strong, nonatomic) UIFont *replyUserLabelFont;
@property (strong, nonatomic) UIColor *replyLabelTextColor;

+ (ColorPalette*)grey;
+ (ColorPalette*)seaAndSky;
+ (ColorPalette *)melonBallSurprise;
+ (ColorPalette *)instaFall;

@end
