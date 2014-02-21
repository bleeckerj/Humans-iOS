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
#import <REMenu.h>
#import <MGLineStyled.h>
#import "ViewUtils.h"
#import "HuShowServicesViewController.h"
#import <UIColor+FPBrandColor.h>

@interface HuHumansProfileCarouselViewController : UIViewController
@property (nonatomic, strong) REMenu *mainMenu;

- (void)setHumansUserHandler:(HuUserHandler *)aUserHandler;
- (id)initWithUserHandler:(HuUserHandler *)aUserHandler;

@end