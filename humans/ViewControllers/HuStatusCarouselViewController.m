//
//  HuStatusCarouselViewController.m
//  humans
//
//  Created by julian on 12/22/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import "HuStatusCarouselViewController.h"
#import "defines.h"
#import "InstagramStatus.h"
#import "InstagramCaption.h"
#import "InstagramLocation.h"
#import "HuInstagramHTTPSessionManager.h"

#import "HuHeaderForServiceStatusView.h"
#import "HuViewForServiceStatus.h"
#import "HuServiceStatus.h"
#import <UIColor+FPBrandColor.h>
#import <UIColor+Crayola.h>
#import <UIView+MCLayout.h>
#import <ViewUtils.h>
#import "HuUserHandler.h"
#import "HuAppDelegate.h"
#import <ObjectiveSugar.h>

#import "HuTwitterServiceManager.h"

//         HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
//        [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]like:status];

#import "HuTwitterStatus.h"
#import "HuTwitterPlace.h"

#import "HuFlickrStatus.h"
#import "HuFlickrServiceManager.h"

#import "ColorPalette.h"

#define VISIBLE_ITEMS_IN_CAROUSEL 4


@interface HuStatusCarouselViewController () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) iCarousel *carousel;


@end

@implementation HuStatusCarouselViewController
{
    HuHeaderForServiceStatusView *header;
    CGRect carouselFrame;
    UIStoryboardSegue *segueToFriends;
    NSMutableArray *statusViews;
    HuUserHandler *user_handler;
    MRProgressOverlayView *activityIndicatorViewForWebView;
    
}

@synthesize carousel;
@synthesize items;
@synthesize human;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if(self) {
        [self commonInit];
    }
    return self;
}


- (void)commonInit
{
    activityIndicatorViewForWebView = [[MRProgressOverlayView alloc]init];
    items = [[NSMutableArray alloc]init];
    carousel = [[iCarousel alloc] init];
    
    carousel.type = iCarouselTypeLinear;
	carousel.delegate = self;
	carousel.dataSource = self;
    carousel.bounces = NO;
    carousel.scrollSpeed = 0.3;
    carousel.vertical = NO;
    
    statusViews = [[NSMutableArray alloc]init];
    
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    user_handler = [delegate humansAppUser];
}

- (void)setItems:(NSMutableArray *)_items
{
    items = _items;
    if(statusViews && [statusViews count] > 0) {
        [statusViews removeAllObjects];
        ////////////[self buildViewsForStatus];
    }
    [carousel reloadData];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.frame = CGRectMake(0, 0, 320, 560);
    self.view.frame = [self.navigationController.view bounds];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor crayolaManateeColor]];
    
    [self.view addSubview:carousel];
    
    // header
    [carousel setBackgroundColor:[UIColor crayolaTimberwolfColor]];
    
    carouselFrame = self.view.frame;
    
    [carousel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [carousel setFrame:carouselFrame];
    ///////////////[self buildViewsForStatus];

    LOG_UI(0, @"view (%@) header= carousel=%@", self.view, NSStringFromCGRect(carousel.frame));
}

