//
//  HuHumansProfileCarouselViewController.m
//  humans
//
//  Created by Julian Bleecker on 2/13/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuHumansProfileCarouselViewController.h"
#import <UIView+MCLayout.h>
#import "Flurry.h"
#import <BlocksKit+UIKit.h>
#import "MSWeakTimer.h"
#import <REMenu.h>
#import <IonIcons.h>

@interface HuHumanProfileView : UIView
{
    TYMActivityIndicatorView *waitOnStatusActivityIndicatorView;
    HuStatusCarouselViewController *statusCarouselViewController;
    HuHumansProfileCarouselViewController *parentViewController;
    MRProgressOverlayView *activityIndicatorView;
    UIView *containerView;
    
}

- (void)editHuman;

@property HuHuman *human;
@property HuUserHandler *userHandler;
@property UILabel *nameLabel;
@property UILabel *countLabel;
@property UILabel *instagramCountLabel, *flickrCountLabel, *twitterCountLabel, *foursquareCountLabel;
@property NSNumber *count;

@end

@implementation HuHumanProfileView
@synthesize human;
@synthesize userHandler;
@synthesize nameLabel;
@synthesize countLabel, instagramCountLabel, flickrCountLabel, twitterCountLabel, foursquareCountLabel;
@synthesize count;


