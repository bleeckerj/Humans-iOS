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
#import "MGTableBoxStyled.h"
#import "MGBox.h"
#import "PhotoBox.h"
#import "MGScrollView.h"
#import "MGLineStyled.h"
#import "HuTextFieldLine.h"
#import "HuServiceUserProfilePhoto.h"
#import "StateMachine.h"
#import "HuServiceViewLine.h"
#import <UIColor+FlatUI.h>
#import <UIColor+Crayola.h>
#import <UIColor+FPBrandColor.h>

@interface HuShowServicesViewController : UIViewController <HuServiceViewLineDelegate>
@property BOOL checkMarkTapped, exTapped;
@property (nonatomic, retain) HuUserHandler *appUser;
@property (nonatomic, retain) MGLineStyled *header;
@property (nonatomic, copy) Block tapOnEx;
@end
