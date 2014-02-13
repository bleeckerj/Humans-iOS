//
//  HuTopViewController.m
//  humans
//
//  Created by julian on 1/25/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuSlidingViewController.h"
#import <UIControl+BlocksKit.h>
#import <BButton.h>
#import <UIView+MCLayout.h>
#import "HuShowServicesViewController.h"

@interface HuSettingsViewController : UIViewController

@end

@implementation HuSettingsViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end


@interface HuSlidingViewController ()
{
    HuSettingsViewController *underLeftViewController;
    HuShowServicesViewController *showServicesViewController;
    UIViewController *firstTopViewController;
}
@end

@implementation HuSlidingViewController

//@synthesize humansScrollViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self setup];
    }
    return self;
}

- (id)initWithTopViewController:(UIViewController *)topViewController
{
    self = [super init];
    if(self) {
        self.topViewController = topViewController;
        firstTopViewController = topViewController;
        [self setupUnderViews];
    }
    return self;
}


- (void)setupUnderViews
{
    underLeftViewController  = [[HuSettingsViewController alloc] init];
    
    // configure under left view controller
    underLeftViewController.view.layer.borderWidth     = 5;
    underLeftViewController.view.layer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    underLeftViewController.view.layer.borderColor     = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    underLeftViewController.edgesForExtendedLayout     = UIRectEdgeTop | UIRectEdgeBottom | UIRectEdgeLeft; // don't go under the top view
    __block HuSlidingViewController *bself = self;
    __block UIViewController   *bfirst = firstTopViewController;
    showServicesViewController = [[HuShowServicesViewController alloc]init];
    [showServicesViewController setTapOnEx:^{
        LOG_UI(0, @"You tapped on the Ex on the Show Services Screen");
        bself.topViewController = bfirst;
 //       [bself anchorTopViewToRightAnimated:YES onComplete:^{
            [bself resetTopViewAnimated:NO onComplete:^{
                //
                LOG_UI(0, @"Doesn't seem right..");
            }];
 //       }];
    }];

    [showServicesViewController.view setBackgroundColor:[UIColor whiteColor]];
    [showServicesViewController.header addGestureRecognizer:self.panGesture];
    
    //                    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mySelector:)];
    
    
    // configure under right view controller
//    underRightViewController.view.layer.borderWidth     = 20;
//    underRightViewController.view.layer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
//    underRightViewController.view.layer.borderColor     = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
//    underRightViewController.edgesForExtendedLayout     = UIRectEdgeTop | UIRectEdgeBottom | UIRectEdgeRight; // don't go under the top view
    
    [self setUnderLeftViewController:underLeftViewController];
//    [self setUnderRightViewController:underRightViewController];
//    [self setAnchorRightPeekAmount:100.0];
    [self setAnchorRightPeekAmount:110.0];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self.topViewController action:@selector(doubleTapTop:)];
    [tapGesture setNumberOfTapsRequired:2];
    [self.underLeftViewController.view addGestureRecognizer:tapGesture];

    //[self.topViewController.view addGestureRecognizer:self.panGesture];
    
    
    
    CGRect frameRect = CGRectMake(underLeftViewController.view.layer.borderWidth*2,
                                  underLeftViewController.view.layer.borderWidth*2,
                                  self.anchorRightRevealAmount - underLeftViewController.view.layer.borderWidth*4,
                                  80);
    
    UIButton *settingsButton = [[UIButton alloc]initWithFrame:frameRect];
    [settingsButton setBackgroundColor:[UIColor orangeColor]];
    [settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
    
    [settingsButton bk_addEventHandler:^(id sender) {
        //
        LOG_UI(0, @"Hey. You touched %@", sender);
        
        UINavigationController *c = [[UINavigationController alloc]initWithRootViewController:showServicesViewController];
        [c setNavigationBarHidden:YES];

        self.topViewController = c; //connectServices;
        
        [self resetTopViewAnimated:YES];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    BButton *button = [[BButton alloc]init];
    [button setType:BButtonTypePrimary];
    [button setStyle:BButtonStyleBootstrapV3];
    [button setSize:settingsButton.size];
    
    [button bk_addEventHandler:^(id sender) {
        //
        LOG_UI(0, @"Hey! You touched bbuton %@", sender);
    } forControlEvents:UIControlEventTouchUpInside];
    [[BButton appearance] setButtonCornerRadius:[NSNumber numberWithFloat:10.0f]];
    [button setTitle:@"Settings" forState:UIControlStateNormal];
    //[button mc_setPosition:MCViewRelativePositionUnderCentered ]
    [button mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:settingsButton withMargins:UIEdgeInsetsMake(10, 0, 0, 0)];
    [underLeftViewController.view addSubview:settingsButton];
    [underLeftViewController.view addSubview:button];
    
    BButton *b2 = [[BButton alloc]initWithFrame:CGRectMake(10, 10, 100, 80) color:[UIColor orangeColor] style:BButtonStyleBootstrapV3 icon:FAIconCogs fontSize:32];
    
    //[BButton awesomeButtonWithOnlyIcon:FAIconCogs color:[UIColor orangeColor] style:BButtonStyleBootstrapV3];
    [b2 setSize:CGSizeMake(100, 100)];
    
    [b2 mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:button withMargins:UIEdgeInsetsMake(10, 0, 0, 0)];
    //[b2 setTitle:@"Settings" forState:UIControlStateNormal];
    [underLeftViewController.view addSubview:b2];
    [b2 bk_addEventHandler:^(id sender) {
        //
        LOG_UI(0, @"Oooh! You touched bbuton %@", sender);
        // switch Top
        
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)doubleTapTop:(id)gesture
{
    LOG_UI(0, @"Double Tap Top %@", gesture);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) // only for iOS 7 and above
    {
        CGRect frame = self.navigationController.view.frame;
        if(frame.origin.y == 0) {
            
            frame.origin.y += 20;
            frame.size.height -= 20;
            self.navigationController.view.frame = frame;
            self.navigationController.view.backgroundColor = [UIColor orangeColor];
            
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPanGestureRecognizer action

//- (void)detectPanGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
//    
//    CGFloat translationX  = [recognizer translationInView:self.view].x;
//    CGFloat velocityX     = [recognizer velocityInView:self.view].x;
//
//    if(velocityX > 300) {
//        SEL setup = @selector(detectPanGestureRecognizer:);
//        [super performSelectorOnMainThread:setup withObject:recognizer waitUntilDone:YES];
//        LOG_UI(0, @"translationX=%f, velocityX=%f", translationX, velocityX);
//
//    }
////    [self.defaultInteractiveTransition updateTopViewHorizontalCenterWithRecognizer:recognizer];
////    _isInteractive = NO;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

