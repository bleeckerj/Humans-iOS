//
//  HuViewForServiceStatus.m
//  Humans
//
//  Created by julian on 1/2/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import "HuViewForServiceStatus.h"
#import "InstagramStatus.h"
//#import "FlickrStatus.h"
#import "TwitterStatus.h"
#import "HuStatusPhotoBox.h"
#import "UIView+MGEasyFrame.h"
#import "UIView+BlocksKit.h"
#import "defines.h"
#import "LoggerClient.h"

@interface HuTwitterStatusView : HuViewForServiceStatus {
   // HuStatusPhotoBox *photoBox;
    UITextView *statusView;
    TwitterStatus *status;

}
@end

/*
@interface HuFlickrStatusView : HuViewForServiceStatus {
    HuStatusPhotoBox *photoBox;
    UITextView *statusView;
    FlickrStatus *status;
}
@end
*/

@interface HuInstagramStatusView : HuViewForServiceStatus {
    HuStatusPhotoBox *photoBox;
    UITextView *statusView;
    InstagramStatus *status;

}

//-(void)loadPhoto;
//-(void)loadPhotoWithCompletionHandler:(CompletionHandler)handler;
- (void)showOrRefreshPhoto;

@end


@implementation HuViewForServiceStatus


- (HuViewForServiceStatus *)initWithFrame:(CGRect)frame forStatus:(id<HuServiceStatus>)mstatus
{
    HuViewForServiceStatus* hView = nil;
    
    if([mstatus isKindOfClass:[TwitterStatus class]]) {
        hView = [[HuTwitterStatusView alloc]initWithFrame:frame forStatus:mstatus];
    }
    if([mstatus isKindOfClass:[InstagramStatus class]]) {
        hView = [[HuInstagramStatusView alloc]initWithFrame:frame forStatus:mstatus];
    }
    /*
    if([mstatus isKindOfClass:[HuFlickrStatus class]]) {
        hView = [[HuFlickrStatusView alloc]initWithFrame:frame forStatus:mstatus];
    }
     */
    //LOG_GENERAL(0, @"View is %@", hView);
    return hView;
}


+ (UIView *)viewForStatus:(id<HuServiceStatus>)mstatus withFrame:(CGRect)frame
{
    //UIView *result;
    return[[HuViewForServiceStatus alloc]initWithFrame:frame forStatus:mstatus];
}

- (void)showOrRefreshPhoto
{
    
}

@end

@implementation HuTwitterStatusView
{
}

-(HuTwitterStatusView *)initWithFrame:(CGRect)frame forStatus:(TwitterStatus *)mstatus
{
    self = [super initWithFrame:frame];
    if(self) {
        LOG_TWITTER(0, @"frame for twitter status=%@", NSStringFromCGRect(frame));
        
        status = mstatus;
        // header isn't part of the actual status view, which gets pasted into the carousel, so we need
        // the header to be separate..it's managed by HuStatusCarousel_ViewController

        //UITextView *statusView = [[UITextView alloc]initWithFrame:[self getStatusViewFrame]];//(CGRectInset(frame, 5, 5))];

        [self setBackgroundColor:[UIColor blackColor]];
        
        if([status statusText] != nil) {
            statusView = [[UITextView alloc]initWithFrame:[self getStatusViewFrame]];
            statusView.editable = NO;
            //statusField.lineBreakMode = UILineBreakModeTailTruncation;
            //statusLabel.numberOfLines = 0;
            [statusView setBackgroundColor:[UIColor whiteColor]];
            NSString *description = [NSString stringWithFormat:@"%@", [status statusText]];
            [statusView setText:description];
            [statusView setTextColor:[UIColor blackColor]];
            LOG_TWITTER_VERBOSE(0, @"Status: %@ %@", [status statusText], statusView);
            [statusView setFont:TWITTER_FONT];
            [statusView setScrollEnabled:YES];
            [statusView setBounces:NO];
            [self addSubview:statusView];
        }

    }
   
    
    
    return self;
}

- (CGRect) getStatusViewFrame
{
    float screen_height, screen_width;
    
    if(IS_IPHONE && IS_IPHONE_5) {
        screen_height = IPHONE_5_PORTRAIT_SIZE_HEIGHT;
        screen_width = IPHONE_5_PORTRAIT_SIZE.width; //CGSizeGetWidth(IPHONE_5_PORTRAIT_SIZE);
    } else {
        screen_height = IPHONE_PORTRAIT_SIZE_HEIGHT;
        screen_width = IPHONE_5_PORTRAIT_SIZE.width;
    }
    
    //float clear_bottom = screen_height - HEADER_HEIGHT;
    CGRect statusview_frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    //(CGRectMake(CGRectGetMinX(photoBox.frame), CGRectGetMaxY(photoBox.frame), CGRectGetWidth(photoBox.frame), clear_bottom));
    
    return CGRectInset(statusview_frame, 8, 12);
    
}

- (void)showOrRefreshPhoto
{
    LOG_TWITTER(0, @"TO DO: If Twitter Has Photo Do Something..");
}

@end

@implementation HuInstagramStatusView {

}

@class CALayer;