- (id)initWithFrame:(CGRect)frame human:(HuHuman *)aHuman parent:(HuHumansProfileCarouselViewController *)aParent
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setHuman:aHuman];
        parentViewController = aParent;
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)commonInit
{
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    userHandler = [delegate humansAppUser];
    
    self.count = [NSNumber numberWithInt:0];
    
    CGFloat width = self.frame.size.width/6;
    
    NSArray *s = [human serviceUsers];
    
    containerView = [[UIView alloc]initWithFrame:self.frame];
    [containerView setBackgroundColor:[UIColor whiteColor]];
    
    [self addSubview:containerView];
    
    UIView *overlay = [[UIView alloc]init];
    [containerView addSubview:overlay];
    
    [overlay mc_setSize:CGSizeMake(containerView.bounds.size.width, containerView.bounds.size.height/6)];
    [overlay mc_setPosition:MCViewPositionTopHCenter inView:containerView withMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    [overlay setBackgroundColor:[UIColor Garmin]];
    
    nameLabel = [[UILabel alloc]initWithFrame:[overlay frame]];
    [overlay addSubview:nameLabel];
    [nameLabel setText:[human name]];
    [nameLabel setFont:PROFILE_VIEW_FONT_LARGE];
    [nameLabel setTextColor:PROFILE_VIEW_FONT_COLOR];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel mc_setRelativePosition:MCViewPositionCenters toView:overlay];
    
    CGFloat diam = overlay.size.height -8;
    
    countLabel = [[UILabel alloc]init];
    [countLabel setSize:CGSizeMake(diam+2, diam+2)];
    [containerView addSubview:countLabel];
    [countLabel setFont:COUNT_LABEL_FONT];
    [countLabel setTextColor:[UIColor darkGrayColor]];
    [countLabel setBackgroundColor:[UIColor whiteColor]];
    [countLabel setTextAlignment:NSTextAlignmentCenter];
    [countLabel mc_setRelativePosition:MCViewPositionRight toView:overlay withMargins:UIEdgeInsetsMake(0, 0, 0, 4)];
    [countLabel mc_setRelativePosition:MCViewPositionVerticalCenter toView:overlay];
    [countLabel.layer setCornerRadius:(diam+2)/2];
    [countLabel.layer setMasksToBounds:YES];
    [countLabel.layer setBorderColor:[[UIColor crayolaNeonCarrotColor]CGColor]];
    [countLabel.layer setBorderWidth:3];
    
    
    instagramCountLabel = [[UILabel alloc]init];
    [instagramCountLabel setSize:CGSizeMake(diam, diam)];
    [containerView addSubview:instagramCountLabel];
    [instagramCountLabel setFont:COUNT_LABEL_FONT];
    [instagramCountLabel setTextColor:[UIColor whiteColor]];
    [instagramCountLabel setBackgroundColor:INSTAGRAM_COLOR];
    [instagramCountLabel setTextAlignment:NSTextAlignmentCenter];
    [instagramCountLabel mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:countLabel withMargins:UIEdgeInsetsMake(6, 0, 0, 0)];
    [instagramCountLabel.layer setCornerRadius:diam/2];
    [instagramCountLabel.layer setMasksToBounds:YES];
    
    flickrCountLabel = [[UILabel alloc]init];
    [flickrCountLabel setSize:CGSizeMake(diam+3, diam+3)];
    [containerView addSubview:flickrCountLabel];
    [flickrCountLabel setFont:COUNT_LABEL_FONT];
    [flickrCountLabel setTextColor:[UIColor whiteColor]];
    [flickrCountLabel setBackgroundColor:[UIColor FlickrPink]];
    [flickrCountLabel setTextAlignment:NSTextAlignmentCenter];
    [flickrCountLabel mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:instagramCountLabel withMargins:UIEdgeInsetsMake(6, 0, 0, 0)];
    [flickrCountLabel.layer setCornerRadius:(diam+3)/2];
    [flickrCountLabel.layer setMasksToBounds:YES];

    
    twitterCountLabel = [[UILabel alloc]init];
    [twitterCountLabel setSize:CGSizeMake(diam, diam)];
    [containerView addSubview:twitterCountLabel];
    [twitterCountLabel setFont:COUNT_LABEL_FONT];
    [twitterCountLabel setTextColor:[UIColor whiteColor]];
    [twitterCountLabel setBackgroundColor:TWITTER_COLOR];
    [twitterCountLabel setTextAlignment:NSTextAlignmentCenter];
    [twitterCountLabel mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:flickrCountLabel withMargins:UIEdgeInsetsMake(6, 0, 0, 0)];
    [twitterCountLabel.layer setCornerRadius:diam/2];
    [twitterCountLabel.layer setMasksToBounds:YES];
    
    foursquareCountLabel = [[UILabel alloc]init];
    [foursquareCountLabel setSize:CGSizeMake(diam, diam)];
    [containerView addSubview:foursquareCountLabel];
    [foursquareCountLabel setFont:COUNT_LABEL_FONT];
    [foursquareCountLabel setTextColor:[UIColor whiteColor]];
    [foursquareCountLabel setBackgroundColor:FOURSQUARE_COLOR];
    [foursquareCountLabel setTextAlignment:NSTextAlignmentCenter];
    [foursquareCountLabel mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:twitterCountLabel withMargins:UIEdgeInsetsMake(6, 0, 0, 0)];
    [foursquareCountLabel.layer setCornerRadius:diam/2];
    [foursquareCountLabel.layer setMasksToBounds:YES];
    
    
    
    
    waitOnStatusActivityIndicatorView = [[TYMActivityIndicatorView alloc] initWithActivityIndicatorStyle:TYMActivityIndicatorViewStyleNormal];
    NSUInteger r = arc4random_uniform(2);
    [waitOnStatusActivityIndicatorView setFullRotationDuration:3+r];
    [waitOnStatusActivityIndicatorView setSize:[countLabel size]];
    [waitOnStatusActivityIndicatorView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [waitOnStatusActivityIndicatorView setOpaque:NO];
    [waitOnStatusActivityIndicatorView setBackgroundImage:[UIImage imageNamed:@"hublankbackground"]];
    [waitOnStatusActivityIndicatorView setIndicatorImage:[UIImage imageNamed:@"hugrayspinner"]];
    [waitOnStatusActivityIndicatorView setTintColor:[UIColor whiteColor]];
    [waitOnStatusActivityIndicatorView mc_setRelativePosition:MCViewPositionRight toView:overlay];
    [waitOnStatusActivityIndicatorView mc_setRelativePosition:MCViewPositionVerticalCenter toView:overlay];
    [waitOnStatusActivityIndicatorView setHidden:YES];
    
    [containerView addSubview:waitOnStatusActivityIndicatorView];
    
    [self bk_whenTapped:^{
        //
        activityIndicatorView = [MRProgressOverlayView showOverlayAddedTo:parentViewController.view animated:YES];
        activityIndicatorView.mode = MRProgressOverlayViewModeIndeterminate;
        activityIndicatorView.tintColor = [UIColor orangeColor];
        [self performBlock:^{
            //[noticeView dismiss:YES];
            
            [self showHuman];
        } afterDelay:0.25];
        
    }];
    
    UIView *profile_image_container = [[UIView alloc]init];
    [s enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //
        HuServiceUser *user = (HuServiceUser*)obj;
        
        UIImageView *profile_imgview = [[UIImageView alloc]initWithFrame:(CGRectMake((idx/2)*width, (idx%2)*width, width, width))];
        profile_imgview.layer.borderWidth = 0.5;
        profile_imgview.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        [profile_imgview setImageWithURL:[NSURL URLWithString:[user imageURL]] placeholderImage:[UIImage imageNamed:@"angry_unicorn_tiny.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            //
            if(image == nil) {
                LOG_ERROR(0, @"Couldn't download image %@", [user username]);
                LOG_ERROR(0, @"May mean that the user has changed their image and we don't have a fresh URL. We could initiate a refresh of the local user data, which only rarely gets updated serverside");
            }
        }];
        
        [profile_image_container addSubview:profile_imgview];
    }];
    [containerView addSubview:profile_image_container];
    [profile_image_container mc_setRelativePosition:MCViewRelativePositionUnderAlignedLeft toView:overlay];
    
    containerView.layer.cornerRadius = 0;
    
}



