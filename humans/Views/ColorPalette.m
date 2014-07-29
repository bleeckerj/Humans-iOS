//
//  ColorPalette.m
//  Pods
//
//  Created by Julian Bleecker on 7/8/14.
//
//
#import "defines.h"
#import "ColorPalette.h"
#import "UIColor+Expanded.h"


ColorPalette *grey;
ColorPalette *sea_and_sky;

@implementation ColorPalette

- (id)init
{
    self = [super init];
    if(self) {
        [self buildPalettes];
    }
    return self;
}

- (void)buildPalettes
{

    


}

- (void)applyGrey:(StatusView *)view
{
    
}


+ (ColorPalette*)grey
{
    ColorPalette *grey = ColorPalette.new;
    
    grey.dateViewColor = [[UIColor colorWithHexString:@"f6f8fc"]colorByDarkeningTo:0.90];
    grey.dateViewText = [UIColor colorWithHexString:@"bed2d9"];
    grey.dateViewFont = [UIFont fontWithName:@"DINPro-Black" size:24];
    grey.dateViewHeight = @40;
    grey.dateLabelAlignment = NSTextAlignmentCenter;

    grey.locViewColor = [UIColor colorWithHexString:@"ecf1f1"];
    grey.locViewText = [UIColor colorWithHexString:@"bed2d9"];
    grey.locViewFont = [UIFont fontWithName:@"DINPro-Black" size:24];
    grey.locLabelAlignment = NSTextAlignmentCenter;
    grey.locViewHeight = @40;
    grey.locLabelAlignment = NSTextAlignmentCenter;

    
    grey.statusViewColor = [UIColor colorWithHexString:@"BED2D9"];
    grey.statusViewTextColor = [UIColor whiteColor];
    grey.statusViewFont = [UIFont fontWithName:@"Avenir-Medium" size:22];
    
    grey.activityViewColor = [UIColor colorWithHexString:@"F1F1F2"];
    
    grey.replyLabelColor = [UIColor Twitter];
    grey.replyLabelFont = [UIFont fontWithName:@"Avenir-Black" size:20];
    grey.replyLabelColor = [UIColor colorWithHexString:@"F0E0D0"];
    grey.replyUserLabelFont = [UIFont fontWithName:@"Avenir-Black" size:18];
    grey.replyUserLabelTextColor = [UIColor Twitter];
    grey.replyLabelTextColor = [UIColor Twitter];

    grey.nameLabelAlignment = NSTextAlignmentCenter;
    grey.nameViewFont = [UIFont fontWithName:@"Avenir-Roman" size:28];
    grey.nameViewHeight = NAME_VIEW_HEIGHT;
    
    
    return grey;
}

+ (ColorPalette *)seaAndSky
{
    ColorPalette *sea_and_sky = ColorPalette.new;
    sea_and_sky.dateViewColor = [UIColor colorWithHexString:@"fbd710"];
    sea_and_sky.dateViewText = [UIColor whiteColor];
    sea_and_sky.dateViewFont = [UIFont fontWithName:@"Avenir-Heavy" size:22];
    sea_and_sky.dateViewHeight = @40;
    sea_and_sky.dateLabelAlignment = NSTextAlignmentRight;
    
    sea_and_sky.locViewColor = [UIColor colorWithHexString:@"8bceb5"];
    sea_and_sky.locViewText = [UIColor whiteColor];
    sea_and_sky.locViewFont = [UIFont fontWithName:@"Avenir-Heavy" size:22];
    sea_and_sky.locViewHeight = @40;
    sea_and_sky.locLabelAlignment = NSTextAlignmentRight;
    
    sea_and_sky.statusViewColor = [UIColor colorWithHexString:@"4da0b1"];
    sea_and_sky.statusViewTextColor = [UIColor whiteColor];
    sea_and_sky.statusViewFont =  [UIFont fontWithName:@"Avenir-Heavy" size:20];
    
    sea_and_sky.replyLabelColor = sea_and_sky.statusViewColor;
    sea_and_sky.replyLabelFont = [UIFont fontWithName:@"Avenir-Book" size:20];
    sea_and_sky.replyLabelTextColor = [UIColor whiteColor];
    sea_and_sky.replyUserLabelColor = [UIColor clearColor];
    sea_and_sky.replyUserLabelFont = [UIFont fontWithName:@"Avenir-Heavy" size:18];
    sea_and_sky.replyUserLabelTextColor = [UIColor whiteColor];
    
    sea_and_sky.nameLabelAlignment = NSTextAlignmentRight;
    sea_and_sky.nameViewFont = [UIFont fontWithName:@"Avenir-Roman" size:48];
    sea_and_sky.nameViewHeight = NAME_VIEW_HEIGHT;
    
    return sea_and_sky;
}

