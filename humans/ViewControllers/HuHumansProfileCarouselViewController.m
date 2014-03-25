//
//  HuHumansProfileCarouselViewController.m
//  humans
//
//  Created by Julian Bleecker on 2/13/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuHumansProfileCarouselViewController.h"
#define SERVICEUSER_COLUMNS 6
@interface HuHumanProfileView : UIView
{
    TYMActivityIndicatorView *waitOnStatusActivityIndicatorView;
    HuStatusCarouselViewController *statusCarouselViewController;
    HuHumansProfileCarouselViewController *parentViewController;
    MRProgressOverlayView *activityIndicatorView;
    UIView *containerView;
    UIView *topBorder;
    UIView *profileImageContainer;
    CGFloat pip_diameter;
}

- (void)editHuman;
//- (void)updateHumanProfileViewsStatusCounts;

@property HuEditHumanViewController *editHumanViewController;
@property (nonatomic)  HuHuman *human;
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
@synthesize editHumanViewController;

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

//- (void)setHuman:(HuHuman *)aHuman
//{
//    human = aHuman;
//    //[self commonInit];
//}
//
//- (HuHuman *)human
//{
//    return human;
//}

- (void)commonInit
{
    
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    userHandler = [delegate humansAppUser];
    
    self.count = [NSNumber numberWithInt:0];
    
    //CGFloat width = self.frame.size.width/6;
    
    containerView = [[UIView alloc]initWithFrame:self.frame];
    [containerView setBackgroundColor:[UIColor whiteColor]];
    
    [self addSubview:containerView];
    
    topBorder = [[UIView alloc]init];
    [containerView addSubview:topBorder];
    
    [topBorder mc_setSize:CGSizeMake(containerView.bounds.size.width, containerView.bounds.size.height/6)];
    [topBorder mc_setPosition:MCViewPositionTopHCenter inView:containerView withMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    [topBorder setBackgroundColor:[UIColor Garmin]];
    
    nameLabel = [[UILabel alloc]initWithFrame:[topBorder frame]];
    [topBorder addSubview:nameLabel];
    [nameLabel setText:[human name]];
    [nameLabel setFont:PROFILE_VIEW_FONT_LARGE];
    [nameLabel setTextColor:PROFILE_VIEW_FONT_COLOR];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel mc_setRelativePosition:MCViewPositionCenters toView:topBorder];
    
    pip_diameter = topBorder.size.height -8;
    
    countLabel = [[UILabel alloc]init];
    [countLabel setSize:CGSizeMake(pip_diameter+2, pip_diameter+2)];
    [containerView addSubview:countLabel];
    [countLabel setFont:COUNT_LABEL_FONT];
    [countLabel setTextColor:[UIColor darkGrayColor]];
    [countLabel setBackgroundColor:[UIColor whiteColor]];
    [countLabel setTextAlignment:NSTextAlignmentCenter];
    [countLabel mc_setRelativePosition:MCViewPositionRight toView:topBorder withMargins:UIEdgeInsetsMake(0, 0, 0, 4)];
    [countLabel mc_setRelativePosition:MCViewPositionVerticalCenter toView:topBorder];
    [countLabel.layer setCornerRadius:(pip_diameter+2)/2];
    [countLabel.layer setMasksToBounds:YES];
    [countLabel.layer setBorderColor:[[UIColor crayolaNeonCarrotColor]CGColor]];
    [countLabel.layer setBorderWidth:3];
    
    
    instagramCountLabel = [[UILabel alloc]init];
    [instagramCountLabel setSize:CGSizeMake(pip_diameter, pip_diameter)];
    [containerView addSubview:instagramCountLabel];
    [instagramCountLabel setFont:COUNT_LABEL_FONT];
    [instagramCountLabel setTextColor:[UIColor whiteColor]];
    [instagramCountLabel setBackgroundColor:INSTAGRAM_COLOR];
    [instagramCountLabel setTextAlignment:NSTextAlignmentCenter];
    [instagramCountLabel mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:countLabel withMargins:UIEdgeInsetsMake(6, 0, 0, 0)];
    [instagramCountLabel.layer setCornerRadius:pip_diameter/2];
    [instagramCountLabel.layer setMasksToBounds:YES];
    
    flickrCountLabel = [[UILabel alloc]init];
    [flickrCountLabel setSize:CGSizeMake(pip_diameter+3, pip_diameter+3)];
    [containerView addSubview:flickrCountLabel];
    [flickrCountLabel setFont:COUNT_LABEL_FONT];
    [flickrCountLabel setTextColor:[UIColor whiteColor]];
    [flickrCountLabel setBackgroundColor:[UIColor FlickrPink]];
    [flickrCountLabel setTextAlignment:NSTextAlignmentCenter];
    [flickrCountLabel mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:instagramCountLabel withMargins:UIEdgeInsetsMake(6, 0, 0, 0)];
    [flickrCountLabel.layer setCornerRadius:(pip_diameter+3)/2];
    [flickrCountLabel.layer setMasksToBounds:YES];
    
    
    twitterCountLabel = [[UILabel alloc]init];
    [twitterCountLabel setSize:CGSizeMake(pip_diameter, pip_diameter)];
    [containerView addSubview:twitterCountLabel];
    [twitterCountLabel setFont:COUNT_LABEL_FONT];
    [twitterCountLabel setTextColor:[UIColor whiteColor]];
    [twitterCountLabel setBackgroundColor:TWITTER_COLOR];
    [twitterCountLabel setTextAlignment:NSTextAlignmentCenter];
    [twitterCountLabel mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:flickrCountLabel withMargins:UIEdgeInsetsMake(6, 0, 0, 0)];
    [twitterCountLabel.layer setCornerRadius:pip_diameter/2];
    [twitterCountLabel.layer setMasksToBounds:YES];
    
    foursquareCountLabel = [[UILabel alloc]init];
    [foursquareCountLabel setSize:CGSizeMake(pip_diameter, pip_diameter)];
    [containerView addSubview:foursquareCountLabel];
    [foursquareCountLabel setFont:COUNT_LABEL_FONT];
    [foursquareCountLabel setTextColor:[UIColor whiteColor]];
    [foursquareCountLabel setBackgroundColor:FOURSQUARE_COLOR];
    [foursquareCountLabel setTextAlignment:NSTextAlignmentCenter];
    [foursquareCountLabel mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:twitterCountLabel withMargins:UIEdgeInsetsMake(6, 0, 0, 0)];
    [foursquareCountLabel.layer setCornerRadius:pip_diameter/2];
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
    [waitOnStatusActivityIndicatorView mc_setRelativePosition:MCViewPositionRight toView:topBorder];
    [waitOnStatusActivityIndicatorView mc_setRelativePosition:MCViewPositionVerticalCenter toView:topBorder];
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
    
    profileImageContainer = [[UIView alloc]init];
    [self updateProfileImageContainer];
}

