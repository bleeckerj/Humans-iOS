//
//  HuLoginOrSignUpViewController.h
//  Pods
//
//  Created by Julian Bleecker on 2/22/14.
//
//
#import "defines.h"
#import <UIKit/UIKit.h>
#import <FlatUIKit/UIColor+FlatUI.h>
#import <FlatUIKit/FUIButton.h>
#import <FPBrandColors/UIColor+FPBrandColor.h>
#import <UIColor+Crayola.h>
#import <RFRotate.h>

@interface HuLoginOrSignUpViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *rotatingHandView;
@property (strong, nonatomic) IBOutlet FUIButton *loginButton;
@property (strong, nonatomic) IBOutlet FUIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIButton *rotatingHandTextField;
@end
