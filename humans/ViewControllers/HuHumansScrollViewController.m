//
//  HuHumansScrollViewController.m
//  humans
//  This shows a scroll view of all the humans for a particular user once they've logged in
//
//  Created by julian on 12/20/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import "HuHumansScrollViewController.h"

#import <MGScrollView.h>
#import <MGTableBoxStyled.h>
#import <MGLineStyled.h>
#import <UIImageView+AFNetworking.h>
//#import <AFNetworking/AFNetworking.h>
#import "UIImage+Resize.h"
#import "defines.h"
#import "HuStatusCarouselViewController.h"
#import "UIControl+BlocksKit.h"
#import <BlocksKit/UIControl+BlocksKit.h>
#import "Flurry.h"
#import <UIView+FLKAutoLayout.h>
#import <MRProgress/MRActivityIndicatorView.h>
#import "MSWeakTimer.h"

@interface HuHumansScrollViewController ()
{
    //UINavigationController *navigator;
    MGLineStyled *header;
    MGLine *add_human;
    MGTableBox *section;
    MRProgressOverlayView *activityIndicatorView;
    NSMutableArray *linesOfHumans;
    MGScrollView *scroller;
    MSWeakTimer *timerForStatusRefresh;
    HuUserHandler *userHandler;
    dispatch_queue_t privateQueue;
    
}


@end

@implementation HuHumansScrollViewController

static const char *HuHumansScrollViewControllerTimerQueueContext = "HuHumansScrollViewControllerTimerQueueContext";


@synthesize arrayOfHumans;
@synthesize statusCarouselViewController;
@synthesize slidingViewController;

- (id)init
{
    self = [super init];
    if (self) {
        [self customInit];
        
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self customInit];
    }
    return self;
}

- (void)customInit
{
    
    linesOfHumans = [[NSMutableArray alloc]init];
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    userHandler = [delegate humansAppUser];
    arrayOfHumans = [[NSMutableArray alloc]init];
    
    privateQueue = dispatch_queue_create("com.nearfuturelaboratory.private_queue", DISPATCH_QUEUE_CONCURRENT);
    
    timerForStatusRefresh = [MSWeakTimer scheduledTimerWithTimeInterval:120
                                                                 target:self
                                                               selector:@selector(updateHumanStatusCounts)
                                                               userInfo:nil
                                                                repeats:YES
                                                          dispatchQueue:privateQueue];
    
    dispatch_queue_set_specific(privateQueue, (__bridge const void *)(self), (void *)HuHumansScrollViewControllerTimerQueueContext, NULL);
}


- (void)setUp:(UIViewController *)controller
{
    
}

- (void)resetController
{
    [self viewDidLoad];
    //    scroller = [[MGScrollView alloc]init];
    //    self.view = [[UIView alloc]init];
    //    [self.view setBackgroundColor:[UIColor orangeColor]];
    //    [self.view addSubview:scroller];
}