- (void)updateProfileImageContainer
{
    if([profileImageContainer superview] != nil) {
        [profileImageContainer removeFromSuperview];
    }
    CGFloat width = (self.frame.size.width)/SERVICEUSER_COLUMNS;
    NSArray *serviceUsers = [human serviceUsers];
    profileImageContainer = [[UIView alloc]init];
    [serviceUsers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //
        HuServiceUser *user = (HuServiceUser*)obj;
        
        UIImageView *profile_imgview = [[UIImageView alloc]initWithFrame:(CGRectMake((idx/3)*width, (idx%3)*width, width, width))];
        
        profile_imgview.layer.borderWidth = 0.5;
        profile_imgview.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        [profile_imgview setImageWithURL:[NSURL URLWithString:[user imageURL]] placeholderImage:[UIImage imageNamed:@"angry_unicorn_tiny.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            //
            if(image == nil) {
                LOG_ERROR(0, @"Couldn't download image %@", [user username]);
                LOG_ERROR(0, @"May mean that the user has changed their image and we don't have a fresh URL. We could initiate a refresh of the local user data, which only rarely gets updated serverside");
            }
        }];
        
        [profileImageContainer addSubview:profile_imgview];
    }];
    [containerView addSubview:profileImageContainer];
    [profileImageContainer mc_setRelativePosition:MCViewRelativePositionUnderAlignedLeft toView:topBorder];
    
    containerView.layer.cornerRadius = 0;
    
}

