//
//  HuAppDelegate.m
//  humans
//
//  Created by julian on 12/13/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import "HuAppDelegate.h"
#import "LoggerClient.h"
#import "defines.h"
#import <Crashlytics/Crashlytics.h>
//#import "Flurry.h"
#import <Parse/Parse.h>
#import "HuHumansProfileCarouselViewController.h"

@implementation HuAppDelegate
{
    HuLoginViewController *loginViewController;
    HuSignUpViewController *signUpViewController;
    HuHumansProfileCarouselViewController *humansProfileCarouselViewController;
}
@synthesize humansAppUser;
@synthesize jediFindFriendsViewController;

//@synthesize findFollowsMainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [TestFlight takeOff:@"7d627af6-7629-44dc-8103-a7a1baa81d03"];
    // The rest of your application:didFinishLaunchingWithOptions method// ...
    
    [Parse setApplicationId:@"RBemMZQt31HNHJBfEXTj5oFcxo1ZBwbiZDutTbAe"
                  clientKey:@"rOKCHpW5MnjSHwCgLAGFQk72UNvZNzdKUbQ4qXeW"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //[Flurry startSession:@"W63YQC9B83PWB64HT8VF"];
    [application setStatusBarHidden:NO];

    [self setupApplication];
    
    return YES;
}

- (void) setupApplication {
    // Override point for customization after application launch.
    LoggerInit();
    
    
    LoggerStart(LoggerGetDefaultLogger());
    
    LOG_GENERAL(0, @"Are we running?");
    LOG_UI(0, @"Model %@ IS_IPHONE? %@", [ [ UIDevice currentDevice ] model ], (IS_IPHONE?@"YES":@"NO"));
    LOG_UI(0, @"Widescreen %d", ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON ));
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager.imageDownloader setDownloadTimeout:45.0];
    
    //    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    //    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *d = [[NSMutableDictionary alloc]init];
    [defaults registerDefaults:@{@"lastPeeks" : d}];
    [defaults synchronize];
    
    //        for (NSString* family in [UIFont familyNames])
    //        {
    //            NSLog(@"%@", family);
    //
    //            for (NSString* name in [UIFont fontNamesForFamilyName: family])
    //            {
    //                NSLog(@"  %@", name);
    //            }
    //        }
    
    humansAppUser = [[HuUserHandler alloc]init];
    
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    loginViewController = [storyBoard instantiateViewControllerWithIdentifier:@"HuLoginViewController"];
    //    signUpViewController = [[HuSignUpViewController alloc]init];//[storyBoard instantiateViewControllerWithIdentifier:@"HuSignUpViewController"];
    
    HuSplashViewController *splash = [storyBoard instantiateViewControllerWithIdentifier:@"HuSplashViewController"];
    
    UINavigationController *navigator = (UINavigationController *)[self.window rootViewController];
    [navigator pushViewController:splash animated:NO];
    
    //return YES;
}


- (NSArray *)freshNavigationStack
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HuLoginOrSignUpViewController *loginOrSignUpViewController = [storyBoard instantiateViewControllerWithIdentifier:@"HuLoginOrSignUpViewController"];
    return  @[loginOrSignUpViewController];
}

// only makes sense once we are logged in
- (HuHumansProfileCarouselViewController *)humansProfileCarouselViewController
{
    // are we logged in??
    if(humansProfileCarouselViewController == nil ) {
        humansProfileCarouselViewController = [[HuHumansProfileCarouselViewController alloc]init];
    }
    return humansProfileCarouselViewController;
}

- (void)setHumansHumansProfileCarouselViewController:(HuHumansProfileCarouselViewController *)viewController
{
    humansProfileCarouselViewController = viewController;
}


- (HuJediFindFriends_ViewController *)jediFindFriendsViewController
{
    if(jediFindFriendsViewController == nil) {
        jediFindFriendsViewController = [[HuJediFindFriends_ViewController alloc]init];
    }
    return jediFindFriendsViewController;
}

- (HuLoginViewController *)loginViewController
{
    if(loginViewController == nil) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        loginViewController = [storyBoard instantiateViewControllerWithIdentifier:@"HuLoginViewController"];
    }
    return loginViewController;
}

- (HuSignUpViewController *)signUpViewController
{
    if(signUpViewController == nil) {
//        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        signUpViewController = [storyBoard instantiateViewControllerWithIdentifier:@"HuSignUpViewController"];
        signUpViewController = [[HuSignUpViewController alloc]init];
    }
    return signUpViewController;
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - BITCrashManagerDelegate
/**
- (void)crashManagerWillCancelSendingCrashReport:(BITCrashManager *)crashManager {
    if ([self didCrashInLastSessionOnStartup]) {
        [self setupApplication];
    }
}

- (void)crashManager:(BITCrashManager *)crashManager didFailWithError:(NSError *)error {
    if ([self didCrashInLastSessionOnStartup]) {
        [self setupApplication];
    }
}

- (void)crashManagerDidFinishSendingCrashReport:(BITCrashManager *)crashManager {
    if ([self didCrashInLastSessionOnStartup]) {
        [self setupApplication];
    }
}
**/
@end

@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end
