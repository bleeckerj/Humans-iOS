//
//  HuHumansProfileCarouselViewController.h
//  humans
//
//  Created by Julian Bleecker on 2/13/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCarousel.h>
#import "defines.h"
#import "HuUserHandler.h"
#import "HuHuman.h"
#import "HuServiceUser.h"
#import <UIImageView+AFNetworking.h>
#import "HuAppDelegate.h"
#import <MRProgressOverlayView.h>
#import "HuStatusCarouselViewController.h"
#import <MGLineStyled.h>
#import "ViewUtils.h"
#import <UIView+MCLayout.h>
#import "HuShowServicesViewController.h"
#import <UIColor+FPBrandColor.h>
#import <UIColor+Crayola.h>
//#import "UIColor+UIColor_LighterDarker.h"
//#import "CoconutKit.h"
#import "HuEditHumanViewController.h"
#import <TYMActivityIndicatorView.h>
#import <UIImage+RoundedCorner.h>
#import "UIImage+ResizeToFit.h"
#import <UIImage+Resize.h>
#import <UIView+MCLayout.h>
//#import "Flurry.h"
#import <BlocksKit+UIKit.h>
#import "MSWeakTimer.h"
#import <REMenu.h>
#import "HuConnectServicesViewController.h"

@interface HuHumansProfileCarouselViewController : UIViewController

@property NSUInteger indexToShow;
@property BOOL humanHasEdited;
@property HuUser *user;
- (void)invalidateStatusRefreshTimer;
- (void)resetStatusRefreshTimer:(NSTimeInterval)refreshTime;
- (void)setHumansUserHandler:(HuUserHandler *)aUserHandler;
- (void)populateViewsForHumans;
//- (id)initWithUserHandler:(HuUserHandler *)aUserHandler;

@end