- (void)editHuman
{
    LOG_GENERAL(0, @"Would present %@", human);
    [Flurry logEvent:[NSString stringWithFormat:@"Trying to show human %@ (%@)", [human name], [human humanid]]];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HuEditHumanViewController *profileViewController = [storyBoard instantiateViewControllerWithIdentifier:@"HuHumanProfileViewController"];
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
            
            // turn off the indicator that the status has new stuff..assume once we're showing it, it won't when
            // we return to the carousel
            [self shouldMakeStatusLabel:self.countLabel ringOn:NO];
            
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
        int mod = dur_hours_int % 24;
        LOG_GENERAL(0, @"duration.day_int=%d duration.hours_int=%d mod=%d %@", dur_days_int, dur_hours_int, mod, [human name]);
        
        if(dur_days_int > 1 && mod == 0) {
            NSString *time_total = [NSString stringWithFormat:@"%@d", dur_days];
            [self.countLabel setText:time_total];
        } else
            if(dur_days_int < 3 && mod != 0)
            {
                NSString *time_total = [NSString stringWithFormat:@"%@h", dur_hours];
                [self.countLabel setText:time_total];
            } else
            {
                NSString *time_total = [NSString stringWithFormat:@"%@d", dur_days];
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
    //    MGLineStyled *header;
    MGLine *add_human;
    HuShowServicesViewController *showServicesViewController;
    MSWeakTimer *timerForStatusRefresh;
    dispatch_queue_t privateQueue;
    CGRect full_sized, half_sized;
    REMenu *mainMenu;
    tViewType viewType;
    // a common "profile view" that we use to jump-off for editing a human
    // looks ugly
    HuEditHumanViewController *commonEditHumanViewController;
    REMenuItem *editItem;
    REMenuItem *settingsItem;
}
@end


@implementation HuHumansProfileCarouselViewController

@synthesize indexToShow;
@synthesize humanHasEdited;
@synthesize user;

//static const char *HuHumansScrollViewControllerTimerQueueContext = "HuHumansProfileCarouselViewControllerTimerQueueContext";



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self commonInit];
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
    user = [userHandler humans_user];
    arrayOfHumans = [NSMutableArray arrayWithArray:[[userHandler humans_user]humans]];
    humans_views = [[NSMutableArray alloc]init];
    
    if(commonEditHumanViewController == nil) {
        commonEditHumanViewController = [[HuEditHumanViewController alloc]init];
    }
    
    viewType = kHalfHeightScrollView;
    indexToShow = 0;
    
    // do it once now
    [self updateHumanProfileViewsStatusCounts];
    //and queue to do it every 2 minutes as well..
    privateQueue = dispatch_queue_create("com.nearfuturelaboratory.private_queue", DISPATCH_QUEUE_CONCURRENT);
    
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
                [self resetStatusRefreshTimer:30];
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

- (HuHumanProfileView *)viewForHuman:(HuHuman *)aHuman
{
    __block HuHumanProfileView *result = NULL;
    [humans_views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HuHumanProfileView *view = (HuHumanProfileView*)obj;
        if([[view human]isEqual:aHuman]) {
            result = view;
            *stop = YES;
        }
    }];
    return result;
}

// super wonky. we call this if we've just added
- (void)addViewForHuman:(HuHuman *)human
{
    if(viewType == kHalfHeightScrollView) {
        HuHumanProfileView *view_of_human = [[HuHumanProfileView alloc]initWithFrame:half_sized human:human parent:self];
        [view_of_human setEditHumanViewController:commonEditHumanViewController];
        [humans_views addObject:view_of_human];
    } else {
        HuHumanProfileView *view_of_human = [[HuHumanProfileView alloc]initWithFrame:full_sized human:human parent:self];
        [view_of_human setEditHumanViewController:commonEditHumanViewController];
        [humans_views addObject:view_of_human];
    }
    
}