- (void)editHuman
{
    LOG_GENERAL(0, @"Would present %@", human);
    [Flurry logEvent:[NSString stringWithFormat:@"Trying to show human %@ (%@)", [human name], [human humanid]]];
    
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HuHumanProfileViewController *profileViewController = [storyBoard instantiateViewControllerWithIdentifier:@"HuHumanProfileViewController"];
    [profileViewController setHumansProfileCarouselViewController:parentViewController];
    [profileViewController setHuman:human];
    
    UINavigationController *root = (UINavigationController*)self.window.rootViewController;
    [root pushViewController:profileViewController animated:YES];
    
}

- (void)showHuman
{
    [parentViewController invalidateStatusRefreshTimer];
    
    HuAppDelegate *delegate =  [[UIApplication sharedApplication]delegate];
    HuUserHandler *user_handler = [delegate humansAppUser];
    
    [user_handler getStatusForHuman:human withCompletionHandler:^(BOOL success, NSError *error) {
        //
        [MRProgressOverlayView dismissAllOverlaysForView:parentViewController.view animated:YES];
        
        if(success) {
            LOG_GENERAL(0, @"Loaded Status for %@", human);
            [Flurry logEvent:[NSString stringWithFormat:@"Successfully loaded human %@", [human name]]];
            
            statusCarouselViewController = [[HuStatusCarouselViewController alloc]init];
            [statusCarouselViewController setHuman:human];
            
            NSMutableArray *items = [[user_handler statusForHuman:human]mutableCopy];
            
            [statusCarouselViewController setItems:items];
            
            [MRProgressOverlayView dismissAllOverlaysForView:parentViewController.view animated:YES];
            
            UINavigationController *nav = [parentViewController navigationController];
            [nav pushViewController:statusCarouselViewController animated:YES];
         
        } else {
            LOG_ERROR(0, @"Error loading status %@", error);
            [Flurry logEvent:[NSString stringWithFormat:@"Error loading human %@ %@", [human name], error]];
            [MRProgressOverlayView dismissAllOverlaysForView:parentViewController.view animated:NO];
            MRProgressOverlayView *noticeView = [MRProgressOverlayView showOverlayAddedTo:parentViewController.view animated:YES];
            noticeView.mode = MRProgressOverlayViewModeIndeterminateSmall;
            noticeView.titleLabelText = [NSString stringWithFormat:@"Problem loading %@", error];
            [self performBlock:^{
                [noticeView dismiss:YES];
            } afterDelay:2.0];
            
        }
        
    }];
}


- (void)turnOnStatusActivityIndicator
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //LOG_DEEBUG(0, @"Show Activity Indicator For %@ %@", [self.human name], waitOnStatusActivityIndicatorView);
        self.count = [NSNumber numberWithInt:0];
        [self.countLabel setHidden:YES];
        [self.flickrCountLabel setHidden:YES];
        [self.instagramCountLabel setHidden:YES];
        [self.twitterCountLabel setHidden:YES];
        [self.foursquareCountLabel setHidden:YES];
        
        
        [waitOnStatusActivityIndicatorView setHidden:NO];
        double val = ((double)arc4random() / ARC4RANDOM_MAX);
        double r = arc4random_uniform(3)*val;
        [self performBlock:^{
            [waitOnStatusActivityIndicatorView startAnimating];
        } afterDelay:1+r];
        [self setNeedsDisplay];
        [waitOnStatusActivityIndicatorView setNeedsDisplay];
    });
}

- (void)turnOffStatusActivityIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.countLabel setHidden:NO];
        [self.flickrCountLabel setHidden:NO];
        [self.foursquareCountLabel setHidden:NO];
        [self.instagramCountLabel setHidden:NO];
        [self.twitterCountLabel setHidden:NO];

        [waitOnStatusActivityIndicatorView setHidden:YES];
        [self setNeedsDisplay];
    });
    
}

