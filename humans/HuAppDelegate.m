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
#import "Flurry.h"
#import "TestFlight.h"

@implementation HuAppDelegate

@synthesize humansAppUser;
@synthesize jediFindFriendsViewController;
//@synthesize findFollowsMainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TestFlight takeOff:@"7d627af6-7629-44dc-8103-a7a1baa81d03"];
    // Override point for customization after application launch.
    LoggerInit();
    //LoggerSetViewerHost(LoggerGetDefaultLogger(), CFSTR("10.0.0.79"), 49767);
    LoggerStart(LoggerGetDefaultLogger());
    LOG_GENERAL(0, @"Are we running?");
    LOG_UI(0, @"Model %@ IS_IPHONE? %@", [ [ UIDevice currentDevice ] model ], (IS_IPHONE?@"YES":@"NO"));
    LOG_UI(0, @"Widescreen %d", ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON ));
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager.imageDownloader setDownloadTimeout:30.0];

    
    
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//        
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }

    humansAppUser = [[HuUserHandler alloc]init];
    
//    [Parse setApplicationId:@"RBemMZQt31HNHJBfEXTj5oFcxo1ZBwbiZDutTbAe"
//                  clientKey:@"rOKCHpW5MnjSHwCgLAGFQk72UNvZNzdKUbQ4qXeW"];
//    
    [Crashlytics startWithAPIKey:@"f3ea4d3148c2d7cf3a017fdad4bd9871d2f1a988"];
//    [Crashlytics startWithAPIKey:@"f3ea4d3148c2d7cf3a017fdad4bd9871d2f1a988"];
    [Crashlytics sharedInstance].debugMode = YES;
    
//    
    //[Flurry setCrashReportingEnabled:YES];
////
[Flurry startSession:@"W63YQC9B83PWB64HT8VF"];
[application setStatusBarHidden:NO];
    
    return YES;
}

- (HuJediFindFriends_ViewController *)jediFindFriendsViewController
{
    if(jediFindFriendsViewController == nil) {
        jediFindFriendsViewController = [[HuJediFindFriends_ViewController alloc]init];
    }
    return jediFindFriendsViewController;
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

@end
