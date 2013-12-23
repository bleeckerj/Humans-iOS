//
//  TwitterStatus_Box.m
//  Humans
//
//  Created by Julian Bleecker on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HuTwitterStatus_Box.h"



#define IMAGE_LINE_HEIGHT_PADDING 80
#define IMAGE_LINE_PADDING 0

@implementation HuTwitterStatus_Box

@synthesize status;
//@synthesize parent;
//@synthesize amObserving;

SwipeAwayMGLineStyled *statusLine;
MGLineStyled *dateLine, *imageLine;






- (id)initWithTwitterStatus:(TwitterStatus *)_status
{
    self = [super init];
    if(self) {
        self.status = _status;
    }
    return self;
}




- (void)setStatus:(TwitterStatus *)_twitterStatus
{
    status = _twitterStatus;
    // determine whether status has an image and from where
    // or if it's a foursquare status
    
    //[self setDateToShow:[twitterStatus dateForSorting]];
    
//    [self.topLines removeAllObjects];
//    [self.middleLines removeAllObjects];
//    [self.bottomLines removeAllObjects];
    [self setup];
    [self buildContentBoxes];    
    
}

- (void)setup
{
    [super setup];
    // shape, size, and position
    self.width = self.width ? self.width : WIDTH;
    self.topMargin = TOP_MARGIN;
    self.bottomMargin = BOTTOM_MARGIN;
    self.leftMargin = LEFT_MARGIN;
    self.padding = (UIEdgeInsetsMake(8.0, 0.0, 8.0, 0.0));
    
    // shape and colour
    self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
    self.layer.cornerRadius = CORNER_RADIUS;
    
    // shadow
    self.layer.shadowColor = [UIColor colorWithWhite:0.12 alpha:1].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 0;
    
    // performance
    self.rasterize = YES;

}


- (void)buildContentBoxes
{
    MGLine *statusLine = [MGLine multilineWithText:[status statusTextNoURL] font:TWITTER_FONT width:self.width
                                           padding:UIEdgeInsetsMake(TEXT_TOP_PADDING, TEXT_LEFT_PADDING, TEXT_BOTTOM_PADDING, TEXT_RIGHT_PADDING)];
    
    
    //[MGLine lineWithLeft:@"Hello" right:@"What the fuck?"];
    [self.topLines addObject:statusLine];
    
//    MGLine *dateLine = [MGLine lineWithLeft:[UIImage imageNamed:@"twitter-bottom-line"] right:@"10m" size:DATELINE_ROW_SIZE];
//    [dateLine setPadding:UIEdgeInsetsMake(TEXT_TOP_PADDING, TEXT_LEFT_PADDING, TEXT_BOTTOM_PADDING, TEXT_RIGHT_PADDING)];
//    [dateLine setFont:DATELINE_FONT];
//    [self.bottomLines addObject:dateLine];
}

- (CGRect)rectForImage:(UIImage*)image maxSize:(CGSize)value
{
    float hfactor = image.size.width / value.width;
    float vfactor = image.size.height / value.height;
    
    float factor = fmax(hfactor, vfactor);
    //NSLog(@"%f", factor);
    // Divide the size by the greater of the vertical or horizontal shrinkage factor
    float newWidth = image.size.width / factor;
    float newHeight = image.size.height / factor;
    
    // Then figure out if you need to offset it to center vertically or horizontally
    float leftOffset = (value.width - newWidth) / 2;
    float topOffset = (value.height - newHeight) / 2;
    
    CGRect newRect = CGRectMake(leftOffset, topOffset, newWidth, newHeight);
    return newRect;
}

- (void)dealloc
{
    NSLog(@"%@ BYE BYE!", self);
}
@end
