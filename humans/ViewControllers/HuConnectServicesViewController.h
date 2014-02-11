//
//  HuConnectServicesViewController.h
//  humans
//
//  Created by Julian Bleecker on 2/8/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defines.h"
#import "LoggerClient.h"
#import "HuAppDelegate.h"
#import "HuUserHandler.h"
#import "UIImage+Resize.h"
#import "MGBox.h"
#import <MRProgress.h>
#import "Flurry.h"
#import "HuAuthenticateServiceWebViewController.h"

@interface HuConnectServicesViewController : UIViewController <UIWebViewDelegate>
@property BOOL checkMarkTapped, exTapped;
@property (nonatomic, retain) MGLineStyled *header;

@end
