//
//  FindFollowsForService_ViewController.m
//  Humans
//
//  Created by julian on 12/6/12.
//  Copyright (c) 2012 nearfuturelaboratory. All rights reserved.
//

#import "FindFollowsForService_ViewController.h"

@interface FindFollowsForService_ViewController ()

@end

@implementation FindFollowsForService_ViewController

HuUserHandler *appUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self commonInit];
    }
    return self;
}

- (id)init
{
    self = [super self];
    if(self) {
        [self commonInit];
    }
return self;
}

- (void)commonInit
{
    HuAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    appUser = [delegate humansAppUser];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // set up the search view
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