- (StatusView *)resetForFlickr:(StatusView *)reuse forStatus:(HuFlickrStatus *)status
{
    ColorPalette *palette = [ColorPalette melonBallSurprise];
    [reuse applyColorPalette:palette];
    [reuse setNameViewColor:[UIColor FlickrBlue]];
    [reuse setupFlickrWithStatus:status fromViewController:self];
    [[reuse scrollView]setBounces:YES];
    [reuse scrollToStatusTop];
    [reuse setName:[status serviceUsername]];
    [reuse setDate:[status dateForSorting]];
    // Location
    //        if([s location] != nil) {
    //            InstagramLocation *location = [s location];
    //            if([location name] == nil) {
    //                // defer a reverse geocode to the view, which is weird..
    //                CLLocation *cl_location = [[CLLocation alloc]initWithLatitude:[[location latitude]doubleValue] longitude:[[location longitude]doubleValue]];
    //                [v setCLLocation:cl_location];
    //            } else {
    //                [v setLocation:[NSString stringWithFormat:@"%@", [location name]]];
    //            }
    //        }
    [reuse setOnTapBackButton:^(){
        LOG_UI(0, @"Back On Tap");
        [carousel scrollToItemAtIndex:0 duration:0.5];
        [self performBlock:^{
            [[self navigationController]popViewControllerAnimated:YES];
        } afterDelay:0.6];
        
    }];
    
    [reuse setOnDoubleTap:^(){
        HuFlickrServiceManager *mgr = [[HuFlickrServiceManager alloc]initFor:status];
        [mgr like:status];
 
    }];
    
    [reuse setOnTapLikeButton:^() {
        HuFlickrServiceManager *mgr = [[HuFlickrServiceManager alloc]initFor:status];
        [mgr like:status];
    }];
    
    //[statusViews addObject:v];
    dispatch_async(dispatch_get_main_queue(), ^{
        [reuse setNeedsDisplay];
        
    });
    return reuse;

}

- (StatusView *)resetForTwitter:(StatusView *)reuse forStatus:(HuTwitterStatus *)status
{
    [reuse resetupView];
    ColorPalette *palette = [ColorPalette seaAndSky];
    [reuse applyColorPalette:palette];
    [reuse setNameViewColor:[UIColor Twitter]];
    [reuse setupTwitterWithStatus:status fromViewController:self];
    
    [reuse setOnDoubleTap:^(void) {
        NSLog(@"Double Tapped!");
        HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
        [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]like:status];
        
    }];
    
    [reuse setOnTapLikeButton:^(void) {
        HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
        [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]like:status];
        
    }];
    //                [v setupTwitterWithStatus:[s statusText] imageURL:[status statusImageURL] hasImage:YES inReplyTo:nil];
    
    [[reuse scrollView]setBounces:YES];
    [reuse scrollToStatusTop];
    // NSLog(@"%@", dateInLocalTimezone);
    
    [reuse setName:[status serviceUsername]];
    [reuse setDate:[status dateForSorting]];
    if([status place] != nil) {
        HuTwitterPlace *place = [status place];
        [reuse setLocation:[NSString stringWithFormat:@"%@ %@", [place full_name], [place country_code]]];
    }
    
    [reuse setOnTapBackButton:^(){
        LOG_UI(0, @"Back On Tap");
        [carousel scrollToItemAtIndex:0 duration:0.5];
        [self performBlock:^{
            [[self navigationController]popViewControllerAnimated:YES];
        } afterDelay:0.6];
        
    }];
    
    if([status in_reply_to_status_id] != nil) {
        HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
        [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]getStatus:[status in_reply_to_status_id] withStatuses:@[status]
                                                                         withCompletion:^(id data, BOOL success, NSError *error) {
                                                                             LOG_DEEBUG(0, @"%@", data);
                                                                             if(success == YES && error == nil && data != nil) {
                                                                                 NSMutableArray *replies = [NSMutableArray new];
                                                                                 if([data isKindOfClass:[NSArray class]]) {
                                                                                     NSArray *r = (NSArray *)data;
                                                                                     //NSEnumerator *e = [r reverseObjectEnumerator];
                                                                                     NSMutableArray *reverse = [[r reverse]mutableCopy];
                                                                                     [reverse removeLastObject];
                                                                                     [reverse enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                                                         if([obj isKindOfClass:[HuTwitterStatus class]]) {
                                                                                             HuTwitterStatus *reply = (HuTwitterStatus*)obj;
                                                                                             [replies addObject:@{@"user": [reply serviceUsername], @"text" : [reply statusText]}];
                                                                                         }
                                                                                         
                                                                                     }];
                                                                                     [reuse setTwitterReplies:replies];
                                                                                     
                                                                                 }
                                                                             }
                                                                         }];
    }
    
    //[statusViews addObject:v];
    dispatch_async(dispatch_get_main_queue(), ^{
        [reuse setNeedsDisplay];
        
    });
    return reuse;
}