+ (ColorPalette *)melonBallSurprise
{
    ColorPalette *melon_ball_surprise = ColorPalette.new;
    melon_ball_surprise.dateViewColor = [UIColor colorWithHexString:@"f06890"];
    melon_ball_surprise.dateViewText = [UIColor whiteColor];//[[UIColor colorWithHexString:@"d0f1a4"]complementaryColor];
    melon_ball_surprise.dateViewFont = [UIFont fontWithName:@"Avenir-Heavy" size:22];
    melon_ball_surprise.dateViewHeight = @40;
    melon_ball_surprise.dateLabelAlignment = NSTextAlignmentRight;
    
    melon_ball_surprise.locViewColor = [UIColor colorWithHexString:@"d0f1a4"];
    melon_ball_surprise.locViewText = [UIColor whiteColor];
    melon_ball_surprise.locViewFont = [UIFont fontWithName:@"Avenir-Heavy" size:22];
    melon_ball_surprise.locViewHeight = @40;
    melon_ball_surprise.locLabelAlignment = NSTextAlignmentRight;
    
    melon_ball_surprise.statusViewColor = [UIColor colorWithHexString:@"f79d80"];
    melon_ball_surprise.statusViewTextColor = [UIColor whiteColor];
    melon_ball_surprise.statusViewFont = [UIFont fontWithName:@"Avenir-Heavy" size:20];
    
    melon_ball_surprise.replyLabelColor = [UIColor blueColor];
    melon_ball_surprise.replyLabelFont = [UIFont fontWithName:@"Avenir-Book" size:20];
    melon_ball_surprise.replyLabelTextColor = [UIColor Twitter];
    //melon_ball_surprise.replyUserViewHeight = @40;
    melon_ball_surprise.replyUserLabelFont = [UIFont fontWithName:@"Avenir-Book" size:18];
    melon_ball_surprise.replyUserLabelTextColor = [UIColor whiteColor];
    melon_ball_surprise.replyUserLabelColor = [UIColor clearColor];
    
    melon_ball_surprise.nameLabelAlignment = NSTextAlignmentRight;
    melon_ball_surprise.nameViewFont = [UIFont fontWithName:@"Avenir-Roman" size:48];
    melon_ball_surprise.nameViewHeight = NAME_VIEW_HEIGHT;
    
    return melon_ball_surprise;
  
}

+ (ColorPalette*)instaFall
{
    ColorPalette *instaFall = ColorPalette.new;
    instaFall.dateViewText = [UIColor whiteColor];//[[UIColor colorWithHexString:@"d0f1a4"]complementaryColor];
    instaFall.dateViewFont = [UIFont fontWithName:@"Avenir-Heavy" size:22];
    instaFall.dateViewHeight = @40;
    instaFall.dateLabelAlignment = NSTextAlignmentRight;
    instaFall.dateViewColor = [UIColor colorWithHexString:@"FFD816"];
    
    instaFall.locViewColor = [UIColor colorWithHexString:@"8cc63e"];
    instaFall.locViewText = [UIColor whiteColor];
    instaFall.locViewFont = [UIFont fontWithName:@"Avenir-Heavy" size:22];
    instaFall.locViewHeight = @40;
    instaFall.locLabelAlignment = NSTextAlignmentRight;
    
    instaFall.statusViewColor = [UIColor colorWithHexString:@"ed7748"];
    instaFall.statusViewTextColor = [UIColor whiteColor];
    instaFall.statusViewFont = [UIFont fontWithName:@"Avenir-Heavy" size:20];
    
    instaFall.replyLabelColor = [UIColor Twitter];
    instaFall.replyLabelFont = [UIFont fontWithName:@"Avenir-Book" size:20];
    instaFall.replyLabelTextColor = [UIColor whiteColor];
    instaFall.replyUserLabelFont = [UIFont fontWithName:@"Avenir-Book" size:18];
    instaFall.replyUserLabelTextColor = [UIColor whiteColor];
    instaFall.replyUserLabelColor = [UIColor clearColor];

    instaFall.nameLabelAlignment = NSTextAlignmentRight;
    instaFall.nameViewFont = [UIFont fontWithName:@"Avenir-Roman" size:48];
    instaFall.nameViewHeight = NAME_VIEW_HEIGHT;
    return instaFall;
    
}

@end
