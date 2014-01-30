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

@interface HuLoginViewController ()
{
    HuUserHandler *userHandler;
    HuHumansScrollViewController *humansScrollViewController;
}
@end

@implementation HuLoginViewController

@synthesize emailTextField;
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize signInButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) // only for iOS 7 and above
//    {
//        CGRect frame = self.navigationController.view.frame;
//        frame.origin.y += 20;
//        frame.size.height -= 20;
//        self.navigationController.view.frame = frame;
//        self.navigationController.view.backgroundColor = [UIColor grayColor];
//        
//    }

    
    //[[Crashlytics sharedInstance] crash];
    //int *x = NULL; *x = 42;
    [self registerForKeyboardNotifications];
    [emailTextField setDelegate:self];
    [usernameTextField setDelegate:self];
    [passwordTextField setDelegate:self];
    
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    userHandler = [delegate humansAppUser];
    
    UIFont *font = [UIFont fontWithName:@"DINAlternate-Bold" size:30.0f];
    
    self.emailTextField.font=[font fontWithSize:19];
    self.usernameTextField.font=[font fontWithSize:28];
    self.passwordTextField.font=[font fontWithSize:29];
    
}


- (IBAction)touchUp_signInButton:(id)sender {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    LOG_UI(0, @"Touch Up Sign In Button %@", sender);
    [Flurry logEvent:[NSString stringWithFormat:@"SIGN_IN %@" , [usernameTextField text]]];
    
    MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    progressView.mode = MRProgressOverlayViewModeIndeterminate;
    progressView.titleLabelText = @"Logging In";
    
//    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"Logging in" mode:MRProgressOverlayViewModeIndeterminate animated:YES stopBlock:^(MRProgressOverlayView *progressOverlayView) {
//        //
//        LOG_UI(0, @"Stopped");
//    }];
    [userHandler userRequestTokenForUsername:[usernameTextField text] forPassword:[passwordTextField text] withCompletionHandler:^(BOOL success, NSError *error) {
        //
        if(success) {
            
            //go ahead
//            SBJson4Writer *writer = [[SBJson4Writer alloc] init];
//            NSString *user_json = [writer stringWithObject:[[userHandler humans_user] dictionary]];
//            LOG_GENERAL(0, @"User %@", user_json);
            [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
            [Flurry logEvent:[NSString stringWithFormat:@"%@ logged in successfully", [usernameTextField text]]];
            
            dispatch_group_t group = dispatch_group_create();
            dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
            
            __block int i = 0;
            dispatch_group_notify(group, queue, ^{
                LOG_GENERAL(0, @"%d now going to push to humans scroll view", i);
                //NSArray *a = [[userHandler humans_user]humans];
                
                [[[userHandler humans_user]humans]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    //
                    HuHuman *human = (HuHuman*)obj;
                    [[human profile_images]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        //
                        
                        //UIImage *img = (UIImage *)obj;
                    }];
                }];
                
                humansScrollViewController = [[HuHumansScrollViewController alloc]init];
                //[humansScrollViewController setArrayOfHumans:[[userHandler humans_user]humans]];
                
                // have to do this on the main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    //UIViewController *topViewController        = humansScrollViewController;///[[UIViewController alloc] init];
                    UIViewController *underLeftViewController  = [[UIViewController alloc] init];
                    UIViewController *underRightViewController = [[UIViewController alloc] init];
                    
                    // configure under left view controller
                    underLeftViewController.view.layer.borderWidth     = 20;
                    underLeftViewController.view.layer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
                    underLeftViewController.view.layer.borderColor     = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
                    underLeftViewController.edgesForExtendedLayout     = UIRectEdgeTop | UIRectEdgeBottom | UIRectEdgeLeft; // don't go under the top view
                    
                    // configure under right view controller
                    underRightViewController.view.layer.borderWidth     = 20;
                    underRightViewController.view.layer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
                    underRightViewController.view.layer.borderColor     = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
                    underRightViewController.edgesForExtendedLayout     = UIRectEdgeTop | UIRectEdgeBottom | UIRectEdgeRight; // don't go under the top view
                    
                    // configure sliding view controller
                    //self.slidingViewController = [ECSlidingViewController slidingWithTopViewController:humansScrollViewController];
                    self.slidingViewController = [HuSlidingViewController slidingWithTopViewController:humansScrollViewController];
                    [humansScrollViewController setSlidingViewController:self.slidingViewController];
                    self.slidingViewController.underLeftViewController  = underLeftViewController;
                    self.slidingViewController.underRightViewController = underRightViewController;
                    
                    // configure anchored layout
                    self.slidingViewController.anchorRightPeekAmount  = 100.0;
                    self.slidingViewController.anchorLeftRevealAmount = 250.0;
                    
                    //self.window.rootViewController = self.slidingViewController;
                    [humansScrollViewController setSlidingViewController:self.slidingViewController];
                    [[self navigationController]pushViewController:self.slidingViewController animated:YES];
                });
            
            });
            
        
        } else {
            ///[self.activityIndicatorView stopAnimating];
            
            [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
            
            MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
            progressView.mode = MRProgressOverlayViewModeCheckmark;
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

- (void)anchorRight {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void)anchorLeft {
    [self.slidingViewController anchorTopViewToLeftAnimated:YES];
}


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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LOG_UI(0, @"View Will Appear");
    // if the view appears again (going back from a status scroller), we need to
    // re-add this gesture recognizer, which gets removed by HuHumansScrollViewController
    // so that the gestures in the top bar of HuHumansScrollViewController are recognized
    
    //    [[self view]setBackgroundColor:[UIColor grayColor]];
    //    [[self usernameTextField]setText:@"HELLO??"];
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    LOG_UI(0, @"%@", [textField text]);
//}

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
    LOG_UI(0, @"Hello %@ %@ %@", [usernameTextField text], [passwordTextField text], [emailTextField text]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