- (StatusView *)resetForInstagram:(StatusView *)reuse forStatus:(InstagramStatus*)status
{
    [reuse resetupView];
    ColorPalette *palette = [ColorPalette instaFall];
    [reuse applyColorPalette:palette];
    [reuse setNameViewColor:[UIColor Instagram]];
    [reuse setupInstagramWithStatus:status fromViewController:self];
    [[reuse scrollView]setBounces:YES];
    [reuse scrollToStatusTop];
    [reuse setName:[status serviceUsername]];
    [reuse setDate:[status dateForSorting]];
    if([status location] != nil) {
        InstagramLocation *location = [status location];
        if([location name] == nil) {
            // defer a reverse geocode to the view, which is weird..
            CLLocation *cl_location = [[CLLocation alloc]initWithLatitude:[[location latitude]doubleValue] longitude:[[location longitude]doubleValue]];
            [reuse setCLLocation:cl_location];
        } else {
            [reuse setLocation:[NSString stringWithFormat:@"%@", [location name]]];
        }
    }
    
    [reuse setOnDoubleTap:^(void) {
        NSLog(@"Double Tapped!");
        [[HuInstagramHTTPSessionManager sharedInstagramClient]like:status];
        
    }];
    
    [reuse setOnTapLikeButton:^(void) {
        [[HuInstagramHTTPSessionManager sharedInstagramClient]like:status];
        
    }];

    
    [reuse setOnTapBackButton:^(){
        LOG_UI(0, @"Back On Tap");
        [carousel scrollToItemAtIndex:0 duration:0.5];
        [self performBlock:^{
            [[self navigationController]popViewControllerAnimated:YES];
        } afterDelay:0.6];
        
    }];
    
    //[statusViews addObject:v];
    dispatch_async(dispatch_get_main_queue(), ^{
        [reuse setNeedsDisplay];
        
    });
    return reuse;

}

