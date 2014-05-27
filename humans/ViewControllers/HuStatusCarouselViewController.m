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
#import <ObjectiveSugar.h>

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
//    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onSwipeNameLabel:)];
//    [gesture setDirection:UISwipeGestureRecognizerDirectionRight];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onSwipeNameLabel:)];
    [gesture setNumberOfTapsRequired:2];
    
    [header addGestureRecognizer:gesture];
    
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
    
//    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        
//    }];
    
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
    header.frame = CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT);
    [header setBackgroundColor:[UIColor Amazon]];
    
    
    [header setStatus:[items objectAtIndex:0]];
    //[self.view addSubview:header];
    
    [carousel setBackgroundColor:[UIColor crayolaTimberwolfColor]];
      
    carouselFrame = self.view.frame;//CGRectMake(0, 0/*HEADER_HEIGHT*/, 320, CGRectGetHeight(self.view.frame) - CGRectGetHeight(header.frame));
    
    [carousel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [carousel setFrame:carouselFrame];
//	carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
#pragma mark -- set up the HuViewForServiceStatus based on the status
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HuViewForServiceStatus *result = HuViewForServiceStatus.new;
        result = [[HuViewForServiceStatus alloc]initWithFrame:self.carousel.frame forStatus:[items objectAtIndex:idx] with:self];
        [result setOnTap:^(){
            LOG_UI(0, @"On Tap");
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
        
    }];

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
       // LOG_TODO(0, @"How do you reuse a view? %@", view);
    }
    
    return [statusViews objectAtIndex:index];
    
}
- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