- (void)addHumanToViewIfNotAlready:(HuHuman *)human
{
    if([arrayOfHumans containsObject:human] == NO) {
        [arrayOfHumans addObject:human];
        if(viewType == kHalfHeightScrollView) {
            HuHumanProfileView *view_of_human = [[HuHumanProfileView alloc]initWithFrame:half_sized human:human parent:self];
            [view_of_human setEditHumanViewController:commonEditHumanViewController];
            [humans_views addObject:view_of_human];
        } else {
            HuHumanProfileView *view_of_human = [[HuHumanProfileView alloc]initWithFrame:full_sized human:human parent:self];
            [view_of_human setEditHumanViewController:commonEditHumanViewController];
            [humans_views addObject:view_of_human];
        }
    }
    
}

- (void)freshenHumansForView
{
    NSArray *list_of_humans = [[userHandler humans_user]humans];
    arrayOfHumans = [list_of_humans copy];
    
    // Basically go through the views
    // check to see if the human in the view also in the users list of humans
    // it *may not* be if we're freshening after having gone to the HuHumanProfileView and
    // it's been deleted.
    // Also if we've deleted or whatever a service user, we want to reflect that
    // Basically for every view that is still here, re-set the human it represents
    // with fresh goodness.
    //
    [humans_views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HuHumanProfileView *view = (HuHumanProfileView *)obj;
        HuHuman *human_of_view = [view human];
        if([arrayOfHumans containsObject:human_of_view] == NO) {
            [humans_views removeObject:view];
        } else {
            [arrayOfHumans each:^(id object) {
                HuHuman *fresh_human = (HuHuman*)object;
                if([human_of_view isEqual:fresh_human]) {
                    [view setHuman:fresh_human];
                    [view updateProfileImageContainer];
                }
            }];
        }
    }];
    
    [arrayOfHumans enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HuHuman *human = (HuHuman*)obj;
        // go through all views..see if this guy has one?
        if([self viewForHuman:human] == nil) {
            [self addViewForHuman:human];
        }
    }];
    
    [carousel reloadData];
    // [self updateHumanProfileViewsStatusCounts];
    
}