- (StatusView *)viewForStatus:(id)status
{
    StatusView *result = [StatusView new];
    // INSTAGRAM
    if([status isKindOfClass:[InstagramStatus class]]) {
        InstagramStatus *s = (InstagramStatus *)status;
        StatusView *v = [[StatusView alloc]initWithFrame:self.carousel.frame];
        result = [self resetForInstagram:v forStatus:s];
        /*
        ColorPalette *palette = [ColorPalette instaFall];
        [v applyColorPalette:palette];
        [v setNameViewColor:[UIColor Instagram]];
        [v setupInstagramWithStatus:s fromViewController:self];
        [[v scrollView]setBounces:YES];
        [v scrollToStatusTop];
        [v setName:[s serviceUsername]];
        [v setDate:[s dateForSorting]];
        if([s location] != nil) {
            InstagramLocation *location = [s location];
            if([location name] == nil) {
                // defer a reverse geocode to the view, which is weird..
                CLLocation *cl_location = [[CLLocation alloc]initWithLatitude:[[location latitude]doubleValue] longitude:[[location longitude]doubleValue]];
                [v setCLLocation:cl_location];
            } else {
                [v setLocation:[NSString stringWithFormat:@"%@", [location name]]];
            }
        }
        [v setOnTapBackButton:^(){
            LOG_UI(0, @"Back On Tap");
            [carousel scrollToItemAtIndex:0 duration:0.5];
            [self performBlock:^{
                [[self navigationController]popViewControllerAnimated:YES];
            } afterDelay:0.6];
            
        }];
        
        //[statusViews addObject:v];
        dispatch_async(dispatch_get_main_queue(), ^{
            [v setNeedsDisplay];
            
        });
        result = v;
        */
    }
    
    // TWITTER
    if([status isKindOfClass:[HuTwitterStatus class]]) {
        HuTwitterStatus *s = (HuTwitterStatus*)status;
        StatusView *v = [[StatusView alloc]initWithFrame:self.carousel.frame];
        result = [self resetForTwitter:v forStatus:s];
        /*
        ColorPalette *palette = [ColorPalette seaAndSky];
        [v applyColorPalette:palette];
        [v setNameViewColor:[UIColor Twitter]];
        [v setupTwitterWithStatus:s fromViewController:self];
        [v setOnDoubleTap:^(void) {
            NSLog(@"Double Tapped!");
            HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
            [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]like:status];
            
        }];
        
        [v setOnTapLikeButton:^(void) {
            HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
            [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]like:status];
            
        }];
        //                [v setupTwitterWithStatus:[s statusText] imageURL:[status statusImageURL] hasImage:YES inReplyTo:nil];
        
        [[v scrollView]setBounces:YES];
        [v scrollToStatusTop];
        // NSLog(@"%@", dateInLocalTimezone);
        
        [v setName:[s serviceUsername]];
        [v setDate:[s dateForSorting]];
        if([s place] != nil) {
            HuTwitterPlace *place = [s place];
            [v setLocation:[NSString stringWithFormat:@"%@ %@", [place full_name], [place country_code]]];
        }
        
        [v setOnTapBackButton:^(){
            LOG_UI(0, @"Back On Tap");
            [carousel scrollToItemAtIndex:0 duration:0.5];
            [self performBlock:^{
                [[self navigationController]popViewControllerAnimated:YES];
            } afterDelay:0.6];
            
        }];
        
        if([status in_reply_to_status_id] != nil) {
            HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
            [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]getStatus:[status in_reply_to_status_id] withStatuses:@[status]
                                                                             withCompletion:^(id data, BOOL success, NSError *error) {
                                                                                 LOG_DEEBUG(0, @"%@", data);
                                                                                 if(success == YES && error == nil && data != nil) {
                                                                                     NSMutableArray *replies = [NSMutableArray new];
                                                                                     if([data isKindOfClass:[NSArray class]]) {
                                                                                         NSArray *r = (NSArray *)data;
                                                                                         //NSEnumerator *e = [r reverseObjectEnumerator];
                                                                                         NSMutableArray *reverse = [[r reverse]mutableCopy];
                                                                                         [reverse removeLastObject];
                                                                                         [reverse enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                                                             if([obj isKindOfClass:[HuTwitterStatus class]]) {
                                                                                                 HuTwitterStatus *reply = (HuTwitterStatus*)obj;
                                                                                                 [replies addObject:@{@"user": [reply serviceUsername], @"text" : [reply statusText]}];
                                                                                             }
                                                                                             
                                                                                         }];
                                                                                         [v setTwitterReplies:replies];
                                                                                         
                                                                                     }
                                                                                 }
                                                                             }];
        }
        
        //[statusViews addObject:v];
        dispatch_async(dispatch_get_main_queue(), ^{
            [v setNeedsDisplay];
            
        });
        result = v;
         */
    }
    
    // FLICKR
    if([status isKindOfClass:[HuFlickrStatus class]]) {
        HuFlickrStatus *s = (HuFlickrStatus *)status;
        StatusView *v = [[StatusView alloc]initWithFrame:self.carousel.frame];
        result = [self resetForFlickr:v forStatus:s];
        /*
        ColorPalette *palette = [ColorPalette melonBallSurprise];
        [v applyColorPalette:palette];
        [v setNameViewColor:[UIColor FlickrBlue]];
        [v setupFlickrWithStatus:status fromViewController:self];
        [[v scrollView]setBounces:YES];
        [v scrollToStatusTop];
        [v setName:[s serviceUsername]];
        [v setDate:[s dateForSorting]];
        // Location
//        if([s location] != nil) {
//            InstagramLocation *location = [s location];
//            if([location name] == nil) {
//                // defer a reverse geocode to the view, which is weird..
//                CLLocation *cl_location = [[CLLocation alloc]initWithLatitude:[[location latitude]doubleValue] longitude:[[location longitude]doubleValue]];
//                [v setCLLocation:cl_location];
//            } else {
//                [v setLocation:[NSString stringWithFormat:@"%@", [location name]]];
//            }
//        }
        [v setOnTapBackButton:^(){
            LOG_UI(0, @"Back On Tap");
            [carousel scrollToItemAtIndex:0 duration:0.5];
            [self performBlock:^{
                [[self navigationController]popViewControllerAnimated:YES];
            } afterDelay:0.6];
            
        }];
        
        //[statusViews addObject:v];
        dispatch_async(dispatch_get_main_queue(), ^{
            [v setNeedsDisplay];
            
        });
        result = v;
         */
    }
    return result;
}

