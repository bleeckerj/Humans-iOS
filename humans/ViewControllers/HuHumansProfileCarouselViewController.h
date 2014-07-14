//
//  HuHumansProfileCarouselViewController.h
//  humans
//
//  Created by Julian Bleecker on 2/13/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuUser.h"
#import "NSMutableDictionary+JCBDictionaryTimedCache.h"
//#import "HuUserHandler.h"

@class HuUserHandler;

@interface HuHumansProfileCarouselViewController : UIViewController

@property NSUInteger indexToShow;
@property BOOL humanHasEdited;
@property HuUser *user;
- (void)invalidateStatusRefreshTimer;
- (void)resetStatusRefreshTimer:(NSTimeInterval)refreshTime;
- (void)setHumansUserHandler:(HuUserHandler *)aUserHandler;
- (void)populateViewsForHumans;
- (void)freshenHumansForView:(Boolean)updateProfileImages;
- (void)freshenHumansForView;
//- (id)initWithUserHandler:(HuUserHandler *)aUserHandler;

@end
