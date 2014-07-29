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
#import <HockeySDK/HockeySDK.h>
#import <SDWebImageManager.h>
#import "HuHumansProfileCarouselViewController.h"
#import "HuStatusCarouselViewController.h"

@implementation HuAppDelegate
{
    HuLoginViewController *loginViewController;
    HuSignUpViewController *signUpViewController;
    HuStatusCarouselViewController *statusCarouselViewController;
    //HuHumansProfileCarouselViewController *humansProfileCarouselViewController;
}
@synthesize humansAppUser;
@synthesize jediFindFriendsViewController;
@synthesize humansProfileCarouselViewController;
//@synthesize findFollowsMainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"89a415bf14fb56ed6e81ef153d4cb481"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];

    [Crashlytics startWithAPIKey:@"f3ea4d3148c2d7cf3a017fdad4bd9871d2f1a988"];
    
    [application setStatusBarHidden:NO];

    [self setupApplication];
    
    return YES;
}

- (void) setupApplication {
    // Override point for customization after application launch.
    LoggerInit();
    
    
    LoggerStart(LoggerGetDefaultLogger());
    
    LOG_GENERAL(0, @"Are we running?");
    
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


- (void)popToProfileCarouselView
{
    UINavigationController *navigator = (UINavigationController *)[self.window rootViewController];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [navigator setViewControllers:@[[self humansProfileCarouselViewController]] animated:YES];
    });
}

- (void)popToLoginViewController
{
    UINavigationController *navigator = (UINavigationController *)[self.window rootViewController];
    dispatch_async(dispatch_get_main_queue(), ^{

    [navigator setViewControllers:@[[self loginViewController]] animated:YES];
    });

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

- (HuStatusCarouselViewController *)statusCarouselViewController
{
    if(statusCarouselViewController == nil) {
        statusCarouselViewController = [[HuStatusCarouselViewController alloc]init];
    }
    return statusCarouselViewController;
}


//- (void)setHumansHumansProfileCarouselViewController:(HuHumansProfileCarouselViewController *)viewController
//{
//    humansProfileCarouselViewController = viewController;
//}


- (NSString *)humansUsername
{
    return [[[self humansAppUser]humans_user]username];
}

- (NSUUID *)uuid
{
    return [[ASIdentifierManager sharedManager]advertisingIdentifier];
}

- (NSString *)clusteredVersionBuild
{
    NSString *shortVersionString = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    //[versionLabel setText:shortVersionString];
    NSString *build  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CWBuildNumber"];
    
    NSString *result = NSString.new;
    
#ifdef DEV
#ifdef DEBUG
   result = [NSString stringWithFormat:@"%@-debug   build %@.dbg aka-%@",version, build, shortVersionString ];
#else
    result = [NSString stringWithFormat:@"%@-release   build %@.dbg aka-%@",version, build, shortVersionString ];
    
#endif
#else
#ifdef DEBUG
    
     result = [NSString stringWithFormat:@"%@-debug   build %@.prd aka-%@",version, build, shortVersionString ];
#else
    result = [NSString stringWithFormat:@"%@-release   build %@.prd aka-%@",version, build, shortVersionString ];
    
#endif
#endif

    
    return result;
}

- (NSString *)clusteredUUID
{
    if([self humansAppUser] != nil && [[self humansAppUser]humans_user] != nil) {
    return [NSString stringWithFormat:@"%@ %@", [self humansUsername], [[self uuid]UUIDString]];
    } else {
        return [NSString stringWithFormat:@"%@", [[self uuid]UUIDString]];
    }
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
static UIWebView *sharedWebView;

+ (UIWebView *)sharedWebView:(NSURL *)url
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWebView = [[UIWebView alloc]init];
        [sharedWebView setScalesPageToFit:YES];
    });
    // clear the browser which'll cache..
    [sharedWebView loadHTMLString:@"" baseURL:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [sharedWebView loadRequest:request];
    
    return sharedWebView;
}


+ (void)popGoodToastNotification:(NSString *)notice withColor:(UIColor *)color withImage:(UIImage *)image
{
    [CRToastManager dismissNotification:YES];
    
    NSDictionary *options = @{
                              kCRToastTextKey :notice,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : color,
                              kCRToastFontKey : HEADER_FONT_LARGE,
                              //kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypePush),
                              kCRToastImageKey : image,
                              kCRToastAnimationInTimeIntervalKey: @0.5,
                              kCRToastAnimationOutTimeIntervalKey: @0.5,
                              kCRToastTimeIntervalKey : @1.0,
                              kCRToastUnderStatusBarKey : @NO,
                              kCRToastNotificationPreferredHeightKey : NAME_VIEW_HEIGHT,
                              kCRToastNotificationTypeKey : @(CRToastTypeCustom),
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeSpring),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeSpring),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop)
                              };
    
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    NSLog(@"Completed");
                                }];

}




+ (void)popGoodToastNotification:(NSString *)notice withColor:(UIColor *)color
{
    
    [CRToastManager dismissNotification:YES];
    
    NSDictionary *options = @{
                              kCRToastTextKey :notice,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : color,
                              kCRToastFontKey : HEADER_FONT_LARGE,
                              //kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypePush),
                              kCRToastAnimationInTimeIntervalKey: @0.5,
                              kCRToastAnimationOutTimeIntervalKey: @0.5,
                              kCRToastTimeIntervalKey : @1,
                              kCRToastUnderStatusBarKey : @NO,
                              kCRToastNotificationPreferredHeightKey : NAME_VIEW_HEIGHT,
                              kCRToastNotificationTypeKey : @(CRToastTypeCustom),
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeSpring),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeSpring),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop)
                              };
    
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    NSLog(@"Completed");
                                }];
}

+ (void)popBadToastNotification:(NSString *)notice withSubnotice:(NSString *)subnotice
{
    [CRToastManager dismissNotification:YES];
    
    NSDictionary *options = @{
                              kCRToastTextKey :notice,
                              kCRToastSubtitleTextKey : subnotice,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : [UIColor crayolaManateeColor],
                              kCRToastFontKey : HEADER_FONT_LARGE,
                              kCRToastSubtitleFontKey : HEADER_FONT,
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypePush),
                              kCRToastAnimationInTimeIntervalKey: @0.5,
                              kCRToastAnimationOutTimeIntervalKey: @0.5,
                              kCRToastTimeIntervalKey : @3,
                              kCRToastUnderStatusBarKey : @NO,
                              kCRToastNotificationPreferredHeightKey : @HEADER_HEIGHT,
                              kCRToastNotificationTypeKey : @(CRToastTypeCustom),
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeSpring),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeSpring),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop)
                              };
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    NSLog(@"Completed");
                                }];
    
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
