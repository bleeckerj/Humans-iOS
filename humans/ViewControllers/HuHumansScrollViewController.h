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

@interface HuHumansScrollViewController : UIViewController

@property (nonatomic, strong) NSArray *arrayOfHumans;

-(void)showHuman:(HuHuman *)human;

@end
