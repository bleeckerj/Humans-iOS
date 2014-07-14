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
#import "HuTwitterEntitiesURL.h"

#import "HuFoursquareCheckin.h"
#import "HuFoursquareVenue.h"
#import "HuStatusPhotoBox.h"
#import "LoggerClient.h"
#import "UILabel+withDate.h"
#import <BlocksKit+UIKit.h>
#import <IDMPhotoBrowser.h>
#import "HuInstagramHTTPSessionManager.h"
#import "HuTwitterStatusEntities.h"
#import <UIColor+FPBrandColor.h>
#import <UIColor+Crayola.h>
#import <UIImage+Resize.h>
#import <Masonry.h>
#import "JBAttributedAwareScrollView.h"
#import <UIImageView+AFNetworking.h>
#import <UIView+MCLayout.h>

#import "HuServiceStatus.h"
#import "HuTwitterServiceManager.h"


#import "HuFlickrServiceManager.h"
//#import "HuFlickrServicer.h"
@class HuTwitterStatusView;

@interface HuTwitterStatusView : HuViewForServiceStatus <TTTAttributedLabelDelegate, UIViewControllerAnimatedTransitioning, UIGestureRecognizerDelegate> {
    UIImageView *photoView;
    JBAttributedAwareScrollView *statusView;
    HuTwitterStatus *status;
    UIViewController<HuViewControllerForStatusDelegate> *parent;
    //UIScreenEdgePanGestureRecognizer *bottomEdgeRecognizer;

}
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition* interactiveTransition;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *bottomEdgeRecognizer;

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end


@interface HuFlickrStatusView : HuViewForServiceStatus {
    UIImageView *photoView;
    JBAttributedAwareScrollView *statusView;
    HuFlickrStatus *status;
    UIViewController<HuViewControllerForStatusDelegate> *parent;

}
@end


@interface HuInstagramStatusView : HuViewForServiceStatus {
    JBAttributedAwareScrollView *statusView;
    InstagramStatus *status;
    UIImageView *photoView;
    UIViewController<HuViewControllerForStatusDelegate> *parent;
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
@synthesize onTapBackButton;
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
    [avatar.layer setCornerRadius:0.0];
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
    [button.layer setCornerRadius:0];
    
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
    if(self.onTapBackButton != nil) {
        self.onTapBackButton();
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
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext;
{
    return 0.4;
}

#pragma mark UIViewControllerAnimatedTransitioning delegate methods
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    LOG_UI(0, @"transitionContext=%@", transitionContext);
}

#pragma mark TTTAttributedLabelDelegate method
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    LOG_DEEBUG(0, @"clicked: %@", url);
    if(parent != nil) {
        [parent popWebViewFor:url over:self];
    }
}


- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithURL:(NSURL *)url atPoint:(CGPoint)point
{
    LOG_DEEBUG(0, @"%@ %@ %@", label, url, NSStringFromCGPoint(point));
    if(parent != nil) {
        [parent popWebViewFor:url over:self];
    }

}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result
{
    LOG_DEEBUG(0, @"%@ %@", label, result);
    //NSMutableArray *data = [NSMutableArray array];

    //[data addObject:[statusView.text substringWithRange:[result rangeAtIndex:1]]];
    NSString *foo = [statusView.text substringWithRange:[result rangeAtIndex:1]];
    LOG_DEEBUG(0, @"clicked=%@", foo);
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    LOG_UI(0, @"HELLO TOUCH=%@", event);
}