- (void)refreshStats:(id)jsonStatsData
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    id period = nil;
    id cached = nil;
    if(jsonStatsData != nil) {
        period = [jsonStatsData objectForKey:[NSString stringWithFormat:@"%@_period", [self.human humanid]]];
        cached =[jsonStatsData objectForKey:[NSString stringWithFormat:@"%@_cache", [self.human humanid]]];
    }
    
    if(period != nil) {
        NSNumber *total =[period objectForKey:@"service.count.total"];
        int total_int = [total intValue];
        if(total_int < 1) {
            [self turnOnStatusActivityIndicator];
            return;
        } else {
            [self turnOffStatusActivityIndicator];
        }
        NSNumber *dur_days = [period objectForKey:@"duration.days"];
        NSNumber *dur_hours = [period objectForKey:@"duration.hours"];
        int dur_days_int = [dur_days intValue];
        int dur_hours_int = [dur_hours intValue];
        if(dur_days_int > 1) {
        NSString *time_total = [NSString stringWithFormat:@"%@d", dur_days];
        [self.countLabel setText:time_total];
        } else {
            NSString *time_total = [NSString stringWithFormat:@"%@h", dur_hours];
            [self.countLabel setText:time_total];
        }
        if([period objectForKey:@"service.flickr.count"] != nil) {
            NSString *_ppd = [formatter stringFromNumber:[period objectForKey:@"service.flickr.ppd"]];
            NSString *_pph =[period objectForKey:@"service.flickr.pph"];
            
            NSString *_total = [NSString stringWithFormat:@"%@", [period objectForKey:@"service.flickr.count"] ];
            [self.flickrCountLabel setText:_total];
        } else {
            [self.flickrCountLabel setText:@"0"];
        }
        
        if([period objectForKey:@"service.instagram.count"] != nil) {
            NSString *_ppd = [formatter stringFromNumber:[period objectForKey:@"service.instagram.ppd"]];
            NSString *_pph =[period objectForKey:@"service.instagram.pph"];
            
            NSString *_total = [NSString stringWithFormat:@"%@", [period objectForKey:@"service.instagram.count"] ];
            [self.instagramCountLabel setText:_total];
        } else {
            [self.instagramCountLabel setText:@"0"];
        }
        if([period objectForKey:@"service.twitter.count"] != nil) {
            NSString *_ppd = [formatter stringFromNumber:[period objectForKey:@"service.twitter.ppd"]];
            NSString *_pph =[period objectForKey:@"service.twitter.pph"];
            
            NSString *_total = [NSString stringWithFormat:@"%@", [period objectForKey:@"service.twitter.count"] ];
            [self.twitterCountLabel setText:_total];
        } else {
            [self.twitterCountLabel setText:@"0"];
        }
        
        if([period objectForKey:@"service.foursquare.count"] != nil) {
            NSString *_ppd = [formatter stringFromNumber:[period objectForKey:@"service.foursquare.ppd"]];
            NSString *_pph =[period objectForKey:@"service.foursquare.pph"];
            
            NSString *_total = [NSString stringWithFormat:@"%@", [period objectForKey:@"service.foursquare.count"] ];
            [self.foursquareCountLabel setText:_total];
        } else {
            [self.foursquareCountLabel setText:@"0"];
        }
   
        
        
    }
    
}
- (void)shouldMakeStatusLabel:(UILabel *)aLabel ringOn:(BOOL)on
{
    if(on) {
    [aLabel.layer setBorderColor:[[UIColor crayolaNeonCarrotColor]CGColor]];
    [aLabel.layer setBorderWidth:3];
    } else {
        [aLabel.layer setBorderColor:[aLabel.backgroundColor CGColor]];
        [aLabel.layer setBorderWidth:0];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [aLabel setNeedsDisplay];
        [self setNeedsDisplay];
    });
}

-(void)statusSinceLast:(id)data
{
    //service.count.total
    if(data != nil) {
        NSString *key = [NSString stringWithFormat:@"%@_period", [human humanid]];
        if([data objectForKey:key] != nil) {
            id period = [data objectForKey:key];
            NSNumber *since_last_count = [period objectForKey:@"service.count.total"];
            int since_int = [since_last_count intValue];
            if(since_int > 0) {
                [self shouldMakeStatusLabel:countLabel ringOn:YES];
            } else {
                [self shouldMakeStatusLabel:countLabel ringOn:NO];
            }
        }
    }
}



- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end

#pragma mark ==================

@interface HuHumansProfileCarouselViewController () <iCarouselDataSource, iCarouselDelegate>
{
    
    
    HuUserHandler *userHandler;
    iCarousel *carousel;
    NSMutableArray *arrayOfHumans;
    NSMutableArray *humans_views;
    MGLineStyled *header;
    MGLine *add_human;
    HuShowServicesViewController *showServicesViewController;
    MSWeakTimer *timerForStatusRefresh;
    dispatch_queue_t privateQueue;
    CGRect full_sized, half_sized;
    REMenu *mainMenu;
    tViewType viewType;
}
@end

@implementation HuHumansProfileCarouselViewController

@synthesize indexToShow;
@synthesize humanHasEdited;