- (void)populateViewsForHumans
{
    [arrayOfHumans removeAllObjects];
    [humans_views removeAllObjects];
    NSArray *list_of_humans = [[userHandler humans_user]humans];
    [list_of_humans enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //
        HuHuman *human = (HuHuman*)obj;
        //TODO bizzare !!
        if([arrayOfHumans containsObject:human] == NO) {
            [self addHumanToViewIfNotAlready:human];
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
    
    [self freshenHumansForView];
    
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
    
    [timerForStatusRefresh fire];
    
    if(viewType == kHalfHeightScrollView) {
        if([carousel numberOfItems] == 1 ) {
            [carousel setScrollEnabled:NO];
            [carousel scrollToItemAtIndex:0 animated:YES];
            
        }
        if([carousel numberOfItems] == 2) {
            [carousel setScrollEnabled:YES];
            [carousel scrollToItemAtIndex:0 animated:YES];
        }
        if([carousel numberOfItems] > 2) {
            [carousel setScrollEnabled:YES];
        }
        if([carousel numberOfItems] < 4) {
            [carousel setBounceDistance:0.1];
        }
        
    }
    if(viewType == kFullHeightScrollView) {
        
        if([carousel numberOfItems] == 1) {
            [carousel setScrollEnabled:NO];
        }
        if([carousel numberOfItems] == 2) {
            [carousel setBounceDistance:0.1];
            [carousel scrollToItemAtIndex:0 animated:YES];
            
        }
    }
    
    
    // suppose we've updated linked services
    NSUInteger servicesCount = [[[userHandler humans_user]services]count];
    settingsItem.badge = [NSString stringWithFormat:@"%lu", servicesCount];
    
    
    
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
    
    UIView *settings_bar_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HEADER_SIZE.width, HEADER_SIZE.height)];
    [settings_bar_view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:settings_bar_view];
    
    FUIButton *settingsButton = [[FUIButton alloc]initWithFrame:CGRectMake(0, 0, HEADER_SIZE.height, HEADER_SIZE.height)];
    [settingsButton setButtonColor:[UIColor whiteColor]];
    [settingsButton setImage:[UIImage imageNamed:@"settings-bars"] forState:UIControlStateNormal];
    [settingsButton bk_addEventHandler:^(id sender) {
        if(mainMenu.isOpen == NO) {
            [mainMenu showFromRect:(CGRectMake(0, 0, settings_bar_view.width, 400)) inView:carousel];
        } else {
            [mainMenu close];
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    FUIButton *addHumanButton = [[FUIButton alloc]initWithFrame:CGRectMake(0, 0, HEADER_SIZE.height, HEADER_SIZE.height)];
    [addHumanButton setButtonColor:[UIColor whiteColor]];
    [addHumanButton setImage:[UIImage imageNamed:@"add-human-gray"] forState:UIControlStateNormal];
    [addHumanButton bk_addEventHandler:^(id sender) {
        LOG_UI(0, @"Tapped Add Human Limit?");
        HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        //
        HuJediFindFriends_ViewController *jedi = [delegate jediFindFriendsViewController];
        [[bself navigationController]pushViewController:jedi animated:NO];
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat width = self.view.width - [addHumanButton width] - [settingsButton width];
    UILabel *appNameLabel = [[UILabel alloc]initWithFrame:CGRectMake([settingsButton right], 0, width, HEADER_HEIGHT)];
    [appNameLabel setText:@"Humans"];
    [appNameLabel setTextAlignment:NSTextAlignmentCenter];
    [appNameLabel setFont:HEADER_FONT_XLARGE];
    [appNameLabel setUserInteractionEnabled:YES];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]      initWithTarget:self action:@selector(longPressOnAppName:)];
    longPress.minimumPressDuration = 0.5;  // Seconds
    longPress.numberOfTapsRequired = 0;
    [appNameLabel addGestureRecognizer:longPress];
    
    [appNameLabel bk_whenDoubleTapped:^{
        dispatch_async(dispatch_get_main_queue(), ^{
//            [[bself navigationController]popToRootViewControllerAnimated:YES];
            HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
            
            [[bself navigationController]setViewControllers:[delegate freshNavigationStack] animated:YES];
            //[[bself navigationController]pushViewController:[[delegate freshNavigationStack]objectAtIndex:0] animated:YES];
        });
        
    }];
    
    [settings_bar_view addSubview:settingsButton];
    [settings_bar_view addSubview:addHumanButton];
    [settings_bar_view addSubview:appNameLabel];
    
    
    [addHumanButton mc_setPosition:MCViewPositionRight inView:settings_bar_view];
    [appNameLabel mc_setRelativePosition:MCViewPositionHorizontalCenter toView:self.view];
    
    
    
    //    UIImage *settings_bar_img = [UIImage imageNamed:@"settings-bars"];
    //
    //    MGLine *settings_bar = [MGLine lineWithLeft:settings_bar_img right:nil size:[settings_bar_img size]];
    //    settings_bar.onTap = ^{
    //        if(mainMenu.isOpen == NO) {
    //            [mainMenu showFromRect:(CGRectMake(0, header.height, header.width, 400)) inView:carousel];
    //        } else {
    //            [mainMenu close];
    //        }
    //    };
    //
    //
    //    UIImage *add_human_img = [UIImage imageNamed:@"add-human-gray"];
    //
    //    add_human = [MGLine lineWithLeft:add_human_img right:nil size:[add_human_img size]];
    //    add_human.onTap = ^{
    //        LOG_UI(0, @"Tapped Add Human Limit?");
    //        HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    //        //
    //        HuJediFindFriends_ViewController *jedi = [delegate jediFindFriendsViewController];
    //        [[bself navigationController]pushViewController:jedi animated:NO];
    //
    //    };
    
    
#pragma mark header setup
    //header
    
    __block UINavigationController *bnav = [self navigationController];
    __block iCarousel *weak_carousel = carousel;
#pragma mark here's where we set up the menu items
    settingsItem = [[REMenuItem alloc] initWithTitle:@"Link Services"
                                               image:[UIImage imageNamed:@"add-cloud-gray"]
                                    highlightedImage:nil
                                              action:^(REMenuItem *item) {
                                                  if(showServicesViewController == nil) {
                                                      showServicesViewController = [[HuShowServicesViewController alloc]init];
                                                      
                                                  }
//                                                  showServicesViewController.tapOnEx = ^{
//                                                      dispatch_async(dispatch_get_main_queue(), ^{
//                                                          [bnav popToViewController:bself animated:YES];
//                                                      });
//                                                  
//                                                  };
                                                  
                                                  
                                                  [bnav pushViewController:showServicesViewController animated:YES];//setViewControllers:@[showServicesViewController] animated:NO];
                                              }];
    
    
    
    editItem = [[REMenuItem alloc] initWithTitle:@"Edit Human"
                                           image:[UIImage imageNamed:@"Icon_Home"]
                                highlightedImage:nil
                                          action:^(REMenuItem *item) {
                                              //LOG_UI(0, @"Item: %@", item);
                                              //NSInteger index = [carousel currentItemIndex];
                                              HuHumanProfileView *current = (HuHumanProfileView*)[carousel currentItemView];
                                              //                                                            NSString *human_name = [[current human]name];
                                              //                                                            [item setTitle:[NSString stringWithFormat:@"Edit %@", human_name]];
                                              
                                              [current editHuman];
                                          }];
    
    
    mainMenu.waitUntilAnimationIsComplete = NO;
    mainMenu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
        badgeLabel.backgroundColor = [UIColor colorWithWhite:.9 alpha:.5];
        //badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.000].CGColor;
    };
    
    NSUInteger servicesCount = [[[userHandler humans_user]services]count];
    settingsItem.badge = [NSString stringWithFormat:@"%lu", servicesCount];
    settingsItem.textColor = [UIColor crayolaSmokeColor];
    settingsItem.backgroundColor = [UIColor whiteColor];
    
    editItem.textColor = [UIColor crayolaSmokeColor];
    editItem.backgroundColor = [UIColor whiteColor];
    
    mainMenu = [[REMenu alloc]initWithItems:@[settingsItem, editItem]];
    [mainMenu setLiveBlur:YES];
    UIColor *d = [[UIColor crayolaOuterSpaceColor]darkerColor];
    [mainMenu setHighlightedBackgroundColor:d];
    mainMenu.borderWidth = 0.0;
    
    
    [mainMenu setCloseCompletionHandler:^{
        LOG_UI(0, @"Menu did close");
    }];
    
#pragma mark size the individual humans views based on the type of view we want
    // Do any additional setup after loading the view.
    full_sized = CGRectMake(0, settings_bar_view.bottom, self.view.frame.size.width, self.view.frame.size.height-settings_bar_view.bottom/*-status_bar_height*/);
    half_sized = CGRectMake(0, settings_bar_view.bottom, self.view.frame.size.width,  (full_sized.size.height)/2);
    
    
    carousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, full_sized.size.height)];
    [carousel mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:settings_bar_view];
    [carousel setBackgroundColor:[UIColor crayolaManateeColor]];
    [carousel setType:iCarouselTypeCustom];
    [carousel setDataSource:self];
    [carousel setDelegate:self];
    [carousel setVertical:YES];
    [carousel setCenterItemWhenSelected:NO];
    [carousel setBounceDistance:0.33];
    
    
    [self.view addSubview:carousel];
    [self.view sendSubviewToBack:carousel];
    //    [self.view addSubview:header];
    //    [header layout];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    
    [self populateViewsForHumans];
}

