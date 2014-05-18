//
//  HuAddDeleteHumanViewController.m
//  humans
//
//  Created by Julian Bleecker on 3/1/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuAddDeleteServiceUserCarouselViewController.h"

@interface HuAddDeleteServiceUserCarouselViewController ()

@end

@implementation HuAddDeleteServiceUserCarouselViewController
@synthesize deletesWereMade;
@synthesize addMoreHuman;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        addMoreHuman = NO;
        deletesWereMade = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LOG_UI(0, @"presented within here: %@ %@ %@",NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.formSheetController.view.bounds), self.formSheetController.view);
    [self.carousel setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.carousel reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = self.formSheetController.view.frame;
    
    LOG_UI(0, @"huh what? %@ %@ %@", NSStringFromCGRect(self.formSheetController.view.frame), NSStringFromCGRect(self.formSheetController.view.bounds), NSStringFromCGRect(self.view.frame));
    
    
    //self.view.superview.bounds = CGRectMake(0, 0, 100, 100);
    //[self.view.superview setBackgroundColor:[UIColor redColor]];
    self.carousel = [[iCarousel alloc]initWithFrame:self.view.frame];
    [self.carousel setDelegate:self];
    [self.carousel setDataSource:self];
    [self.carousel setDecelerationRate:0.75];
    [self.carousel setBounceDistance:0.5];
    
    [self.view setAutoresizesSubviews:YES];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    [self.view setBackgroundColor:[UIColor greenColor]];
	// Do any additional setup after loading the view.
    
    // self.view.frame = self.parentViewController.view.frame;
    self.showStatusBar = NO;
    [self.carousel setType:iCarouselTypeLinear];
    
    [self.carousel setBackgroundColor:[UIColor whiteColor]];
    //[self.carousel reloadData];
    [self.view addSubview:self.carousel];
    self.carousel.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    
}

- (void)reloadData
{
    dispatch_async(dispatch_get_main_queue(), ^{
            [self.carousel reloadData];
    });

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.showStatusBar = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // your own style
}

- (BOOL)prefersStatusBarHidden
{
    return self.showStatusBar;
}


#pragma mark iCarouselDataSource methods


#pragma mark iCarouselDelegate methods
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [[self.human serviceUsers]count] + 1;
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    CGRect view_frame = CGRectInset(carousel.bounds, 10, 10);
    
    if(index == [self numberOfItemsInCarousel:carousel]-1) {
        UIView *add_service_user_view = [[UIView alloc]initWithFrame:carousel.bounds];

        add_service_user_view.layer.borderColor = [[UIColor crayolaManateeColor]CGColor];
        add_service_user_view.layer.borderWidth = 0.5;
        add_service_user_view.layer.shadowColor = [[UIColor crayolaManateeColor]CGColor];
        add_service_user_view.layer.shadowOffset = CGSizeMake(5, 5);
        add_service_user_view.layer.shadowOpacity = .2;
        add_service_user_view.layer.shadowRadius = 4;
        add_service_user_view.layer.cornerRadius = 4;
        add_service_user_view.layer.masksToBounds = YES;
#pragma mark === add more human button event stuff
        FUIButton *add_user = [[FUIButton alloc]initWithFrame:view_frame];
        [add_user setTitle:@"Add More Human" forState:UIControlStateNormal];
        [[add_user titleLabel]setFont:BUTTON_FONT_LARGE];
        [add_user setButtonColor:[UIColor crayolaCaribbeanGreenColor]];
        UIColor *foo = [UIColor crayolaCaribbeanGreenColor];
        [add_user setHighlightedColor:foo];
        add_user.layer.cornerRadius = 4;
        [add_service_user_view addSubview:add_user];
        
        [add_user bk_addEventHandler:^(id sender) {
            // bunky flag we'll use to tell the HuEditHumanViewController to pop-up HuJediMiniViewController
            addMoreHuman = YES;
            
            [[self formSheetController]dismissAnimated:YES completionHandler:nil ];
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        return add_service_user_view;
    } else {
    
    HuServiceUser *service_user = [[self.human serviceUsers]objectAtIndex:index];
    UIView *service_user_view = [[UIView alloc]initWithFrame:view_frame];
    service_user_view.layer.borderColor = [[UIColor crayolaManateeColor]CGColor];
    service_user_view.layer.borderWidth = 0.5;
    service_user_view.layer.shadowColor = [[UIColor crayolaManateeColor]CGColor];
    service_user_view.layer.shadowOffset = CGSizeMake(5, 5);
    service_user_view.layer.shadowOpacity = .2;
    service_user_view.layer.shadowRadius = 4;
    service_user_view.layer.cornerRadius = 4;
    service_user_view.layer.masksToBounds = YES;

    [service_user_view setBackgroundColor:[UIColor whiteColor]];
    
    
    NSURLRequest *req = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[service_user imageURL]]];
    UIImageView *profile_image_view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0.5*service_user_view.frame.size.height, 0.5*service_user_view.frame.size.height)];
    [service_user_view addSubview:profile_image_view];
    
    // same size
    UIImageView *service_image_view = [[UIImageView alloc]initWithFrame:profile_image_view.frame];
    [service_user_view addSubview:service_image_view];
    // but underneath
    [service_image_view mc_setRelativePosition:MCViewRelativePositionToTheRightAlignedTop toView:profile_image_view withMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    
    //CGSize size = CGSizeMake(service_user_view.frame.size.height, service_user_view.frame.size.height);
    
    [WSLObjectSwitch switchOn:[service_user serviceName] defaultBlock:^{
    } cases:
     @"twitter", ^{
         UIImage *img = [UIImage imageNamed:TWITTER_COLOR_IMAGE];
         [service_image_view setImage:img];
         //[service_image_view setImage:[[UIImage imageNamed:TWITTER_COLOR_IMAGE] thumbnailImage:0.5*service_user_view.frame.size.height transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh]];
     },
     @"flickr", ^{
         UIImage *img = [UIImage imageNamed:FLICKR_COLOR_IMAGE];
         [service_image_view setImage:img];

         //[service_image_view setImage:[[UIImage imageNamed:FLICKR_COLOR_IMAGE] thumbnailImage:0.5*service_user_view.frame.size.height transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh]];
         
         
     },
     @"instagram", ^{
         [service_image_view setImage:[UIImage imageNamed:INSTAGRAM_COLOR_IMAGE]];
         
     },
     @"foursquare", ^{
         [service_image_view setImage:[UIImage imageNamed:FOURSQUARE_GRAY_IMAGE]];
         
     },
     @"tumblr", ^{
         [service_image_view setImage:[UIImage imageNamed:TUMBLR_COLOR_IMAGE]];
         
     },
     @"facebook", ^{
         [service_image_view setImage:[UIImage imageNamed:FACEBOOK_COLOR_IMAGE]];
         
     }
     ,nil
     ];
    
    
    
    __block UIImageView *weak = profile_image_view;
    dispatch_async(dispatch_get_main_queue(), ^{
        [profile_image_view setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"angry_unicorn.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            [weak setImage:[image thumbnailImage:0.5*service_user_view.frame.size.height transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh]];
            [weak layoutSubviews];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            //
            LOG_ERROR(0, @"Wasn't able to load the profile image %@", error);
            weak.image = [UIImage imageNamed:@"angry_unicorn.png"];
        }];
    });
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view_frame.size.width, 0.5*view_frame.size.height)];
    [service_user_view addSubview:label];

    [label setBackgroundColor:[UIColor whiteColor]];
    [label mc_setPosition:MCViewPositionBottomHCenter inView:service_user_view];
    [label setFont:HEADER_FONT_LARGE];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    NSString *name = [NSString stringWithFormat:@"@%@",[[[self.human serviceUsers]objectAtIndex:index]username]];
    [label setText:name];
    
    UIButton *delete = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0.5*service_user_view.frame.size.height, 0.5*service_user_view.frame.size.height)];
    [service_user_view addSubview:delete];
    [delete setBackgroundColor:[UIColor crayolaRadicalRedColor]];
    [delete setTitle:@"Delete" forState:UIControlStateNormal];
    [[delete titleLabel]setFont:BUTTON_FONT_SMALL];
    [delete mc_setPosition:MCViewPositionRight inView:service_user_view];
