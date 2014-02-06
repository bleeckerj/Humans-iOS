//
//  HuFindFollows_ViewController.h
//  Humans
//
//  Created by julian on 12/4/12.
//  Copyright (c) 2012 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defines.h"

#import "MGBox.h"
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"
#import "LoggerClient.h"
#import "UIImage+Resize.h"
#import "UIColor+UIColor_LighterDarker.h"
#import "HuAppDelegate.h"
#import "HuJediFindFriends_ViewController.h"

@interface HuFindFollowsMain_ViewController : UIViewController

@property (nonatomic, retain) MGScrollView *scroller;

-(id)init;

@end
