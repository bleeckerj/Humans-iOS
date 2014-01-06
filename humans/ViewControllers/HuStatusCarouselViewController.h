//
//  HuStatusCarouselViewController.h
//  humans
//
//  Created by julian on 12/22/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuFriendsGridViewController.h"

@interface HuStatusCarouselViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) HuFriendsGridViewController *friendsViewController;

@end
