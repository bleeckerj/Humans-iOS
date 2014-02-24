//
//  HuSignUpViewController.m
//  humans
//
//  Created by Julian Bleecker on 2/21/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuSignUpViewController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
@implementation UITextField (custom)
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 8,
                      bounds.size.width - 20, bounds.size.height - 16);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}
@end

#pragma clang diagnostic pop

@interface HuSignUpViewController ()
{
    CGRect keyboardEndFrame;
}


@property (nonatomic, strong) NSArray *textFields;

@property (nonatomic, strong) UIButton *completeButton;


@end

@implementation HuSignUpViewController

@synthesize signUpLabel;
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize usernameTextField;
@synthesize signUpButton;
@synthesize keyboardAvoidingScrollView;
@synthesize confirmPasswordTextField;
@synthesize loginButton;

@synthesize completeButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat status_bar_height = [UIApplication sharedApplication].statusBarFrame.size.height;

    CGFloat elementWidth = roundf(applicationFrame.size.width - 2 * 20);
    CGRect scrollViewFrame = CGRectMake(self.navigationController.view.frame.origin.x, self.navigationController.view.frame.origin.y + 2*status_bar_height, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
    self.keyboardAvoidingScrollView = [[RDVKeyboardAvoidingScrollView alloc] initWithFrame:scrollViewFrame];
    [keyboardAvoidingScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [keyboardAvoidingScrollView setBackgroundColor:[UIColor whiteColor]];
    [keyboardAvoidingScrollView setAlwaysBounceVertical:YES];
    
    signUpLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, elementWidth, 45)];
    [signUpLabel setTextColor:[UIColor blackColor]];
    [signUpLabel setFont:TEXTFIELD_FONT_LARGE];
    [signUpLabel setText:@"Sign Up"];
    [signUpLabel setTextAlignment:NSTextAlignmentCenter];
    [signUpLabel setBackgroundColor:[UIColor clearColor]];
    
    [keyboardAvoidingScrollView addSubview:signUpLabel];
    
    usernameTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(signUpLabel.frame) + 45, elementWidth, 45)];
    [usernameTextField setBorderStyle:UITextBorderStyleNone];
    [usernameTextField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [usernameTextField setAdjustsFontSizeToFitWidth:YES];
    [usernameTextField setFont:TEXTFIELD_FONT_LARGE];
    [usernameTextField setBackgroundColor:[UIColor carrotColor ]];
    [usernameTextField setTextColor:[UIColor whiteColor]];
    [usernameTextField setPlaceholder:@"Pick A Username"];
    [usernameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [usernameTextField setDelegate:self];
    [keyboardAvoidingScrollView addSubview:usernameTextField];
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(usernameTextField.frame) + 45/2, elementWidth, 45)];
    [passwordTextField setBorderStyle:UITextBorderStyleNone];
    [passwordTextField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [passwordTextField setAdjustsFontSizeToFitWidth:YES];
    [passwordTextField setFont:TEXTFIELD_FONT_LARGE];
    [passwordTextField setBackgroundColor:[UIColor carrotColor ]];
    [passwordTextField setTextColor:[UIColor whiteColor]];
    [passwordTextField setPlaceholder:@"Pick A Password"];
    [passwordTextField setDelegate:self];
    [passwordTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [passwordTextField setSecureTextEntry:YES];
    [keyboardAvoidingScrollView addSubview:passwordTextField];

    confirmPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(passwordTextField.frame) + 45/2, elementWidth, 45)];
    [confirmPasswordTextField setBorderStyle:UITextBorderStyleNone];
    [confirmPasswordTextField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [confirmPasswordTextField setAdjustsFontSizeToFitWidth:YES];
    [confirmPasswordTextField setFont:TEXTFIELD_FONT_LARGE];
    [confirmPasswordTextField setBackgroundColor:[UIColor carrotColor ]];
    [confirmPasswordTextField setTextColor:[UIColor whiteColor]];
    [confirmPasswordTextField setPlaceholder:@"Confirm Password"];
    [confirmPasswordTextField setDelegate:self];
    [confirmPasswordTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [confirmPasswordTextField setSecureTextEntry:YES];
    [keyboardAvoidingScrollView addSubview:confirmPasswordTextField];

    emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(confirmPasswordTextField.frame) + 45/2, elementWidth, 45)];
    [emailTextField setBorderStyle:UITextBorderStyleNone];
    [emailTextField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [emailTextField setAdjustsFontSizeToFitWidth:YES];
    [emailTextField setFont:TEXTFIELD_FONT_LARGE];
    [emailTextField setBackgroundColor:[UIColor carrotColor ]];
    [emailTextField setTextColor:[UIColor whiteColor]];
    [emailTextField setPlaceholder:@"Your Email"];
    [emailTextField setDelegate:self];
    [emailTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [keyboardAvoidingScrollView addSubview:emailTextField];

    
    
    self.textFields = @[usernameTextField, passwordTextField, confirmPasswordTextField, emailTextField];
    
    signUpButton = [FUIButton buttonWithType:UIButtonTypeSystem];
    [signUpButton setFrame:CGRectMake(198, CGRectGetMaxY(emailTextField.frame) + 45/2, 104, 45)];
    [signUpButton.titleLabel setFont:TEXTFIELD_FONT_LARGE];
    [signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [signUpButton setBackgroundColor:[UIColor carrotColor]];
    [signUpButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signUpButton bk_addEventHandler:^(id sender) {
        [self signUpButtonTouchUpInside];
    } forControlEvents:UIControlEventTouchUpInside];
    //[completeButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
   // [completeButton addTarget:self action:@selector(completeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [keyboardAvoidingScrollView addSubview:signUpButton];
    
    loginButton = [FUIButton buttonWithType:UIButtonTypeSystem];
    [loginButton setFrame:CGRectMake(emailTextField.left, CGRectGetMaxY(emailTextField.frame) + 45/2, 104, 45)];
    [loginButton.titleLabel setFont:TEXTFIELD_FONT_LARGE];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor crayolaTealBlueColor ]];
    [loginButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton bk_addEventHandler:^(id sender) {
        HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        HuLoginViewController *loginViewController = [delegate loginViewController];
        [[self navigationController]setViewControllers:@[loginViewController]];
    } forControlEvents:UIControlEventTouchUpInside];
    [keyboardAvoidingScrollView addSubview:loginButton];
    
    
    [keyboardAvoidingScrollView setContentSize:CGSizeMake(applicationFrame.size.width, CGRectGetMaxY(signUpButton.frame) + 20)];
    [keyboardAvoidingScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.keyboardAvoidingScrollView];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//- (UIStatusBarStyle )preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat status_bar_height = [UIApplication sharedApplication].statusBarFrame.size.height;
    
//    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) // only for iOS 7 and above
//    {
//        CGRect frame = self.navigationController.view.frame;
//        if(frame.origin.y == 0) {
//            frame.origin.y += status_bar_height;
//            frame.size.height -= status_bar_height;
//            self.navigationController.view.frame = frame;
//            //self.navigationController.view.backgroundColor = [UIColor greenColor];
//            //[self.navigationController.view setNeedsDisplay];
//            
//        }
//    }

	// Do any additional setup after loading the view.
   
//    loginButton.buttonColor = [UIColor crayolaTealBlueColor];
//    loginButton.shadowColor = loginButton.buttonColor;
//    loginButton.shadowHeight = 0.0f;
//    loginButton.cornerRadius = 0.0f;
//    loginButton.titleLabel.font = BUTTON_FONT_LARGE;
//    [loginButton setHighlightedColor:[UIColor crayolaTealBlueColor]];
//    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//    //[self.keyboardAvoidingScrollView contentSizeToFit];
//    //keyboardAvoidingScrollView = [[RDVKeyboardAvoidingScrollView alloc] initWithFrame:applicationFrame];
//    
//    NSArray *foo = [keyboardAvoidingScrollView subviews];
//    UIView *parent = signUpButton.superview;
//    [keyboardAvoidingScrollView addSubview:signUpButton];
//    [keyboardAvoidingScrollView addSubview:loginButton];
//    [keyboardAvoidingScrollView addSubview:usernameTextField];
//    [keyboardAvoidingScrollView addSubview:emailTextField];
//    [keyboardAvoidingScrollView addSubview:passwordTextField];
//    [keyboardAvoidingScrollView addSubview:confirmPasswordTextField];

}


