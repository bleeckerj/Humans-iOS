//
//  HuLoginViewController.h
//  humans
//
//  Created by julian on 12/18/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ECSlidingViewController.h>
#import "HuSlidingViewController.h"
#import <MRProgress/MRProgress.h>

@interface HuLoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (nonatomic, strong) HuSlidingViewController *slidingViewController;
//@property (strong, nonatomic) MRActivityIndicatorView *activityIndicatorView;
@end