// we get here when the view loads or from somewhere else
/*
- (void)buildViewsForStatus
{
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id status = [items objectAtIndex:idx];
        
        // INSTAGRAM
        if([status isKindOfClass:[InstagramStatus class]]) {
            InstagramStatus *s = (InstagramStatus *)status;
            StatusView *v = [[StatusView alloc]initWithFrame:self.carousel.frame];
            ColorPalette *palette = [ColorPalette instaFall];
            [v applyColorPalette:palette];
            [v setNameViewColor:[UIColor Instagram]];
            [v setupInstagramWithStatus:s fromViewController:self];
            [[v scrollView]setBounces:YES];
            [v scrollToStatusTop];
            [v setName:[s serviceUsername]];
            [v setDate:[s dateForSorting]];
            if([s location] != nil) {
                InstagramLocation *location = [s location];
                if([location name] == nil) {
                    // defer a reverse geocode to the view, which is weird..
                    CLLocation *cl_location = [[CLLocation alloc]initWithLatitude:[[location latitude]doubleValue] longitude:[[location longitude]doubleValue]];
                    [v setCLLocation:cl_location];
                } else {
                    [v setLocation:[NSString stringWithFormat:@"%@", [location name]]];
                }
            }
            [v setOnTapBackButton:^(){
                LOG_UI(0, @"Back On Tap");
                [carousel scrollToItemAtIndex:0 duration:0.5];
                [self performBlock:^{
                    [[self navigationController]popViewControllerAnimated:YES];
                } afterDelay:0.6];
                
            }];
            
            [statusViews addObject:v];
            dispatch_async(dispatch_get_main_queue(), ^{
                [v setNeedsDisplay];
                
            });
        }
        
        // TWITTER
        if([status isKindOfClass:[HuTwitterStatus class]]) {
            HuTwitterStatus *s = (HuTwitterStatus*)status;
            StatusView *v = [[StatusView alloc]initWithFrame:self.carousel.frame];
            ColorPalette *palette = [ColorPalette seaAndSky];
            [v applyColorPalette:palette];
            [v setNameViewColor:[UIColor Twitter]];
            [v setupTwitterWithStatus:s fromViewController:self];
            [v setOnDoubleTap:^(void) {
                NSLog(@"Double Tapped!");
                HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
                [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]like:status];
                
            }];
            
            [v setOnTapLikeButton:^(void) {
                HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
                [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]like:status];
                
            }];
            //                [v setupTwitterWithStatus:[s statusText] imageURL:[status statusImageURL] hasImage:YES inReplyTo:nil];
            
            [[v scrollView]setBounces:YES];
            [v scrollToStatusTop];
            // NSLog(@"%@", dateInLocalTimezone);
            
            [v setName:[s serviceUsername]];
            [v setDate:[s dateForSorting]];
            if([s place] != nil) {
                HuTwitterPlace *place = [s place];
                [v setLocation:[NSString stringWithFormat:@"%@ %@", [place full_name], [place country_code]]];
            }
            
            [v setOnTapBackButton:^(){
                LOG_UI(0, @"Back On Tap");
                [carousel scrollToItemAtIndex:0 duration:0.5];
                [self performBlock:^{
                    [[self navigationController]popViewControllerAnimated:YES];
                } afterDelay:0.6];
                
            }];
            
            if([status in_reply_to_status_id] != nil) {
                HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
                [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]getStatus:[status in_reply_to_status_id] withStatuses:@[status]
                                                                                 withCompletion:^(id data, BOOL success, NSError *error) {
                                                                                     LOG_DEEBUG(0, @"%@", data);
                                                                                     if(success == YES && error == nil && data != nil) {
                                                                                         NSMutableArray *replies = [NSMutableArray new];
                                                                                         if([data isKindOfClass:[NSArray class]]) {
                                                                                             NSArray *r = (NSArray *)data;
                                                                                             //NSEnumerator *e = [r reverseObjectEnumerator];
                                                                                             NSMutableArray *reverse = [[r reverse]mutableCopy];
                                                                                             [reverse removeLastObject];
                                                                                             [reverse enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                                                                 if([obj isKindOfClass:[HuTwitterStatus class]]) {
                                                                                                     HuTwitterStatus *reply = (HuTwitterStatus*)obj;
                                                                                                     [replies addObject:@{@"user": [reply serviceUsername], @"text" : [reply statusText]}];
                                                                                                 }
                                                                                                 
                                                                                             }];
                                                                                             [v setTwitterReplies:replies];

                                                                                         }
                                                                                     }
                                                                                 }];
            }
            
            [statusViews addObject:v];
            dispatch_async(dispatch_get_main_queue(), ^{
                [v setNeedsDisplay];
                
            });
            
        }
        
        if([status isKindOfClass:[HuFlickrStatus class]]) {
            
            HuViewForServiceStatus *result = HuViewForServiceStatus.new;
            result = [[HuViewForServiceStatus alloc]initWithFrame:self.carousel.frame forStatus:[items objectAtIndex:idx] with:self];
            
            [result setOnTapBackButton:^(){
                LOG_UI(0, @"Back On Tap");
                [carousel scrollToItemAtIndex:0 duration:0.5];
                [self performBlock:^{
                    [[self navigationController]popViewControllerAnimated:YES];
                } afterDelay:0.6];
                
            }];
            if(idx < 10) {
                [result showOrRefreshPhoto];
            }
            [statusViews addObject:result];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [result setNeedsDisplay];
                
            });
        }
    }];
    
    
}
*/
 
