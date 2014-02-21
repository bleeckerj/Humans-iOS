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

@interface HuHumanProfileView : UIView
{
    
}
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
    [overlay setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.2]];
    
    nameLabel = [[UILabel alloc]initWithFrame:[overlay frame]];
    [overlay addSubview:nameLabel];
    [nameLabel setText:[human name]];
    [nameLabel setFont:PROFILE_VIEW_FONT_LARGE];
    [nameLabel setTextColor:PROFILE_VIEW_FONT_COLOR];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel mc_setRelativePosition:MCViewPositionCenters toView:overlay];
    
    countLabel = [[UILabel alloc]init];
    [countLabel setSize:CGSizeMake(overlay.size.height, overlay.size.height)];
    [container addSubview:countLabel];
    [countLabel setFont:COUNT_LABEL_FONT];
    [countLabel setTextColor:[UIColor darkGrayColor]];
    [countLabel setBackgroundColor:[UIColor whiteColor]];
    [countLabel setTextAlignment:NSTextAlignmentCenter];
    [countLabel mc_setRelativePosition:MCViewPositionRight toView:overlay];
    [countLabel.layer setCornerRadius:overlay.size.height/2];
    
    [self bk_whenTapped:^{
        //
        LOG_UI(0, @"Tapped");
        activityIndicatorView = [MRProgressOverlayView showOverlayAddedTo:parentViewController.view animated:YES];
        activityIndicatorView.mode = MRProgressOverlayViewModeIndeterminate;
        activityIndicatorView.tintColor = [UIColor orangeColor];

        [self showHuman];
    }];
    
    UIView *profile_image_container = [[UIView alloc]init];
    
    [s enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //
        HuServiceUser *user = (HuServiceUser*)obj;
        
        UIImageView *profile_imgview = [[UIImageView alloc]initWithFrame:(CGRectMake((idx/2)*width, (idx%2)*width, width, width))];
        profile_imgview.layer.borderWidth = 0.5;
        profile_imgview.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        [profile_imgview setImageWithURL:[NSURL URLWithString:[user imageURL]] placeholderImage:[UIImage imageNamed:@"angry_unicorn_tiny.png"]];
        [profile_image_container addSubview:profile_imgview];
    }];
    [container addSubview:profile_image_container];
    [profile_image_container mc_setRelativePosition:MCViewRelativePositionUnderAlignedLeft toView:overlay];
    
    container.layer.cornerRadius = 0;
    container.layer.borderColor = [UIColor lightGrayColor].CGColor;
    container.layer.borderWidth = 1.0f;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)showHuman
{
    LOG_GENERAL(0, @"Would present %@", human);
    [Flurry logEvent:[NSString stringWithFormat:@"Trying to show human %@ (%@)", [human name], [human humanid]]];
    
    HuAppDelegate *delegate =  [[UIApplication sharedApplication]delegate];
    HuUserHandler *user_handler = [delegate humansAppUser];
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
}

- (void)refreshCounts
{
    __block HuHumanProfileView *bself = self;
    [userHandler getStatusCountForHuman:self.human withCompletionHandler:^(id data, BOOL success, NSError *error) {
        //
        if(success) {
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            bself.count = [f numberFromString:[data description]];
            [self.countLabel setText:[bself.count stringValue]];
             dispatch_async(dispatch_get_main_queue(), ^{
                [bself setNeedsDisplay];
            });
        } else {
            LOG_UI(0, @"Couldn't get a count for %@", bself.human.name);
            LOG_UI(0, @"This probably means you should log out and log back in, especially if you're debugging as the access token may have changed based on logging in from somewhere else.");
            bself.count = [[NSNumber alloc]initWithInt:65535];
            dispatch_async(dispatch_get_main_queue(), ^{
                [bself setNeedsLayout];
            });
        }
        
    }];
    
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
}
@end

@implementation HuHumansProfileCarouselViewController
@synthesize mainMenu;

static const char *HuHumansScrollViewControllerTimerQueueContext = "HuHumansProfileCarouselViewControllerTimerQueueContext";



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)initWithUserHandler:(HuUserHandler *)aUserHandler
{
    self = [super init];
    if(self) {
        userHandler = aUserHandler;
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    arrayOfHumans = [NSMutableArray arrayWithArray:[[userHandler humans_user]humans]];
    humans_views = [[NSMutableArray alloc]init];
    privateQueue = dispatch_queue_create("com.nearfuturelaboratory.private_queue", DISPATCH_QUEUE_CONCURRENT);
    
    timerForStatusRefresh = [MSWeakTimer scheduledTimerWithTimeInterval:120
                                                                 target:self
                                                               selector:@selector(updateHumanStatusCounts)
                                                               userInfo:nil
                                                                repeats:YES
                                                          dispatchQueue:privateQueue];
    
    dispatch_queue_set_specific(privateQueue, (__bridge const void *)(self), (void *)HuHumansScrollViewControllerTimerQueueContext, NULL);

}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle )preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)addHumanToView:(HuHuman *)human
{
    if([arrayOfHumans containsObject:human] == NO) {
        [arrayOfHumans addObject:human];
        [humans_views addObject:[[HuHumanProfileView alloc]initWithFrame:half_sized human:human parent:self]];
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
    
    [self updateHumanStatusCounts];
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timerForStatusRefresh invalidate];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateHumansForView];
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
            self.navigationController.view.backgroundColor = [UIColor greenColor];
            //[self.navigationController.view setNeedsDisplay];
            
        }
    }

    
    HuHumansProfileCarouselViewController *bself = self;
    
    UIImage *settings_bar_img = [UIImage imageNamed:@"settings-bars"];
    
    MGLine *settings_bar = [MGLine lineWithLeft:settings_bar_img right:nil size:[settings_bar_img size]];
    settings_bar.onTap = ^{
        LOG_UI(0, @"Tapped Settings Box");
        if (bself.mainMenu.isOpen)
            return [bself.mainMenu close];
        
        // [bself.mainMenu showFromNavigationController:self.navigationController];
        [bself.mainMenu showInView:carousel];
        
        [bself.mainMenu showFromRect:(CGRectMake(0, header.bottom, carousel.size.width, carousel.size.height - header.height)) inView:carousel];
    };
    
    
    
    UIImage *add_human_img = [UIImage imageNamed:@"add-human-gray"];
    
    add_human = [MGLine lineWithLeft:add_human_img right:nil size:[add_human_img size]];
    //add_human.alpha = 1.0;
    add_human.onTap = ^{
        LOG_UI(0, @"Tapped Add Human Limit?");
        HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        //
        HuJediFindFriends_ViewController *jedi = [delegate jediFindFriendsViewController];
       [[bself navigationController]pushViewController:jedi animated:NO];
//        UIViewController *screwy = [[UIViewController alloc]init];
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
//        [view setBackgroundColor:[UIColor Amazon]];
//        [[bself navigationController]pushViewController:screwy animated:YES];
    };
    
    
