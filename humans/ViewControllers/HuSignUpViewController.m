//
//  HuSignUpViewController.m
//  humans
//
//  Created by Julian Bleecker on 2/21/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuSignUpViewController.h"
#import <NSObject+BKBlockObservation.h>

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





@interface HuUsernameValidator : US2Validator
{
    
}

@property HuSignUpViewController *_notifyDelegate;
//@property BOOL isCheckingUsernameUniqueness;

@end

@implementation HuUsernameValidator

@synthesize _notifyDelegate;
//@synthesize isCheckingUsernameUniqueness;
- (id)init
{
    self = [super init];
    if (self)
    {
        //US2ConditionCollection *conditions = [[US2ConditionCollection alloc]init];
        
        HuUS2ConditionLowerAlphaEmotis *lowerAlphaEmotis = [[HuUS2ConditionLowerAlphaEmotis alloc]init];
        [lowerAlphaEmotis setLocalizedViolationString:@"Use only lower case"];
        [_conditionCollection addCondition:lowerAlphaEmotis];
        
        HuUS2ConditionEmojiStringRange *range = [[HuUS2ConditionEmojiStringRange alloc]init];
        [range setRange:NSMakeRange(2, 24)];
        [range setLocalizedViolationString:@"Enter at least two letters"];
        [range setShouldAllowViolation:NO];
        [_conditionCollection addCondition:range];
        
    }
    
    return self;
    
}

- (US2ConditionCollection *)checkConditions:(NSString *)string
{
    US2ConditionCollection *result = [super checkConditions:string];
    //    [_notifyDelegate.checkUsernameAnnunciator setHidden:NO];
    //    [_notifyDelegate.checkUsernameAnnunciator startAnimating];
    [HuUserHandler usernameExists:string withCompletionHandler:^(BOOL exists, NSError *error) {
        [self performBlock:^{
            [_notifyDelegate.checkUsernameAnnunciator setHidden:YES];
            if(error == nil) {
                if(exists) {
                    [_notifyDelegate isUniqueUsername:string isUnique:NO];
                } else {
                    [_notifyDelegate isUniqueUsername:string isUnique:YES];
                    
                }
            }
            
        } afterDelay:1.0];
        
    }];
    return result;
}

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end


@interface HuSignUpViewController ()
{
    CGRect keyboardEndFrame;
    HuUserHandler *user_handler;
    MSWeakTimer *timer;
    dispatch_queue_t privateQueue;
    //HuConditionUniqueUsername *uniqueUsername;
    //@private NSMutableArray *_textUICollection;
}


@property (nonatomic, strong) NSArray *textFields;

@property (nonatomic, strong) UIButton *completeButton;

@end

@implementation HuSignUpViewController

@synthesize signUpLabel;
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize usernameTextField;
@synthesize usernameInfoLabel;
@synthesize signUpButton;
@synthesize keyboardAvoidingScrollView;
@synthesize confirmPasswordTextField;
@synthesize loginButton;
@synthesize passwordInfoLabel, emailInfoLabel;
@synthesize completeButton;
@synthesize checkUsernameAnnunciator;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    //uniqueUsername = [[HuConditionUniqueUsername alloc]init];
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    user_handler = [delegate humansAppUser];
    privateQueue = dispatch_queue_create("com.nearfuturelaboratory.private_queue", DISPATCH_QUEUE_CONCURRENT);
    
}

- (void)initFields
{
    //[firstNameTextField release];
    
}