- (void)hide:(id)gesture
{
    LOG_UI(0, @"hide %@", gesture);
    
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    LOG_UI(0, @"View Did Appear");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    LOG_UI(0, @"View Will Disappear");
    [timerForStatusRefresh invalidate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LOG_UI(0, @"View Will Appear");
    
    [header addGestureRecognizer:[self.slidingViewController panGesture]];
    
    [scroller layoutSubviews];
    
    [self updateHumansForView];
    
    // restart the timer
    if(timerForStatusRefresh == nil) {
        timerForStatusRefresh = [MSWeakTimer scheduledTimerWithTimeInterval:120
                                                                     target:self
                                                                   selector:@selector(updateHumanStatusCounts)
                                                                   userInfo:nil
                                                                    repeats:YES
                                                              dispatchQueue:privateQueue];
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [scroller layout];
        [self.view setNeedsDisplay];
    });
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) // only for iOS 7 and above
    //    {
    //        CGRect frame = self.navigationController.view.frame;
    //        if(frame.origin.y == 0) {
    //
    //            frame.origin.y += 20;
    //            frame.size.height -= 20;
    //            self.navigationController.view.frame = frame;
    //            self.navigationController.view.backgroundColor = [UIColor orangeColor];
    //
    //        }
    //    }
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    __block HuHumansScrollViewController *bself = self;
    
    UIImage *settings_bar_img = [UIImage imageNamed:@"settings-bars"];
    
    MGLine *settings_bar = [MGLine lineWithLeft:settings_bar_img right:nil size:[settings_bar_img size]];
    settings_bar.onTap = ^{
        LOG_UI(0, @"Tapped Settings Box");
    };
    
    UIImage *add_human_img = [UIImage imageNamed:@"add-human-gray"];
    
    add_human = [MGLine lineWithLeft:add_human_img right:nil size:[add_human_img size]];
    //add_human.alpha = 1.0;
    add_human.onTap = ^{
        LOG_UI(0, @"Tapped Add Human Limit?");
        HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        //
        [[bself navigationController]pushViewController:[delegate jediFindFriendsViewController] animated:YES];
        
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
    header.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
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
    // add it to the view then lay it all out
    [self.view addSubview:header];
    [header layout];
    
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0]];
    
    
#pragma mark setup the scroller
    CGSize size = self.view.frame.size;//self.navigationController.view.frame.size;
    
    scroller = [MGScrollView scrollerWithSize:size];
    [scroller setFrame:CGRectMake(0, HEADER_HEIGHT, size.width, size.height-HEADER_HEIGHT)];
    section = MGTableBox.box;
    [scroller.boxes addObject:section];
    
    
    
    
#pragma mark setup the lines of humans
    [scroller setContentSize:CGSizeMake(scroller.bounds.size.width, scroller.bounds.size.height+50)];
    
    [scroller layoutWithSpeed:1.0 completion:nil];
    //[scroller scrollToView:section withMargin:0];
    [self.view addSubview:scroller];
    
}



