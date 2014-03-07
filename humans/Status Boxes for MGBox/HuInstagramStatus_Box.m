//
//  InstagramMedia_Box.m
//  Humans
//
//  Created by Julian Bleecker on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HuInstagramStatus_Box.h"
#import "MGBox.h"
#import "MGLine.h"
#import "defines.h"
#import "UIImageView+WebCache.h"
#import "InstagramImages.h"
#import "InstagramImage.h"


@implementation HuInstagramStatus_Box

@synthesize status;


- (void)setStatus:(InstagramStatus *)_status
{
    status = _status;
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
    count = 0;
    self.deferImageLoad = NO;
    
   imgArray = [[NSArray alloc]initWithObjects:@"http://imprint.printmag.com/wp-content/uploads/2010/07/squirell_monkey.jpg", @"http://4.bp.blogspot.com/-SWLJdR2_YzE/TWB-EvvBWpI/AAAAAAAAA6U/MVtkwJXED88/s1600/donkey.png", nil];
}

- (void)loadPhoto
{
    [mainPhotoBox loadPhoto];
}


- (void)showOrRefreshPhoto
{
    [mainPhotoBox setUrlStr:[mainPhotoBox urlStr]]; // I guess we can change the photo URL, for fun..and profit
    [mainPhotoBox loadPhoto];
    [mainPhotoBox setNeedsDisplay];
}


- (void)buildContentBoxes
{
    InstagramImages *images = [status images];
    
    if(IS_IPHONE && IS_IPHONE_5) {
        mainPhotoBox = [HuStatusPhotoBox photoBoxFor:[[images low_resolution ]url] size:ROW_SIZE_WITH_IMAGE_IPHONE_5 deferLoad:NO];
    } else {
        mainPhotoBox = [HuStatusPhotoBox photoBoxFor:[[images low_resolution]url] size:ROW_SIZE_WITH_IMAGE_IPHONE deferLoad:NO];
    }
    //[mainPhotoBox setRightMargin:10];
    [self.topLines addObject:mainPhotoBox];
    [mainPhotoBox setTopParentBox:self.parentBox];

    statusLine = [MGLine multilineWithText:[NSString stringWithFormat:@"Instagram %@", [status statusText]] font:INSTAGRAM_STATUS_TEXT_FONT  width:self.width padding:UIEdgeInsetsMake(TEXT_TOP_PADDING, TEXT_LEFT_PADDING, TEXT_BOTTOM_PADDING, TEXT_RIGHT_PADDING)];
    
    [self.bottomLines addObject:statusLine];
    
}

- (void)refresh:(id)sender
{
}

- (CGRect)rectForImage:(UIImage*)_image maxSize:(CGSize)value
{
    float hfactor = _image.size.width / value.width;
    float vfactor = _image.size.height / value.height;
    
    float factor = fmax(hfactor, vfactor);
    //NSLog(@"%f", factor);
    // Divide the size by the greater of the vertical or horizontal shrinkage factor
    float newWidth = _image.size.width / factor;
    float newHeight = _image.size.height / factor;
    
    // Then figure out if you need to offset it to center vertically or horizontally
    float leftOffset = (value.width - newWidth) / 2;
    float topOffset = (value.height - newHeight) / 2;
    
    CGRect newRect = CGRectMake(leftOffset, topOffset, newWidth, newHeight);
    return newRect;
}

- (NSString *)description
{
    NSString *result = [NSString stringWithFormat:@"%@ %@", [self class], status];
    return result;
}

- (void)dealloc
{
    LOG_GENERAL(0, @"Bye %@", self);
    NSLog(@"Bye, %@", self);
}
@end
