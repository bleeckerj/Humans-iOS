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
#import "LoggerClient.h"
#import "UILabel+withDate.h"
#import <BlocksKit+UIKit.h>
#import <IDMPhotoBrowser.h>
#import "HuInstagramHTTPSessionManager.h"

#import <UIColor+FPBrandColor.h>
#import <UIColor+Crayola.h>
#import <UIImage+Resize.h>
#import <Masonry.h>
#import "JBAttributedAwareScrollView.h"
#import <UIImageView+AFNetworking.h>
#import <UIView+MCLayout.h>

#import "HuServiceStatus.h"
#import "HuTwitterServiceManager.h"

@interface HuTwitterStatusView : HuViewForServiceStatus <TTTAttributedLabelDelegate> {
    UIImageView *photoView;
    JBAttributedAwareScrollView *statusView;
    HuTwitterStatus *status;
}
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end


@interface HuFlickrStatusView : HuViewForServiceStatus {
    UIImageView *photoView;
    JBAttributedAwareScrollView *statusView;
    HuFlickrStatus *status;
}
@end


@interface HuInstagramStatusView : HuViewForServiceStatus {
    JBAttributedAwareScrollView *statusView;
    InstagramStatus *status;
    UIImageView *photoView;
    UIViewController *parent;
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
@synthesize onTap;
UIImageView *exView;
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
    return hView;
    
}


- (HuViewForServiceStatus *)initWithFrame:(CGRect)frame forStatus:(id<HuServiceStatus>)mstatus with:(UIViewController *)mparent
{
    HuViewForServiceStatus* hView = nil;
    
    if([mstatus isKindOfClass:[HuTwitterStatus class]]) {
        //hView = [[HuTwitterStatusView alloc]initWithFrame:frame forStatus:mstatus];
        // hView = [[HuTwitterStatusView alloc]init];
        hView = [[HuTwitterStatusView alloc]initWithFrame:frame forStatus:mstatus with:mparent];
        
    }
    if([mstatus isKindOfClass:[InstagramStatus class]]) {
        hView = [[HuInstagramStatusView alloc]initWithFrame:frame forStatus:mstatus with:mparent];
    }
    
    if([mstatus isKindOfClass:[HuFlickrStatus class]]) {
        hView = [[HuFlickrStatusView alloc]initWithFrame:frame forStatus:mstatus with:mparent];
    }
    
    
    if([mstatus isKindOfClass:[HuFoursquareCheckin class]]) {
        hView = [[HuFoursquareStatusView alloc]initWithFrame:frame forStatus:mstatus with:mparent];
    }
    
    //LOG_GENERAL(0, @"View is %@", hView);
    return hView;
}

#pragma mark gets a view for a specific status
+ (UIView *)viewForStatus:(id<HuServiceStatus>)mstatus withFrame:(CGRect)frame with:(UIViewController *)mparent
{
    //UIView *result;
    return[[HuViewForServiceStatus alloc]initWithFrame:frame forStatus:mstatus with:mparent];
}