-(HuTwitterStatusView *)initWithFrame:(CGRect)frame forStatus:(HuTwitterStatus *)mstatus with:(UIViewController<HuViewControllerForStatusDelegate> *)mparent
{
    self = [super initWithFrame:frame];
    if(self) {
        status = mstatus;
        parent = mparent;
        Boolean hasStatusText = NO;
        if([status statusText] != nil) {
            hasStatusText = YES;
            
        }

//        UIScreenEdgePanGestureRecognizer *sep = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(panUp:)];
//        self.bottomEdgeRecognizer = sep;
//        sep.edges = UIRectEdgeBottom;
//        [self addGestureRecognizer:sep];
//        sep.delegate = self;
        
        
        HuTwitterStatusEntities *entities = [status entities];
        NSMutableString *str = [[NSMutableString alloc]init];

        NSArray *links = [entities urls];
        if(links && [links count]) {
            [links each:^(id object) {
                if(object) {
                    HuTwitterEntitiesURL *url = (HuTwitterEntitiesURL*)object;
                    [str appendString:[url url]];
                }
            }];
        }

        
        
        UIView *head = [self headerForServiceStatus:mstatus];
        __block HuTwitterStatusView *bself = self;
        [self addSubview:head];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [head mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bself.mas_top);
                make.left.equalTo(bself.mas_left).with.offset(0);
                make.right.equalTo(bself.mas_right).with.offset(0);
                make.height.equalTo(@55).priorityHigh();
            }];
        });
        // header isn't part of the actual status view, which gets pasted into the carousel, so we need
        // the header to be separate..it's managed by HuStatusCarousel_ViewController
        [self setBackgroundColor:[UIColor whiteColor]];
        
        statusView = JBAttributedAwareScrollView.new;
        [self addSubview:statusView];
        [statusView setFrame:CGRectZero];
        [statusView.layer setCornerRadius:0];
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

        
//        UILongPressGestureRecognizer *longPress = [UILongPressGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
//            if(state == UIGestureRecognizerStateBegan) {
//                LOG_UI(0, @"Long Press.");
//                
//                HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
//                [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]retweet:status];
//            }
//            
//        }];
//        [statusView addGestureRecognizer:longPress];
        
        
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
                make.left.equalTo(head.mas_left).with.offset(6);
                make.right.equalTo(head.mas_right).with.offset(-6);
            }];
            
            [photoView setBackgroundColor:[UIColor crayolaJellyBeanColor]];
            [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(head.mas_bottom).with.offset(0);
                make.left.equalTo(head.mas_left).with.offset(0);
                make.right.equalTo(head.mas_right).with.offset(0);
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
            NSString *t = [NSString stringWithFormat:@"%@ %@", [status statusText], str];
            
            statusView.text = t;
            statusView.backgroundColor = [UIColor whiteColor];
            [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(head.mas_bottom).with.offset(3);
                if([status place] == nil) {
                    make.bottom.equalTo(self.mas_bottom).with.offset(-3);
                    
                } else {
                    make.height.greaterThanOrEqualTo(@200).with.priorityMedium();
                }
                make.left.equalTo(head.mas_left).with.offset(6);
                make.right.equalTo(head.mas_right).with.offset(-6);
            }];
        }
        if([status containsMedia] == true) {
            
            NSString *t = [NSString stringWithFormat:@"%@ %@", [status statusText], str];
            
            statusView.text = t;
            //statusView.backgroundColor = [UIColor crayolaKeyLimePearlColor];
            
        }
        
        if([status in_reply_to_status_id] != nil) {
            HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
            [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]getStatus:[status in_reply_to_status_id] withStatuses:@[status] withCompletion:^(id data, BOOL success, NSError *error) {
                if(success) {
                    NSString *t = statusView.text;
                    NSLog(0, @"reply: %@", data);
                    NSString *f = [NSString stringWithFormat:@"%@\n%@", data, t];
                    [statusView setText:f];
                }
            }];
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
                
                make.left.equalTo(head.mas_left).with.offset(0);
                make.right.equalTo(head.mas_right).with.offset(0);
                make.height.greaterThanOrEqualTo(@150).with.priorityMedium();
                
            }];
            [locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(locView.mas_left).with.offset(0);
                make.right.equalTo(locView.mas_right).with.offset(0);
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
    return CGRectInset(statusview_frame, 8, 12);
    
}

-(BOOL)gestureRecognizerShouldBegin:(UIScreenEdgePanGestureRecognizer *)g {
    LOG_UI(0, @"gesture=%@", g);
    if(g == self.bottomEdgeRecognizer) {
        // Do something
        
    }

    return YES;
}