- (void)trackOpenTime
{
    // track last time we looked here
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *lastPeeks = [[defaults objectForKey:@"lastPeeks"]mutableCopy];;
    NSNumber *time = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] * 1000L];
    [lastPeeks setValue:time forKey:[human humanid]];
    [defaults setObject:lastPeeks forKey:@"lastPeeks"];
    [defaults setObject:lastPeeks forKey:@"hello"];
    [defaults synchronize];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self trackOpenTime];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

// TODO Figure out how to tell *why the view disappeared
// If it disappears just cause the IDMPhotoBrowser appears, we do
// not need to delete all these things and clean up

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //    [items each:^(id object) {
    //        object = [NSNull null];
    //    }];
    //    [statusViews each:^(id object) {
    //        object = [NSNull null];
    //    }];
    //    [items removeAllObjects];
    //    [statusViews removeAllObjects];
}

- (void)onSwipeNameLabel:(id)gesture
{
    //LOG_UI(0, @"Swiped gesture=%@", gesture);
    //[carousel st]
    [carousel scrollToItemAtIndex:0 duration:0.5];
    [self performBlock:^{
        [[self navigationController]popViewControllerAnimated:YES];
    } afterDelay:0.6];
    
}


#pragma mark iCarouselDelegate methods

//- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
//    LOG_UI(0, @"Did select Item at Index %ld", index );
//}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    CGFloat result = self.view.frame.size.width;
    return result;
}



- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    if (offset > 0)
    {
        //move back
        transform = CATransform3DTranslate(transform, 0, 0, -50 * offset);
    }
    else
    {
        //flip around
        transform = CATransform3DTranslate(transform, 250 * sin(MIN(1, -offset) * M_PI), 0, 100 * offset);
    }
    return transform;
}


- (BOOL) isScrollingLater
{
    if(last_index > current_index) {
        return YES;
    } else {
        return NO;
    }
}


