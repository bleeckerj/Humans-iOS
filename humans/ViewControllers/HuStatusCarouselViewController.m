//
//  HuStatusCarouselViewController.m
//  humans
//
//  Created by julian on 12/22/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import "HuStatusCarouselViewController.h"
#import "defines.h"
#import "iCarousel.h"
#import "TwitterStatus.h"
#import "InstagramStatus.h"
#import "InstagramCaption.h"

#define VISIBLE_ITEMS_IN_CAROUSEL 3


@interface HuStatusCarouselViewController () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) iCarousel *carousel;


@end

@implementation HuStatusCarouselViewController
{
    //HuHeaderForServiceStatusView *header;
    CGRect carouselFrame;
    //MBProgressHUD *HUD;
}

@synthesize carousel;
@synthesize items;


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
    LOG_GENERAL(0, @"WHOA %@", self);
    return self;
}


- (void)commonInit
{
    items = [[NSMutableArray alloc]init];
    carousel = [[iCarousel alloc] init];
    
    //header = [[HuHeaderForServiceStatusView alloc]init];
    
    //UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onSwipeNameLabel:)];
    //[gesture setDirection:UISwipeGestureRecognizerDirectionRight];
    //[header addGestureRecognizer:gesture];
    
    carousel.type = iCarouselTypeCustom;
	carousel.delegate = self;
	carousel.dataSource = self;
    carousel.bounces = NO;
    carousel.scrollSpeed = 0.3;
    carousel.vertical = NO;
    
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blueColor]];
    [carousel setBackgroundColor:[UIColor grayColor]];
    carouselFrame = CGRectMake(0, 30/*CGRectGetMaxY(header.frame)*/, 320, 548);//CGRectGetHeight(self.view.frame) - CGRectGetHeight(header.frame));
    
    [carousel setFrame:carouselFrame];
	//carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	//add carousel to view
	[self.view addSubview:carousel];
    
    //[UIApplication sharedApplication];
    LOG_UI(0, @"view (%@) header= carousel=%@", self.view, NSStringFromCGRect(carousel.frame));
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [carousel reloadData];
}

#pragma mark iCarouselDelegate methods

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    LOG_UI(0, @"Did select Item at Index %d", index);
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
        transform = CATransform3DTranslate(transform, 0, 0, -50 * offset);
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
    current_index = [mcarousel currentItemIndex];
    
    
    //    NSUInteger distance_to_end =  [[friendToView allStatus]count] -[mcarousel currentItemIndex];
    //LOG_UI(0, @"Distance To End = %d and carousel count=%d friendToView allStatus count=%d items=%d", distance_to_end, [mcarousel numberOfItems], [[friendToView allStatus]count], [items count]);
    //    if(header == nil) {
    //        header = [[HuHeaderForServiceStatusView alloc]init];
    //    }
    //    [header setStatus:[friendToView statusAtIndex:[mcarousel currentItemIndex]]];
    //    [[friendToView statusAtIndex:[mcarousel currentItemIndex]] setHasBeenRead:YES];
    
    //    if(( ([self isScrollingLater] == NO) && (distance_to_end == ceil(2*VISIBLE_ITEMS_IN_CAROUSEL))) || distance_to_end == 1) {
    
    //if(distance_to_end == ceil(2*VISIBLE_ITEMS_IN_CAROUSEL)) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //            [HUD show:YES];
    //            HUD.center = CGPointMake(160, 120);
    //            HUD.mode = MBProgressHUDModeIndeterminate;
    //
    //            //HUD.delegate = self;
    //            [HUD setAnimationType:MBProgressHUDAnimationZoom];
    //            //[HUD performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:YES];
    //
    //            HUD.labelText = @"Just a sec..";
    //
    //        });
    // }
    //FIXME: below the HUD hide is unnecessary if distance_to_end was 0
    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    //            //
    //            [friendToView loadOlderStatusWithCompletionHandler:^(BOOL success, NSError *error) {
    //                //
    //                LOG_UI(1, @"Data Update! Success=[%@]", success?@"YES":@"NO");
    //                if(success) {
    //                    NSMutableArray *x = [friendToView allStatus];
    //
    //                    LOG_UI(1, @"friend status=%@\n\ncarousel data=%@", x, items);
    //                    // this should only load unique status, but a better completion handler would send back *only the increment
    //                    [self orderedInsertDataSourceItems:x];
    //                    LoggerFlush(LoggerGetDefaultLogger(), NO);
    //                } else {
    //                    dispatch_async(dispatch_get_main_queue(), ^{
    //
    //                        [HUD hide:YES];
    //                        [HUD removeFromSuperview];
    //                    });
    //                }
    //            }];
    //
    //        });
    //
    //    }
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



#pragma mark iCarouselDataSource Delegate methods
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    LOG_UI(0, @"checking number of items in carousel=%d", [items count]);
    return [items count];
}



- (UIView *)carousel:(iCarousel *)mcarousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UIView *result;
    //TODO: tie the friendToView status more delegate-y to the view controller..can refactor to
    //Make it so we don't need this "items" ivar, which is just a lousy go-between
    // We'd need to make sure the status array in friend is ordered!
    
    
    //    __block HuInstagramServiceUser *wtf;
    //    LOG_UI(1, @"All Managed Status is %@", [friendToView allStatus]);
    //    [self.friendToView.serviceUsers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //        //
    //        LOG_GENERAL(2, @"SERVICE_USER %@", obj);
    //        if([obj isKindOfClass:[HuInstagramServiceUser class]]) {
    //            wtf = (HuInstagramServiceUser*)obj;
    //            LOG_GENERAL(2, @"AND..%@", [wtf test]);
    //            [wtf.test enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //                //
    //                LOG_GENERAL(2, @"HERE: %@", obj);
    //            }];
    //        }
    //    }];
    
    
    
    //    id<HuServiceStatus>status = [self.friendToView statusAtIndex:index];
    //    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(carousel.frame), CGRectGetHeight(carousel.frame));
    //
    //    result = [[HuViewForServiceStatus alloc]initWithFrame:frame forStatus:status];
    //    if([result respondsToSelector:@selector(showOrRefreshPhoto)]) {
    //        [result performSelector:@selector(showOrRefreshPhoto)];
    //    }
    
    result = [[UIView alloc]initWithFrame:self.view.frame];
    [result setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-10, self.view.frame.size.height-10)];
    [result addSubview:label];
    
    NSObject *item = [items objectAtIndex:index];
    if([item isKindOfClass:[TwitterStatus class]])
    {
        TwitterStatus *t = (TwitterStatus*)item;
        [label setText:[t text]];
    }
    if([item isKindOfClass:[InstagramStatus class]])
    {
        InstagramStatus *i = (InstagramStatus*)item;
        InstagramCaption *c = [i caption];
        label.text = [c text];
    }
    return result;
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end