- (void) panUp: (UIScreenEdgePanGestureRecognizer *) g
{
    UIView* v = g.view;
    LOG_UI(0, @"pan gesture=%@", g);
    if (g.state == UIGestureRecognizerStateBegan) {
        //NSLog(@"%@", @"begin");
        self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
    }
    else if (g.state == UIGestureRecognizerStateChanged) {
        CGPoint delta = [g translationInView: v];
        CGFloat percent = fabs(delta.x/v.bounds.size.width);
        [self.interactiveTransition updateInteractiveTransition:percent];
        LOG_UI(0, @"delta=%@ percent=%f v=%@ v.bounds.size=%@", NSStringFromCGPoint(delta), percent, v, NSStringFromCGSize(v.bounds.size));
    }
    else if (g.state == UIGestureRecognizerStateEnded) {
        CGPoint delta = [g translationInView: v];
        CGFloat percent = fabs(delta.x/v.bounds.size.width);
        self.interactiveTransition.completionSpeed = 0.5;
        // (try completionSpeed = 2 to see "ghosting" problem after a partial)
        // (can occur with 1 as well)
        // (setting to 0.5 seems to fix it)
        
        if (percent > 0.5) {
            LOG_UI(0, @"%@", @"calling finish");
            [self.interactiveTransition finishInteractiveTransition];
        }
        else {
            LOG_UI(0, @"%@", @"calling cancel");
            [self.interactiveTransition cancelInteractiveTransition];
        }
    } else if (g.state == UIGestureRecognizerStateCancelled) {
        [self.interactiveTransition cancelInteractiveTransition];
    }

}