static const char *HuHumansScrollViewControllerTimerQueueContext = "HuHumansProfileCarouselViewControllerTimerQueueContext";



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
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    userHandler = [delegate humansAppUser];
    arrayOfHumans = [NSMutableArray arrayWithArray:[[userHandler humans_user]humans]];
    humans_views = [[NSMutableArray alloc]init];
    
    viewType = kHalfHeightScrollView;
    indexToShow = 0;
    
    // do it once now
    [self updateHumanProfileViewsStatusCounts];
    //and queue to do it every 2 minutes as well..
    privateQueue = dispatch_queue_create("com.nearfuturelaboratory.private_queue", DISPATCH_QUEUE_CONCURRENT);
    
    timerForStatusRefresh = [MSWeakTimer scheduledTimerWithTimeInterval:120
                                                                 target:self
                                                               selector:@selector(updateHumanProfileViewsStatusCounts)
                                                               userInfo:nil
                                                                repeats:YES
                                                          dispatchQueue:privateQueue];
    
    
    dispatch_queue_set_specific(privateQueue, (__bridge const void *)(self), (void *)HuHumansScrollViewControllerTimerQueueContext, NULL);
    
}

- (void)updateHumanProfileViewsStatusCounts
{
    //__block HuHumanProfileView *bself = self;
    [userHandler getStatusCountsWithCompletionHandler:^(id data, BOOL success, NSError *error) {
        if(success) {
            // handle counts
            __block BOOL containsEmptyStatus = NO;
            [humans_views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                HuHumanProfileView *humanProfileView = (HuHumanProfileView *)obj;
                HuHuman *human = [humanProfileView human];
                [humanProfileView refreshStats:data];
                NSTimeInterval last = [userHandler lastPeekTimeFor:human];

                [userHandler getStatusCountForHuman:human after:last withCompletionHandler:^(id data, BOOL success, NSError *error) {
                    //
                    if(success) {
                        //service.count.total
                        [humanProfileView statusSinceLast:data];
                    } else {
                        
                    }
                }];
                
                
                
                NSNumber *c = [data objectForKey:[human humanid]];
                if([c intValue] < 1) {
                    containsEmptyStatus = YES;
                }
                
            }];
            if(containsEmptyStatus) {
                [self resetStatusRefreshTimer:60];
            } else {
                [self resetStatusRefreshTimer:240];
            }
        }
    }];
    
    
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarStyle )preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)invalidateStatusRefreshTimer
{
    [timerForStatusRefresh invalidate];
}

- (void)resetStatusRefreshTimer:(NSTimeInterval)refreshTime
{
    [self invalidateStatusRefreshTimer];
    timerForStatusRefresh = [MSWeakTimer scheduledTimerWithTimeInterval:refreshTime
                                                                 target:self
                                                               selector:@selector(updateHumanProfileViewsStatusCounts)
                                                               userInfo:nil
                                                                repeats:YES
                                                          dispatchQueue:privateQueue];
    
}

- (void)addHumanToView:(HuHuman *)human
{
    if([arrayOfHumans containsObject:human] == NO) {
        [arrayOfHumans addObject:human];
        if(viewType == kHalfHeightScrollView) {
            [humans_views addObject:[[HuHumanProfileView alloc]initWithFrame:half_sized human:human parent:self]];
            
        } else {
            [humans_views addObject:[[HuHumanProfileView alloc]initWithFrame:full_sized human:human parent:self]];
            
        }
    }
    
}

- (void)updateHumansForView
{
    [arrayOfHumans removeAllObjects];
    [humans_views removeAllObjects];
    NSArray *list_of_humans = [[userHandler humans_user]humans];
    [list_of_humans enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //
        HuHuman *human = (HuHuman*)obj;
        if([arrayOfHumans containsObject:human] == NO) {
            [self addHumanToView:human];
        }
    }];
    [carousel reloadData];
    [self updateHumanProfileViewsStatusCounts];
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timerForStatusRefresh invalidate];
    indexToShow = [carousel currentItemIndex];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateHumansForView];
    
    [carousel setCurrentItemIndex:indexToShow];
    
    LOG_UI(0, @"Here we have %ld humans", [arrayOfHumans count]);
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        [[[self.navigationController navigationBar]topItem] setTitle:@"Profile Carousel"];
        
    });
    
    if(timerForStatusRefresh != nil) {
        [timerForStatusRefresh invalidate];
    }
    timerForStatusRefresh = [MSWeakTimer scheduledTimerWithTimeInterval:240
                                                                 target:self
                                                               selector:@selector(updateHumanProfileViewsStatusCounts)
                                                               userInfo:nil
                                                                repeats:YES
                                                          dispatchQueue:privateQueue];
    ///[timerForStatusRefresh fire];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[[self.navigationController navigationBar]topItem] setTitle:@"Profile Carousel"];
    
    
    //[self.view setFrame:self.parentViewController.view.frame];
    CGFloat status_bar_height = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) // only for iOS 7 and above
    {
        CGRect frame = self.navigationController.view.frame;
        if(frame.origin.y == 0) {
            frame.origin.y += status_bar_height;
            frame.size.height -= status_bar_height;
            self.navigationController.view.frame = frame;
            self.navigationController.view.backgroundColor = [UIColor whiteColor];
            //[self.navigationController.view setNeedsDisplay];
            
        }
    }
    
    HuHumansProfileCarouselViewController *bself = self;
    
    UIImage *settings_bar_img = [UIImage imageNamed:@"settings-bars"];
    
    MGLine *settings_bar = [MGLine lineWithLeft:settings_bar_img right:nil size:[settings_bar_img size]];
    settings_bar.onTap = ^{
        if(mainMenu.isOpen == NO) {
            [mainMenu showFromRect:(CGRectMake(0, header.height, header.width, 400)) inView:carousel];
        } else {
            [mainMenu close];
        }
    };
    
    
    UIImage *add_human_img = [UIImage imageNamed:@"add-human-gray"];
    
    add_human = [MGLine lineWithLeft:add_human_img right:nil size:[add_human_img size]];
    add_human.onTap = ^{
        LOG_UI(0, @"Tapped Add Human Limit?");
        HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        //
        HuJediFindFriends_ViewController *jedi = [delegate jediFindFriendsViewController];
        [[bself navigationController]pushViewController:jedi animated:NO];
        
    };
    
    
