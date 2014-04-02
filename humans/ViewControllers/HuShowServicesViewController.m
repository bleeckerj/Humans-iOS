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
#import "HuConnectServicesViewController.h"
#import "HuServiceViewLine.h"

@interface HuShowServicesViewController ()

@end

@implementation HuShowServicesViewController
{
    BOOL didSomething;
}

MGScrollView *servicesScroller;
MGLine *check_;
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
    didSomething = NO;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIImage *small_exbox_img = [UIImage imageNamed:@"delete-x-22sq"];//resizedImage:(CGSize){22,22}
    
    MGLine *ex_ = [MGLine lineWithLeft:small_exbox_img right:nil size:[small_exbox_img size]];
    ex_.onTap = ^{
        LOG_UI(0, @"Tapped Ex");
        __block HuShowServicesViewController *bself = self;
        if(didSomething == YES) {
            didSomething = NO;
            [userHandler getHumansWithCompletionHandler:^(BOOL success, NSError *error) {
                [userHandler userGettyUpdateYoumanWithCompletionHandler:^(BOOL success, NSError *error) {
                    [bself.navigationController popViewControllerAnimated:YES];
                }];
            }];
            
        } else {
            [bself.navigationController popViewControllerAnimated:YES];
        }
    };
    
    UIImage *small_checkbox_img = [UIImage imageNamed:@"add-cloud-gray.png"];
    
    check_ = [MGLine lineWithLeft:small_checkbox_img right:nil size:[small_checkbox_img size]];
    check_.alpha = 1.0;
    check_.onTap = ^{
        LOG_UI(0, @"Tapped Add Service");
        didSomething = YES;
        [[self navigationController]pushViewController:connectServicesViewController animated:YES];
        //LOG_GENERAL(0, @"%@", stateMachine.currentState.stateName);
    };
#pragma mark header setup
    //header
    self.header = [MGLineStyled lineWithLeft:ex_ right:check_ size:(CGSize){self.view.width,HEADER_HEIGHT}];
    [self.header setMiddleFont:HEADER_FONT_LARGE];
    [self.header setMiddleTextColor:[UIColor blackColor]];
    [self.header setMiddleItems:[NSMutableArray arrayWithObject:@"Services"]];
    [self.header setMiddleItemsAlignment:NSTextAlignmentCenter];
    self.header.sidePrecedence = MGSidePrecedenceMiddle;
    self.header.padding = UIEdgeInsetsMake(4, 8, 4, 8);
    self.header.fixedPosition = (CGPoint){0,0};
    self.header.backgroundColor = [UIColor whiteColor];
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
    
    [servicesScroller setContentSize:CGSizeMake(servicesScroller.size.width, servicesScroller.size.height+20)];
    [servicesScroller setBackgroundColor:[UIColor whiteColor]];
    [servicesScroller setBounces:YES];
    
    
    [servicesView addSubview:servicesScroller];
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in servicesScroller.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    servicesScroller.contentSize = contentRect.size;
    [servicesScroller layoutWithSpeed:0.3 completion:^{
        //
        //LOG_UI(0, @"Done laying out.");
    }];
    
    [self.view addSubview:servicesScroller];
    
    [connectServicesViewController.view setSize:self.view.size];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [userHandler getHumansWithCompletionHandler:^(BOOL success, NSError *error) {
        if(success) {
            [servicesScroller.boxes removeAllObjects];
        __block NSArray *usersServices = [[userHandler humans_user]services];
        [usersServices enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            //
            HuServices *service = (HuServices *)obj;
            HuServiceViewLine *serviceUserLine = [HuServiceViewLine lineWithSize:CGSizeMake(servicesScroller.width, 1.5*HEADER_HEIGHT)];
            [serviceUserLine setService:service];
            [serviceUserLine setDelegate:self];
            [serviceUserLine setBackgroundColor:[UIColor whiteColor]];
            [serviceUserLine setFont:PROFILE_VIEW_FONT_SMALL];
            [serviceUserLine setPadding:UIEdgeInsetsMake(5, 20, 5, 20)];
            UIView *bottomBorderView = [[UIView alloc]initWithFrame:(CGRectMake(10, 0, serviceUserLine.width - 10, 1))];
            [bottomBorderView setBackgroundColor:[UIColor lightGrayColor]];
            [serviceUserLine setBorderColors:serviceUserLine.backgroundColor];
            [serviceUserLine.bottomBorder addSubview:bottomBorderView];
            [serviceUserLine.bottomBorder setBackgroundColor:serviceUserLine.backgroundColor];
            
            
            [servicesScroller.boxes addObject:serviceUserLine];
            
            //[servicesScroller.boxes addObject:serviceUserLine.underneath];
        }];
            CGRect contentRect = CGRectZero;
            for (UIView *view in servicesScroller.subviews) {
                contentRect = CGRectUnion(contentRect, view.frame);
            }
            servicesScroller.contentSize = contentRect.size;
            [servicesScroller layoutWithSpeed:0.3 completion:^{
                //
                //LOG_UI(0, @"Done laying out.");
            }];
        }

    }];
}

-(void)loadView
{
    [super loadView];
}

#pragma mark HuServiceViewLineDelegate methods
- (void)lineDidDelete:(HuServiceViewLine *)lineDeleted
{
    didSomething = YES;
    [servicesScroller.boxes removeObject:lineDeleted];
    dispatch_async(dispatch_get_main_queue(), ^{
        [servicesScroller layoutWithSpeed:0.5 completion:^{
            //
            __block NSArray *usersServices = [[userHandler humans_user]services];
            LOG_UI(0, @"Now services array is %@", usersServices);
        }];
    });
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end