#pragma mark header setup
    //header
    header = [MGLineStyled lineWithLeft:settings_bar right:add_human size:(CGSize){self.view.frame.size.width,HEADER_HEIGHT}];
    UIColor *color = UIColorFromRGB(0xF5F5F5);
    [header setBackgroundColor:color];
    
    [header setMiddleFont:HEADLINE_FONT];
    [header setMiddleTextColor:[UIColor darkGrayColor]];
    [header setMiddleItems:[NSMutableArray arrayWithObject:@"humans"]];
    [header setMiddleItemsAlignment:NSTextAlignmentCenter];
    header.sidePrecedence = MGSidePrecedenceMiddle;
    header.padding = UIEdgeInsetsMake(4, 8, 4, 8);
    header.fixedPosition = (CGPoint){0,0};
    header.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    header.zIndex = 1;
    header.layer.cornerRadius = 0;
    header.layer.shadowOffset = CGSizeZero;
    [header setFrame:(CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT))];
    header.onTap = ^{
        LOG_UI(0, @"Tapped Header");
        //nextState++;
    };
    __block MGLineStyled *bheader = header;
    header.onLongPress = ^{
        LOG_UI(0, @"Long Press Header..Esc to %@ %@", [bself presentingViewController], bheader.longPresser);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[bself navigationController]popViewControllerAnimated:YES];
        });
        
    };
    
    __block UINavigationController *bnav = [self navigationController];
    REMenuItem *settingsItem = [[REMenuItem alloc] initWithTitle:@"Settings"
                                                           image:[UIImage imageNamed:@"Icon_Profile"]
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
    
    
    self.mainMenu.imageOffset = CGSizeMake(5, -1);
    self.mainMenu.waitUntilAnimationIsComplete = NO;
    self.mainMenu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
        badgeLabel.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
        badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.000].CGColor;
    };
    
    settingsItem.badge = @"15";
    mainMenu = [[REMenu alloc]initWithItems:@[settingsItem]];
    [mainMenu setLiveBlur:YES];
    
    
    [self.mainMenu setCloseCompletionHandler:^{
        LOG_UI(0, @"Menu did close");
    }];
    
    
	// Do any additional setup after loading the view.
    full_sized = CGRectMake(0, header.bottom, self.view.frame.size.width, self.view.frame.size.height-header.height-status_bar_height-10);
    half_sized = CGRectMake(0, header.bottom, self.view.frame.size.width,  (self.view.frame.size.height-header.height-status_bar_height)/2);
    
    
    [arrayOfHumans enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //
        [humans_views addObject:[[HuHumanProfileView alloc]initWithFrame:half_sized human:obj parent:self]];
    }];
    
    
    carousel = [[iCarousel alloc]initWithFrame:full_sized];
    [carousel setBackgroundColor:[UIColor Amazon]];
    [carousel setType:iCarouselTypeCustom];
    [carousel setDataSource:self];
    [carousel setDelegate:self];
    [carousel setVertical:YES];
    [carousel setCenterItemWhenSelected:NO];
    [self.view addSubview:carousel];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    // add it to the view then lay it all out
    [self.view addSubview:header];
    [header layout];
    
    
    //[self.mainMenu showFromNavigationController:self.navigationController];
    
}

- (void)setHumansUserHandler:(HuUserHandler *)aUserHandler
{
    userHandler = aUserHandler;
}

- (void)showHuman:(HuHuman *)human fromLine:(HuHumanProfileView *)line
{
    LOG_GENERAL(0, @"Would present %@", human);
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

- (void)updateHumanStatusCounts
{
    [humans_views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //
        
        HuHumanProfileView *humanProfileView = (HuHumanProfileView *)obj;
        
        [humanProfileView refreshCounts];
        
        // update the box presentation on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *c = [[NSMutableArray alloc]initWithArray:@[[[humanProfileView count]stringValue]]];
            //NSMutableArray *c = [[NSMutableArray alloc]initWithArray:@[@"WTF?"]];
            //[line setRightItems:c];
            //[line layout];
        });
        
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

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}



#pragma mark iCarouselDelegate methods

- (CATransform3D)carousel:(iCarousel *)mcarousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    CGFloat spacing = [self carousel:carousel valueForOption:iCarouselOptionSpacing withDefault:1.01];
    return CATransform3DTranslate(transform, 0.0f, (offset - .71) * (carousel.bounds.size.height)/2 * spacing, 0.0f);
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

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
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

-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
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
