//
//  HuStatusCarouselViewController.h
//  humans
//
//  Created by julian on 12/22/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuHuman.h"
#import <iCarousel.h>
#import "HuHumansProfileCarouselViewController.h"
#import <Masonry.h>
#import "HuViewForServiceStatus.h"
#import <MZFormSheetController.h>
#import "StatusView.h"
#import <CoreLocation/CoreLocation.h>

//@class HuHumansProfileCarouselViewController;

@interface HuStatusCarouselViewController : UIViewController <HuViewControllerForStatusDelegate, MZFormSheetBackgroundWindowDelegate, UIWebViewDelegate>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) HuHuman *human;
@end
