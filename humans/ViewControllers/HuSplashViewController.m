//
//  HuViewController.m
//  humans
//
//  Created by julian on 12/13/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import "HuSplashViewController.h"

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
    [self.view addSubview:buildLabel];
    UILabel *versionLabel = UILabel.new;
    [self.view addSubview:versionLabel];
    
    [buildLabel setTextAlignment:NSTextAlignmentCenter];
    [buildLabel setBackgroundColor:[UIColor clearColor]];
    [buildLabel setFont:HEADER_FONT];
    [buildLabel setTextColor:[UIColor crayolaManateeColor]];
    [buildLabel setTextColor:[UIColor crayolaManateeColor]];
    [buildLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.width.equalTo(self.view.mas_width);
        
    }];
    
    [versionLabel setTextAlignment:NSTextAlignmentCenter];
    [versionLabel setBackgroundColor:[UIColor clearColor]];
    [versionLabel setFont:HEADER_FONT];
    [versionLabel setTextColor:[UIColor Amazon]];
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buildLabel.mas_bottom);
        make.bottom.lessThanOrEqualTo(self.view.mas_bottom).with.offset(-8.0);
        make.height.equalTo(@15);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.width.equalTo(self.view.mas_width);
    }];
    
    
    NSString *shortVersionString = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [versionLabel setText:shortVersionString];
    NSString *build  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CWBuildNumber"];
#ifndef DEBUG
    LELog *log = [LELog sharedInstance];
    [log log:[NSString stringWithFormat:@"Splash %@ %@ %@", shortVersionString, version, build]];
#endif
    
#ifdef DEV
#ifdef DEBUG
    [buildLabel setText:[NSString stringWithFormat:@"%@-debug   build %@.d",version, build ]];
#else
    [buildLabel setText:[NSString stringWithFormat:@"%@-release   build %@.d",version, build ]];

#endif
#else
#ifdef DEBUG

    [buildLabel setText:[NSString stringWithFormat:@"%@-debug   build %@.p",version, build ]];
#else
    [buildLabel setText:[NSString stringWithFormat:@"%@-release   build %@.p",version, build ]];

#endif
#endif
//    [buildLabel setSize:CGSizeMake(40, 40)];
//
//    [buildLabel setSize:CGSizeMake(self.view.size.width, 40)];
    [buildLabel mc_setPosition:MCViewPositionBottomHCenter inView:self.view];
    
    NSDictionary *dimensions = @{@"key": CLUSTERED_UUID,@"start" : CLUSTERED_EDITION};
    [[LELog sharedInstance]log:dimensions];
    //[PFAnalytics trackEvent:@"start" dimensions:dimensions];
    //[Flurry logEvent:@"start" withParameters:dimensions];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    [self performBlock:^{
        [self loginViaKeychain];
    } afterDelay:3.0];

}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)loginViaKeychain
{
    //[PFAnalytics trackEvent:@"start" dimensions:dimensions];
    ////[Flurry logEvent:@"start" withParameters:dimensions];
    //[[FXKeychain defaultKeychain]objectForKey:@"username"];
    
    if([[FXKeychain defaultKeychain]objectForKey:@"username"] != nil) {
        NSDictionary *dimensions = @{@"key": CLUSTERED_UUID,@"username" : [[FXKeychain defaultKeychain]objectForKey:@"username"]};
        [[LELog sharedInstance]log:dimensions];
        // only one really
        NSString *username = [[FXKeychain defaultKeychain] objectForKey:@"username"];
        NSString *password = [[FXKeychain defaultKeychain] objectForKey:@"password"];
        
        [self loginWithUsername:username password:password completionHandler:^(BOOL success, NSError *error) {
            //
            NSDictionary *dimensions = @{@"key" : CLUSTERED_UUID ,@"edition" : CLUSTERED_EDITION, @"login-user" : username, @"success": success?@"YES":@"NO", @"error": error==nil?@"nil":[[error userInfo]description]};
            [[LELog sharedInstance]log:dimensions];
            if(success) {
                
                HuHumansProfileCarouselViewController *theHumansProfileCarousel = [delegate humansProfileCarouselViewController];
                UINavigationController *root = (UINavigationController*)delegate.window.rootViewController;
                [root pushViewController:theHumansProfileCarousel animated:YES];
            } else {
                //[PFAnalytics trackEvent:@"keychain-login" dimensions:dimensions];
                
                HuLoginViewController *loginViewController = [delegate loginViewController];
                UINavigationController *root = (UINavigationController*)delegate.window.rootViewController;
                [root pushViewController:loginViewController animated:YES];
            }
        }];
    } else {
        NSDictionary *dimensions = @{@"new-user" : CLUSTERED_UUID, @"edition" : CLUSTERED_EDITION};
        [[LELog sharedInstance]log:dimensions];
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