-(HuInstagramStatusView *)initWithFrame:(CGRect)frame forStatus:(InstagramStatus*)mstatus
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setBackgroundColor:INSTAGRAM_COLOR];

        status = mstatus;
        LOG_UI(0, @"Status Image URL %@", [status statusImageURL]);
        
        photoBox = [HuStatusPhotoBox photoBoxFor:[status statusImageURL] size:CGSizeMake(frame.size.width, frame.size.height) deferLoad:YES];
        [photoBox setBackgroundColor:[UIColor grayColor]];
        [self addSubview:photoBox];
        
        
        if([status statusText] != nil) {
            statusView = [[UITextView alloc]initWithFrame:[self getStatusViewFrame]];
            LOG_INSTAGRAM(0, @"For HuInstagramStatusView statusView size is %@", NSStringFromCGRect([statusView frame]));
            statusView.editable = NO;
            //statusField.lineBreakMode = UILineBreakModeTailTruncation;
            //statusLabel.numberOfLines = 0;
            [statusView setBackgroundColor:[UIColor whiteColor]];
            NSString *description = [NSString stringWithFormat:@"%@", [status statusText]];
            [statusView setText:description];
            [statusView setTextColor:[UIColor blackColor]];
            [statusView setFont:INSTAGRAM_FONT];
            [statusView setScrollEnabled:YES];
            [statusView setBounces:NO];
            [self addSubview:statusView];
        }
        //id<HuSocialServiceUser>user = [status serviceUser];
        //[self setBackgroundColor:[user serviceSolidColor]];
        
    }
    self.layer.cornerRadius = CORNER_RADIUS;
    
    return self;
}

- (void)updateStatusView
{
    [statusView setFrame:[self getStatusViewFrame]];
}

- (CGRect) getStatusViewFrame
{
    float screen_height;
    
    if(IS_IPHONE && IS_IPHONE_5) {
        screen_height = IPHONE_5_PORTRAIT_SIZE_HEIGHT;
    } else {
        screen_height = IPHONE_PORTRAIT_SIZE_HEIGHT;
    }
    
    float clear_bottom = screen_height - CGRectGetMaxY(photoBox.frame);
    CGRect statusview_frame = (CGRectMake(CGRectGetMinX(photoBox.frame), CGRectGetMaxY(photoBox.frame), CGRectGetWidth(photoBox.frame), clear_bottom));
    
    return CGRectInset(statusview_frame, 8, 12);
    
}


- (void)showOrRefreshPhoto
{
    //[photoBox setUrlStr:[photoBox urlStr]]; // I guess we can change the photo URL, for fun..and profit
    [photoBox loadPhotoWithCompletionHandler:^(BOOL success, NSError *error) {
        if(success) {
            
        } else {
            LOG_TODO(0, @"You'll want to indicate that there was a network problem");
        }
        [self updateStatusView];
    }];
    
}


-(void)loadPhoto
{
    [photoBox loadPhoto];
}

-(void)loadPhotoWithCompletionHandler:(CompletionHandlerWithResult)handler
{
    [photoBox loadPhotoWithCompletionHandler:handler];
}

-(NSString *)description
{
    NSString *result = [NSString stringWithFormat:@"%@ %@", [super description], status];
    return result;
}
@end


/*
@implementation HuFlickrStatusView

@class CALayer;


-(id)initWithFrame:(CGRect)frame forStatus:(HuFlickrStatus*)mstatus
{


self = [super initWithFrame:frame];
if(self) {
    status = mstatus;
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    photoBox = [HuStatusPhotoBox photoBoxFor:[status statusImageURL] size:CGSizeMake(frame.size.width, frame.size.height) deferLoad:YES];
    [photoBox setBackgroundColor:[UIColor grayColor]];
    [self addSubview:photoBox];
        
    if([status statusText] != nil) {
        statusView = [[UITextView alloc]initWithFrame:[self getStatusViewFrame]];
        statusView.editable = NO;
        //statusField.lineBreakMode = UILineBreakModeTailTruncation;
        //statusLabel.numberOfLines = 0;
        [statusView setBackgroundColor:[UIColor whiteColor]];
        NSString *description = [NSString stringWithFormat:@"%@\n%@", [status statusTitle], [status statusText]];
        [statusView setText:description];
        [statusView setTextColor:[UIColor blackColor]];
        LOG_FLICKR_VERBOSE(0, @"Status: %@ %@", [status statusText], statusView);
        [statusView setFont:FLICKR_FONT];
        [statusView setScrollEnabled:YES];
        [statusView setBounces:NO];
        [self addSubview:statusView];
    }
    //id<HuSocialServiceUser>user = [status serviceUser];
    //[self setBackgroundColor:[user serviceSolidColor]];
    
}
self.layer.cornerRadius = CORNER_RADIUS;

return self;
}

- (void)updateStatusView
{
    [statusView setFrame:[self getStatusViewFrame]];
}

- (CGRect) getStatusViewFrame
{
    float screen_height;
    
    if(IS_IPHONE && IS_IPHONE_5) {
        screen_height = IPHONE_5_PORTRAIT_SIZE_HEIGHT;
    } else {
        screen_height = IPHONE_PORTRAIT_SIZE_HEIGHT;
    }
    
    float clear_bottom = screen_height - CGRectGetMaxY(photoBox.frame);
    CGRect statusview_frame = (CGRectMake(CGRectGetMinX(photoBox.frame), CGRectGetMaxY(photoBox.frame), CGRectGetWidth(photoBox.frame), clear_bottom));
    
    return CGRectInset(statusview_frame, 8, 12);

}

- (void)showOrRefreshPhoto
{
    //[photoBox setUrlStr:[photoBox urlStr]]; // I guess we can change the photo URL, for fun..and profit
    [photoBox loadPhotoWithCompletionHandler:^{
        //[photoBox setNeedsDisplay];
        //        NSLog(@"%@ photoBox frame=%@", self, NSStringFromCGRect(photoBox.frame));
        //        LOG_UI(0, @"%@ photoBox frame=%@", self, NSStringFromCGRect(photoBox.frame));
        [self updateStatusView];
    }];
}


@end
 */