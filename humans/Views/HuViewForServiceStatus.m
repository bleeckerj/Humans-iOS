//
//  HuViewForServiceStatus.m
//  Humans
//
//  Created by julian on 1/2/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import "HuViewForServiceStatus.h"
#import "InstagramStatus.h"
#import "InstagramLocation.h"
#import "HuFlickrStatus.h"
#import "HuTwitterStatus.h"
#import "HuTwitterCoordinates.h"
#import "HuTwitterPlace.h"
#import "HuFoursquareCheckin.h"
#import "HuFoursquareVenue.h"
#import "HuStatusPhotoBox.h"
#import "defines.h"
#import "LoggerClient.h"


@interface HuTwitterStatusView : HuViewForServiceStatus <TTTAttributedLabelDelegate> {
    //HuStatusPhotoBox *photoBox;
    //UITextView *statusView;
    UIImageView *photoView;
    JBAttributedAwareScrollView *statusView;
    HuTwitterStatus *status;
}
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end


@interface HuFlickrStatusView : HuViewForServiceStatus {
    HuStatusPhotoBox *photoBox;
    //UITextView *statusView;
    JBAttributedAwareScrollView *statusView;
    HuFlickrStatus *status;
}
@end


@interface HuInstagramStatusView : HuViewForServiceStatus {
    //HuStatusPhotoBox *photoBox;
    //IDMPhotoBrowser *photoBrowser;
    //UITextView *statusView;
    JBAttributedAwareScrollView *statusView;
    InstagramStatus *status;
    UIImageView *photoView;
    
    
}

@end

@interface HuFoursquareStatusView : HuViewForServiceStatus {
    UITextView *statusView;
    HuFoursquareCheckin *status;
}

//-(void)loadPhoto;
//-(void)loadPhotoWithCompletionHandler:(CompletionHandler)handler;
- (void)showOrRefreshPhoto;

@end


@implementation HuViewForServiceStatus
#pragma mark TTTAttributedLabelDelegate method

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    LOG_DEEBUG(0, @"%@", url);
}


- (HuViewForServiceStatus *)initWithStatus:(id<HuServiceStatus>)mStatus
{
    HuViewForServiceStatus* hView = nil;
    
    if([mStatus isKindOfClass:[HuTwitterStatus class]]) {
        //hView = [[HuTwitterStatusView alloc]initWithFrame:frame forStatus:mstatus];
        hView = [[HuTwitterStatusView alloc]initWithStatus:mStatus];
    }
    //    if([mStatus isKindOfClass:[InstagramStatus class]]) {
    //        hView = [[HuInstagramStatusView alloc]initWithFrame:frame forStatus:mstatus];
    //    }
    //
    //    if([mStatus isKindOfClass:[HuFlickrStatus class]]) {
    //        hView = [[HuFlickrStatusView alloc]initWithFrame:frame forStatus:mstatus];
    //    }
    //
    //
    //    if([mStatus isKindOfClass:[HuFoursquareCheckin class]]) {
    //        hView = [[HuFoursquareStatusView alloc]initWithFrame:frame forStatus:mstatus];
    //    }
    
    //LOG_GENERAL(0, @"View is %@", hView);
    return hView;
    
}