-(void)viewDidUnload
{
    [super viewDidUnload];
    [self setKeyboardAvoidingScrollView:nil];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    [self performBlock:^{
    //        //
    //        FUIAlertView *alert = [[FUIAlertView alloc] initWithTitle:@"Hello" message:@"This is a test" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    //        [self styleAlertView:alert];
    //        [alert show];
    //
    //    } afterDelay:1.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.emailTextField.text = @"";
    self.confirmPasswordTextField.text = @"";
    self.usernameTextField.text = @"";
    self.passwordTextField.text = @"";
}

- (void)emailTextFieldEditingDidEnd:(id)sender
{
    BOOL isValid = [self validateEmail:[emailTextField text]];
    if(isValid == NO) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        });
        
        FUIAlertView *alert = [[FUIAlertView alloc] initWithTitle:@"Hello" message:[NSString stringWithFormat:@"'%@' isn't valid", [emailTextField text]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert setOnOkAction:^{
            [emailTextField becomeFirstResponder];
        }];
        [self styleAlertView:alert];
        [alert show];
        
    }
}

- (IBAction)confirmPasswordTextFieldEditingDidEnd:(id)sender
{
    if([[passwordTextField text]isEqualToString:[confirmPasswordTextField text]] == NO) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        });
        
        
        FUIAlertView *alert = [[FUIAlertView alloc] initWithTitle:@"Hello Human" message:@"Double-check your password. They don't match." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert setOnOkAction:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [passwordTextField becomeFirstResponder];
            });
        }];
        [self styleAlertView:alert];
        [alert show];
        
        [passwordTextField setText:@""];
        [confirmPasswordTextField setText:@""];
        
        

        
    }
}