- (void)addHumanToView:(HuHuman *)human
{
    CGSize rowSize = (CGSize){self.view.width, 110};
    
    HuHumanLineStyled *line = [HuHumanLineStyled lineWithLeft:nil right:nil size:rowSize];
    [line setUserHandler:userHandler];
    [line setHuman:human];
    [line setMiddleItemsAlignment:NSTextAlignmentLeft];
    [line setMiddleFont:HEADLINE_FONT];
    [linesOfHumans addObject:line];
    
    [human loadServiceUsersProfileImagesWithCompletionHandler:^{
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            //
            UIImage *profile_image = [human largestServiceUserProfileImage];
            
            profile_image = [profile_image resizedImageToFitInSize:CGSizeMake(110,110) scaleIfSmaller:YES];
            
            UIImageView *profile_iv = [[UIImageView alloc]initWithImage:profile_image];
            CALayer *maskLayer = [CALayer layer];
            UIImage *mask = [UIImage imageNamed:@"user-profile-image-mask-100px"];
            maskLayer.contents = (id)mask.CGImage;
            maskLayer.frame = (CGRect){CGPointZero, mask.size};
            
            profile_iv.image = profile_image;
            profile_iv.layer.mask = maskLayer;
            
            NSMutableArray *marray = [[NSMutableArray alloc]initWithArray:@[profile_iv]];
            //[human_mgline setLeftItems:marray];
            
            [line setLeftItems:marray];
            [line layout];
            
        });
        
    }];
    __block HuHumanLineStyled *bline = line;
    __block NSMutableArray *array = linesOfHumans;
    
    line.onTap = ^{
        LOG_UI(0, @"Tapped on %@", [human name]);
        activityIndicatorView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
        activityIndicatorView.mode = MRProgressOverlayViewModeIndeterminate;
        activityIndicatorView.tintColor = [UIColor orangeColor];
        //[self.view addSubview:activityIndicatorView];
        //[activityIndicatorView show:YES];
        
        [self showHuman:human fromLine:bline];
    };
    
    line.onSwipe = ^{
        LOG_UI(0, @"Swiped on %@", [human name]);
        bline.swiper.direction = UISwipeGestureRecognizerDirectionRight;
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            //
            HuHumanLineStyled *b = (HuHumanLineStyled*)obj;
            if(b != bline) {
                [UIView animateWithDuration:0.2 animations:^{
                    //
                    b.x = 0;
                }];
            }
        }];
        
        // if the line is positioned at 0, it hasn't been slid either left or right,
        // so let's slide it to reveal the delete button
        if (bline.x == 0) {
            // change the swiper's accepted direction,
            // to allow swiping the line back to its original position
            bline.swiper.direction = UISwipeGestureRecognizerDirectionLeft;
            [UIView animateWithDuration:0.2 animations:^{
                bline.x = 100;
            }];
            
        } else {
            // change the swiper's accepted direction,
            // to allow it to be swiped to reveal delete again
            bline.swiper.direction = UISwipeGestureRecognizerDirectionRight;
            [UIView animateWithDuration:0.2 animations:^{
                bline.x = 0;
            }];
        }
    };
    
    
    UIImage *garbage = [UIImage imageNamed:@"garbage-gray"];
    MGLine *garbage_box = [MGLine lineWithSize:[garbage size]];
    [[garbage_box leftItems]addObject:garbage];
    
    
    MGLine *underneath = [MGLine lineWithSize:line.size];
    [underneath setBackgroundColor:[UIColor yellowColor]];
    underneath.attachedTo = line;
    underneath.zIndex = -1;
    [underneath.leftItems setArray:@[garbage_box]];
    
    UILongPressGestureRecognizer *__longpresser = [[UILongPressGestureRecognizer alloc]initWithTarget:garbage_box action:@selector(longPressed)];
    [__longpresser setMinimumPressDuration:2.5];
    [__longpresser setNumberOfTapsRequired:0];
    garbage_box.longPresser = __longpresser;
    
    garbage_box.onLongPress = ^{
        LOG_UI(0, @"Garbage Toss..%@ %@", human.name, __longpresser);
        HuAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        HuUserHandler *handler = [appDelegate humansAppUser];
        if(__longpresser.state == UIGestureRecognizerStateBegan) {
            [handler userRemoveHuman:human withCompletionHandler:^(BOOL success, NSError *error) {
                //
                if(success) {
                    [section.topLines removeObject:line];
                    [section.topLines removeObject:underneath];
                    //CGRect frame = human_mgline.frame;
                    //CGRect scroll_frame = scroller.frame;
                    //CGRect new_frame = CGRectMake(scroll_frame.origin.x, scroll_frame.origin.y, scroll_frame.size.width, scroll_frame.size.height - frame.size.height);
                    [scroller layoutWithSpeed:1.5 completion:^{
                        LOG_UI(0, @"Finished removing %@", human);
                        [UIView animateWithDuration:1.5 animations:^{
                            scroller.contentSize = CGSizeMake(scroller.contentSize.width, scroller.contentSize.height-line.size.height);
                        }];
                    }];
                } else {
                    LOG_UI(0, @"Error removing human %@ %@", [human name], [human humanid]);
                    //[Flurry logEvent:[NSString stringWithFormat:@"Error removing human %@ (%@)", [human name], [human humanid]]];
                    
                }
                
            }];
        }
    };
    
    [line layout];
    [section.topLines addObject:line];
    [section.topLines addObject:underneath];
    
    if([arrayOfHumans containsObject:human] == NO) {
        [arrayOfHumans addObject:human];
    }
}