- (HuViewForServiceStatus *)initWithFrame:(CGRect)frame forStatus:(id<HuServiceStatus>)mstatus
{
    HuViewForServiceStatus* hView = nil;
    
    if([mstatus isKindOfClass:[HuTwitterStatus class]]) {
        //hView = [[HuTwitterStatusView alloc]initWithFrame:frame forStatus:mstatus];
        // hView = [[HuTwitterStatusView alloc]init];
        hView = [[HuTwitterStatusView alloc]initWithFrame:frame forStatus:mstatus];
        
    }
    if([mstatus isKindOfClass:[InstagramStatus class]]) {
        hView = [[HuInstagramStatusView alloc]initWithFrame:frame forStatus:mstatus];
    }
    
    if([mstatus isKindOfClass:[HuFlickrStatus class]]) {
        hView = [[HuFlickrStatusView alloc]initWithFrame:frame forStatus:mstatus];
    }
    
    
    if([mstatus isKindOfClass:[HuFoursquareCheckin class]]) {
        hView = [[HuFoursquareStatusView alloc]initWithFrame:frame forStatus:mstatus];
    }
    
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

@implementation HuFoursquareStatusView
{
    
}
-(HuFoursquareStatusView *)initWithStatus:(HuFoursquareCheckin*)mStatus
{
    self = [super init];
    if(!self) return nil;
    
    return self;
}

-(HuFoursquareStatusView *)initWithFrame:(CGRect)frame forStatus:(HuFoursquareCheckin*)mstatus
{
    self = [super initWithFrame:frame];
    if(self) {
        LOG_FOURSQUARE(0, @"frame for foursquare status=%@", NSStringFromCGRect(frame));
        if([mstatus venue] != nil) {
            status = mstatus;
            [self setBackgroundColor:UIColorFromRGB(0xd1d4d3)];
            statusView = [[UITextView alloc]initWithFrame:self.frame];
            [statusView setBackgroundColor:UIColorFromRGB(0xeeebac)];
            HuFoursquareVenue *venue = [status venue];
            NSString *description = [NSString stringWithFormat:@"%@", [venue name]];
            [statusView setText:description];
            [statusView setTextColor:[UIColor blackColor]];
            [statusView setFont:TWITTER_FONT];
            [statusView setScrollEnabled:YES];
            [statusView setBounces:NO];
            [self addSubview:statusView];
        }
    }
    return self;
    
}

- (void)showOrRefreshPhoto
{
    
}

@end

@implementation HuTwitterStatusView
{
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    NSLog(@"GOODBYE %@", event);
}

#pragma mark TTTAttributedLabelDelegate method
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"%@", url);
    LOG_DEEBUG(0, @"clicked: %@", url);
    if(self.backgroundColor == [UIColor crayolaApricotColor]) {
        [self setBackgroundColor:[UIColor crayolaAquaPearlColor]];
    } else {
        [self setBackgroundColor:[UIColor crayolaApricotColor]];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"HELLO %@", event);
}

-(HuTwitterStatusView *)initWithStatus:(HuTwitterStatus *)mStatus
{
    self = [super init];
    if(!self) return nil;
    
    if([status containsMedia]) {
        
        //        photoBox = [HuStatusPhotoBox photoBoxFor:[status statusImageURL] size:CGSizeZero];
        //        [self addSubview:photoBox];
        //
        //        [photoBox mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.width.equalTo(self.mas_width);
        //            make.height.equalTo(self.mas_height);
        //            make.top.equalTo(self.mas_top);
        //            make.left.equalTo(self.mas_left);
        //        }];
        //        [photoBox setBackgroundColor:[UIColor whiteColor]];
        //
        //    }
        //    if([status statusText] != nil && [status containsMedia] == false ) {
        //        statusView = JBAttributedAwareScrollView.new;
        //        [statusView setFrame:CGRectZero];
        //        [self addSubview:statusView];
        //        statusView.label.delegate = self;
        //        [statusView setFont:TWITTER_FONT_LARGE];
        //        statusView.text = [status statusText];
        //        [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            UIEdgeInsets padding = UIEdgeInsetsMake(20, 10, 20, 10);
        //            make.edges.equalTo(self).with.insets(padding);
        //
        //        }];
        //
        //    }
        //    if([status statusText] != nil && [status containsMedia] == true) {
        //
        //        UIView *marker = [[UIView alloc]initWithFrame:CGRectMake(0, photoBox.size.height, self.size.width, self.size.height - photoBox.size.height)];
        //        [marker setBackgroundColor:[UIColor crayolaLapisLazuliColor]];
        //        [self addSubview:marker];
        //
        //    }
        //
    }
    
    
    return self;
}