#pragma mark Here is where we make the header
- (UIView *)headerForServiceStatus:(id<HuServiceStatus>)mStatus
{
    UIView *head = UIView.new;
    UIView *topContainer = UIView.new;
    
    [head addSubview:topContainer];
    
    
    
    [head setBackgroundColor:[mStatus serviceSolidColor]];
    [head.layer setCornerRadius:5.0];
    
    UIImageView *avatar = [[UIImageView alloc]init];
    [topContainer addSubview:avatar];
    
    UILabel *usernameLabel = UILabel.new;
    [topContainer addSubview:usernameLabel];
    UILabel *dateLabel = UILabel.new;
    [topContainer addSubview:dateLabel];
    UIImageView *tinyServiceIcon = UIImageView.new;
    [topContainer addSubview:tinyServiceIcon];
    
    [topContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(head);
        //make.height.equalTo(head.mas_height)/*.with.offset(-25)*/;
    }];
    
    [usernameLabel setFont:HEADER_FONT_LARGE];
    [usernameLabel setTextColor:[UIColor whiteColor]];
    [usernameLabel setTextAlignment:NSTextAlignmentRight];
    
    [usernameLabel setText:[NSString stringWithFormat:@"@%@", [mStatus serviceUsername]]];
    [usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(avatar.mas_left).with.offset(-10);
        //make.height.equalTo(topContainer.mas_height);
        make.centerY.equalTo(topContainer.mas_centerY).with.offset(-10);
    }];
    
    [dateLabel setDateToShow:[mStatus dateForSorting]];
    [dateLabel setTextColor:[UIColor whiteColor]];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setFont:HEADER_FONT];
    [dateLabel setTextAlignment:NSTextAlignmentRight];
    [dateLabel setNumberOfLines:1];
    
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tinyServiceIcon.mas_left).with.offset(-3);
        make.top.equalTo(usernameLabel.mas_bottom).with.offset(-3);
    }];
    
    UIImage *image = [UIImage imageNamed:[mStatus tinyMonochromeServiceImageBadgeName]];
    [tinyServiceIcon setImage:image];
    [tinyServiceIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(usernameLabel.mas_right);
        make.top.equalTo(dateLabel.mas_top);
        make.bottom.equalTo(dateLabel.mas_bottom);
        make.height.equalTo(@15);
        make.width.equalTo(@15);
    }];
    
    
    
    [avatar setContentMode:(UIViewContentModeScaleAspectFit)];
    [avatar setClipsToBounds:YES];
    [avatar setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [avatar.layer setCornerRadius:5.0];
    __block UIImageView *bavatar = avatar;
    [avatar setImageWithURL:[mStatus userProfileImageURL] placeholderImage:[UIImage imageNamed:@"GIJoeAngry"] options:(SDWebImageRetryFailed) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if(error == nil) {
            bavatar.image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(35, 35) interpolationQuality:kCGInterpolationHigh];
            dispatch_async(dispatch_get_main_queue(), ^{
                [bavatar mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(head.mas_right);
                    make.top.equalTo(head.mas_top);
                    make.bottom.equalTo(head.mas_bottom);
                    make.height.equalTo(head.mas_height);
                    make.width.equalTo(head.mas_height);
                    [bavatar sizeToFit];
                }];
                [bavatar setNeedsDisplay];
            });
        }
    }
     ];
    [avatar.image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(35,35) interpolationQuality:kCGInterpolationHigh];
    //
    
    //UIImage *ex = [UIImage imageNamed:@"delete-x"];
    exView = UIImageView.new;
    
    UIButton *button = UIButton.new;
    [button setUserInteractionEnabled:YES];
    [button setBackgroundColor:[UIColor crayolaYellowOrangeColor]];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button.layer setCornerRadius:5];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapHeader:)];
    [gesture setNumberOfTapsRequired:1];
    
    [button addGestureRecognizer:gesture];
    
    
    [head addSubview:button];
    //[exView setImage:ex];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topContainer.mas_left);
        make.centerY.equalTo(topContainer.mas_centerY);
        make.width.equalTo(head.mas_height);
        make.height.equalTo(head.mas_height);
        //make.top.equalTo(usernameLabel.mas_top);
        //make.height.equalTo(avatar.mas_height);
    }];
    
    return head;
}



- (void)onTapHeader:(id)sender {
    if(self.onTap != nil) {
        self.onTap();
    }
}

- (void)showOrRefreshPhoto
{
    
}


@end


#pragma mark Foursquare Status View
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

#pragma mark Twitter Status View
@implementation HuTwitterStatusView
{
}

//- (void)touchesEnded:(NSSet *)touches
//           withEvent:(UIEvent *)event
//{
//    NSLog(@"GOODBYE %@", event);
//}

