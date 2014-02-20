//
//  HuStatusCarouselViewController.h
//  humans
//
//  Created by julian on 12/22/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuHuman.h"

@interface HuStatusCarouselViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) HuHuman *human;
@end
