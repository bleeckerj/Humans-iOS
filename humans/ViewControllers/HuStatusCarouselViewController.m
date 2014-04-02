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
#import "HuHeaderForServiceStatusView.h"
#import "HuViewForServiceStatus.h"
#import "HuServiceStatus.h"
#import <UIColor+FPBrandColor.h>
#import <UIColor+Crayola.h>
#import <UIView+MCLayout.h>
#import <ViewUtils.h>
#import "HuUserHandler.h"
#import "HuAppDelegate.h"

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
    items = [[NSMutableArray alloc]init];
    carousel = [[iCarousel alloc] init];
    
    header = [[HuHeaderForServiceStatusView alloc]init];
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onSwipeNameLabel:)];
    [gesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [header addGestureRecognizer:gesture];
    
    carousel.type = iCarouselTypeCustom;
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
    
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
    }];
    
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
    
    // header?
    header.frame = CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT);
    [header setBackgroundColor:[UIColor Amazon]];
    NSAssert((items != nil), @"Why is items nil?");
    NSAssert(([items count] > 0), @"Why are there no status items?");
    
    
    [header setStatus:[items objectAtIndex:0]];  //[carousel currentItemIndex]]];
    [self.view addSubview:header];
    
    [carousel setBackgroundColor:[UIColor crayolaTimberwolfColor]];
      
    carouselFrame = CGRectMake(0, HEADER_HEIGHT, 320, CGRectGetHeight(self.view.frame) - CGRectGetHeight(header.frame));
    [carousel setFrame:carouselFrame];
	carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	//add carousel to view
	[self.view addSubview:carousel];
    
    /** here's where we preload some crap **/
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HuViewForServiceStatus *result = [[HuViewForServiceStatus alloc]initWithFrame:self.carousel.frame forStatus:[items objectAtIndex:idx]];
        if(idx < 5) {
            [result showOrRefreshPhoto];
        }
        [statusViews addObject:result];
        
                dispatch_async(dispatch_get_main_queue(), ^{
                    [result setNeedsDisplay];
        
                });
        
    }];

    
//    UIView *topCard = [[UIView alloc]init];
//    [topCard mc_setSize:self.carousel.frame.size];
//     [topCard setBackgroundColor:[UIColor Amazon]];
//    UILabel *label = [[UILabel alloc]initWithFrame:(CGRectMake(0, 0, topCard.frame.size.width, 50))];
//    [topCard addSubview:label];
//    
//    [items insertObject:topCard atIndex:0];
    
    
    LOG_UI(0, @"view (%@) header= carousel=%@", self.view, NSStringFromCGRect(carousel.frame));
}

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
    [carousel reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [items each:^(id object) {
        object = [NSNull null];
    }];
    [statusViews each:^(id object) {
        object = [NSNull null];
    }];
    [items removeAllObjects];
    [statusViews removeAllObjects];
}

- (void)onSwipeNameLabel:(id)gesture
{
    //LOG_UI(0, @"Swiped gesture=%@", gesture);
    [[self navigationController]popViewControllerAnimated:YES];
}


#pragma mark iCarouselDelegate methods

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    LOG_UI(0, @"Did select Item at Index %ld", index );
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    CGFloat result = self.view.frame.size.width;
    return result;
}



- (CATransform3D)carousel:(iCarousel *)mcarousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    
    if (offset >= 0)
    {
        //move back
        transform = CATransform3DTranslate(transform, 0, 0, -10 * offset);
    }
    else
    {
        if(offset < 0 && offset > -0.9) {
            transform  = CATransform3DTranslate(transform, offset*[self carouselItemWidth:self.carousel], 0, 0);
        } else {
            //flip around
            transform = CATransform3DTranslate(transform, -1 * [self carouselItemWidth:self.carousel] * sin(MIN(1, -1*offset) * M_PI) , 0, 500 * offset);
        }
        
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
    // HuServiceStatus *status = (HuServiceStatus*)[items objectAtIndex:current_index];
    current_index = [mcarousel currentItemIndex];
    
    
    for(NSUInteger i=current_index; i<[carousel numberOfItems] && i < current_index + 3; i++) {
        [[statusViews objectAtIndex:i]showOrRefreshPhoto];
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



#pragma mark iCarouselDelegate methods
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
    
    if(view != nil) {
        LOG_TODO(0, @"How do you reuse a view? %@", view);
    }
    
    return [statusViews objectAtIndex:index];

    /*
    if([[items objectAtIndex:index] isKindOfClass:[UIView class]] == NO) {
        HuViewForServiceStatus *result = [[HuViewForServiceStatus alloc]initWithFrame:self.carousel.frame forStatus:[items objectAtIndex:index]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [result setNeedsDisplay];
        });
        return result;
    } else {
        // we're probably at a special item
        return [items objectAtIndex:index];
        
    }
     */
    //return result;
    
    //TODO: tie the friendToView status more delegate-y to the view controller..can refactor to
    //Make it so we don't need this "items" ivar, which is just a lousy go-between
    // We'd need to make sure the status array in friend is ordered!
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