-(HuTwitterStatusView *)initWithFrame:(CGRect)frame forStatus:(HuTwitterStatus *)mstatus
{
    self = [super initWithFrame:frame];
    if(self) {
        //LOG_TWITTER(0, @"status entities %@", [mstatus entities]);
        status = mstatus;
        
        // header isn't part of the actual status view, which gets pasted into the carousel, so we need
        // the header to be separate..it's managed by HuStatusCarousel_ViewController
        [self setBackgroundColor:[UIColor whiteColor]];
        
        if([status containsMedia]) {
            photoView = UIImageView.new;
            [photoView setContentMode:(UIViewContentModeScaleAspectFit)];
            [photoView setClipsToBounds:YES];
            [self addSubview:photoView];
            [photoView setBackgroundColor:[UIColor crayolaJellyBeanColor]];
            
            __block UIImageView *bphotoView = photoView;
            __block HuViewForServiceStatus *bself = self;
            [photoView setImageWithURL:[NSURL URLWithString:[mstatus statusImageURL]] placeholderImage:nil options:(SDWebImageRetryFailed) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                if(error == nil) {
                    //bphotoView.image = [image resizedImageToFitInSize:bphotoView.frame.size scaleIfSmaller:YES];
                    if(image.size.width > image.size.height) {
                        
                        bphotoView.image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(300,300)
                                                         interpolationQuality:kCGInterpolationHigh];
                    } else {
                        
                        bphotoView.image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(320,320)
                                                         interpolationQuality:kCGInterpolationHigh];
                    }
                    //bphotoView.image = image;
                    
                    //__block CGRect frame;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(image.size.width > image.size.height) {
                            [bphotoView mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.top.equalTo(bself.mas_top);
                                make.left.equalTo(bself.mas_left).with.offset(10);
                                make.right.equalTo(bself.mas_right).with.offset(-10);
                                //make.center.equalTo(bself);
                                //                                make.width.equalTo(@300);
                            }];
                            //frame = CGRectMake(0, 0, bself.size.width, 200);
                            
                        } else {
                            [bphotoView mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.top.equalTo(bself.mas_top);
                                make.left.equalTo(bself.mas_left).with.offset(10);
                                make.right.equalTo(bself.mas_right).with.offset(-10);
                                //make.center.equalTo(bself);
                                //                                make.height.equalTo(@300);
                            }];
                            
                        }
                        //[bphotoView setFrame:frame];
                        [bphotoView setNeedsDisplay];
                        
                    });
                } else {
                    // do something if there was a problem loading the image?
                    
                }
            }];
            
            
        }
        
        if([status statusText] != nil && [status containsMedia] == false) {
            
            statusView = JBAttributedAwareScrollView.new;
            [self addSubview:statusView];
            [statusView setFrame:CGRectZero];
            statusView.label.delegate = self;
            [statusView setFont:TWITTER_FONT_LARGE];
            statusView.text = [status statusText];
            statusView.backgroundColor = [UIColor crayolaKeyLimePearlColor];
            [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
                UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
                make.edges.equalTo(self).with.insets(padding);
                //make.center.equalTo(self);
            }];
        }
        if([status statusText] != nil && [status containsMedia] == true) {
            
            statusView = JBAttributedAwareScrollView.new;
            [self addSubview:statusView];
            [statusView setFrame:CGRectZero];
            statusView.label.delegate = self;
            [statusView setFont:TWITTER_FONT_LARGE];
            statusView.text = [status statusText];
            statusView.backgroundColor = [UIColor crayolaKeyLimePearlColor];
            [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
                //UIEdgeInsets padding = UIEdgeInsetsMake(200, 10, 20, 10);
                //make.edges.equalTo(self).with.insets(padding);
                //make.center.equalTo(self);
                make.top.equalTo(photoView.mas_bottom).with.offset(10);
                make.bottom.equalTo(self.mas_bottom).with.offset(-10);
                make.left.equalTo(self.mas_left).with.offset(10);
                make.right.equalTo(self.mas_right).with.offset(-10);
            }];
            
        }
        
        if([status place]  != nil) {
            LOG_DEEBUG(0, @"%@", [status place]);
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
    //    LOG_TWITTER(0, @"TO DO: If Twitter Has Photo Do Something..");
    //    if([status containsMedia]) {
    //        if([photoBox urlStr] == nil) {
    //            LOG_TWITTER(0, @"Weird. The photo box urlStr should've been set?");
    //            [photoBox setUrlStr:[status statusImageURL]];
    //        }
    //        [photoBox loadPhotoWithCompletionHandler:^(BOOL success, NSError *error) {
    //            if(success) {
    //                LOG_TWITTER(0, @"If this was an image from Twitter itself, I don't quite yet know how to show it..%@", error);
    //            } else {
    //                LOG_TODO(0, @"You'll want to indicate that there was a network problem or something %@", error);
    //            }
    //            [self updateStatusView];
    //        }];
    //
    //    }
    
    LOG_TWITTER(0, @"TO DO: If Twitter Has Photo Do Something..");
    if([status containsMedia]) {
        
        [status statusImageURL];
        
        if([status statusImageURL] == nil) {
            LOG_TWITTER(0, @"Weird. The photo box urlStr should've been set?");
            //[photoBox setUrlStr:[status statusImageURL]];
        }
        __block HuTwitterStatusView *bself = self;
        //        [photoView setImageWithURL:[NSURL URLWithString:[status statusImageURL]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        //            LOG_DEEBUG(0, @"%@", error);
        //            [bself updateStatusView];
        //        }];
        
        //        [photoView loadPhotoWithCompletionHandler:^(BOOL success, NSError *error) {
        //            if(success) {
        //                LOG_TWITTER(0, @"If this was an image from Twitter itself, I don't quite yet know how to show it..%@", error);
        //            } else {
        //                LOG_TODO(0, @"You'll want to indicate that there was a network problem or something %@", error);
        //            }
        //            [self updateStatusView];
        //        }];
        
    }
}

