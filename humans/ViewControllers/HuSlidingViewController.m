//
//  HuTopViewController.m
//  humans
//
//  Created by julian on 1/25/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuSlidingViewController.h"

@interface HuSlidingViewController ()

@end

@implementation HuSlidingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPanGestureRecognizer action

//- (void)detectPanGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
//    
//    CGFloat translationX  = [recognizer translationInView:self.view].x;
//    CGFloat velocityX     = [recognizer velocityInView:self.view].x;
//
//    if(velocityX > 300) {
//        SEL setup = @selector(detectPanGestureRecognizer:);
//        [super performSelectorOnMainThread:setup withObject:recognizer waitUntilDone:YES];
//        LOG_UI(0, @"translationX=%f, velocityX=%f", translationX, velocityX);
//
//    }
////    [self.defaultInteractiveTransition updateTopViewHorizontalCenterWithRecognizer:recognizer];
////    _isInteractive = NO;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
