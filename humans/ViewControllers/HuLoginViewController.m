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
#import "SBJsonWriter.h"

@interface HuLoginViewController ()
{
    HuUserHandler *userHandler;
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
    if (self) {
        
        // Custom initialization
//        CGRect rect = CGRectMake(10, 10, 200, 30);
//        usernameTextField  = [[UITextField alloc]initWithFrame:rect];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    [emailTextField setDelegate:self];
    [usernameTextField setDelegate:self];
    [passwordTextField setDelegate:self];
    
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    userHandler = [delegate humansAppUser];
    
	// Do any additional setup after loading the view.
//            CGRect rect = CGRectMake(10, 10, 200, 30);
//            usernameTextField  = [[UITextField alloc]initWithFrame:rect];
//    [[self view]addSubview:usernameTextField];

}


- (IBAction)touchUp_signInButton:(id)sender {
    LOG_UI(0, @"Touch Up Sign In Button %@", sender);
    [userHandler userRequestTokenForUsername:[usernameTextField text] forPassword:[passwordTextField text] withCompletionHandler:^(BOOL success, NSError *error) {
        //
        if(success) {
            //go ahead
            SBJsonWriter *writer = [[SBJsonWriter alloc] init];
            NSString *user_json = [writer stringWithObject:[[userHandler humans_user] dictionary]];
            LOG_GENERAL(0, @"User %@", user_json);
        } else {
            //shake
        }
    }];
}


- (IBAction)textEditingDidEnd:(UITextField *)sender {
    LOG_UI(9, @"End %@", [sender text]);
}

- (IBAction)textEditingDidBeginFTW:(UITextField *)sender {
    LOG_UI(0, @"Begin %@", [sender text]);

}

- (void)viewWillAppear:(BOOL)animated
{
    LOG_UI(0, @"View Will Appear");
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