#pragma mark TTTAttributedLabelDelegate method
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    //NSLog(@"%@", url);
    LOG_DEEBUG(0, @"clicked: %@", url);
    if(self.backgroundColor == [UIColor crayolaApricotColor]) {
        [self setBackgroundColor:[UIColor crayolaAquaPearlColor]];
    } else {
        [self setBackgroundColor:[UIColor crayolaApricotColor]];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    LOG_UI(0, @"HELLO TOUCH=%@", event);
}

-(HuTwitterStatusView *)initWithStatus:(HuTwitterStatus *)mStatus
{
    self = [super init];
    if(!self) return nil;
    
    if([status containsMedia]) {
        
        
    }
    
    
    return self;
}

-(HuTwitterStatusView *)initWithFrame:(CGRect)frame forStatus:(HuTwitterStatus *)mstatus with:(UIViewController *)mparent
{
    self = [super initWithFrame:frame];
    if(self) {
        status = mstatus;
        
        Boolean hasStatusText = NO;
        if([status statusText] != nil) {
            hasStatusText = YES;
        }
        
        
        UIView *head = [self headerForServiceStatus:mstatus];
        __block HuTwitterStatusView *bself = self;
        [self addSubview:head];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [head mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bself.mas_top);
                make.left.equalTo(bself.mas_left).with.offset(5);
                make.right.equalTo(bself.mas_right).with.offset(-5);
                make.height.equalTo(@55).priorityHigh();
            }];
        });
        // header isn't part of the actual status view, which gets pasted into the carousel, so we need
        // the header to be separate..it's managed by HuStatusCarousel_ViewController
        [self setBackgroundColor:[UIColor whiteColor]];
        
        statusView = JBAttributedAwareScrollView.new;
        [self addSubview:statusView];
        [statusView setFrame:CGRectZero];
        [statusView.layer setCornerRadius:5];
        statusView.label.delegate = self;
        [statusView setFont:TWITTER_FONT_LARGE];
        
        
        // prepare to like/fav
        UITapGestureRecognizer *singleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            LOG_UI(0, @"Single tap.");
        } delay:0.18];
        [statusView addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            [singleTap bk_cancel];
            LOG_UI(0, @"Double tap.");
            HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
            [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]like:status];
        }];
        doubleTap.numberOfTapsRequired = 2;
        [statusView addGestureRecognizer:doubleTap];

        
        
        if([status containsMedia]) {
            photoView = UIImageView.new;
            [photoView setUserInteractionEnabled:YES];
            [photoView setContentMode:(UIViewContentModeScaleAspectFill | UIViewContentModeTop)];
            [photoView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
            [photoView setClipsToBounds:YES];
            [self addSubview:photoView];
            
            [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.greaterThanOrEqualTo(photoView.mas_bottom).with.offset(3);
                make.bottom.equalTo(self.mas_bottom).with.offset(-3);
                make.left.equalTo(head.mas_left);
                make.right.equalTo(head.mas_right);
            }];
            
            [photoView setBackgroundColor:[UIColor crayolaJellyBeanColor]];
            [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(head.mas_bottom).with.offset(3);
                make.left.equalTo(head.mas_left);
                make.right.equalTo(head.mas_right);
                make.height.equalTo(@320).priorityHigh();
                //make.bottom.lessThanOrEqualTo(bself.statusView.mas_top).with.offset(3);
            }];
            
            __block UIImageView *bphotoView = photoView;
            UILongPressGestureRecognizer *longPress = [UILongPressGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
                if(state == UIGestureRecognizerStateBegan) {
                    LOG_UI(0, @"Long Press.");
                    
                    IDMPhoto *idmphoto = [IDMPhoto photoWithImage:bphotoView.image];
                    
                    NSArray *photo = @[idmphoto];
                    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photo];
                    [mparent presentViewController:browser animated:NO completion:nil];
                }
                
            }];
            [photoView addGestureRecognizer:longPress];

            
            
            UITapGestureRecognizer *singleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
                LOG_UI(0, @"Single tap.");
            } delay:0.18];
            [photoView addGestureRecognizer:singleTap];
            
            UITapGestureRecognizer *doubleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
                [singleTap bk_cancel];
                LOG_UI(0, @"Double tap.");
                HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
                [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]like:status];
            }];
            doubleTap.numberOfTapsRequired = 2;
            [photoView addGestureRecognizer:doubleTap];

            
            [photoView setImageWithURL:[NSURL URLWithString:[mstatus statusImageURL]] placeholderImage: [UIImage imageNamed:@"BoozyBear.png"] options:(SDWebImageRetryFailed) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                if(error == nil) {
                    CGSize resizeSize = CGSizeMake(320, 320);
                    
                    bphotoView.image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:resizeSize interpolationQuality:kCGInterpolationDefault];
                    //image = img;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [bphotoView setNeedsDisplay];
                        
                    });
                } else {
                    // do something if there was a problem loading the image?
                    bphotoView.image = [UIImage imageNamed:@"BoozyBear.png"];
                    
                }
            }];
        }
        
        if([status containsMedia] == false) {
            NSString *t = [NSString stringWithFormat:@"%@", [status statusText]];
            statusView.text = t;
            statusView.backgroundColor = [UIColor whiteColor];
            [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(head.mas_bottom).with.offset(3);
                if([status place] == nil) {
                    make.bottom.equalTo(self.mas_bottom).with.offset(-3);
                    
                } else {
                    make.height.greaterThanOrEqualTo(@200).with.priorityMedium();
                }
                make.left.equalTo(head.mas_left);
                make.right.equalTo(head.mas_right);
            }];
        }
        if([status containsMedia] == true) {
            
            NSString *t = [NSString stringWithFormat:@"%@ %@ in_reply_to=%@", [status statusText], [status statusImageURL], [status in_reply_to_status_id]];
            statusView.text = t;//[status statusText];
            statusView.backgroundColor = [UIColor crayolaKeyLimePearlColor];
            
        }
        
        if([status place]  != nil) {
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
            HuTwitterPlace *place = [status place];
            NSString *minimal = [[place jsonString] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            //NSLog(@"%@", minimal);
            [locLabel setText:[NSString stringWithFormat:@"(FPO MAP HERE SOON)\n%@",minimal]];
            [locLabel setFont:INSTAGRAM_FONT_SMALL];
            [locLabel setContentMode:UIViewContentModeTop];
            
            
            [locView mas_makeConstraints:^(MASConstraintMaker *make) {
                if(hasStatusText == YES) {
                    make.top.equalTo(statusView.mas_bottom).offset(3);
                } else {
                    make.top.equalTo(photoView.mas_bottom).offset(3);
                }
                //make.bottom.equalTo(self.mas_bottom).offset(-3);
                
                make.left.equalTo(head.mas_left);
                make.right.equalTo(head.mas_right);
                make.height.greaterThanOrEqualTo(@150).with.priorityMedium();
                
            }];
            [locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(locView.mas_left).with.offset(3);
                make.right.equalTo(locView.mas_right).with.offset(-3);
                make.top.equalTo(locView.mas_top).with.offset(3);
                make.bottom.equalTo(locView.mas_bottom).with.offset(-3);
            }];
            
            
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
    
    //    if([status containsMedia]) {
    //
    //        [status statusImageURL];
    //
    //        if([status statusImageURL] == nil) {
    //            LOG_TWITTER(0, @"Weird. The photo box urlStr should've been set?");
    //            //[photoBox setUrlStr:[status statusImageURL]];
    //        }
    //
    //    }
}