//- (void)showHuman:(HuHuman *)human fromLine:(HuHumanLineStyled *)line
//{
////    LOG_GENERAL(0, @"Would present %@", human);
////    [Flurry logEvent:[NSString stringWithFormat:@"Trying to show human %@ (%@)", [human name], [human humanid]]];
////    
////    HuAppDelegate *delegate =  [[UIApplication sharedApplication]delegate];
////    HuUserHandler *user_handler = [delegate humansAppUser];
////    [userHandler getStatusCountForHuman:human withCompletionHandler:^(id data, BOOL success, NSError *error) {
////        int count = 0;
////        if(success) {
////            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
////            [f setNumberStyle:NSNumberFormatterDecimalStyle];
////            count = [[f numberFromString:[data description]] intValue];
////            
////        }
////        if(count <= 0) {
////            [Flurry logEvent:[NSString stringWithFormat:@"Was going to load human=%@, but status is still baking..", [human name]]];
////            
////            MRProgressOverlayView *noticeView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
////            noticeView.mode = MRProgressOverlayViewModeCross;
////            noticeView.titleLabelText = [NSString stringWithFormat:@"Still baking the cake.."];
////            [self performBlock:^{
////                [noticeView dismiss:YES];
////                [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
////            } afterDelay:4.0];
////            
////        }
////        
////        if(success && count > 0) {
////            [user_handler getStatusForHuman:human withCompletionHandler:^(BOOL success, NSError *error) {
////                //
////                if(success) {
////                    LOG_GENERAL(0, @"Loaded Status for %@", human);
////                    //[Flurry logEvent:[NSString stringWithFormat:@"Successfully loaded human %@", [human name]]];
////                    
////                    //NSString *human_id = [human humanid]    ;
////                    NSArray *status = [user_handler statusForHuman:human];
////                    LOG_GENERAL(0, @"Count is %d", [status count]);
////                    statusCarouselViewController = [[HuStatusCarouselViewController alloc]init];
////                    
////                    [statusCarouselViewController setItems:[[user_handler statusForHuman:human] copy]];
////                    
////                    //[self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
////                    
////                    [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
////                    
////                    [[self navigationController] pushViewController:statusCarouselViewController animated:YES];
////                    
////                } else {
////                    LOG_ERROR(0, @"Error loading status %@", error);
////                    //[Flurry logEvent:[NSString stringWithFormat:@"Error loading human %@ %@", [human name], error]];
////                    [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:NO];
////                    MRProgressOverlayView *noticeView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
////                    noticeView.mode = MRProgressOverlayViewModeIndeterminateSmall;
////                    noticeView.titleLabelText = [NSString stringWithFormat:@"Problem loading %@", error];
////                    [self performBlock:^{
////                        [noticeView dismiss:YES];
////                    } afterDelay:2.0];
////                    
////                }
////                
////            }];
////        }
////    }];
//}

- (void)updateHumanStatusCounts
{
    [linesOfHumans enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //
        
        HuHumanLineStyled *line = (HuHumanLineStyled *)obj;
        
        [line refreshCounts];
        
        // update the box presentation on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *c = [[NSMutableArray alloc]initWithArray:@[[[line count]stringValue]]];
            //NSMutableArray *c = [[NSMutableArray alloc]initWithArray:@[@"WTF?"]];
            [line setRightItems:c];
            [line layout];
        });
        
        __block HuHumanLineStyled *bline = line;
        
        line.asyncLayoutOnce = ^{
            // fetch a remote image on a background thread
            [bline refreshCounts];
            
            // update the box presentation on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableArray *c = [[NSMutableArray alloc]initWithArray:@[[[bline count]stringValue]]];
                //NSMutableArray *c = [[NSMutableArray alloc]initWithArray:@[@"WTF?"]];
                
                [bline setRightItems:c];
                [bline layout];
            });
        };
        
    }];
    
}

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

- (void)largestProfileImageForHuman:(HuHuman *)human withCompletionHandler:(UIImageViewResultsHandler)completionHandler
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    __block UIImageView *human_image = [[UIImageView alloc] init];
    __block UIImage *largest_image;
    
    for(int i=0; i<[[human serviceUsers]count]; i++) {
        
        dispatch_group_enter(group);
        
        
        NSString *url = [[human serviceUserProfileImageURLs]objectAtIndex:i];
        NSURL *image_url = [[NSURL alloc]initWithString:url];
        __block CGSize largest = CGSizeZero;
        [human_image setImageWithURLRequest:[NSURLRequest requestWithURL:image_url] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            //
            long area = [image size].width * [image size].height;
            if(area > (largest.width * largest.height)) {
                largest = [image size];
                largest_image = image;
                
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            //
            LOG_NETWORK(0, @"Failed to async load profile image %@ %@", url, error);
            
        }];
        dispatch_group_leave(group);
        
    }
    
    dispatch_group_notify(group, queue, ^{
        if(completionHandler) {
            completionHandler(human_image);
        }
        
    });
}


- (void)dealloc
{
    [timerForStatusRefresh invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, nil), ^{
    [timerForStatusRefresh invalidate];
    
    // });
}


@end
