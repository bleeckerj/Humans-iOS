//
//  HuViewController.m
//  humans
//
//  Created by julian on 12/13/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import "HuSplashViewController.h"
#import "defines.h"

@interface HuSplashViewController ()

@end

@implementation HuSplashViewController
{
//    HuLoginViewController *loginViewController;
//    HuSignUpViewController *signUpViewController;
    HuAppDelegate *delegate;
}

- (id)init
{
    self = [super init];
    if(self) {
        [self commonInit];
    }
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    delegate = [[UIApplication sharedApplication]delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *splash = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Humans-iPhone"]];
    [self.view addSubview:splash];
    
    UILabel *buildLabel = [[UILabel alloc]init];
    [buildLabel setTextAlignment:NSTextAlignmentCenter];
    [buildLabel setBackgroundColor:[UIColor clearColor]];
    [buildLabel setFont:HEADER_FONT];
    [buildLabel setTextColor:[UIColor crayolaManateeColor]];
    
    [self.view addSubview:buildLabel];
    
    NSString *shortVersionString = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *build  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CWBuildNumber"];
#ifdef DEV
#ifdef DEBUG
    [buildLabel setText:[NSString stringWithFormat:@"%@-debug   version %@   build %@.d",shortVersionString, version, build ]];
#else
    [buildLabel setText:[NSString stringWithFormat:@"%@-release   version %@   build %@.d",shortVersionString, version, build ]];

#endif
#else
#ifdef DEBUG

    [buildLabel setText:[NSString stringWithFormat:@"%@-debug   version %@   build %@.p",shortVersionString, version, build ]];
#else
    [buildLabel setText:[NSString stringWithFormat:@"%@-release   version %@   build %@.p",shortVersionString, version, build ]];

#endif
#endif
    [buildLabel setSize:CGSizeMake(self.view.size.width, 40)];
    [buildLabel mc_setPosition:MCViewPositionBottomHCenter inView:self.view];
    
    NSDictionary *dimensions = @{@"start" : @"viewDidLoad"};
    [PFAnalytics trackEvent:@"start" dimensions:dimensions];
    //[Flurry logEvent:@"start" withParameters:dimensions];
    [TestFlight passCheckpoint:@"Splash Screen Did Load"];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    //[self performBlock:^{
        [self loginViaKeychain];
    //} afterDelay:6.0];

}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)loginViaKeychain
{
    NSDictionary *dimensions = @{@"start" : @"loginViaKeychain"};
    [PFAnalytics trackEvent:@"start" dimensions:dimensions];
    ////[Flurry logEvent:@"start" withParameters:dimensions];
    
    

    [[FXKeychain defaultKeychain]objectForKey:@"username"];
    
    
    if([[FXKeychain defaultKeychain]objectForKey:@"username"] != nil) {
        // only one really
        NSString *username = [[FXKeychain defaultKeychain] objectForKey:@"username"];
        NSString *password = [[FXKeychain defaultKeychain] objectForKey:@"password"];
        [self loginWithUsername:username password:password completionHandler:^(BOOL success, NSError *error) {
            //
            NSDictionary *dimensions = @{@"user": username, @"success": success?@"YES":@"NO", @"error": error==nil?@"nil":[[error userInfo]description]};

            if(success) {
                [PFAnalytics trackEvent:@"keychain-login" dimensions:dimensions];
                //[Flurry logEvent:@"keychain-login" withParameters:dimensions];
                [TestFlight passCheckpoint:@"keychain-login"];

                HuHumansProfileCarouselViewController *theHumansProfileCarousel = [delegate humansProfileCarouselViewController];
                UINavigationController *root = (UINavigationController*)delegate.window.rootViewController;
                [root pushViewController:theHumansProfileCarousel animated:YES];
            } else {
                [PFAnalytics trackEvent:@"keychain-login" dimensions:dimensions];
                ////[Flurry logEvent:@"keychain-login" withParameters:dimensions];
                
                HuLoginViewController *loginViewController = [delegate loginViewController];
                UINavigationController *root = (UINavigationController*)delegate.window.rootViewController;
                [root pushViewController:loginViewController animated:YES];
            }
        }];
    } else {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HuLoginOrSignUpViewController *loginOrSignUpViewController = [storyBoard instantiateViewControllerWithIdentifier:@"HuLoginOrSignUpViewController"];
        UINavigationController *root = (UINavigationController*)delegate.window.rootViewController;
        
        [root pushViewController:loginOrSignUpViewController animated:YES];
    }
    
    
}

- (HuSignUpViewController *)signUpViewController
{
    HuSignUpViewController
        *signUpViewController = [delegate signUpViewController];
        //        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        signUpViewController = [storyBoard instantiateViewControllerWithIdentifier:@"HuSignUpViewController"];
    
    [[signUpViewController usernameTextField]setText:@""];
    [[signUpViewController passwordTextField]setText:@""];
    [[signUpViewController emailTextField]setText:@""];
    return signUpViewController;
}


- (HuLoginViewController *)loginViewController
{
    
    HuLoginViewController *loginViewController = [delegate loginViewController];
    
    [[loginViewController usernameTextField]setText:@""];
    [[loginViewController passwordTextField]setText:@""];
    return loginViewController;
}


// try to login
- (void)loginWithUsername:(NSString *)username password:(NSString *)password completionHandler:(CompletionHandlerWithResult)completionHandler
{
    HuUserHandler *userHandler = [delegate humansAppUser];
    [userHandler userRequestTokenForUsername:username forPassword:password withCompletionHandler:^(BOOL success, NSError *error) {
        //
        if(success) {
            if(completionHandler) {
                completionHandler(YES, nil);
            }
        } else {
            if(completionHandler) {
                completionHandler(NO, error);
            }
        }
    }];
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