- (void)longPressOnAppName:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        LOG_UI(0, @"Long Press Header..Esc to %@", [self presentingViewController]);
        dispatch_async(dispatch_get_main_queue(), ^{
            //[[self navigationController]popViewControllerAnimated:YES];
            HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
            [[self navigationController]setViewControllers:[delegate freshNavigationStack] animated:YES];
        });
        
    }
}

- (void)setHumansUserHandler:(HuUserHandler *)aUserHandler
{
    userHandler = aUserHandler;
}



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
        result = CATransform3DTranslate(transform, 0.0f, (offset - .76) * (carousel.bounds.size.height) * spacing, 0.0f);
    } else {
        spacing = [self carousel:carousel valueForOption:iCarouselOptionSpacing withDefault:1.01];
        result = CATransform3DTranslate(transform, 0.0f, (offset - 0) * (carousel.bounds.size.height) * spacing, 0.0f);
    }
    
    return result;
    
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    LOG_UI(0, @"Did select Item at Index %ld", (long)index );
}

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
            //        case iCarouselOptionSpacing:
            //        {
            //            //add a bit of spacing between the item views
            //            return value * 1.1f;
            //        }
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
    if( [humans_views count] == 0) {
        return 1;
    }
    //    if([humans_views count] == 1) {
    //        return 1;
    //    }
    else {
        return 0;
    }
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UIView *result;
    if(view == nil) {
        if(viewType == kHalfHeightScrollView) {
            result = [[UIView alloc]initWithFrame:half_sized];
        } else {
            result = [[UIView alloc]initWithFrame:full_sized];
        }
        UIImage *gi_joe = [UIImage imageNamed:@"GIJoeAngry"];
        gi_joe = [gi_joe resizedImage:result.size interpolationQuality:kCGInterpolationHigh];
        UIImageView *stamp = [[UIImageView alloc]initWithImage:gi_joe];
        
        stamp.contentMode = UIViewContentModeScaleAspectFit;
        //[stamp setAlpha:0.2];
        [result addSubview:stamp];
        [stamp mc_setPosition:MCViewPositionCenters inView:result];
        if([[user services]count] < 1) {
            FUIButton *linkService = [[FUIButton alloc]initWithFrame:CGRectMake(0, 0, result.size.width, 55)];
            [linkService setTitle:@"Link Service" forState:UIControlStateNormal];
            [[linkService titleLabel]setFont:BUTTON_FONT_LARGE];
            [linkService setButtonColor:[UIColor crayolaMangoTangoColor]];
            [linkService setHighlightedColor:[[UIColor crayolaMangoTangoColor]lighterColor]];
            [linkService bk_addEventHandler:^(id sender) {
                
            } forControlEvents:UIControlEventTouchUpInside];
            
            [result addSubview:linkService];
            [linkService mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:stamp withMargins:UIEdgeInsetsMake(10, 0, 0, 0)];
            
        } else {
            FUIButton *makeHuman = [[FUIButton alloc]initWithFrame:CGRectMake(0, 0, result.size.width, 55)];
            [makeHuman setTitle:@"Make Human" forState:UIControlStateNormal];
            [[makeHuman titleLabel]setFont:BUTTON_FONT_LARGE];
            [makeHuman setButtonColor:[UIColor crayolaMangoTangoColor]];
            [makeHuman setHighlightedColor:[[UIColor crayolaMangoTangoColor]lighterColor]];
            [makeHuman bk_addEventHandler:^(id sender) {
                
            } forControlEvents:UIControlEventTouchUpInside];
            
            [result addSubview:makeHuman];
            [makeHuman mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:stamp withMargins:UIEdgeInsetsMake(10, 0, 0, 0)];
        }
        [result setBackgroundColor:[UIColor whiteColor]];
    }
    return result;
}


-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if([humans_views count] < 1) {
        return nil;
    }
    return [humans_views objectAtIndex:index];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