#pragma mark header setup
    //header
    header = [MGLineStyled lineWithLeft:settings_bar right:add_human size:(CGSize){self.view.frame.size.width,HEADER_HEIGHT}];
    UIColor *color = [UIColor whiteColor];
    [header setBackgroundColor:color];
    
    [header setMiddleFont:HEADLINE_FONT];
    [header setMiddleTextColor:[UIColor darkGrayColor]];
    [header setMiddleItems:[NSMutableArray arrayWithObject:@"Humans"]];
    [header setMiddleItemsAlignment:NSTextAlignmentCenter];
    header.sidePrecedence = MGSidePrecedenceMiddle;
    header.padding = UIEdgeInsetsMake(4, 8, 4, 8);
    header.fixedPosition = (CGPoint){0,0};
    header.zIndex = 1;
    header.layer.cornerRadius = 0;
    header.layer.shadowOffset = CGSizeZero;
    header.onTap = ^{
        LOG_UI(0, @"Tapped Header");
        //nextState++;
    };
    __block MGLineStyled *bheader = header;
    header.onLongPress = ^{
        LOG_UI(0, @"Long Press Header..Esc to %@ %@", [bself presentingViewController], bheader.longPresser);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[bself navigationController]popViewControllerAnimated:YES];
            HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
            [[bself navigationController]setViewControllers:[delegate freshNavigationStack] animated:YES];
        });
        
    };
    
    
    __block UINavigationController *bnav = [self navigationController];
    REMenuItem *settingsItem = [[REMenuItem alloc] initWithTitle:@"Settings"
                                                           image:[UIImage imageNamed:@"add-cloud-gray"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              LOG_UI(0, @"Item: %@", item);
                                                              if(showServicesViewController == nil) {
                                                                  showServicesViewController = [[HuShowServicesViewController alloc]init];
                                                                  
                                                              }
                                                              [showServicesViewController setTitle:@"Foo"];
                                                              showServicesViewController.tapOnEx = ^{
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      [bnav popToViewController:bself animated:YES];
                                                                  });
                                                                  
                                                              };
                                                              
                                                              
                                                              [bnav pushViewController:showServicesViewController animated:YES];//setViewControllers:@[showServicesViewController] animated:NO];
                                                          }];
    
    
    
    
    //UIImage *beakerImage = [IonIcons imageWithIcon:@"icon_array_right_a" size:30.0f color:[UIColor blackColor]];
    
    
    REMenuItem *stuffsItem = [[REMenuItem alloc] initWithTitle:@"Stuff"
                                                         image:[UIImage imageNamed:@"Icon_Home"]
                                              highlightedImage:nil
                                                        action:^(REMenuItem *item) {
                                                            //LOG_UI(0, @"Item: %@", item);
                                                            //NSInteger index = [carousel currentItemIndex];
                                                            HuHumanProfileView *current = (HuHumanProfileView*)[carousel currentItemView];
                                                            [current editHuman];
                                                        }];
    
    REMenuItem *beakerItem = [[REMenuItem alloc] initWithTitle:@"Height"
                                                         image:[UIImage imageNamed:@"Icon_Home"]
                                              highlightedImage:nil
                                                        action:^(REMenuItem *item) {
                                                            LOG_UI(0, @"Item: %@", item);
                                                            if(viewType == kFullHeightScrollView) {
                                                                viewType = kHalfHeightScrollView;
                                                            } else {
                                                                viewType = kFullHeightScrollView;
                                                            }
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                //
                                                                [[self view]setNeedsLayout];
                                                            });
                                                            
                                                        }];
    
    
    UIView *customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor blueColor];
    customView.alpha = 0.4;
    REMenuItem *customViewItem = [[REMenuItem alloc] initWithCustomView:customView action:^(REMenuItem *item) {
        NSLog(@"Tap on customView");
    }];
    
    
    //mainMenu.imageOffset = CGSizeMake(5, -1);
    mainMenu.waitUntilAnimationIsComplete = NO;
    mainMenu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
        badgeLabel.backgroundColor = [UIColor Garmin];
        badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.000].CGColor;
    };
    
    settingsItem.badge = @"15";
    settingsItem.textColor = [UIColor blackColor];
    settingsItem.backgroundColor = [UIColor crayolaOuterSpaceColor];
    
    stuffsItem.badge = @"Yes";
    stuffsItem.textColor = [UIColor blackColor];
    stuffsItem.backgroundColor = [UIColor crayolaOuterSpaceColor];
    
    beakerItem.badge = @"No";
    beakerItem.textColor = [UIColor asbestosColor];
    beakerItem.backgroundColor = [UIColor crayolaOuterSpaceColor];
    
    mainMenu = [[REMenu alloc]initWithItems:@[settingsItem, stuffsItem, customViewItem, beakerItem]];
    [mainMenu setLiveBlur:YES];
    UIColor *d = [[UIColor crayolaOuterSpaceColor]darkerColor];
    [mainMenu setHighlightedBackgroundColor:d];
    mainMenu.borderWidth = 0.0;
    
    [mainMenu setCloseCompletionHandler:^{
        LOG_UI(0, @"Menu did close");
    }];
    
