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
#import "HuHumansScrollViewController.h"
#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/NSArray+BlocksKit.h>


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
    if (self) {
        
        // Custom initialization
        //        CGRect rect = CGRectMake(10, 10, 200, 30);
        //        usernameTextField  = [[UITextField alloc]initWithFrame:rect];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    //UINavigationController *nc = [self navigationController];
    
    [super viewDidLoad];
    
    
    [self registerForKeyboardNotifications];
    [emailTextField setDelegate:self];
    [usernameTextField setDelegate:self];
    [passwordTextField setDelegate:self];
    
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    userHandler = [delegate humansAppUser];
    
    UIFont *font = [UIFont fontWithName:@"DINAlternate-Bold" size:30.0f];
    
    self.emailTextField.font=[font fontWithSize:19];
    self.usernameTextField.font=[font fontWithSize:19];
    self.passwordTextField.font=[font fontWithSize:19];
    //UIStoryboard *story_board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //humansScrollViewController = [story_board instantiateViewControllerWithIdentifier:@"HuHumansScrollViewController"];
    //humansScrollViewController = [[HuHumansScrollViewController alloc]init];
    
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
            
            dispatch_group_t group = dispatch_group_create();
            dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
            
            __block int i = 0;
//            [[[userHandler humans_user]humans] bk_apply:^(id obj) {
//                //
//                dispatch_group_enter(group);
//                HuHuman *human = (HuHuman*)obj;
//                [human loadServiceUsersProfileImagesWithCompletionHandler:^{
//                    //
//                    LOG_GENERAL(0, @"%d loaded profile images for %@", ++i, [human name]);
//                    dispatch_group_leave(group);
//                }];
//            }];
            dispatch_group_notify(group, queue, ^{
                LOG_GENERAL(0, @"%d now going to push to humans scroll view", i);
                //NSArray *a = [[userHandler humans_user]humans];
                
                [[[userHandler humans_user]humans]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    //
                    HuHuman *human = (HuHuman*)obj;
                    [[human profile_images]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        //
                        
                        UIImage *img = (UIImage *)obj;
                        CGImageRef imageRef = [img CGImage];
                        LOG_GENERAL(0, @"profile image=%@", img);
                        dispatch_async(dispatch_get_main_queue(), ^{

                            LOG_GENERAL_IMAGE(0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef), UIImageJPEGRepresentation(img, 1.0));
                        });
                    }];
                }];
                
                humansScrollViewController = [[HuHumansScrollViewController alloc]init];
                [humansScrollViewController setArrayOfHumans:[[userHandler humans_user]humans]];
                
                
                // have to do this on the main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[self navigationController]pushViewController:humansScrollViewController animated:YES];

                });
            });
            
            
            
            //UIStoryboard *story_board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            //            UIStoryboardSegue *segue =  [[UIStoryboardSegue alloc] initWithIdentifier:@"ToHumansScrollView" source:self destination:humansScrollViewController];
            //            [segue perform];
            //[self prepareForSegue:segue sender:sender];
            
            // [[self navigationController]performSegueWithIdentifier:@"ToHumansScrollView" sender:sender];
            // [self performSegueWithIdentifier:@"ToHumansScrollView" sender:sender];
            //            [self performSegueWithIdentifier:@"ToHumansScrollView" sender:sender];
            //            [self presentViewController:humansScrollViewController animated:YES completion:^{
            //                //
            //                LOG_UI(0, @"Should've pesented");
            //            }];
        } else {
            //shake
        }
    }];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
