//
//  HuAppDelegate.h
//  humans
//
//  Created by julian on 12/13/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import "HuUserHandler.h"
#import "HuJediFindFriends_ViewController.h"
#import "HuSignUpViewController.h"
#import "HuLoginViewController.h"
#import "HuSplashViewController.h"
#import "HuHumansProfileCarouselViewController.h"

//#import "HockeySDK.h"


#define DELEGATE [[UIApplication sharedApplication]delegate]

//#import "HuFindFollowsMain_ViewController.h"

@class HuJediFindFriends_ViewController;
@class HuSignUpViewController;
@class HuLoginViewController;
@class HuHumansProfileCarouselViewController;
@class HuStatusCarouselViewController;
@interface HuAppDelegate : UIResponder <UIApplicationDelegate/*, BITCrashManagerDelegate, BITHockeyManagerDelegate*/>

- (NSArray*)freshNavigationStack;
- (HuLoginViewController *)loginViewController;
- (HuSignUpViewController *)signUpViewController;
//- (void)setHumansProfileCarouselViewController:(HuHumansProfileCarouselViewController*)humansProfileCarouselViewController;
- (HuHumansProfileCarouselViewController*)humansProfileCarouselViewController;
- (HuStatusCarouselViewController *)statusCarouselViewController;

- (NSString *)clusteredUUID;
- (NSString *)clusteredVersionBuild;
- (void)popToLoginViewController;
- (void)popToProfileCarouselView;

+ (UIWebView *)sharedWebView:(NSURL *)url;
+ (void)popGoodToastNotification:(NSString *)notice withColor:(UIColor *)color withImage:(UIImage *)image;
+ (void)popGoodToastNotification:(NSString *)notice withColor:(UIColor *)color;
+ (void)popBadToastNotification:(NSString *)notice withSubnotice:(NSString *)subnotice;


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HuUserHandler *humansAppUser;
@property (strong, nonatomic) NSUUID *uuid;
@property (nonatomic, retain) HuJediFindFriends_ViewController *jediFindFriendsViewController;
@property (nonatomic, readonly, strong) HuHumansProfileCarouselViewController *humansProfileCarouselViewController;

//@property (nonatomic, retain) HuFindFollowsMain_ViewController *findFollowsMainViewController;
@end