#pragma mark size the individual humans views based on the type of view we want
	// Do any additional setup after loading the view.
    full_sized = CGRectMake(0, header.bottom, self.view.frame.size.width, self.view.frame.size.height-header.bottom/*-status_bar_height*/);
    half_sized = CGRectMake(0, header.bottom, self.view.frame.size.width,  (full_sized.size.height)/2);
    
    
    //    [arrayOfHumans enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //
    //        CGRect sizeBasedOnType;
    //
    //        if(viewType == kHalfHeightScrollView) {
    //            sizeBasedOnType = half_sized;
    //        } else {
    //            sizeBasedOnType = full_sized;
    //        }
    //
    //        [humans_views addObject:[[HuHumanProfileView alloc]initWithFrame:sizeBasedOnType human:obj parent:self]];
    //
    //    }];
    
    
    carousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, full_sized.size.height)];
    //carousel = [[iCarousel alloc]initWithFrame:full_sized];
    
    [carousel setBackgroundColor:[UIColor whiteColor]];
    [carousel setType:iCarouselTypeCustom];
    [carousel setDataSource:self];
    [carousel setDelegate:self];
    [carousel setVertical:YES];
    [carousel setCenterItemWhenSelected:NO];
    
    
    [self.view addSubview:carousel];
    
    [self.view addSubview:header];
    [header layout];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    //[self.view addSubview:transparentForMenu];
    
    
    //[self.mainMenu showFromNavigationController:self.navigationController];
    
}

- (void)setHumansUserHandler:(HuUserHandler *)aUserHandler
{
    userHandler = aUserHandler;
}


/**
 - (void)__showHuman:(HuHuman *)human fromLine:(HuHumanProfileView *)line
 {
 [Flurry logEvent:[NSString stringWithFormat:@"Trying to show human %@ (%@)", [human name], [human humanid]]];
 
 HuAppDelegate *delegate =  [[UIApplication sharedApplication]delegate];
 HuUserHandler *user_handler = [delegate humansAppUser];
 [userHandler getStatusCountForHuman:human withCompletionHandler:^(id data, BOOL success, NSError *error) {
 int count = 0;
 if(success) {
 NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
 [f setNumberStyle:NSNumberFormatterDecimalStyle];
 count = [[f numberFromString:[data description]] intValue];
 
 }
 if(count <= 0) {
 [Flurry logEvent:[NSString stringWithFormat:@"Was going to load human=%@, but status is still baking..", [human name]]];
 
 MRProgressOverlayView *noticeView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
 noticeView.mode = MRProgressOverlayViewModeCross;
 noticeView.titleLabelText = [NSString stringWithFormat:@"Still baking the cake.."];
 [self performBlock:^{
 [noticeView dismiss:YES];
 [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
 } afterDelay:4.0];
 
 }
 
 if(success && count > 0) {
 [user_handler getStatusForHuman:human withCompletionHandler:^(BOOL success, NSError *error) {
 //
 if(success) {
 LOG_GENERAL(0, @"Loaded Status for %@", human);
 //[Flurry logEvent:[NSString stringWithFormat:@"Successfully loaded human %@", [human name]]];
 
 //NSString *human_id = [human humanid]    ;
 NSArray *status = [user_handler statusForHuman:human];
 LOG_GENERAL(0, @"Count is %d", [status count]);
 statusCarouselViewController = [[HuStatusCarouselViewController alloc]init];
 
 [statusCarouselViewController setItems:[[user_handler statusForHuman:human] copy]];
 
 //[self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
 
 [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
 
 [[self navigationController] pushViewController:statusCarouselViewController animated:YES];
 
 } else {
 LOG_ERROR(0, @"Error loading status %@", error);
 //[Flurry logEvent:[NSString stringWithFormat:@"Error loading human %@ %@", [human name], error]];
 [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:NO];
 MRProgressOverlayView *noticeView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
 noticeView.mode = MRProgressOverlayViewModeIndeterminateSmall;
 noticeView.titleLabelText = [NSString stringWithFormat:@"Problem loading %@", error];
 [self performBlock:^{
 [noticeView dismiss:YES];
 } afterDelay:2.0];
 
 }
 
 }];
 }
 }];
 }
 **/

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}



