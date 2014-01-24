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
//#import "UIImageView+AFNetworking.h"
#import <AFNetworking/AFNetworking.h>
#import "UIImage+Resize.h"
#import "defines.h"
#import "HuStatusCarouselViewController.h"
#import "UIControl+BlocksKit.h"
#import <BlocksKit/UIControl+BlocksKit.h>

@interface HuHumansScrollViewController ()
{
    //UINavigationController *navigator;
    MGLineStyled *header;
    MGLine *add_human;
    
}
@end

@implementation HuHumansScrollViewController

@synthesize arrayOfHumans;
@synthesize statusCarouselViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    __block HuHumansScrollViewController *bself = self;
    //navigator = [[UINavigationController alloc]initWithRootViewController:self];
    //[window.addSubview navigator];
    //[self.view addSubview:navigator.view];
	// Do any additional setup after loading the view.
    
    //    UIButton *button = [[UIButton alloc]initWithFrame:(CGRectMake(0, 0, self.view.width/4, HEADER_HEIGHT))];
    //    [button setBackgroundColor:[UIColor grayColor]];
    //    [button bk_addEventHandler:^(id sender) {
    //        [[self navigationController]popViewControllerAnimated:YES];
    //    } forControlEvents:UIControlEventTouchUpInside];
    //
    //
    //
    //    [self.view addSubview:button];
    
    
    
    UIImage *settings_bar_img = [UIImage imageNamed:@"settings-bars"];
    
    MGLine *settings_bar = [MGLine lineWithLeft:settings_bar_img right:nil size:[settings_bar_img size]];
    settings_bar.onTap = ^{
        LOG_UI(0, @"Tapped Settings Box");
        //settingsTapped = YES;
        //settingsTapped = NO;
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
        //        [[bself presentingViewController] dismissViewControllerAnimated:YES completion:^{
        //            //
        //        }];
         });
        
    };
    // add it to the view then lay it all out
    [self.view addSubview:header];
    [header layout];
    
    
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0]];
    //UIScrollView *scroller = [[UIScrollView alloc]initWithFrame:self.view.frame];
    
    
    
    MGScrollView *scroller = [MGScrollView scrollerWithSize:self.view.size];
    [scroller setFrame:CGRectMake(0, HEADER_HEIGHT, self.view.width, self.view.height-HEADER_HEIGHT)];
    [self.view addSubview:scroller];
    
    MGTableBox *section = MGTableBox.box;
    [scroller.boxes addObject:section];
    
    for (int i=0; i<[[self arrayOfHumans]count]; i++) {
        __block MGLineStyled *human_mgline = [MGLineStyled new];
        
        HuHuman *human = (HuHuman*)[arrayOfHumans objectAtIndex:i];
        CGSize rowSize = (CGSize){self.view.width, 80};
        
        human_mgline = [MGLineStyled lineWithLeft:nil right:nil size:rowSize];
        NSMutableArray *a = [[NSMutableArray alloc]initWithArray:@[[human name]]];
        [human_mgline setMiddleItems:a];
        
        [human_mgline setMiddleItemsAlignment:NSTextAlignmentLeft];
        UIFont *font = [UIFont fontWithName:@"Creampuff" size:24];
        [human_mgline setFont:font];
        
        [human loadServiceUsersProfileImagesWithCompletionHandler:^{
            //
            dispatch_async(dispatch_get_main_queue(), ^{
                //
                UIImage *profile_image = [human largestServiceUserProfileImage];
                profile_image = [profile_image resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                                    bounds:CGSizeMake(rowSize.height*.8,rowSize.height*.8) interpolationQuality:kCGInterpolationHigh];
                UIImageView *profile_iv = [[UIImageView alloc]initWithImage:profile_image];
                CALayer *maskLayer = [CALayer layer];
                UIImage *mask = [UIImage imageNamed:@"user-profile-image-mask-60px"];
                maskLayer.contents = (id)mask.CGImage;
                maskLayer.frame = (CGRect){CGPointZero, mask.size};
                
                profile_iv.image = profile_image;
                profile_iv.layer.mask = maskLayer;
                
                NSMutableArray *marray = [[NSMutableArray alloc]initWithArray:@[profile_iv]];
                [human_mgline setLeftItems:marray];
                
                [human_mgline layout];
                [scroller layout];
            });
            
        }];
        
        // a default row size
        
        
        // a header row
        //human_mgline = [MGLineStyled lineWithLeft:image_view right:[human name] size:rowSize];
        human_mgline.leftPadding = human_mgline.rightPadding = 16;
        human_mgline.topPadding = human_mgline.bottomPadding = 16;
        human_mgline.onTap = ^{
            LOG_UI(0, @"Tapped on %@", [human name]);
            [self showHuman:human];
        };
        [human_mgline layout];
        [section.topLines addObject:human_mgline];
    }
    
    [scroller layoutWithSpeed:2.3 completion:nil];
    [scroller scrollToView:section withMargin:0];
    
}

- (void)showHuman:(HuHuman *)human
{
    LOG_GENERAL(0, @"Would present %@", human);
    HuAppDelegate *delegate =  [[UIApplication sharedApplication]delegate];
    HuUserHandler *user_handler = [delegate humansAppUser];
    [user_handler getStatusForHuman:human withCompletionHandler:^(BOOL success, NSError *error) {
        //
        if(success) {
            LOG_GENERAL(0, @"Loaded Status for %@", human);
            //NSString *human_id = [human humanid]    ;
            NSArray *status = [user_handler statusForHuman:human];
            LOG_GENERAL(0, @"Count is %d", [status count]);
            statusCarouselViewController = [[HuStatusCarouselViewController alloc]init];
            //NSArray *items = (NSArray *)[[user_handler statusForHuman:human] copy];
            [statusCarouselViewController setItems:[[user_handler statusForHuman:human] copy]];
            [[self navigationController] pushViewController:statusCarouselViewController animated:YES];
            
            //        UIStoryboardSegue *segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"" source:self destination:statusCarouselViewController];
            //        [self prepareForSegue:segue sender:self];
            //        [segue perform];
            
            
            
            //        [self presentViewController:statusCarouselViewController animated:YES completion:^{
            //            LOG_UI(0, @"Presented for %d items of status", [[statusCarouselViewController items] count]);
            //        }];
        } else {
            LOG_ERROR(0, @"Error loading status %@", error);
        }
    }];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    LOG_UI(0, @"segue=%@ sender=%@", segue, sender);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