- (IBAction)usernameTextFieldEditingDidBegin:(id)sender {
}


- (void)usernameTextFieldEditingDidEnd:(id)sender {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            [usernameTextField resignFirstResponder];

        });
    if([[usernameTextField text]length] > 0) {
        // confirm valid unique username
        
            HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
            HuUserHandler *handler = [delegate humansAppUser];
            
            if([[usernameTextField text]length] < 2) {
                FUIAlertView *alert = [[FUIAlertView alloc] initWithTitle:@"Hello Human" message:@"Usernames need to be at least 2 characters long." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [self styleAlertView:alert];
                [alert show];
                [passwordTextField setText:@""];
                [usernameTextField becomeFirstResponder];
            } else {
                __block MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
                progressView.mode = MRProgressOverlayViewModeIndeterminateSmall;
                progressView.titleLabelText = [NSString stringWithFormat:@"Checking %@", [usernameTextField text]];
                [progressView setTintColor:[UIColor carrotColor]];
                [self performBlock:^{

                    [handler usernameExists:[usernameTextField text] withCompletionHandler:^(BOOL exists, NSError *error) {
                        [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                        if(exists == YES) {
                            [progressView setTintColor:[UIColor alizarinColor]];
                            progressView = [MRProgressOverlayView showOverlayAddedTo:self.view title:[NSString stringWithFormat:@"Username '%@' exists already.", [usernameTextField text]] mode:MRProgressOverlayViewModeCross animated:YES];
                            [self performBlock:^{
                                [usernameTextField setText:@""];
                                [progressView dismiss:YES];
                                [usernameTextField becomeFirstResponder];
                            } afterDelay:4.0];
                        } else {
                            [passwordTextField becomeFirstResponder];
                        }
                        
                    }];

                } afterDelay:2.5];
                
            }

    }
}


- (IBAction)passwordTextFieldEditingDidEnd:(id)sender {
    NSString *pw = [passwordTextField text];
    if([pw length] > 0 && [pw length] < 8) {
        FUIAlertView *alert = [[FUIAlertView alloc] initWithTitle:@"Hello Human" message:@"C'mon. Try for a password that's at least 8 characters long." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert setOnOkAction:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [passwordTextField becomeFirstResponder];
            });
        }];
        [self styleAlertView:alert];
        [alert show];
        [passwordTextField setText:@""];
        [confirmPasswordTextField setText:@""];
    }
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //  return 0;
    return [emailTest evaluateWithObject:candidate];
}

