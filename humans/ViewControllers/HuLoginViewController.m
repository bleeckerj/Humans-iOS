//
//  HuLoginViewController.m
//  humans
//
//  Created by julian on 12/18/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import "HuLoginViewController.h"
#import "defines.h"
#import "HuAppDelegate.h"
#import "HuUserHandler.h"
#import "SBJson4Writer.h"
#import "HuHumansScrollViewController.h"
#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/NSArray+BlocksKit.h>
#import "Flurry.h"
#import <Crashlytics/Crashlytics.h>
#import "HuHumansProfileCarouselViewController.h"
#import <Parse/Parse.h>
#import <SSKeychain.h>

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

@interface HuLoginViewController ()
{
    HuUserHandler *userHandler;
    HuHumansScrollViewController *humansScrollViewController;
}
@end

@implementation HuLoginViewController

@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize loginButton;
@synthesize signUpButton;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        //[self loginViaKeychain];
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    loginButton.buttonColor = [UIColor crayolaTealBlueColor];
    loginButton.shadowColor = loginButton.buttonColor;
    loginButton.shadowHeight = 0.0f;
    loginButton.cornerRadius = 0.0f;
    loginButton.titleLabel.font = BUTTON_FONT_LARGE;
    [loginButton setHighlightedColor:[UIColor crayolaTealBlueColor]];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    signUpButton.buttonColor = [UIColor carrotColor];
    signUpButton.shadowColor = signUpButton.buttonColor;
    signUpButton.shadowHeight = 0.0f;
    signUpButton.cornerRadius = 0.0f;
    signUpButton.titleLabel.font = BUTTON_FONT_LARGE;
    [signUpButton setHighlightedColor:[UIColor carrotColor]];
    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self registerForKeyboardNotifications];
    [usernameTextField setDelegate:self];
    [passwordTextField setDelegate:self];
    
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    userHandler = [delegate humansAppUser];
    
    UIFont *font = LOGIN_VIEW_FONT_LARGE;
    
    self.usernameTextField.font=font;
    self.passwordTextField.font=font;
    
    [self.usernameTextField setBackgroundColor:[UIColor crayolaTealBlueColor]];
    [self.usernameTextField setTextColor:[UIColor whiteColor]];
    
    
    [self.passwordTextField setBackgroundColor:[UIColor crayolaTealBlueColor]];
    [self.passwordTextField setTextColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.usernameTextField.text = @"";
    self.passwordTextField.text = @"";
}

- (IBAction)touchUp_signUpButton:(id)sender
{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    HuSignUpViewController *signUpViewController = [delegate signUpViewController];
    [[self navigationController]setViewControllers:@[signUpViewController] animated:YES];
}