- (void)updateStatusView
{
    //[statusView setFrame:[self getStatusViewFrame]];
    [self layoutSubviews];
}

@end

@implementation HuInstagramStatusView {
    
}

@class CALayer;




-(HuInstagramStatusView *)initWithFrame:(CGRect)frame forStatus:(InstagramStatus*)mstatus
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setBackgroundColor:[UIColor Instagram]];
        
        status = mstatus;
        
        photoView = UIImageView.new;
        [photoView setContentMode:(UIViewContentModeScaleAspectFit)];
        [photoView setClipsToBounds:YES];
        [photoView.layer setCornerRadius:5.0];
        
        [photoView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self addSubview:photoView];
        [photoView setBackgroundColor:[UIColor crayolaManateeColor]];
        
        __block UIImageView *bphotoView = photoView;
        __block HuViewForServiceStatus *bself = self;
        [photoView setImageWithURL:[NSURL URLWithString:[mstatus statusImageURL]] placeholderImage:nil options:(SDWebImageRetryFailed) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if(error == nil) {
                
                bphotoView.image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(310,310) interpolationQuality:kCGInterpolationHigh];

                //bphotoView.image = image;
                //__block CGRect frame;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [bphotoView mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.top.equalTo(bself.mas_top);
                        make.left.equalTo(bself.mas_left).with.offset(5);
                        make.right.equalTo(bself.mas_right).with.offset(-5);
                        make.height.lessThanOrEqualTo(@310).with.priorityHigh();
                        
                        //                            make.top.equalTo(bself.mas_top);
                        //                            make.left.equalTo(bself.mas_left);
                        //                            make.right.equalTo(bself.mas_right);
                        //                            make.height.equalTo(@300);
                        [bphotoView sizeToFit];

                    }];
                    //frame = CGRectMake(0, 0, bself.size.width, 200);
                    
                    
                    //[bphotoView setFrame:frame];
                    [bphotoView setNeedsDisplay];
                    
                });
            } else {
                
            }
        }];
        
            statusView = JBAttributedAwareScrollView.new;
            [self addSubview:statusView];
            [statusView setFrame:CGRectZero];
        [[statusView layer]setCornerRadius:5.0];
            statusView.backgroundColor = [UIColor crayolaKeyLimePearlColor];

            statusView.label.delegate = self;
            [statusView setFont:INSTAGRAM_FONT];
            NSString *description;
            InstagramLocation *loc = [status location];
            if([[status type] isEqualToString:@"video"]) {
                description = [NSString stringWithFormat:@"(video soon) %@", [status statusText]];
            } else {
                description = [NSString stringWithFormat:@"%@",[status statusText]];
            }
            
            
            statusView.text = description;
        
            [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(photoView.mas_bottom).with.offset(5);
                //make.bottom.equalTo(self.mas_bottom).with.offset(-10);
                make.left.equalTo(self.mas_left).with.offset(5);
                make.right.equalTo(self.mas_right).with.offset(-5);
                make.height.lessThanOrEqualTo(@110).with.priorityMedium();
            }];
            
            
        
        if(loc != nil) {
            UIView *locView = UIView.new;
            [self addSubview:locView];
            CGColorRef color = [[UIColor crayolaManateeColor]CGColor];
            [[locView layer]setBorderColor:color];
            [[locView layer]setBorderWidth:1];
            [[locView layer]setCornerRadius:5.0];
            [locView setBackgroundColor:[UIColor whiteColor]];
            UILabel *locLabel = UILabel.new;
            [locLabel setFrame:CGRectZero];
            [locLabel setNumberOfLines:0];
            [locLabel setBackgroundColor:[UIColor whiteColor]];
            [locView addSubview:locLabel];
            
            NSString *minimal = [[loc jsonString] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            //NSLog(@"%@", minimal);
            [locLabel setText:[NSString stringWithFormat:@"(FPO MAP HERE SOON)\n%@",minimal]];
            [locLabel setFont:INSTAGRAM_FONT_SMALL];
            [locLabel setContentMode:UIViewContentModeTop];
            

            [locView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(statusView.mas_bottom).offset(5);
                make.bottom.equalTo(self.mas_bottom).offset(-5);
                make.left.equalTo(statusView.mas_left);
                make.right.equalTo(statusView.mas_right);
                make.height.lessThanOrEqualTo(@50).with.priorityMedium();
                
            }];
            [locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(statusView.mas_left).with.offset(5);
                make.right.equalTo(statusView.mas_right).with.offset(-5);
                make.top.equalTo(statusView.mas_bottom).with.offset(5);
                make.bottom.equalTo(locView.mas_bottom).with.offset(-5);
            }];
        }
        
        //id<HuSocialServiceUser>user = [status serviceUser];
        //[self setBackgroundColor:[user serviceSolidColor]];
        
    }
    self.layer.cornerRadius = CORNER_RADIUS;
    
    return self;
}


