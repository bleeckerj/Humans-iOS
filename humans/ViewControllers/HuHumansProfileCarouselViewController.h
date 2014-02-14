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

@interface HuHumansProfileCarouselViewController : UIViewController
- (void)setHumansUserHandler:(HuUserHandler *)aUserHandler;
@end