- (void)styleAlertView:(FUIAlertView *)viewToStyle
{
    viewToStyle.titleLabel.textColor = [UIColor blackColor];
    viewToStyle.titleLabel.font = ALERT_FONT_LIGHT;
    viewToStyle.messageLabel.textColor = [UIColor whiteColor];
    viewToStyle.messageLabel.font = ALERT_FONT_LIGHT;
    viewToStyle.backgroundOverlay.backgroundColor = [UIColor clearColor];
    viewToStyle.alertContainer.backgroundColor = [UIColor cloudsColor];
    viewToStyle.defaultButtonColor = [UIColor carrotColor];
    viewToStyle.defaultButtonShadowHeight = 0.0f;
    viewToStyle.defaultButtonFont = ALERT_FONT_LIGHT;
    viewToStyle.defaultButtonTitleColor = [UIColor whiteColor];
}

- (void)isUsernameValidWithCompletionHandler:(CompletionHandlerWithResult)completionhandler
{
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    HuUserHandler *handler = [delegate humansAppUser];
    [handler usernameExists:[usernameTextField text] withCompletionHandler:^(BOOL exists, NSError *error) {
        if(completionhandler) {
            completionhandler(exists, error);
        }
    }];
}

- (BOOL)isPasswordValid
{
    BOOL result = false;
    if([[passwordTextField text] length] >= 8) {
        result = true;
    }
    return result;
    
}

- (BOOL)isEmailValid
{
    return [self validateEmail:[emailTextField text]];
}

- (IBAction)loginButtonTouchUpInside:(id)sender
{
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    HuLoginViewController *loginViewController = [delegate loginViewController];
    [[self navigationController]setViewControllers:@[loginViewController] animated:YES];
}

- (void)signUpButtonTouchUpInside {
    // validate fields
    [self isUsernameValidWithCompletionHandler:^(BOOL exists, NSError *error) {
        //
        if(exists == NO) {
            if([self isPasswordValid] && [self isEmailValid]) {
                // good to go
                HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
                HuUserHandler *handler = [delegate humansAppUser];
                HuUser *user = [[HuUser alloc]init];
                [user setUsername:[usernameTextField text]];
                [user setEmail:[emailTextField text]];
                [handler parseCreateNewUser:user password:[passwordTextField text] withCompletionHandler:^(id data, BOOL success, NSError *error) {
                    //
                    if(success == NO) {
                        NSString *msg = [NSString stringWithFormat:@"Something went wrong. %@", [error userInfo]];
                        FUIAlertView *alert = [[FUIAlertView alloc] initWithTitle:@"Hello Human" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                        [self styleAlertView:alert];
                        [alert show];
                    }
                }];
            }
        }
    }];
 
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == usernameTextField) {
        [self usernameTextFieldEditingDidEnd:textField];
    }
    if(textField == passwordTextField) {
        [self passwordTextFieldEditingDidEnd:passwordTextField];
    }
    if(textField == confirmPasswordTextField) {
        [self confirmPasswordTextFieldEditingDidEnd:confirmPasswordTextField];
    }
    if(textField == emailTextField) {
        if([[[self emailTextField]text]length] > 0) {
        [self emailTextFieldEditingDidEnd:emailTextField];
        }
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger textFieldIndex = [self.textFields indexOfObject:textField];

    if (textFieldIndex <self.textFields.count - 1) {
        [[self.textFields objectAtIndex:0] becomeFirstResponder];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [textField resignFirstResponder];
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        });
    }
    
    return YES;
}


//-(void)textFieldDidEndEditing:(UITextField *)sender
//{
//    LOG_UI(0, @"%@", sender);
//}
//
//-(void)textFieldDidBeginEditing:(UITextField *)sender
//{
//}


- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
