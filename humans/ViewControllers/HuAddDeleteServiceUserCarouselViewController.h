//
//  HuAddDeleteHumanViewController.h
//  humans
//
//  Created by Julian Bleecker on 3/1/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCarousel.h>
#import "HuHuman.h"
#import "HuUserHandler.h"
#import "HuServiceUser.h"
#import "HuUserHandler.h"
#import "HuAppDelegate.h"
#import "Flurry.h"
#import <Parse/Parse.h>

#import <MZFormSheetController.h>
#import <UIView+MCLayout.h>
#import <UIColor+FPBrandColor.h>
#import <UIColor+Crayola.h>
#import <UIColor+FlatUI.h>
#import "UIColor+UIColor_LighterDarker.h"
#import <UIImageView+AFNetworking.h>
#import <UIImage+Resize.h>
#import <WSLObjectSwitch.h>
#import <UIControl+BlocksKit.h>

@interface HuAddDeleteServiceUserCarouselViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>
@property BOOL showStatusBar;
@property BOOL deletesWereMade;
@property BOOL addMoreHuman;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet iCarousel *carousel;
@property (strong, nonatomic) HuHuman *human;
- (void)reloadData;

@end
