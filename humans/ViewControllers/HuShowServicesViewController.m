//
//  HuConnectServicesViewController.m
//  humans
//
//  Created by Julian Bleecker on 2/8/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuShowServicesViewController.h"
#import <UIView+MCLayout.h>
#import "HuUserHandler.h"
#import "HuServiceViewLine.h"
#import "HuConnectServicesViewController.h"

@interface HuShowServicesViewController ()

@end

@implementation HuShowServicesViewController

MGScrollView *servicesScroller;
MGLine *check_;
//MGLineStyled *header;
MGLineStyled *statusUserHeader;
MGBox *userLine;
UIView *servicesView;
HuUserHandler *userHandler;
HuConnectServicesViewController *connectServicesViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self customInit];
        
        
    }
    return self;
}


-(void)customInit
{
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    userHandler = [delegate humansAppUser];
    connectServicesViewController = [[HuConnectServicesViewController alloc]init];
    [connectServicesViewController.view setBackgroundColor:[UIColor whiteColor]];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
   //HuShowServicesViewController *bself = self;
    
    UIImage *small_exbox_img = [UIImage imageNamed:@"delete-x-22sq"];//resizedImage:(CGSize){22,22}
    
    MGLine *ex_ = [MGLine lineWithLeft:small_exbox_img right:nil size:[small_exbox_img size]];
    ex_.onTap = self.tapOnEx;
    
    /**
    ^{
        LOG_UI(0, @"Tapped Ex Box");
        
        //LOG_GENERAL(0, @"%@", stateMachine.currentState.stateName);
        //bself.exTapped = YES;
        //[bself.stateMachine nextState:bself];
        //bself.exTapped = NO;
        //LOG_GENERAL(0, @"%@", stateMachine.currentState.stateName);
    };
    **/
    UIImage *small_checkbox_img = [UIImage imageNamed:@"add-cloud-gray.png"];
    
    check_ = [MGLine lineWithLeft:small_checkbox_img right:nil size:[small_checkbox_img size]];
    check_.alpha = 1.0;
    check_.onTap = ^{
        LOG_UI(0, @"Tapped Add Service");
        [[self navigationController]pushViewController:connectServicesViewController animated:YES];
        //LOG_GENERAL(0, @"%@", stateMachine.currentState.stateName);
    };
#pragma mark header setup
    //header
    self.header = [MGLineStyled lineWithLeft:ex_ right:check_ size:(CGSize){self.view.width,HEADER_HEIGHT}];
    [self.header setMiddleFont:HEADER_FONT];
    [self.header setMiddleTextColor:[UIColor darkGrayColor]];
    [self.header setMiddleItems:[NSMutableArray arrayWithObject:@"Profile"]];
    [self.header setMiddleItemsAlignment:NSTextAlignmentCenter];
    self.header.sidePrecedence = MGSidePrecedenceMiddle;
    self.header.padding = UIEdgeInsetsMake(4, 8, 4, 8);
    self.header.fixedPosition = (CGPoint){0,0};
    self.header.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    self.header.zIndex = 1;
    self.header.layer.cornerRadius = 0;
    self.header.layer.shadowOffset = CGSizeZero;
    [self.header setFrame:(CGRectMake(0, 0, self.view.width, HEADER_HEIGHT))];
    self.header.onTap = ^{
        LOG_UI(0, @"Tapped Header");
        //nextState++;
    };
    // add it to the view then lay it all out
    [self.view addSubview:self.header];
    [self.header layout];
    
    servicesScroller = [MGScrollView scroller];//  CGSizeMake(servicesView.size.width, servicesView.size.height-18)];
    [servicesScroller mc_setSize:CGSizeMake(self.view.width, self.view.size.height - self.header.size.height)];
    [servicesScroller mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:self.header];
    
    [servicesScroller setContentSize:servicesScroller.size];
    [servicesScroller setBackgroundColor:[UIColor whiteColor]];
    [servicesScroller setBounces:YES];
    __block NSArray *usersServices = [[userHandler humans_user]services];
    [usersServices enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //
        HuServices *services = (HuServices *)obj;
        HuServiceViewLine *serviceUserLine = [HuServiceViewLine lineWithSize:CGSizeMake(servicesScroller.width, 1.5*HEADER_HEIGHT)];
        [serviceUserLine setServices:services];
        //[[HuServiceViewLine alloc]initWithService:services];
        [serviceUserLine setBackgroundColor:[UIColor whiteColor]];
        [serviceUserLine setFont:HEADER_FONT_LARGE];
        [serviceUserLine setPadding:UIEdgeInsetsMake(5, 20, 5, 20)];
        UIView *bottomBorderView = [[UIView alloc]initWithFrame:(CGRectMake(10, 0, serviceUserLine.width - 10, 1))];
        [bottomBorderView setBackgroundColor:[UIColor lightGrayColor]];
        [serviceUserLine setBorderColors:serviceUserLine.backgroundColor];
        [serviceUserLine.bottomBorder addSubview:bottomBorderView];
        [serviceUserLine.bottomBorder setBackgroundColor:serviceUserLine.backgroundColor];
        
//        UIView *topBorderView = [[UIView alloc]initWithFrame:(CGRectMake(10, 0, serviceUserLine.width - 10, 1))];
//        [topBorderView setBackgroundColor:[UIColor lightGrayColor]];
//        [serviceUserLine setBorderColors:serviceUserLine.backgroundColor];
//        [serviceUserLine.topBorder addSubview:topBorderView];
//        [serviceUserLine.topBorder setBackgroundColor:serviceUserLine.backgroundColor];
//        
        __block HuServiceViewLine *bline = serviceUserLine;
        
        serviceUserLine.swiper.direction = UISwipeGestureRecognizerDirectionLeft;
        serviceUserLine.onSwipe = ^{
            LOG_UI(0, @"Swiped on @%@ for %@", [services serviceUsername], [services serviceName]);
           // bline.swiper.direction = UISwipeGestureRecognizerDirectionRight;
            // go through all the lines and basically move them back to where they are when reset
            [servicesScroller.boxes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                //
                if([obj isKindOfClass:[HuServiceViewLine class]] == false) {
                    HuServiceViewLine *b = (HuServiceViewLine*)obj;
                    if(b != bline) {
                        [UIView animateWithDuration:0.2 animations:^{
                            //
                            b.x = 0;
                        }];
                    }
                }
            }];
            if (bline.x == 0) {
                // change the swiper's accepted direction,
                // to allow swiping the line back to its original position
                bline.swiper.direction = UISwipeGestureRecognizerDirectionRight;
                [UIView animateWithDuration:0.2 animations:^{
                    bline.x = -100;
                }];
                
            } else {
                // change the swiper's accepted direction,
                // to allow it to be swiped to reveal delete again
                bline.swiper.direction = UISwipeGestureRecognizerDirectionLeft;
                [UIView animateWithDuration:0.2 animations:^{
                    bline.x = 0;
                }];
            }
            
        };
        
        [servicesScroller.boxes addObject:serviceUserLine];
    }];
    
//    MGLine *addServiceLine = [MGLine lineWithSize:CGSizeMake(servicesScroller.width, 1.5*HEADER_HEIGHT)];
//    [addServiceLine setLeftItems:[NSMutableArray arrayWithObjects:[UIImage imageNamed:@"add-cloud-gray.png"], @"  ", @"Add more accounts", nil]];
//    [addServiceLine setFont:HEADER_FONT];
//    addServiceLine.onTap = ^{
//        LOG_UI(0, @"You tapped?");
//        
//    };
//    
//    [servicesScroller.boxes addObject:addServiceLine];
    
    [servicesView addSubview:servicesScroller];
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in servicesScroller.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    servicesScroller.contentSize = contentRect.size;
    [servicesScroller layoutWithSpeed:0.3 completion:^{
        //
        LOG_UI(0, @"Done laying out.");
    }];
    
    [self.view addSubview:servicesScroller];
    
    [connectServicesViewController.view setSize:self.view.size];
    
}

-(void)loadView
{
    [super loadView];
    
    //    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    //    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    //    contentView.backgroundColor = [UIColor blackColor];
    //    self.view = contentView;
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
