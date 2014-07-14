//
//  HuJediMiniFindFriendsViewController.h
//  humans
//
//  Created by Julian Bleecker on 3/2/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defines.h"


@class HuEditHumanViewController;
@class HuHuman;

@interface HuJediMiniFindFriendsViewController : UIViewController <UITextFieldDelegate>

@property  NSUInteger maxNewUsers;
@property HuHuman *human;
@property HuEditHumanViewController *invokingViewController;
@end