#pragma mark **** delete service user event handler ****
    [delete bk_addEventHandler:^(id sender) {
        //
        __block MRProgressOverlayView *noticeView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
        noticeView.mode = MRProgressOverlayViewModeIndeterminateSmall;
        noticeView.titleLabelText = [NSString stringWithFormat:@"Deleting %@..", [service_user username]];
        
        HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        HuUserHandler *handler = [delegate humansAppUser];
        [handler humanRemoveServiceUser:service_user forHuman:self.human withCompletionHandler:^(BOOL success, NSError *error) {
            if(success) {
                LOG_UI(0, @"Delete %@", [service_user username]);

                deletesWereMade = YES;
                [handler getHumansWithCompletionHandler:^(BOOL success, NSError *error) {
                    
                    if(success) {
                        // make sure our human is up to date given that we just deleted
                        HuUser *user = [handler humans_user];
                        self.human = [user getHumanByID:self.human.humanid];
                        
                        [carousel removeItemAtIndex:index animated:YES];
                        [self reloadData];
                        
                        [self performBlock:^{
                            [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
                        } afterDelay:0.5];
                    } else {
                        NSDictionary *dimensions = @{@"key": CLUSTERED_UUID,@"service-user-id": [service_user id], @"service-user-username" : [service_user username], @"success": success?@"YES":@"NO", @"error": error==nil?@"nil":[[error userInfo]description]};
                        
                        LELog *log = [LELog sharedInstance];
                        [log log:dimensions];
                    }

                }];
                
                
            } else {
                LOG_ERROR(0, @"Problem deleting a user");
                
                noticeView.titleLabelText = [NSString stringWithFormat:@"There was a problem deleting %@", [service_user username]];
                [self performBlock:^{
                    [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
                } afterDelay:4.0];
                
                NSDictionary *dimensions = @{@"key": CLUSTERED_UUID,@"service-user-id": [service_user id], @"service-user-username" : [service_user username], @"success": success?@"YES":@"NO", @"error": error==nil?@"nil":[[error userInfo]description]};
                LELog *log = [LELog sharedInstance];
                [log log:dimensions];
            }

        }];
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    return service_user_view;
    }
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    // we'll load images well in advance this way, i think
    // cause of - carousel:(iCarousel *)mcarousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
    if(option == iCarouselOptionVisibleItems) {
        return 3;
    }
    if(option == iCarouselOptionSpacing) {
        return 1.2;
    }
    if(option == iCarouselOptionRadius) {
        return 10;
    }
    if(option == iCarouselOptionOffsetMultiplier) {
        return 0.8;
    }
    if(option == iCarouselOptionWrap) {
        return YES;
    }
    
    //    if(option == iCarouselOptionArc) {
    //        return M_PI;
    //    }
    else {
        return value;
    }
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