- (void)loadView
{
    // [super loadView];
    [self initFields];
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat status_bar_height = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGFloat elementWidth = roundf(applicationFrame.size.width - 2 * 20);
    CGRect scrollViewFrame = CGRectMake(self.navigationController.view.frame.origin.x, self.navigationController.view.frame.origin.y + status_bar_height, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height-status_bar_height);
    
    self.keyboardAvoidingScrollView = [[RDVKeyboardAvoidingScrollView alloc] initWithFrame:scrollViewFrame];
    [keyboardAvoidingScrollView setBackgroundColor:[UIColor whiteColor]];
    [keyboardAvoidingScrollView setAlwaysBounceVertical:YES];
    
    signUpLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, elementWidth, 45)];
    [signUpLabel setTextColor:[UIColor blackColor]];
    [signUpLabel setFont:TEXTFIELD_FONT_LARGE];
    [signUpLabel setText:@"Sign Up"];
    [signUpLabel setTextAlignment:NSTextAlignmentCenter];
    [signUpLabel setBackgroundColor:[UIColor clearColor]];
    
    [keyboardAvoidingScrollView addSubview:signUpLabel];
    
    usernameTextField = [[US2ValidatorTextField alloc]init];
    [usernameTextField setFrame:CGRectMake(20, CGRectGetMaxY(signUpLabel.frame) + 45, elementWidth, 45)];
    usernameTextField.text = @"";
    
    usernameTextField.validatorUIDelegate = self;
    usernameTextField.validateOnFocusLossOnly = NO;
    HuUsernameValidator *validator = [[HuUsernameValidator alloc]init];
    [validator set_notifyDelegate:self];
    [usernameTextField setValidator:validator];
    
    [usernameTextField setBorderStyle:UITextBorderStyleNone];
    //[usernameTextField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [usernameTextField setAdjustsFontSizeToFitWidth:YES];
    [usernameTextField setFont:TEXTFIELD_FONT_LARGE];
    [usernameTextField setBackgroundColor:[UIColor carrotColor ]];
    [usernameTextField setTextColor:[UIColor whiteColor]];
    [usernameTextField setPlaceholder:@"Pick A Username"];
    [usernameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [usernameTextField setDelegate:self];
    [usernameTextField mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:signUpLabel withMargins:UIEdgeInsetsMake(usernameTextField.height/2, 0, 0, 0)];
    [keyboardAvoidingScrollView addSubview:usernameTextField];
    
    checkUsernameAnnunciator = [[TYMActivityIndicatorView alloc] initWithActivityIndicatorStyle:TYMActivityIndicatorViewStyleNormal];
    [checkUsernameAnnunciator setFullRotationDuration:0.8];
    [checkUsernameAnnunciator setSize:CGSizeMake(usernameTextField.size.height, usernameTextField.size.height)];
    [checkUsernameAnnunciator setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [checkUsernameAnnunciator setOpaque:NO];
    [checkUsernameAnnunciator setBackgroundImage:[UIImage imageNamed:@"hublankbackground"]];
    [checkUsernameAnnunciator setIndicatorImage:[UIImage imageNamed:@"hugrayspinner"]];
    [checkUsernameAnnunciator setTintColor:[UIColor whiteColor]];
    [checkUsernameAnnunciator setHidden:YES];
    [usernameTextField setRightViewMode:UITextFieldViewModeAlways];
    [usernameTextField setRightView:checkUsernameAnnunciator];
    //[checkUsernameAnnunciator mc_setPosition:MCViewPositionRight inView:usernameTextField];
    
    
    usernameInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, usernameTextField.size.width, usernameTextField.size.height/3)];
    usernameInfoLabel.text = @"";
    [usernameInfoLabel setTextColor:[UIColor Garmin]];
    [usernameInfoLabel setFont:INFO_FONT_SMALL];
    [keyboardAvoidingScrollView addSubview:usernameInfoLabel];
    [usernameInfoLabel mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:usernameTextField withMargins:UIEdgeInsetsMake(5, 0, 0, 0)];
    
    passwordTextField = [[US2ValidatorTextField alloc]init ];
    passwordTextField.text = @"";
    [passwordTextField setFrame:CGRectMake(20, CGRectGetMaxY(usernameTextField.frame) + 45/2, elementWidth, 45)];
    [passwordTextField setBorderStyle:UITextBorderStyleNone];
    //[passwordTextField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [passwordTextField setAdjustsFontSizeToFitWidth:YES];
    [passwordTextField setFont:TEXTFIELD_FONT_LARGE];
    [passwordTextField setBackgroundColor:[UIColor carrotColor ]];
    [passwordTextField setTextColor:[UIColor whiteColor]];
    [passwordTextField setPlaceholder:@"Pick A Password"];
    [passwordTextField setDelegate:self];
    [passwordTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [passwordTextField setSecureTextEntry:YES];
    [keyboardAvoidingScrollView addSubview:passwordTextField];
    [passwordTextField mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:usernameInfoLabel withMargins:UIEdgeInsetsMake(5, 0, 0, 0)];
    
    US2ValidatorPasswordStrength *pwValidator = [[US2ValidatorPasswordStrength alloc]init];
    [pwValidator setRequiredStrength:US2PasswordStrengthMedium];
    passwordTextField.validator = pwValidator;
    passwordTextField.validatorUIDelegate = self;
    
    [passwordTextField bk_addEventHandler:^(id sender) {
        [passwordTextField setText:@""];
    } forControlEvents:UIControlEventEditingDidBegin];
    
    passwordInfoLabel = [[UILabel alloc]init];
    [passwordInfoLabel setFrame:CGRectMake(20, CGRectGetMaxY(passwordTextField.frame) + 45, passwordTextField.size.width, passwordTextField.size.height/3)];
    passwordInfoLabel.text = @"";
    [passwordInfoLabel setTextColor:[UIColor Garmin]];
    [passwordInfoLabel setFont:INFO_FONT_SMALL];
    [keyboardAvoidingScrollView addSubview:passwordInfoLabel];
    [passwordInfoLabel mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:passwordTextField withMargins:UIEdgeInsetsMake(5, 0, 0, 0)];
    
    
    confirmPasswordTextField = [[US2ValidatorTextField alloc]init];
    confirmPasswordTextField.text = @"";
    [confirmPasswordTextField setFrame:CGRectMake(20, CGRectGetMaxY(passwordInfoLabel.frame) + 45/2, elementWidth, 45)];
    [confirmPasswordTextField setBorderStyle:UITextBorderStyleNone];
    //[confirmPasswordTextField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [confirmPasswordTextField setAdjustsFontSizeToFitWidth:YES];
    [confirmPasswordTextField setFont:TEXTFIELD_FONT_LARGE];
    [confirmPasswordTextField setBackgroundColor:[UIColor carrotColor ]];
    [confirmPasswordTextField setTextColor:[UIColor whiteColor]];
    [confirmPasswordTextField setPlaceholder:@"Confirm Password"];
    [confirmPasswordTextField setDelegate:self];
    [confirmPasswordTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [confirmPasswordTextField setSecureTextEntry:YES];
    [keyboardAvoidingScrollView addSubview:confirmPasswordTextField];
    [confirmPasswordTextField mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:passwordInfoLabel withMargins:UIEdgeInsetsMake(5, 0, 0, 0)];
    [confirmPasswordTextField setDelegate:self];
    [confirmPasswordTextField bk_addEventHandler:^(id sender) {
        if([[passwordTextField text]isEqualToString:[confirmPasswordTextField text]] == NO) {
            [passwordInfoLabel setText:@"Passwords don't match"];
            [passwordInfoLabel setTextColor:[UIColor crayolaRadicalRedColor]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            });
            //[passwordTextField setText:@""];
            [confirmPasswordTextField setText:@""];
            
            
        }
    }forControlEvents:UIControlEventEditingDidEnd];
    
    [confirmPasswordTextField bk_addEventHandler:^(id sender) {
        if([[passwordTextField text]isEqualToString:[confirmPasswordTextField text]] == NO) {
            [passwordInfoLabel setText:@"Passwords don't match"];
            [passwordInfoLabel setTextColor:[UIColor crayolaRadicalRedColor]];
        }
        if([passwordTextField isValid] == NO) {
            [passwordInfoLabel setText:@"Lame password. Use numbers & punctuation"];
            [passwordTextField becomeFirstResponder];
            
        }
        if([passwordTextField isValid] && [[confirmPasswordTextField text]isEqualToString:[passwordTextField text]]) {
            [passwordInfoLabel setText:@"Passwords match. Good to go"];
            [passwordInfoLabel setTextColor:[UIColor Garmin]];
        }
    } forControlEvents:UIControlEventEditingChanged];
    
    emailTextField = [[US2ValidatorTextField alloc]init];
    emailTextField.text = @"";
    [emailTextField setFrame:CGRectMake(20, CGRectGetMaxY(confirmPasswordTextField.frame) + 45/2, elementWidth, 45)];
    [emailTextField setBorderStyle:UITextBorderStyleNone];
    //[emailTextField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [emailTextField setAdjustsFontSizeToFitWidth:YES];
    [emailTextField setFont:TEXTFIELD_FONT_LARGE];
    [emailTextField setBackgroundColor:[UIColor carrotColor ]];
    [emailTextField setTextColor:[UIColor whiteColor]];
    [emailTextField setPlaceholder:@"Your Email"];
    [emailTextField setDelegate:self];
    [emailTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [keyboardAvoidingScrollView addSubview:emailTextField];
    
    US2ValidatorEmail *emailValidator = [[US2ValidatorEmail alloc]init];
    emailTextField.validator = emailValidator;
    emailTextField.validatorUIDelegate = self;
    
    emailInfoLabel = [[UILabel alloc]init];
    [emailInfoLabel setFrame:CGRectMake(20, CGRectGetMaxY(emailTextField.frame) + 45, emailTextField.size.width, emailTextField.size.height/3)];
    emailInfoLabel.text = @"";
    [emailInfoLabel setTextColor:[UIColor Garmin]];
    [emailInfoLabel setFont:INFO_FONT_SMALL];
    [keyboardAvoidingScrollView addSubview:emailInfoLabel];
    [emailInfoLabel mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:emailTextField withMargins:UIEdgeInsetsMake(5, 0, 0, 0)];
    
    self.textFields = @[usernameTextField, passwordTextField, confirmPasswordTextField, emailTextField];
    
    signUpButton = [FUIButton buttonWithType:UIButtonTypeSystem];
    [signUpButton setFrame:CGRectMake(198, CGRectGetMaxY(emailTextField.frame) + 45/2, 104, 45)];
    [signUpButton.titleLabel setFont:TEXTFIELD_FONT_LARGE];
    [signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [signUpButton setBackgroundColor:[UIColor carrotColor]];
    [signUpButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signUpButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    [signUpButton bk_addEventHandler:^(id sender) {
        [self signUpButtonTouchUpInside];
    } forControlEvents:UIControlEventTouchUpInside];
    [keyboardAvoidingScrollView addSubview:signUpButton];
    
    loginButton = [FUIButton buttonWithType:UIButtonTypeSystem];
    [loginButton setFrame:CGRectMake(emailTextField.left, CGRectGetMaxY(emailTextField.frame) + 45/2, 104, 45)];
    [loginButton.titleLabel setFont:TEXTFIELD_FONT_LARGE];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor crayolaTealBlueColor ]];
    [loginButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton bk_addEventHandler:^(id sender) {
        __weak HuAppDelegate *delegate = (HuAppDelegate*)[[UIApplication sharedApplication]delegate];
        HuLoginViewController *loginViewController = [delegate loginViewController];
        [[self navigationController]setViewControllers:@[loginViewController]];
    } forControlEvents:UIControlEventTouchUpInside];
    [keyboardAvoidingScrollView addSubview:loginButton];
    
    
    self.view = keyboardAvoidingScrollView;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle )preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


-(void)viewDidUnload
{
    [super viewDidUnload];
    [self setKeyboardAvoidingScrollView:nil];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //LOG_ERROR(0, @"%@", [user_handler valueForKey:@"networkState"]);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setSize:CGSizeMake(180, 180)];
    
    self.emailTextField.text = @"";
    self.emailInfoLabel.text = @"";
    self.confirmPasswordTextField.text = @"";
    [self.confirmPasswordTextField setEnabled:NO];
    self.usernameTextField.text = @"";
    [checkUsernameAnnunciator setHidden:YES];
    
    self.passwordTextField.text = @"";
    self.passwordInfoLabel.text = @"";
    [self.passwordTextField setEnabled:NO];
    [self.confirmPasswordTextField setEnabled:NO];
    [user_handler bk_addObserverForKeyPath:@"networkState" task:^(id target) {
        //
        LOG_NETWORK(0, @"%@", target);
        [self networkChangedFrom:@0 to:@0];
    }];
    //[self disableSignUpButton];
    
    //[self checkNetwork];
    
    
    
}

- (void)networkChangedFrom:(NSNumber *)oldState to:(NSNumber *)newState
{
    if([user_handler networkState] == NETWORK_DOWN) {
        [self.usernameTextField setEnabled:NO];
        [self.emailTextField setEnabled:NO];
        [self.passwordTextField setEnabled:NO];
        [self.confirmPasswordTextField setEnabled:NO];
        [self popBadToastNotification:@"Network Down" withSubnotice:@""];
        
    } else {
        [self.usernameTextField setEnabled:YES];
        [self.emailTextField setEnabled:YES];
        [self.passwordTextField setEnabled:YES];
        [self.confirmPasswordTextField setEnabled:YES];
        [self popGoodToastNotification:@"Internet Back"];
        
    }
    
}

- (void)disableSignUpButton
{
    [signUpButton setEnabled:NO];
    [signUpButton setButtonColor:[UIColor crayolaManateeColor]];
}

- (void)enableSignUpButton
{
    [signUpButton setEnabled:YES];
    [signUpButton setButtonColor:[UIColor carrotColor]];
    
}



#pragma mark === US2ValidatorUIDelegate methods

- (void)validatorUI:(id<US2ValidatorUIProtocol>)validatorUI changedValidState:(BOOL)isValid
{
    
    if(validatorUI == passwordTextField) {
        //LOG_UI(0, @"%d", isValid);
        [passwordInfoLabel setText:[validatorUI text]];
        if(isValid) {
            [self.confirmPasswordTextField setEnabled:YES];
        }
    }
    
}


- (void)validatorUI:(id<US2ValidatorUIProtocol>)validatorUI violatedConditions:(US2ConditionCollection *)conditions
{
    if(validatorUI == usernameTextField) {
        LOG_UI(0, @"%@", conditions);
        if([conditions count] >  0) {
            US2Condition *first = [conditions conditionAtIndex:0];
            [usernameInfoLabel setText:[first localizedViolationString]];
        } else {
            [usernameInfoLabel setText:@""];
        }
    }
    if(validatorUI == passwordTextField) {
        NSDictionary *dimensions;
        if(conditions != nil) {
        dimensions = @{@"key": CLUSTERED_UUID,@"signup-password-field": conditions};
        } else {
            dimensions = @{@"key": CLUSTERED_UUID,@"signup-password-field" : @"nil"};
        }
        [[LELog sharedInstance]log:dimensions];
        LOG_UI(0, @"%@", conditions);
    }
    
}

#pragma mark == we check to see if all the fields are copacetic here

- (void)validatorUIDidChange:(id<US2ValidatorUIProtocol>)validatorUI
{
    if(validatorUI == usernameTextField) {
        
        if([validatorUI isValid]) {
            [usernameInfoLabel setText:[NSString stringWithFormat:@"%@", [validatorUI text]]];
            [usernameInfoLabel setTextColor:[UIColor Garmin]];
        } else {
            [passwordTextField setEnabled:NO];
        }
    }
    if(validatorUI == passwordTextField) {
        //LOG_UI(0, @"%d", [validatorUI isValid]);
        BOOL isValid = [validatorUI isValid];
        if(isValid) {
            [passwordInfoLabel setText:@"Not Lame"];
            [passwordInfoLabel setTextColor:[UIColor Garmin]];
            [confirmPasswordTextField setEnabled:YES];
        } else {
            [passwordInfoLabel setText:@"Lame. Use > 8 chars & numbers. #datahygeine"];
            [passwordInfoLabel setTextColor:[UIColor crayolaRadicalRedColor]];
            [confirmPasswordTextField setEnabled:NO];
        }
    }
    
    if(validatorUI == confirmPasswordTextField) {
        BOOL isValid = [validatorUI isValid];
        if(isValid && [[passwordTextField text]isEqualToString:[confirmPasswordTextField text]]) {
            [passwordInfoLabel setText:@"Not lame and passwords match"];
            [passwordInfoLabel setTextColor:[UIColor Garmin]];
            [emailTextField setEnabled:YES];
            return;
        }
        if(isValid) {
            [passwordInfoLabel setText:@"Not lame"];
            [passwordInfoLabel setTextColor:[UIColor Garmin]];
            [emailTextField setEnabled:NO];
            
        }
        else {
            [passwordInfoLabel setText:@"Lame"];
            [passwordInfoLabel setTextColor:[UIColor crayolaRadicalRedColor]];
            [emailTextField setEnabled:YES];
        }
        
    }
    
    // if all fields are good, we can sign up
    if([usernameTextField isValid] && [passwordTextField isValid] && [confirmPasswordTextField isValid] && [[confirmPasswordTextField text]isEqualToString:[passwordTextField text]] && [emailTextField isValid]) {
        [self enableSignUpButton];
        [self performBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                [emailTextField resignFirstResponder];
                
            });
            
        } afterDelay:3.5];
        
    } else {
        
        [self disableSignUpButton];
    }
    
    
}