- (void)showOrRefreshPhoto
{

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


-(HuInstagramStatusView *)initWithFrame:(CGRect)frame forStatus:(InstagramStatus*)mstatus with:(UIViewController<HuViewControllerForStatusDelegate> *)mparent
{
    self = [super initWithFrame:frame];
    
    if(self) {
        
        [self setBackgroundColor:[UIColor crayolaGraniteGrayColor]];
        [self.layer setCornerRadius:0.0];
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
        [photoView.layer setCornerRadius:0.0];
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
            make.top.equalTo(head.mas_bottom).with.offset(0);
            make.left.equalTo(head.mas_left).with.offset(0);
            make.right.equalTo(head.mas_right).with.offset(0);
            make.height.equalTo(@(self.frame.size.width)).with.priorityHigh();
        }];
        // dispatch_async(dispatch_get_main_queue(), ^{
        [head mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bself.mas_top);
            make.width.equalTo(bself.mas_width);
            make.left.equalTo(bself.mas_left);
            make.height.equalTo(@55).priorityHigh();
        }];
        
        
        
        [photoView setImageWithURL:[NSURL URLWithString:[mstatus statusImageURL]] placeholderImage:[UIImage imageNamed:@"BoozyBear"] options:(SDWebImageRetryFailed) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if(error == nil) {
                
                bphotoView.image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(310,310) interpolationQuality:kCGInterpolationHigh];
                

                dispatch_async(dispatch_get_main_queue(), ^{
                    [bphotoView setNeedsDisplay];
                    
                });
            } else {
                // pure diagnostics
                NSString *err = [NSString stringWithFormat:@"error.instagram.image.%@", @"foo"];
                NSDictionary *dimensions = @{err: [mstatus statusImageURL] == nil ? @"(null statusImageURL)" : [mstatus statusImageURL]};
                [[LELog sharedInstance]log:dimensions];
                bphotoView.image = [UIImage imageNamed:@"BoozyBear.png"];

                NSString *diagnostic = [NSString stringWithFormat:@"Diagnostic null statusImageURL %@", [mstatus statusImageURL]];
                [bself.status setStatusText:diagnostic];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [bphotoView mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.top.equalTo(head.mas_bottom).with.offset(0);
                        make.left.equalTo(head.mas_left).with.offset(0);
                        make.right.equalTo(head.mas_right).with.offset(0);
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
                make.left.equalTo(head.mas_left).with.offset(0);
                make.right.equalTo(head.mas_right).with.offset(0);
                if(loc == nil) {
                    make.bottom.equalTo(self.mas_bottom).with.offset(-3);
                } else {
                    //if(hasStatusText == YES || [[status type] isEqualToString:@"video"]) {
                    make.height.greaterThanOrEqualTo(@100).with.priorityMedium();
                    //}
                }
            }];
            [statusView setFrame:CGRectZero];
            [[statusView layer]setCornerRadius:0.0];
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
            [[locView layer]setCornerRadius:0.0];
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
                
                make.left.equalTo(head.mas_left).with.offset(0);
                make.right.equalTo(head.mas_right).with.offset(0);
                make.height.greaterThanOrEqualTo(@100).with.priorityMedium();
                
            }];
            [locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(locView.mas_left).with.offset(5);
                make.right.equalTo(locView.mas_right).with.offset(5);
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
        
        UITapGestureRecognizer *singleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            LOG_UI(0, @"Single tap.");
        } delay:0.18];
        [photoView addGestureRecognizer:singleTap];
        
        //__strong __block HuFlickrServicer *servicer;
        __strong __block HuFlickrServiceManager *mgr;
        UITapGestureRecognizer *doubleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            [singleTap bk_cancel];
            LOG_UI(0, @"Double tap.");

                mgr = [[HuFlickrServiceManager alloc]initFor:status];
            [mgr like:status];
        }];
        doubleTap.numberOfTapsRequired = 2;
        [photoView addGestureRecognizer:doubleTap];

        
        [head mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bself.mas_top);
            //make.width.equalTo(bself.mas_width);
            make.left.equalTo(self.mas_left).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(0);
            make.height.equalTo(@55).priorityHigh();
        }];
        
        __block UIImageView *bphotoView = photoView;

        
        [photoView setImageWithURL:[NSURL URLWithString:[mstatus statusImageURL]] placeholderImage:[UIImage imageNamed:@"BoozyBear"] options:(SDWebImageRetryFailed) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if(error == nil) {
                
                bphotoView.image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(310,310) interpolationQuality:kCGInterpolationHigh];
                

                [bphotoView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(head.mas_bottom).with.offset(0);
                    make.left.equalTo(head.mas_left).with.offset(5);
                    make.right.equalTo(head.mas_right).with.offset(-5);
                    make.height.lessThanOrEqualTo(@310).with.priorityHigh();
                    
                    [bphotoView sizeToFit];
                    
                }];
                [bphotoView setNeedsDisplay];

            }
        }];
        
        UILongPressGestureRecognizer *longPress = [UILongPressGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            if(state == UIGestureRecognizerStateBegan) {
                LOG_UI(0, @"Long Press.");
                
               // IDMPhoto *idmphoto = [IDMPhoto photoWithImage:bphotoView.image];
                IDMPhoto *idmphoto = [IDMPhoto photoWithURL:[NSURL URLWithString:[status url_l]]];
                NSArray *photo = @[idmphoto];
                IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photo];
                [mparent presentViewController:browser animated:NO completion:nil];
            }
            
        }];
        [photoView addGestureRecognizer:longPress];
        

        [photoView setBackgroundColor:[UIColor grayColor]];
        [photoView.layer setCornerRadius:0];
        
        if([status statusText] != nil) {
            
            statusView = JBAttributedAwareScrollView.new;
            [self addSubview:statusView];
            [statusView.layer setCornerRadius:0];
            [statusView setFrame:CGRectZero];
            statusView.label.delegate = self;
            [statusView setFont:FLICKR_FONT];
            statusView.text = [NSString stringWithFormat:@"%@ - %@", [status title], [status statusText]];
            statusView.backgroundColor =[UIColor whiteColor];
            [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(photoView.mas_bottom).with.offset(0);
                make.bottom.equalTo(self.mas_bottom).with.offset(-5.0);
                make.left.equalTo(head.mas_left).with.offset(0);
                make.right.equalTo(head.mas_right).with.offset(0);
            }];
            
        }
    }
    self.layer.cornerRadius = 0.0;//CORNER_RADIUS;
    
    return self;
}


- (void)showOrRefreshPhoto
{

}


@end

