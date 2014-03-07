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

- (void)editHuman;

@property HuHuman *human;
@property HuUserHandler *userHandler;
@property UILabel *nameLabel;
@property UILabel *countLabel;
@property NSNumber *count;

@end

@implementation HuHumanProfileView
@synthesize human;
@synthesize userHandler;
@synthesize nameLabel;
@synthesize countLabel;
@synthesize count;

HuStatusCarouselViewController *statusCarouselViewController;
HuHumansProfileCarouselViewController *parentViewController;
MRProgressOverlayView *activityIndicatorView;

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

- (void)commonInit
{
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    userHandler = [delegate humansAppUser];
    
    self.count = [NSNumber numberWithInt:0];
    
    
    CGFloat width = self.frame.size.width/6;
    NSArray *s = [human serviceUsers];
    
    
    UIView *container = [[UIView alloc]initWithFrame:self.frame];
    [container setBackgroundColor:[UIColor whiteColor]];
    
    [self addSubview:container];
    
    UIView *overlay = [[UIView alloc]init];
    [container addSubview:overlay];
    
    [overlay mc_setSize:CGSizeMake(container.bounds.size.width, container.bounds.size.height/6)];
    //[overlay mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:container];
    //[overlay mc_setPosition:MCViewPositionCenters inView:container];
    [overlay mc_setPosition:MCViewPositionTopHCenter inView:container withMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
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
    [countLabel setSize:CGSizeMake(diam, diam)];
    [container addSubview:countLabel];
    [countLabel setFont:COUNT_LABEL_FONT];
    [countLabel setTextColor:[UIColor darkGrayColor]];
    [countLabel setBackgroundColor:[UIColor whiteColor]];
    [countLabel setTextAlignment:NSTextAlignmentCenter];
    [countLabel mc_setRelativePosition:MCViewPositionRight toView:overlay];
    [countLabel.layer setCornerRadius:diam/2];
    
    [self bk_whenTapped:^{
        //
        LOG_UI(0, @"Tapped");
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
        //        [profile_imgview setImageWithURL:[NSURL URLWithString:[user imageURL]] placeholderImage:];
        //
        //        [profile_imgview setImageWithURL:[NSURL URLWithString:[user imageURL]] placeholderImage:[UIImage imageNamed:@"angry_unicorn_tiny.png"]];
        //
        [profile_imgview setImageWithURL:[NSURL URLWithString:[user imageURL]] placeholderImage:[UIImage imageNamed:@"angry_unicorn_tiny.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            //
            if(image == nil) {
                LOG_ERROR(0, @"Couldn't download image %@", [user username]);
                LOG_ERROR(0, @"May mean that the user has changed their image and we don't have a fresh URL. We could initiate a refresh of the local user data, which only rarely gets updated serverside");
            }
        }];
        
        [profile_image_container addSubview:profile_imgview];
    }];
    [container addSubview:profile_image_container];
    [profile_image_container mc_setRelativePosition:MCViewRelativePositionUnderAlignedLeft toView:overlay];
    
    container.layer.cornerRadius = 0;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)editHuman
{
    LOG_GENERAL(0, @"Would present %@", human);
    [Flurry logEvent:[NSString stringWithFormat:@"Trying to show human %@ (%@)", [human name], [human humanid]]];
    
//    UINavigationController *nav = [parentViewController navigationController];
//    [nav pushViewController:statusCarouselViewController animated:YES];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HuHumanProfileViewController *profileViewController = [storyBoard instantiateViewControllerWithIdentifier:@"HuHumanProfileViewController"];
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
            //[Flurry logEvent:[NSString stringWithFormat:@"Successfully loaded human %@", [human name]]];
            
            //NSString *human_id = [human humanid]    ;
            NSArray *status = [user_handler statusForHuman:human];
            LOG_GENERAL(0, @"Count is %d", [status count]);
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
    
    /*
     [userHandler getStatusCountForHuman:human withCompletionHandler:^(id data, BOOL success, NSError *error) {
     int lcount = 0;
     if(success) {
     NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
     [f setNumberStyle:NSNumberFormatterDecimalStyle];
     lcount = [[f numberFromString:[data description]] intValue];
     
     }
     if(lcount <= 0) {
     [Flurry logEvent:[NSString stringWithFormat:@"Was going to load human=%@, but status is still baking..", [human name]]];
     
     MRProgressOverlayView *noticeView = [MRProgressOverlayView showOverlayAddedTo:parentViewController.view animated:YES];
     noticeView.mode = MRProgressOverlayViewModeCross;
     noticeView.titleLabelText = [NSString stringWithFormat:@"Still baking the cake.."];
     [self performBlock:^{
     [noticeView dismiss:YES];
     [MRProgressOverlayView dismissAllOverlaysForView:parentViewController.view animated:YES];
     } afterDelay:4.0];
     
     }
     
     if(success && lcount > 0) {
     [user_handler getStatusForHuman:human withCompletionHandler:^(BOOL success, NSError *error) {
     //
     if(success) {
     LOG_GENERAL(0, @"Loaded Status for %@", human);
     //[Flurry logEvent:[NSString stringWithFormat:@"Successfully loaded human %@", [human name]]];
     
     //NSString *human_id = [human humanid]    ;
     NSArray *status = [user_handler statusForHuman:human];
     LOG_GENERAL(0, @"Count is %d", [status count]);
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
     }];
     */
}

- (void)refreshCounts:(NSString *)countAsStr
{
    NSNumberFormatter *f = [[NSNumberFormatter alloc]init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    self.count = [f numberFromString:countAsStr];
    [self.countLabel setText:[self.count stringValue]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
    //    [userHandler getStatusCountForHuman:self.human withCompletionHandler:^(id data, BOOL success, NSError *error) {
    //        //
    //        if(success) {
    //            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    //            [f setNumberStyle:NSNumberFormatterDecimalStyle];
    //            bself.count = [f numberFromString:[data description]];
    //            [self.countLabel setText:[bself.count stringValue]];
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                [bself setNeedsDisplay];
    //            });
    //        } else {
    //            LOG_UI(0, @"Couldn't get a count for %@", bself.human.name);
    //            LOG_UI(0, @"This probably means you should log out and log back in, especially if you're debugging as the access token may have changed based on logging in from somewhere else.");
    //            bself.count = [[NSNumber alloc]initWithInt:65535];
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                [bself setNeedsLayout];
    //            });
    //        }
    //
    //    }];
    
}

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end

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
    
}
@end

@implementation HuHumansProfileCarouselViewController

@synthesize indexToShow;
@synthesize humanHasEdited;

typedef enum {
    kListGridView = 0,
    kHalfHeightScrollView,
    kFullHeightScrollView
} tViewType;

tViewType viewType;


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
    
    // do it once now
    [self updateHumanStatusCounts];
    //and queue to do it every 2 minutes as well..
     privateQueue = dispatch_queue_create("com.nearfuturelaboratory.private_queue", DISPATCH_QUEUE_CONCURRENT);
    
     timerForStatusRefresh = [MSWeakTimer scheduledTimerWithTimeInterval:120
     target:self
     selector:@selector(updateHumanStatusCounts)
     userInfo:nil
     repeats:YES
     dispatchQueue:privateQueue];
    
    indexToShow = 0;
     
     dispatch_queue_set_specific(privateQueue, (__bridge const void *)(self), (void *)HuHumansScrollViewControllerTimerQueueContext, NULL);
    
}

- (void)updateHumanStatusCounts
{
    //__block HuHumanProfileView *bself = self;
    [userHandler getStatusCountsWithCompletionHandler:^(id data, BOOL success, NSError *error) {
        if(success) {
            // handle counts
            
            
            [humans_views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                HuHumanProfileView *humanProfileView = (HuHumanProfileView *)obj;
                HuHuman *human = [humanProfileView human];
                [humanProfileView refreshCounts:[data objectForKey:[human humanid]]];
                
                // update the box presentation on the main thread
                //                dispatch_async(dispatch_get_main_queue(), ^{
                //                    NSMutableArray *c = [[NSMutableArray alloc]initWithArray:@[[[humanProfileView count]stringValue]]];
                //                    //NSMutableArray *c = [[NSMutableArray alloc]initWithArray:@[@"WTF?"]];
                //                    //[line setRightItems:c];
                //                    //[line layout];
                //                });
                
                //        __block HuHumanLineStyled *bline = line;
                //
                //        line.asyncLayoutOnce = ^{
                //            // fetch a remote image on a background thread
                //            [bline refreshCounts];
                //
                //            // update the box presentation on the main thread
                //            dispatch_async(dispatch_get_main_queue(), ^{
                //                NSMutableArray *c = [[NSMutableArray alloc]initWithArray:@[[[bline count]stringValue]]];
                //                //NSMutableArray *c = [[NSMutableArray alloc]initWithArray:@[@"WTF?"]];
                //
                //                [bline setRightItems:c];
                //                [bline layout];
                //            });
                //        };
                
            }];
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

- (void)addHumanToView:(HuHuman *)human
{
    if([arrayOfHumans containsObject:human] == NO) {
        [arrayOfHumans addObject:human];
        if(viewType == kHalfHeightScrollView) {
            [humans_views addObject:[[HuHumanProfileView alloc]initWithFrame:half_sized human:human parent:self]];
            
        } else {
            [humans_views addObject:[[HuHumanProfileView alloc]initWithFrame:full_sized human:human parent:self]];
            
        }
        [carousel insertItemAtIndex:[carousel numberOfItems] animated:YES];
    }
    
}

- (void)updateHumansForView
{
    NSArray *list_of_humans = [[userHandler humans_user]humans];
    [list_of_humans enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //
        HuHuman *human = (HuHuman*)obj;
        if([arrayOfHumans containsObject:human] == NO) {
            [self addHumanToView:human];
        }
    }];
    [carousel reloadData];
    //[self updateHumanStatusCounts];
    
    
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
    
    LOG_UI(0, @"Here we have %d humans", [arrayOfHumans count]);
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        [[[self.navigationController navigationBar]topItem] setTitle:@"Profile Carousel"];
        
    });
    
    
     if(timerForStatusRefresh == nil) {
     timerForStatusRefresh = [MSWeakTimer scheduledTimerWithTimeInterval:120
     target:self
     selector:@selector(updateHumanStatusCounts)
     userInfo:nil
     repeats:YES
     dispatchQueue:privateQueue];
     
     }
    
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
        LOG_UI(0, @"Tapped Settings Box");
        //[mainMenu showInView:carousel];
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
                                                            LOG_UI(0, @"Item: %@", item);
                                                            NSInteger index = [carousel currentItemIndex];
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
    half_sized = CGRectMake(0, header.bottom, self.view.frame.size.width,  (full_sized.size.height+10)/2);
    
    
    [arrayOfHumans enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CGRect sizeBasedOnType;
        
        if(viewType == kHalfHeightScrollView) {
            sizeBasedOnType = half_sized;
        } else {
            sizeBasedOnType = full_sized;
        }
        
        [humans_views addObject:[[HuHumanProfileView alloc]initWithFrame:sizeBasedOnType human:obj parent:self]];
        
    }];
    
    
    carousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, full_sized.size.height)];
    //carousel = [[iCarousel alloc]initWithFrame:full_sized];
    
    [carousel setBackgroundColor:[UIColor cloudsColor]];
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
        spacing = [self carousel:carousel valueForOption:iCarouselOptionSpacing withDefault:.51];
        result = CATransform3DTranslate(transform, 0.0f, (offset - .49) * (carousel.bounds.size.height) * spacing, 0.0f);
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
            if([self numberOfItemsInCarousel:aCarousel] < 3) {
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
    NSUInteger result = [arrayOfHumans count];//[[[userHandler humans_user]humans]count];
    return result;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)aCarousel
{
    if ([self numberOfItemsInCarousel:aCarousel] < 4) {
        return 3;
    } else {
        return 0;
    }
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UIView *result;
    if(view == nil) {
        result = [[UIView alloc]initWithFrame:half_sized];
        [result setBackgroundColor:[UIColor crayolaBittersweetColor]];
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