- (void)isUniqueUsername:(NSString *)username isUnique:(BOOL)is
{
    if(is == NO) {
        [usernameInfoLabel setText:@"Username is already taken"];
        [usernameInfoLabel setTextColor:[UIColor crayolaRadicalRedColor]];
        [usernameInfoLabel setHidden:NO];
        [passwordTextField setEnabled:NO];
    } else {
        [usernameInfoLabel setText:[NSString stringWithFormat:@"%@ is available", username]];
        [passwordTextField setEnabled:YES];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view setNeedsDisplay];
    });
}



- (void)checkUsernameUniqueness
{
    //LOG_UI(0, @"Would check username uniqueness");
    [timer invalidate];
    dispatch_async(dispatch_get_main_queue(), ^{
        [checkUsernameAnnunciator setHidden:NO];
        [checkUsernameAnnunciator startAnimating];
        [usernameTextField setNeedsDisplay];
    });
    [HuUserHandler usernameExists:[usernameTextField text] withCompletionHandler:^(BOOL exists, NSError *error) {
        [self performBlock:^{
            [checkUsernameAnnunciator setHidden:YES];
            if(error == nil) {
                if(exists) {
                    [self isUniqueUsername:[usernameTextField text] isUnique:NO];
                } else {
                    [self isUniqueUsername:[usernameTextField text] isUnique:YES];
                    
                }
            }
            
        } afterDelay:1.0];
        
    }];
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == usernameTextField) {
        [timer invalidate];
        timer = [MSWeakTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(checkUsernameUniqueness) userInfo:nil repeats:NO dispatchQueue:privateQueue];
        
        
        string = [string lowercaseString];
        textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString:string];
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField == usernameTextField) {
        if([usernameTextField isValid]) {
            [passwordTextField setEnabled:YES];
            return YES;
        } else {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == usernameTextField) {
        if([usernameTextField isValid]) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

- (void)usernameTextFieldEditingDidEnd:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        // [usernameTextField resignFirstResponder];
        
    });
    [usernameTextField isValid];
}