- (void)updateStatusView
{
    //[statusView setFrame:[self getStatusViewFrame]];
    [self layoutSubviews];
}

@end

#pragma mark Instagram Status View

@implementation HuInstagramStatusView {
    
}


-(HuInstagramStatusView *)initWithFrame:(CGRect)frame forStatus:(InstagramStatus*)mstatus with:(UIViewController *)mparent
{
    self = [super initWithFrame:frame];
    
    if(self) {
        
        [self setBackgroundColor:[UIColor crayolaGraniteGrayColor]];
        [self.layer setCornerRadius:3.0];
        status = mstatus;
        //[[status status_on_behalf_of]accessToken];
        parent = mparent;
        
        Boolean hasStatusText = NO;
        if([status statusText] != nil) {
            hasStatusText = YES;
        }
        
        
        
        __block HuViewForServiceStatus *bself = self;
        InstagramLocation *loc = [status location];
        
        UIView *head = [self headerForServiceStatus:mstatus];
        
        [self addSubview:head];
        
        photoView = UIImageView.new;
        [photoView setUserInteractionEnabled:YES];
        [self addSubview:photoView];
        [photoView setContentMode:(UIViewContentModeScaleAspectFit)];
        [photoView setClipsToBounds:YES];
        [photoView.layer setCornerRadius:5.0];
        [photoView setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *singleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            LOG_UI(0, @"Single tap.");
        } delay:0.18];
        [photoView addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            [singleTap bk_cancel];
            LOG_UI(0, @"Double tap.");
            [[HuInstagramHTTPSessionManager sharedInstagramClient]like:status];
            //            [[HuInstagramHTTPSessionManager sharedInstagramClient]like:status];
        }];
        doubleTap.numberOfTapsRequired = 2;
        [photoView addGestureRecognizer:doubleTap];
        
        __block UIImageView *bphotoView = photoView;
        
        
        UILongPressGestureRecognizer *longPress = [UILongPressGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            if(state == UIGestureRecognizerStateBegan) {
                LOG_UI(0, @"Long Press.");
                
                IDMPhoto *idmphoto = [IDMPhoto photoWithImage:bphotoView.image];
                
                NSArray *photo = @[idmphoto];
                IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photo];
                [parent presentViewController:browser animated:NO completion:nil];
            }
            
        }];
        [photoView addGestureRecognizer:longPress];
        
        [photoView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [photoView setBackgroundColor:[UIColor crayolaManateeColor]];
        [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(head.mas_bottom).with.offset(3);
            make.left.equalTo(self.mas_left).with.offset(3);
            make.right.equalTo(self.mas_right).with.offset(-3);
            make.height.lessThanOrEqualTo(@310).with.priorityHigh();
            
            //[photoView sizeToFit];
            
        }];
        // dispatch_async(dispatch_get_main_queue(), ^{
        [head mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bself.mas_top);
            make.width.equalTo(photoView.mas_width);
            make.left.equalTo(photoView.mas_left);
            //                make.right.equalTo(bself.mas_right).with.offset(0);
            make.height.equalTo(@55).priorityHigh();
        }];
        // });
        
        
        
        
        [photoView setImageWithURL:[NSURL URLWithString:[mstatus statusImageURL]] placeholderImage:[UIImage imageNamed:@"BoozyBear"] options:(SDWebImageRetryFailed) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if(error == nil) {
                
                bphotoView.image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(310,310) interpolationQuality:kCGInterpolationHigh];
                
                //bphotoView.image = image;
                //__block CGRect frame;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [bphotoView setNeedsDisplay];
                    
                });
            } else {
                // pure diagnostics
                NSString *err = [NSString stringWithFormat:@"error.instagram.image.%@", @"foo"];
                NSDictionary *dimensions = @{err: [mstatus statusImageURL] == nil ? @"(null statusImageURL)" : [mstatus statusImageURL]};
                [[LELog sharedInstance]log:dimensions];
                bphotoView.image = [UIImage imageNamed:@"BoozyBear.png"];
                //                UILabel *label = UILabel.new;
                //                [bself addSubview:label];
                //                [label setText:[mstatus statusImageURL]];
                NSString *diagnostic = [NSString stringWithFormat:@"Diagnostic null statusImageURL %@", [mstatus statusImageURL]];
                [bself.status setStatusText:diagnostic];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [bphotoView mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.top.equalTo(head.mas_bottom).with.offset(3);
                        make.left.equalTo(bself.mas_left).with.offset(3);
                        make.right.equalTo(bself.mas_right).with.offset(-3);
                        make.height.lessThanOrEqualTo(@310).with.priorityHigh();
                        [bphotoView sizeToFit];
                    }];
                    [bphotoView setNeedsDisplay];
                    
                });
            }
        }];
        
        if(hasStatusText == YES || [[status type]isEqualToString:@"video"]) {
            statusView = JBAttributedAwareScrollView.new;
            
            
            [self addSubview:statusView];
            
            [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(photoView.mas_bottom).with.offset(3);
                make.left.equalTo(head.mas_left);
                make.right.equalTo(head.mas_right);
                if(loc == nil) {
                    make.bottom.equalTo(self.mas_bottom).with.offset(-3);
                } else {
                    //if(hasStatusText == YES || [[status type] isEqualToString:@"video"]) {
                    make.height.greaterThanOrEqualTo(@100).with.priorityMedium();
                    //}
                }
            }];
            [statusView setFrame:CGRectZero];
            [[statusView layer]setCornerRadius:5.0];
            statusView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:186.0/255.0 green:187.0/255.0 blue:188.0/255.0 alpha:1.0];
            
            statusView.label.delegate = self;
            [statusView setFont:INSTAGRAM_FONT];
            [statusView setTextColor:[UIColor blackColor]];
            
            NSString *description;
            
            if([status statusText] != nil) {
                
                if([[status type] isEqualToString:@"video"]) {
                    description = [NSString stringWithFormat:@"(video soon) %@", [status statusText]];
                } else {
                    description = [NSString stringWithFormat:@"%@",[status statusText]];
                }
                statusView.text = description;
            } else {
                statusView.text = @"";
            }
        }
        
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
                if(hasStatusText == YES) {
                    make.top.equalTo(statusView.mas_bottom).offset(3);
                } else {
                    make.top.equalTo(photoView.mas_bottom).offset(3);
                }
                make.bottom.equalTo(self.mas_bottom).offset(-3);
                
                make.left.equalTo(head.mas_left);
                make.right.equalTo(head.mas_right);
                make.height.greaterThanOrEqualTo(@100).with.priorityMedium();
                
            }];
            [locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(locView.mas_left).with.offset(3);
                make.right.equalTo(locView.mas_right).with.offset(-3);
                make.top.equalTo(locView.mas_top).with.offset(3);
                make.bottom.equalTo(locView.mas_bottom).with.offset(-3);
            }];
        }
        
        //id<HuSocialServiceUser>user = [status serviceUser];
        //[self setBackgroundColor:[user serviceSolidColor]];
        
    }
    //self.layer.cornerRadius = CORNER_RADIUS;
    
    return self;
}


