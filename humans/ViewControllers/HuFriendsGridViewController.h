//
//  HuFriendsGridViewController.h
//  humans
//
//  Created by julian on 12/13/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "defines.h"
#import "HuFriend.h"
#import "HuAppDelegate.h"

@interface HuFriendsGridViewController : UIViewController


-(void)preloadFriendProfileDataWithCompletionHandler:(CompletionHandler)completionHandler;
-(void)setup;
- (void)reloadFriendsGridView;
-(NSDictionary*)proxyForJson;

@end
