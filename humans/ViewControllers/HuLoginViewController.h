//
//  HuLoginViewController.h
//  humans
//
//  Created by julian on 12/18/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MRProgress/MRProgress.h>
#import <FUIButton.h>
#import <UIColor+FPBrandColor.h>
#import <UIColor+Crayola.h>
//#import <Parse/Parse.h>
#import <FXKeychain.h>

@interface HuLoginViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet FUIButton *loginButton;
@property (strong, nonatomic) IBOutlet FUIButton *signUpButton;
//@property (nonatomic, strong) ECSlidingViewController *slidingViewController;
//@property (strong, nonatomic) MRActivityIndicatorView *activityIndicatorView;
@end
