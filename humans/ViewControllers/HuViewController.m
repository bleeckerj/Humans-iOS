//
//  HuViewController.m
//  humans
//
//  Created by julian on 12/13/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import "HuViewController.h"
#import "HuLoginViewController.h"
#import "defines.h"

@interface HuViewController ()

@end

@implementation HuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    HuLoginViewController *login = [[self storyboard]instantiateViewControllerWithIdentifier:@"HuLoginViewController"];
    [self presentViewController:login animated:YES completion:^{
        //
        LOG_GENERAL(0, @"Done presenting");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