NSUInteger last_index, current_index;

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)mcarousel
{

    current_index = [mcarousel currentItemIndex];
    
    /**
    for(NSUInteger i=current_index; i<[carousel numberOfItems] && i < current_index + 3; i++) {
        id obj = [statusViews objectAtIndex:i];
        if([obj respondsToSelector:@selector(showOrRefreshPhoto)]) {
            [[statusViews objectAtIndex:i]showOrRefreshPhoto];
        }
    }
    
    if([[items objectAtIndex:current_index] isKindOfClass:[UIView class]] == YES) {
        [header setAlpha:0];
    } else {
        if(header.alpha == 0.0) {
            [UIView animateWithDuration:0.75f animations:^{
                //
                header.alpha = 1.0;
            }];
        }
        
        [header setStatus:[items objectAtIndex:current_index]];
        
    }
    **/
    last_index = [mcarousel currentItemIndex];
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    // we'll load images well in advance this way, i think
    // cause of - carousel:(iCarousel *)mcarousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
    if(option == iCarouselOptionVisibleItems) {
        return VISIBLE_ITEMS_IN_CAROUSEL;
    }
    //    if(option == iCarouselOptionFadeMax) {
    //        return .3;
    //    }
    //    if(option == iCarouselOptionFadeMin) {
    //        return -.8;
    //    }
    //    if(option == iCarouselOptionFadeRange) {
    //        return 0.85;
    //    }
    else {
        return value;
    }
}



#pragma mark iCarouselDataSource methods
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [items count];
}


- (void)carouselWillBeginScrollingAnimation:(iCarousel *)aCarousel
{
    if([aCarousel currentItemIndex] > -1) {
        
        if([[aCarousel itemViewAtIndex:[aCarousel currentItemIndex]] isKindOfClass:[HuViewForServiceStatus class]] == YES) {
            HuViewForServiceStatus *view = (HuViewForServiceStatus *)[aCarousel itemViewAtIndex:[aCarousel currentItemIndex]];
            [view showOrRefreshPhoto];
        }
    }
}


- (UIView *)carousel:(iCarousel *)mcarousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    id obj = [items objectAtIndex:index];
    if(view != nil && [view isKindOfClass:[StatusView class]]) {
        StatusView *s = (StatusView*)view;
        //[s resetupView];
        if([obj isKindOfClass:[HuTwitterStatus class]]) {
            s = [self resetForTwitter:(StatusView*)view forStatus:obj];
            //[s setupTwitterWithStatus:obj fromViewController:self];
        }
        if([obj isKindOfClass:[HuFlickrStatus class]]) {
            s = [self resetForFlickr:(StatusView*)view forStatus:obj];
            //[s setupFlickrWithStatus:obj fromViewController:self];

        }
        if([obj isKindOfClass:[InstagramStatus class]]) {
            s = [self resetForInstagram:(StatusView*)view forStatus:obj];
            //[s setupInstagramWithStatus:obj fromViewController:self];
        }
        return s;
    } else {
    
    return [self viewForStatus:obj];
    }
}


//- (UIView *)carousel:(iCarousel *)mcarousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
//{
//    
//    if(view != nil) {
//        LOG_TODO(0, @"How do you reuse a view? %@", view);
//    }
//    //    NSAssert(statusViews != nil, @"StatusViews is nil?");
//    //    NSAssert([statusViews count] < index, @"Index is out of bounds??");
//    // woops..this shouldn't happen at all, but it seems to and then causes a crash
//    if(statusViews == nil || [statusViews count] < index) {
//        NSDictionary *dimensions = @{@"error": [NSString stringWithFormat:@"statusViews=%@ index=%ld", statusViews, (unsigned long)index]};
//        [[LELog sharedInstance]log:dimensions];
//        LOG_ERROR(1, @"Weird %@", dimensions);
//        [[self navigationController]popViewControllerAnimated:YES];
//        [HuAppDelegate popBadToastNotification:@"Woops." withSubnotice:[dimensions description] ];
//    }
//    
//    return [statusViews objectAtIndex:index];
//    
//}



- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}