#pragma mark iCarouselDelegate methods

- (CATransform3D)carousel:(iCarousel *)mcarousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    // 1.01 for full sized
    // .51 for half sized
    CGFloat spacing;
    
    
    //= [self carousel:carousel valueForOption:iCarouselOptionSpacing withDefault:.51];
    CATransform3D result;
    //return CATransform3DTranslate(transform, 0.0f, (offset - .49) * (carousel.bounds.size.height) * spacing, 0.0f);
    //CATransform3D result = CATransform3DTranslate(transform, 0.0f, (offset - 0) * (carousel.bounds.size.height) * spacing, 0.0f);
    //    CATransform3D result =CATransform3DTranslate(transform, 0.0f, (offset - .24) * (carousel.bounds.size.height) * spacing, 0.0f);
    
    if(viewType == kHalfHeightScrollView) {
        spacing = [self carousel:carousel valueForOption:iCarouselOptionSpacing withDefault:.50];
        result = CATransform3DTranslate(transform, 0.0f, (offset - .50) * (carousel.bounds.size.height) * spacing, 0.0f);
    } else {
        spacing = [self carousel:carousel valueForOption:iCarouselOptionSpacing withDefault:1.01];
        result = CATransform3DTranslate(transform, 0.0f, (offset - 0) * (carousel.bounds.size.height) * spacing, 0.0f);
    }
    
    return result;
    
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    LOG_UI(0, @"Did select Item at Index %d", index );
}

//- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
//    CGFloat result = 100;//self.view.frame.size.width;
//    return result;
//}
//
//- (CGFloat)carouselItemHeight:(iCarousel *)carousel {
//    CGFloat result = self.view.frame.size.height;
//    return result;
//}


- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index
{
    return NO;
}

- (CGFloat)carousel:(iCarousel *)aCarousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            if([self numberOfItemsInCarousel:aCarousel] < 4) {
                return NO;
            } else {
                return YES;
            }
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.0f;
        }
        case iCarouselOptionFadeMax:
        {
            //            if (carousel.type == iCarouselTypeCustom)
            //            {
            //                //set opacity based on distance from camera
            //                return 0.0f;
            //            }
            return value;
        }
        case iCarouselOptionVisibleItems:
        {
            return 6;
            
        }
        default:
        {
            return value;
        }
    }
}

#pragma mark iCarouselDataSource delegate methods
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    NSUInteger result = [humans_views count];//[[[userHandler humans_user]humans]count];
    return result;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)aCarousel
{
    return 0;
    //    if ([self numberOfItemsInCarousel:aCarousel] < 4) {
    //        return 3;
    //    } else {
    //        return 0;
    //    }
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UIView *result;
    if(view == nil) {
        result = [[UIView alloc]initWithFrame:half_sized];
        [result setBackgroundColor:[UIColor whiteColor]];
    }
    return result;
}


-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //    UIView *foo = [[UIView alloc]initWithFrame:full_sized];
    //
    //    if(index % 2 == 0) {
    //    [foo setBackgroundColor:[UIColor tangerineColor]];
    //    } else {
    //        [foo setBackgroundColor:[UIColor Technorati]];
    //    }
    //    return foo;
    if([humans_views count] < 1) {
        return nil;
    }
    return [humans_views objectAtIndex:index];
    
    //    CGRect half = CGRectMake(0, 0, carousel.bounds.size.width, carousel.bounds.size.height/2);
    //
    //    HuHumanProfileView *x = [[HuHumanProfileView alloc]initWithFrame:half human:[humans objectAtIndex:index]];
    //    UIView *v = [[UIView alloc]initWithFrame:half];
    //    [v setBackgroundColor:[UIColor colorWithWhite:0.3*index alpha:1.0]];
    //    view = x;
    //    return view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

