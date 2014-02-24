//
//  HuAppDelegate.h
//  humans
//
//  Created by julian on 12/13/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuUserHandler.h"
#import "HuJediFindFriends_ViewController.h"
#import "HuSignUpViewController.h"
#import "HuLoginViewController.h"
//#import "HuFindFollowsMain_ViewController.h"

@class HuJediFindFriends_ViewController;
@class HuSignUpViewController;
@class HuLoginViewController;

@interface HuAppDelegate : UIResponder <UIApplicationDelegate>

- (NSArray*)freshNavigationStack;
- (HuLoginViewController *)loginViewController;
- (HuSignUpViewController *)signUpViewController;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HuUserHandler *humansAppUser;

@property (nonatomic, retain) HuJediFindFriends_ViewController *jediFindFriendsViewController;


//@property (nonatomic, retain) HuFindFollowsMain_ViewController *findFollowsMainViewController;
@end
