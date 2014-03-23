//
//  HuHumanProfileViewController.h
//  humans
//
//  Created by Julian Bleecker on 2/28/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defines.h"
#import <FUIButton.h>
#import <UIColor+Crayola.h>
#import <UIColor+FlatUI.h>
#import <UIColor+FPBrandColor.h>
#import "HuHuman.h"
#import <RDVKeyboardAvoidingScrollView.h>
#import <BlocksKit+UIKit.h>
#import "HuAppDelegate.h"
#import "HuUserHandler.h"
#import <MZFormSheetBackgroundWindow.h>
#import <MZFormSheetController.h>
#import "HuAddDeleteServiceUserCarouselViewController.h"
#import "HuJediMiniFindFriendsViewController.h"
#import "HuHumansProfileCarouselViewController.h"

@class HuHumansProfileCarouselViewController;

@interface HuEditHumanViewController : UIViewController  <UITextFieldDelegate, MZFormSheetBackgroundWindowDelegate>
@property (strong, nonatomic) IBOutlet FUIButton *editButton;
@property (strong, nonatomic) IBOutlet FUIButton *deleteButton;
@property (strong, nonatomic) IBOutlet FUIButton *goBackButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) HuHuman *human;
@property (retain, nonatomic) IBOutlet RDVKeyboardAvoidingScrollView *keyboardAvoidingScrollView;
@property (nonatomic, assign) BOOL showStatusBar;
@property (nonatomic, assign) BOOL refreshOnReturn;
@property (weak, nonatomic) HuHumansProfileCarouselViewController *humansProfileCarouselViewController;


@end
