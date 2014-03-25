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
//#import <MRProgress.h>
#import <BlocksKit+UIKit.h>
#import <US2FormValidator.h>
#import "HuUS2ConditionLowerAlphaEmotis.h"
#import "HuUS2ConditionEmojiStringRange.h"
#import <CRToast.h>

@interface HuSignUpViewController : UIViewController <UITextFieldDelegate, US2ValidatorUIDelegate>

@property (strong, nonatomic) IBOutlet UILabel *signUpLabel;
@property (strong, nonatomic) IBOutlet US2ValidatorTextField *emailTextField;
@property (strong, nonatomic) IBOutlet US2ValidatorTextField *confirmPasswordTextField;
@property (strong, nonatomic) IBOutlet US2ValidatorTextField *passwordTextField;
@property (strong, nonatomic) IBOutlet US2ValidatorTextField *usernameTextField;
@property (strong, nonatomic) UILabel *usernameInfoLabel;
@property (strong, nonatomic) UILabel *passwordInfoLabel;
@property (strong, nonatomic) UILabel *emailInfoLabel;
@property (strong, nonatomic) IBOutlet FUIButton *signUpButton;
@property (strong, nonatomic) IBOutlet FUIButton *loginButton;
@property (retain, nonatomic) IBOutlet RDVKeyboardAvoidingScrollView *keyboardAvoidingScrollView;

- (void)isUniqueUsername:(NSString *)username isUnique:(BOOL)is;

@end