- (IBAction)loginButtonTouchUpInside:(id)sender
{
    HuAppDelegate *delegate = (HuAppDelegate*)[[UIApplication sharedApplication]delegate];
    HuLoginViewController *loginViewController = [delegate loginViewController];
    // [[self navigationController]setViewControllers:@[loginViewController] animated:YES];
    [[self navigationController]setViewControllers:@[loginViewController] animated:YES];
}

- (void)signUpButtonTouchUpInside {
    [signUpButton setEnabled:NO];
    //[self popGoodToastNotification:[NSString stringWithFormat:@"Welcome %@", @"shemp"]];
    //[self popBadToastNotification:@"There was a problem signing up" withSubnotice:@"really weird error message about something obscure"];
    
    HuAppDelegate *delegate = (HuAppDelegate*)[[UIApplication sharedApplication]delegate];
    HuUserHandler *handler = [delegate humansAppUser];
    HuUser *user = [[HuUser alloc]init];
    [user setUsername:[usernameTextField text]];
    [user setEmail:[emailTextField text]];
    [handler parseCreateNewUser:user password:[passwordTextField text] withCompletionHandler:^(id data, BOOL success, NSError *error) {
        //
        NSDictionary *dimensions;
        if(data != nil) {
            dimensions = @{@"key": CLUSTERED_UUID,@"create-new-user": [user username], @"success" : success ? @"YES" : @"NO", @"data" : data};
        } else {
            dimensions = @{@"key": CLUSTERED_UUID,@"create-new-user" :[user username],  @"success" : success ? @"YES" : @"NO", @"data" : @"nil"};
        }
        [[LELog sharedInstance]log:dimensions];
        
        if(success == YES) {
            [self popGoodToastNotification:[NSString stringWithFormat:@"Welcome %@", [user username]]];
            [signUpButton setEnabled:NO];
            [self performBlock:^{
                //
                [self loginButtonTouchUpInside:nil];
            } afterDelay:4];
            
        }
        
        if(success == NO) {
            [self popBadToastNotification:@"There was a problem signing up" withSubnotice:[error userInfo][@"error"]];
            [self performBlock:^{
                [self enableSignUpButton];
            } afterDelay:5];
        }
    }];
    
    
}

- (void)popBadToastNotification:(NSString *)notice withSubnotice:(NSString *)subnotice
{
    [CRToastManager dismissNotification:YES];
    
    NSDictionary *options = @{
                              kCRToastTextKey :notice,
                              kCRToastSubtitleTextKey : subnotice,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : [UIColor crayolaManateeColor],
                              kCRToastFontKey : HEADER_FONT_LARGE,
                              kCRToastSubtitleFontKey : HEADER_FONT,
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastTimeIntervalKey : @3,
                              kCRToastUnderStatusBarKey : @NO,
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                              };
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    NSLog(@"Completed");
                                }];
    
}

- (void)popGoodToastNotification:(NSString *)notice
{
    
    [CRToastManager dismissNotification:YES];
    
    NSDictionary *options = @{
                              kCRToastTextKey :notice,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : [UIColor Garmin],
                              kCRToastFontKey : HEADER_FONT_LARGE,
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastTimeIntervalKey : @3,
                              kCRToastUnderStatusBarKey : @NO,
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                              };
    
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    NSLog(@"Completed");
                                }];
}


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