- (IBAction)touchUp_logInButton:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    progressView.mode = MRProgressOverlayViewModeIndeterminate;
    progressView.titleLabelText = @"Logging In";
    
    [userHandler userRequestTokenForUsername:[usernameTextField text] forPassword:[passwordTextField text] withCompletionHandler:^(BOOL success, NSError *error) {
        //
        NSDictionary *dimensions = @{@"user": [usernameTextField text], @"success": success?@"YES":@"NO", @"error": error==nil?@"nil":[[error userInfo]description]};
        [PFAnalytics trackEvent:@"service-login" dimensions:dimensions];
        [Flurry logEvent:@"service-login" withParameters:dimensions];

        if(success) {
            NSString *userid = [[[userHandler humans_user]id]description];
            [Crashlytics setUserName:[usernameTextField text]];
            [Crashlytics setUserIdentifier: userid];
            
            [SSKeychain deletePasswordForService:UNIQUE_APP_KEYCHAIN_SERVICE_NAME account:[usernameTextField text]];
            [SSKeychain setPassword:[passwordTextField text] forService:UNIQUE_APP_KEYCHAIN_SERVICE_NAME account:[usernameTextField text]];
            
            [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
            
                [[[userHandler humans_user]humans]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    //
                    HuHuman *human = (HuHuman*)obj;
                    [[human profile_images]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        //
                        
                        //UIImage *img = (UIImage *)obj;
                    }];
                }];

                // have to do this on the main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    humansScrollViewController = [[HuHumansScrollViewController alloc]init];
                   
                    HuHumansProfileCarouselViewController *x = [[HuHumansProfileCarouselViewController alloc]init];
                    
                    [[self navigationController]pushViewController:x animated:YES];
                    /*
                    UIViewController *underLeftViewController  = [[UIViewController alloc] init];
                    UIViewController *underRightViewController = [[UIViewController alloc] init];
                    
                    // configure under left view controller
                    underLeftViewController.view.layer.borderWidth     = 10;
                    underLeftViewController.view.layer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
                    underLeftViewController.view.layer.borderColor     = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
                    underLeftViewController.edgesForExtendedLayout     = UIRectEdgeTop | UIRectEdgeBottom | UIRectEdgeLeft; // don't go under the top view
                    
                    
//                    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mySelector:)];

                    
                    // configure under right view controller
                    underRightViewController.view.layer.borderWidth     = 20;
                    underRightViewController.view.layer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
                    underRightViewController.view.layer.borderColor     = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
                    underRightViewController.edgesForExtendedLayout     = UIRectEdgeTop | UIRectEdgeBottom | UIRectEdgeRight; // don't go under the top view
                    
                    // configure sliding view controller
                    //self.slidingViewController = [ECSlidingViewController slidingWithTopViewController:humansScrollViewController];
                    self.slidingViewController = [HuSlidingViewController slidingWithTopViewController:humansScrollViewController];
                    self.slidingViewController.underLeftViewController  = underLeftViewController;
                    self.slidingViewController.underRightViewController = underRightViewController;
                    
                    // configure anchored layout
                    self.slidingViewController.anchorRightPeekAmount  = 100.0;
                    self.slidingViewController.anchorLeftRevealAmount = 200.0;
                    
                    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:humansScrollViewController action:@selector(mySelector:)];
                    [tapGesture setNumberOfTapsRequired:2];
                    [underLeftViewController.view addGestureRecognizer:tapGesture];

                    
                    [humansScrollViewController setSlidingViewController:self.slidingViewController];
                    [[self navigationController]pushViewController:self.slidingViewController animated:YES];
                     */
                });
            
        
        } else {
            ///[self.activityIndicatorView stopAnimating];
            
            [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
            
            MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
            progressView.mode = MRProgressOverlayViewModeCross;
            progressView.titleLabelText = [NSString stringWithFormat:@"Login Failed %@", [error description]];
            [self performBlock:^{
                [progressView dismiss:YES];
            } afterDelay:5.0];
            //shake
            NSString *msg =[NSString stringWithFormat:@"%@ had trouble logging in with %@ cause of %@", [usernameTextField text], [passwordTextField text], error ];
           
            [Flurry logError:msg message:msg error:error];

        }
    }];
}


- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}
//- (UIPanGestureRecognizer *)recognizer
//{
//    UIPanGestureRecognizer *result = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(crashAndBurn:)];
//    return result;
//}

//- (void)anchorRight {
//    [self.slidingViewController anchorTopViewToRightAnimated:YES];
//}
//
//- (void)anchorLeft {
//    [self.slidingViewController anchorTopViewToLeftAnimated:YES];
//}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    LOG_UI(0, @"prepareForSegue %@ %@", segue, sender);
}

- (IBAction)textEditingDidEnd:(UITextField *)sender {
    LOG_UI(9, @"End %@", [sender text]);
}

- (IBAction)textEditingDidBeginFTW:(UITextField *)sender {
    LOG_UI(0, @"Begin %@", [sender text]);
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    LOG_UI(0, @"View Did Appear");

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)registerForKeyboardNotifications

{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(id)sender
{
    
}

- (void)keyboardWillBeHidden:(id)sender
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
