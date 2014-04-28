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

//#import "HuFindFollowsMain_ViewController.h"

@class HuJediFindFriends_ViewController;
@class HuSignUpViewController;
@class HuLoginViewController;
@class HuHumansProfileCarouselViewController;

@interface HuAppDelegate : UIResponder <UIApplicationDelegate/*, BITCrashManagerDelegate, BITHockeyManagerDelegate*/>

- (NSArray*)freshNavigationStack;
- (HuLoginViewController *)loginViewController;
- (HuSignUpViewController *)signUpViewController;
- (void)setHumansHumansProfileCarouselViewController:(HuHumansProfileCarouselViewController*)humansProfileCarouselViewController;
- (HuHumansProfileCarouselViewController*)humansProfileCarouselViewController;
- (NSString *)clusteredUUID;
- (NSString *)clusteredVersionBuild;


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HuUserHandler *humansAppUser;
@property (strong, nonatomic) NSUUID *uuid;
@property (nonatomic, retain) HuJediFindFriends_ViewController *jediFindFriendsViewController;

//@property (nonatomic, retain) HuFindFollowsMain_ViewController *findFollowsMainViewController;
@end