- (void)showOrRefreshPhoto
{
    //    //[photoBox setUrlStr:[photoBox urlStr]]; // I guess we can change the photo URL, for fun..and profit
    //    [photoBox loadPhotoWithCompletionHandler:^(BOOL success, NSError *error) {
    //        if(success) {
    //            [self updateStatusView];
    //
    //        } else {
    //            LOG_ERROR(0, @"Error loading instagram photo %@", error);
    //        }
    //    }];
    
}



-(NSString *)description
{
    NSString *result = [NSString stringWithFormat:@"%@ %@", [super description], status];
    return result;
}
@end



@implementation HuFlickrStatusView

@class CALayer;


-(id)initWithFrame:(CGRect)frame forStatus:(HuFlickrStatus*)mstatus
{
    
    
    self = [super initWithFrame:frame];
    if(self) {
        status = mstatus;
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        photoBox = [HuStatusPhotoBox photoBoxFor:[status statusImageURL] size:CGSizeMake(frame.size.width, frame.size.height) deferLoad:NO];
        [self addSubview:photoBox];
        [photoBox setBackgroundColor:[UIColor grayColor]];
        
        if([status statusText] != nil) {
            
            statusView = JBAttributedAwareScrollView.new;
            [self addSubview:statusView];
            [statusView setFrame:CGRectZero];
            statusView.label.delegate = self;
            [statusView setFont:FLICKR_FONT];
            statusView.text = [NSString stringWithFormat:@"%@ - %@", [status title], [status statusText]];
            statusView.backgroundColor = [UIColor crayolaKeyLimePearlColor];
            [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
                //UIEdgeInsets padding = UIEdgeInsetsMake(5, 5, 5, 5);
                //make.edges.equalTo(self).with.insets(padding);
                //make.center.equalTo(self);
                make.top.equalTo(photoBox.mas_bottom).with.offset(10.0);
                make.bottom.equalTo(self.mas_bottom).with.offset(-10.0);
                make.left.equalTo(self.mas_left).with.offset(10.0);
                make.right.equalTo(self.mas_right).with.offset(-10.0);
            }];
            
            
            //            statusView = JBAttributedAwareScrollView.new; //[[UITextView alloc]initWithFrame:[self getStatusViewFrame]];
            //            //statusField.lineBreakMode = UILineBreakModeTailTruncation;
            //            //statusLabel.numberOfLines = 0;
            //            [statusView setBackgroundColor:[UIColor whiteColor]];
            //            NSString *description = [NSString stringWithFormat:@"%@\n%@", [status title], [status statusText]];
            //            [statusView setText:description];
            //            [statusView setTextColor:[UIColor blackColor]];
            //            LOG_FLICKR_VERBOSE(0, @"Status: %@ %@", [status statusText], statusView);
            //            [statusView setFont:FLICKR_FONT];
            //            [statusView setScrollEnabled:YES];
            //            [statusView setBounces:NO];
            //            [self addSubview:statusView];
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
    [photoBox loadPhotoWithCompletionHandler:^(BOOL success, NSError *error) {
        if(success) {
            [self updateStatusView];
        } else {
            LOG_ERROR(0, @"Error loading flickr photo %@", error);
        }
    }];
}


@end