- (void)showOrRefreshPhoto
{
}



-(NSString *)description
{
    NSString *result = [NSString stringWithFormat:@"%@ %@", [super description], status];
    return result;
}
@end


#pragma mark Flickr Status View
@implementation HuFlickrStatusView

@class CALayer;


-(id)initWithFrame:(CGRect)frame forStatus:(HuFlickrStatus*)mstatus with:(UIViewController *)mparent
{
    
    
    self = [super initWithFrame:frame];
    if(self) {
        status = mstatus;
        UIView *head = [self headerForServiceStatus:mstatus];
        [self addSubview:head];
        __block HuFlickrStatusView *bself = self;
        [self setBackgroundColor:[UIColor clearColor]];
        
        
        //photoBox = [HuStatusPhotoBox photoBoxFor:[status statusImageURL] size:CGSizeMake(frame.size.width, frame.size.height) deferLoad:NO];
        photoView = UIImageView.new;
        [photoView setUserInteractionEnabled:YES];
        [self addSubview:photoView];
        
        [head mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bself.mas_top);
            //make.width.equalTo(bself.mas_width);
            make.left.equalTo(self.mas_left).with.offset(5);
            make.right.equalTo(self.mas_right).with.offset(-5);
            make.height.equalTo(@55).priorityHigh();
        }];
        
        __block UIImageView *bphotoView = photoView;

        
        [photoView setImageWithURL:[NSURL URLWithString:[mstatus statusImageURL]] placeholderImage:[UIImage imageNamed:@"BoozyBear"] options:(SDWebImageRetryFailed) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if(error == nil) {
                
                bphotoView.image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(310,310) interpolationQuality:kCGInterpolationHigh];
                
                //bphotoView.image = image;
                //__block CGRect frame;
                //dispatch_async(dispatch_get_main_queue(), ^{
                [bphotoView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(head.mas_bottom).with.offset(3);
                    make.left.equalTo(head.mas_left);
                    make.right.equalTo(head.mas_right);
                    make.height.lessThanOrEqualTo(@310).with.priorityHigh();
                    
                    [bphotoView sizeToFit];
                    
                }];
                [bphotoView setNeedsDisplay];
                
                //});
                
            }
        }];
        
        UILongPressGestureRecognizer *longPress = [UILongPressGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            if(state == UIGestureRecognizerStateBegan) {
                LOG_UI(0, @"Long Press.");
                
                IDMPhoto *idmphoto = [IDMPhoto photoWithImage:bphotoView.image];
                
                NSArray *photo = @[idmphoto];
                IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photo];
                [mparent presentViewController:browser animated:NO completion:nil];
            }
            
        }];
        [photoView addGestureRecognizer:longPress];
        

        [photoView setBackgroundColor:[UIColor grayColor]];
        [photoView.layer setCornerRadius:15];
        
        if([status statusText] != nil) {
            
            statusView = JBAttributedAwareScrollView.new;
            [self addSubview:statusView];
            [statusView.layer setCornerRadius:5];
            [statusView setFrame:CGRectZero];
            statusView.label.delegate = self;
            [statusView setFont:FLICKR_FONT];
            statusView.text = [NSString stringWithFormat:@"%@ - %@", [status title], [status statusText]];
            statusView.backgroundColor =[UIColor whiteColor];// [UIColor colorWithRed:186.0/255.0 green:187.0/255.0 blue:188.0/255.0 alpha:1.0];
            [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
                //UIEdgeInsets padding = UIEdgeInsetsMake(5, 5, 5, 5);
                //make.edges.equalTo(self).with.insets(padding);
                //make.center.equalTo(self);
                make.top.equalTo(photoView.mas_bottom).with.offset(3);
                make.bottom.equalTo(self.mas_bottom).with.offset(-5.0);
                make.left.equalTo(head.mas_left);
                make.right.equalTo(head.mas_right);
            }];
            
        }
    }
    self.layer.cornerRadius = CORNER_RADIUS;
    
    return self;
}

//- (void)updateStatusView
//{
//    [statusView setFrame:[self getStatusViewFrame]];
//}
//
//- (CGRect) getStatusViewFrame
//{
//    float screen_height;
//
//    if(IS_IPHONE && IS_IPHONE_5) {
//        screen_height = IPHONE_5_PORTRAIT_SIZE_HEIGHT;
//    } else {
//        screen_height = IPHONE_PORTRAIT_SIZE_HEIGHT;
//    }
//
//    float clear_bottom = screen_height - CGRectGetMaxY(photoView.frame);
//    CGRect statusview_frame = (CGRectMake(CGRectGetMinX(photoView.frame), CGRectGetMaxY(photoView.frame), CGRectGetWidth(photoView.frame), clear_bottom));
//
//    return CGRectInset(statusview_frame, 8, 12);
//
//}

- (void)showOrRefreshPhoto
{
    //    [photoBox loadPhotoWithCompletionHandler:^(BOOL success, NSError *error) {
    //        if(success) {
    //            [self updateStatusView];
    //        } else {
    //            LOG_ERROR(0, @"Error loading flickr photo %@", error);
    //        }
    //    }];
}


@end

