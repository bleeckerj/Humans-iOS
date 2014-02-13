//
//  HuHumansScrollViewController.h
//  humans
//
//  Created by julian on 12/20/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuHuman.h"
#import "HuAppDelegate.h"
#import "HuStatusCarouselViewController.h"
#import <ECSlidingViewController.h>
#import <MRProgress/MRProgress.h>
#import "HuHumanLineStyled.h"

@interface HuHumansScrollViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *arrayOfHumans;
@property (nonatomic, strong) HuStatusCarouselViewController *statusCarouselViewController;

@property (nonatomic, strong) ECSlidingViewController *slidingViewController;

- (void)setUp:(UIViewController *)controller;
-(void)showHuman:(HuHuman *)human fromLine:(HuHumanLineStyled*)line;

@end