#pragma mark ==========================



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [HuAppDelegate popBadToastNotification:@"Memories" withSubnotice:@"Too Much Pressure"];
    
    // Dispose of any resources that can be recreated.
    //        [items each:^(id object) {
    //            object = [NSNull null];
    //        }];
    //        [statusViews each:^(id object) {
    //            object = [NSNull null];
    //        }];
    //        [items removeAllObjects];
    //        [statusViews removeAllObjects];
}



#pragma mark HuViewControllerForStatusDelegate methods
// these get used when the HuViewForServiceStatus (Twitter, Instagram, Flickr, etc.) need to do something
// more at the ViewController level. Delegate-y. PITA.
MZFormSheetController *webViewFormSheet;

- (void)popWebViewFor:(NSURL *)url over:(UIView *)view
{
    LOG_UI(0, @"You must've done something %@", url);
    
    //CGRect rect = [view frame];
    CGSize size = [view size];
    
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:2.0];
    
    
    UIWebView *webView = [HuAppDelegate sharedWebView:url];
    
    
    UIViewController *webViewController = [[UIViewController alloc]init];
    [webViewController setView:webView];
    
    //if(webViewFormSheet == nil) {
    webViewFormSheet = [[MZFormSheetController alloc] initWithViewController:webViewController];
    //}
    __block MZFormSheetController *bformWebViewFormSheet = webViewFormSheet;
    [webViewFormSheet setCornerRadius:3.0f];
    webViewFormSheet.presentedFormSheetSize = CGSizeMake(size.width-10, size.height-90);
    webViewFormSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
    webViewFormSheet.shadowRadius = 4.0;
    webViewFormSheet.shadowOpacity = 0.5;
    webViewFormSheet.shouldDismissOnBackgroundViewTap = YES;
    webViewFormSheet.shouldCenterVertically = YES;
    webViewFormSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    webViewFormSheet.didPresentCompletionHandler = ^(UIViewController *presentedFromViewController) {
        LOG_UI(0, @"%@", presentedFromViewController);
    };
    
    webViewFormSheet.didDismissCompletionHandler = ^(UIViewController *dismissedFromViewController) {
        LOG_UI(0, @"%@", dismissedFromViewController);
        [MRProgressOverlayView dismissAllOverlaysForView:bformWebViewFormSheet.view animated:YES];
    };
    
    [webView setDelegate:self];
    
    [self mz_presentFormSheetController:webViewFormSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
    
}

#pragma mark UIWebViewDelegate methods
//only used here to enable or disable the back and forward buttons
- (void)webViewDidStartLoad:(UIWebView *)thisWebView
{
    if([MRProgressOverlayView overlayForView:thisWebView] == nil) {
        
        MRProgressOverlayView *overlay = [MRProgressOverlayView showOverlayAddedTo:thisWebView title:@"Loading" mode:MRProgressOverlayViewModeIndeterminate animated:YES stopBlock:^(MRProgressOverlayView *progressOverlayView) {
            //
            LOG_UI(0, @"%@", progressOverlayView);
            //[MRProgressOverlayView dismissAllOverlaysForView:webViewFormSheet.view animated:YES];
            //        [webViewFormSheet dismissAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
            //            //
            //        }];
            
        }];
        overlay.stopBlock = ^(MRProgressOverlayView *progressOverlayView) {
            [MRProgressOverlayView dismissAllOverlaysForView:thisWebView animated:YES];
        };
        
    } else {
        [MRProgressOverlayView dismissAllOverlaysForView:thisWebView animated:NO];
    }
	//back.enabled = NO;
	//forward.enabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)thisWebView
{
    
	//stop the activity indicator when done loading
    [MRProgressOverlayView dismissAllOverlaysForView:thisWebView animated:YES];
    
    //canGoBack and canGoForward are properties which indicate if there is
    //any forward or backward history
    //	if(thisWebView.canGoBack == YES)
    //	{
    //		back.enabled = YES;
    //		back.highlighted = YES;
    //	}
    //	if(thisWebView.canGoForward == YES)
    //	{
    //		forward.enabled = YES;
    //		forward.highlighted = YES;
    //	}
	
}


@end
