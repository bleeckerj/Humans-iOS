//
//  HuSignUpViewController.h
//  humans
//
//  Created by Julian Bleecker on 2/21/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defines.h"
#import <FlatUIKit/UIColor+FlatUI.h>
#import <FlatUIKit/FUIButton.h>
#import <FlatUIKit/FUIAlertView.h>
//#import <ViewUtils.h>
#import <RDVKeyboardAvoidingScrollView.h>
#import <FPBrandColors/UIColor+FPBrandColor.h>
#import <UIColor+Crayola.h>
#import "HuAppDelegate.h"
#import "HuUserHandler.h"
#import <MRProgress.h>
#import <BlocksKit+UIKit.h>

@interface HuSignUpViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *signUpLabel;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet FUIButton *signUpButton;
@property (strong, nonatomic) IBOutlet FUIButton *loginButton;
@property (retain, nonatomic) IBOutlet RDVKeyboardAvoidingScrollView *keyboardAvoidingScrollView;
@end
