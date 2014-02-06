//
//  FlickrMedia_Box.m
//  Humans
//
//  Created by julian on 7/30/12.
//
//

#import "HuFlickrStatus_Box.h"
#import "MGBox.h"
#import "MGLine.h"
#import "defines.h"
//#import "UIImageView+WebCache.h"
#import "UIImage+Resize.h"
#import "UILabel+withDate.h"


@implementation HuFlickrStatus_Box

//MGLine *statusTextBox;
//MGLine *statusLine;
//MGLine *dateLine;


@synthesize status;

//BOOL kBoxWouldCurrentlyLeavesWhiteBlankBelowItself = NO;

- (void)setStatus:(HuFlickrStatus *)_status
{
    status = _status;
    if([self.status statusImage] == nil) {
    
    }
    //[self setDateToShow:[flickrStatus dateForSorting]];
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
    self.padding = UIEdgeInsetsZero;//(UIEdgeInsetsMake(8.0, 0.0, 8.0, 0.0));
    
    // shape and colour
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = CORNER_RADIUS;
    
    self.layer.shadowColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 0;
    
    
    // performance
    self.rasterize = YES;
    count = 0;
    self.deferImageLoad = NO;

    
}

- (void)loadPhoto
{
    [mainPhotoBox loadPhoto];
}


- (void)showOrRefreshPhoto
{
    [mainPhotoBox setServiceTinyTag:[UIImage imageNamed:@"flickr-peepers-gray-tiny.png"]];
    [mainPhotoBox setUrlStr:[mainPhotoBox urlStr]]; // I guess we can change the photo URL, for fun..and profit

    [mainPhotoBox loadPhotoWithCompletionHandler:^{
        //LOG_FLICKR_VERBOSE(0, @"%@ Now main photo box size is %@", self, NSStringFromCGSize([mainPhotoBox size]));
        [self layout];

    }];
}

-(void)buildContentBoxes
{
    if(IS_IPHONE && IS_IPHONE_5) {
        mainPhotoBox = [HuStatusPhotoBox photoBoxFor:[status statusImageURL] size:ROW_SIZE_WITH_IMAGE_IPHONE_5 deferLoad:YES];
    } else {
        mainPhotoBox = [HuStatusPhotoBox photoBoxFor:[status statusImageURL] size:ROW_SIZE_WITH_IMAGE_IPHONE deferLoad:YES];
        
    }
    [mainPhotoBox setTopParentBox:self.parentBox];
    
    NSString *descriptionText;
    
    if([[status statusTitle]length] < 1) {
        descriptionText = [status statusText];
    } else {
        descriptionText = [status statusTitle];
    }
    NSString *description = [[NSString alloc] initWithFormat:@"%@",descriptionText];
    
    statusLine = [MGLine multilineWithText:description font:INSTAGRAM_FONT width:self.width padding:UIEdgeInsetsMake(TEXT_TOP_PADDING, TEXT_LEFT_PADDING, TEXT_BOTTOM_PADDING, TEXT_RIGHT_PADDING)];
    
    
   /*
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30) withDate:[flickrStatus dateForSorting]];
    dateLine = [MGLine lineWithSize:DATELINE_ROW_SIZE];//[MGLine lineWithLeft:[UIImage imageNamed:@"flickr-peepers-gray-tiny.png"] right:[dateLabel text] size:DATELINE_ROW_SIZE];
    [dateLine setSidePrecedence:MGSidePrecedenceMiddle];
    dateLine.middleItems = (id)@[ [UIImage imageNamed:@"flickr-peepers-gray-tiny"], @" ", [NSString stringWithFormat:@"@%@",[[flickrStatus serviceUser]username]], @" ", [dateLabel text] ];
    [dateLine setPadding:UIEdgeInsetsMake(TEXT_TOP_PADDING, TEXT_LEFT_PADDING, TEXT_BOTTOM_PADDING, TEXT_RIGHT_PADDING)];
    [dateLine setFont:DATELINE_FONT];
    [dateLine setTextColor:DATELINE_TEXT_COLOR];
    [dateLine setBackgroundColor:[UIColor whiteColor]];
    
    dateLine.underlineType = MGUnderlineNone;
    statusLine.underlineType = MGUnderlineNone;
    */
    //[self.topLines addObject:dateLine];
    [self.topLines addObject:mainPhotoBox];
    [self.bottomLines addObject:statusLine];

    
    //
    //        UISwipeGestureRecognizer *swipe;
    //
    //        swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(boxSelected:)];
    //        [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    //        [img2Line addGestureRecognizer:swipe];
    
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

//- (UIButton *)button:(NSString *)title for:(SEL)selector {
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
//    [button setTitleColor:[UIColor colorWithWhite:0.9 alpha:0.9]
//                 forState:UIControlStateNormal];
//    [button setTitleShadowColor:[UIColor colorWithWhite:0.2 alpha:0.9]
//                       forState:UIControlStateNormal];
//    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
//    CGSize size = [title sizeWithFont:button.titleLabel.font];
//    button.frame = CGRectMake(0, 0, size.width + 18, 26);
//    [button setTitle:title forState:UIControlStateNormal];
//    [button addTarget:self action:selector
//     forControlEvents:UIControlEventTouchUpInside];
//    button.layer.cornerRadius = 3;
//    button.backgroundColor = self.backgroundColor;
//    button.layer.shadowColor = [UIColor blackColor].CGColor;
//    button.layer.shadowOffset = CGSizeMake(0, 1);
//    button.layer.shadowRadius = 0.8;
//    button.layer.shadowOpacity = 0.6;
//    return button;
//}


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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
