//
//  HuHumansProfileCarouselViewController.m
//  humans
//
//  Created by Julian Bleecker on 2/13/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuHumansProfileCarouselViewController.h"


@interface HuHumanProfileView : UIView
{
    
}
@property HuHuman *human;
@property HuUserHandler *userHandler;

@end

@implementation HuHumanProfileView
@synthesize human;
@synthesize userHandler;

- (id)initWithFrame:(CGRect)frame human:(HuHuman *)aHuman
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setHuman:aHuman];
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    NSArray *s = [human serviceUsers];
    UIView *container = [[UIView alloc]initWithFrame:self.frame];
    [container setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:container];
    [s enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //
        HuServiceUser *user = (HuServiceUser*)obj;
        UIImageView *profile_imgview = [[UIImageView alloc]initWithFrame:(CGRectMake(0, idx*50, 50, 50))];
        
        [profile_imgview setImageWithURL:[NSURL URLWithString:[user imageURL]] placeholderImage:[UIImage imageNamed:@"angry_unicorn_tiny.png"]];
        [container addSubview:profile_imgview];
                                                }];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end

@interface HuHumansProfileCarouselViewController () <iCarouselDataSource, iCarouselDelegate>

@end

@implementation HuHumansProfileCarouselViewController

HuUserHandler *userHandler;
iCarousel *carousel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle )preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];

    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) // only for iOS 7 and above
    {
        CGRect frame = self.navigationController.view.frame;
        if(frame.origin.y == 0) {
            frame.origin.y += 20;
            frame.size.height -= 20;
            self.navigationController.view.frame = frame;
            self.navigationController.view.backgroundColor = [UIColor greenColor];
            //[self.navigationController.view setNeedsDisplay];
            
        }
    }

    
    [self.view setFrame:self.parentViewController.view.frame];
	// Do any additional setup after loading the view.
    CGRect full = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    carousel = [[iCarousel alloc]initWithFrame:full];
    [carousel setBackgroundColor:[UIColor orangeColor]];
    [carousel setType:iCarouselTypeCustom];
    [carousel setDataSource:self];
    [carousel setDelegate:self];
    [carousel setVertical:YES];
    [self.view addSubview:carousel];
    
}

- (void)setHumansUserHandler:(HuUserHandler *)aUserHandler
{
    userHandler = aUserHandler;
}

#pragma mark iCarouselDelegate methods
//- (CATransform3D)carousel:(iCarousel *)mcarousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
//{
//
//}

- (CATransform3D)carousel:(iCarousel *)mcarousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    CGFloat spacing = [self carousel:carousel valueForOption:iCarouselOptionSpacing withDefault:1.0];
    return CATransform3DTranslate(transform, 0.0f, (offset - .5) * carousel.bounds.size.height/2 * spacing, 0.0f);
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    LOG_UI(0, @"Did select Item at Index %d", index );
}

//- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
//    CGFloat result = self.view.frame.size.width;
//    return result;
//}
//
- (CGFloat)carouselItemHeight:(iCarousel *)carousel {
    CGFloat result = self.view.frame.size.height;
    return result;
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
            if (carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.8f;
            }
            return value;
        }
        case iCarouselOptionVisibleItems:
        {
            return 4;
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
    NSUInteger result = [[[userHandler humans_user]humans]count];
    return result;
}

-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //HuHuman *human;
    NSArray *humans = [[userHandler humans_user]humans];
    CGRect full = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    CGRect half = CGRectMake(0, 0, carousel.bounds.size.width, carousel.bounds.size.height/2);
//    if(view == nil) {
    
    HuHumanProfileView *x = [[HuHumanProfileView alloc]initWithFrame:half human:[humans objectAtIndex:index]];
   UIView *v = [[UIView alloc]initWithFrame:half];
    [v setBackgroundColor:[UIColor colorWithWhite:0.3*index alpha:1.0]];
        view = x;
//    }
    
    return view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

