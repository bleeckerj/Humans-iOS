//
//  HuHumansScrollViewController.m
//  humans
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

@interface HuHumansScrollViewController ()

@end

@implementation HuHumansScrollViewController

@synthesize arrayOfHumans;

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
    
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0]];
    //UIScrollView *scroller = [[UIScrollView alloc]initWithFrame:self.view.frame];
    
    MGScrollView *scroller = [MGScrollView scrollerWithSize:self.view.size];
    [scroller setFrame:CGRectMake(0, 30, self.view.width, self.view.height)];
    [self.view addSubview:scroller];
    
    MGTableBox *section = MGTableBox.box;
    [scroller.boxes addObject:section];
    
    for (int i=0; i<[[self arrayOfHumans]count]; i++) {
        __block MGLineStyled *human_mgline;
        
        HuHuman *human = (HuHuman*)[arrayOfHumans objectAtIndex:i];

        // a default row size
        CGSize rowSize = (CGSize){self.view.width, 80};
        NSString *url = [[human serviceUserProfileImages]objectAtIndex:1];
        NSURL *image_url = [[NSURL alloc]initWithString:url];
        UIImageView *human_image = [[UIImageView alloc] init];
        
        [human_image setImageWithURLRequest:[NSURLRequest requestWithURL:image_url] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            //
            image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(rowSize.height,rowSize.height) interpolationQuality:kCGInterpolationHigh];
            __strong UIImageView *iv = [[UIImageView alloc]initWithImage:image];
            iv.layer.masksToBounds = YES;
            [[iv layer]setCornerRadius:20.0];
            human_mgline.leftItems = [NSMutableArray arrayWithObjects:iv, nil];
           [human_mgline layout];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            //
            LOG_NETWORK(0, @"Failed to async load profile image %@ %@", url, error);
        }];
        // a header row
        human_mgline = [MGLineStyled lineWithLeft:human_image right:[human name] size:rowSize];
        human_mgline.leftPadding = human_mgline.rightPadding = 16;
        human_mgline.topPadding = human_mgline.bottomPadding = 16;
        human_mgline.onTap = ^{
            LOG_UI(0, @"Tapped on %@", [human name]);
            [self showHuman:human];
        };
        
        
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
        LOG_GENERAL(0, @"Loaded Status for %@", human);
        NSString *human_id = [human humanid]    ;
        NSArray *status = [user_handler statusForHuman:human];
        LOG_GENERAL(0, @"Count is %d", [status count]);
        HuStatusCarouselViewController *status_vc = [[HuStatusCarouselViewController alloc]init];
        //NSArray *items = (NSArray *)[[user_handler statusForHuman:human] copy];
        [status_vc setItems:[[user_handler statusForHuman:human] copy]];
        [self presentViewController:status_vc animated:YES completion:^{
            //
            LOG_UI(0, @"Presented for %d items of status", [[status_vc items] count]);
            
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
