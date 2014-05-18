//
//  HuJediMiniFindFriendsViewController.h
//  humans
//
//  Created by Julian Bleecker on 3/2/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defines.h"
#import "HuAppDelegate.h"
#import "HuUserHandler.h"
#import "HuUserHandler.h"
#import <UIImage+Resize.h>
#import <MGBox.h>
#import <MGScrollView.h>
#import <MGLineStyled.h>
#import <UIColor+Crayola.h>
#import <UIColor+FlatUI.h>
#import <MGScrollView.h>
//#import <Parse/Parse.h>
#import <FlatUIKit.h>
#import <MZFormSheetController.h>
#import <MRProgress.h>
#import <UIView+MCLayout.h>
#import "HuEditHumanViewController.h"

@class HuEditHumanViewController;

@interface HuJediMiniFindFriendsViewController : UIViewController <UITextFieldDelegate>

@property  NSUInteger maxNewUsers;
@property HuHuman *human;
@property HuEditHumanViewController *invokingViewController;
@end
