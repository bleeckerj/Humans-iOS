//
//  HuLoginOrSignUpViewController.m
//  Pods
//
//  Created by Julian Bleecker on 2/22/14.
//
//

#import "HuLoginOrSignUpViewController.h"
#import "HuSignUpViewController.h"
#import "HuLoginViewController.h"
#import <MSWeakTimer.h>

@interface HuLoginOrSignUpViewController ()
@property (strong, nonatomic) MSWeakTimer *animationTimer;
@property (strong, nonatomic) dispatch_queue_t privateQueue;

@end

@implementation HuLoginOrSignUpViewController

@synthesize loginButton;
@synthesize signUpButton;
@synthesize rotatingHandView;
@synthesize rotatingHandTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarStyle )preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    
	// Do any additional setup after loading the view.
    signUpButton.buttonColor = [UIColor carrotColor];
    signUpButton.shadowColor = signUpButton.buttonColor;
    signUpButton.shadowHeight = 0.0f;
    signUpButton.cornerRadius = 0.0f;
    signUpButton.titleLabel.font = BUTTON_FONT_LARGE;
    [signUpButton setHighlightedColor:[UIColor carrotColor]];
    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    loginButton.buttonColor = [UIColor crayolaTealBlueColor];
    loginButton.shadowColor = loginButton.buttonColor;
    loginButton.shadowHeight = 0.0f;
    loginButton.cornerRadius = 0.0f;
    loginButton.titleLabel.font = BUTTON_FONT_LARGE;
    [loginButton setHighlightedColor:[UIColor crayolaTealBlueColor]];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rotatingHandTextField setTitleColor:[loginButton buttonColor] forState:UIControlStateNormal];
    [RFRotate rotate90:rotatingHandView withDuration:0.0];
    isPointingUp = NO;
    //stopAnimating = NO;
    self.privateQueue = dispatch_queue_create("com.nearfuturelaboratory.humans.HuLoginOrSignUpViewController_queue", DISPATCH_QUEUE_CONCURRENT);

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.animationTimer = [MSWeakTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(rotateHand) userInfo:nil repeats:YES dispatchQueue:self.privateQueue];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [rotatingHandTextField.layer removeAllAnimations];
    [signUpButton.layer removeAllAnimations];
    [loginButton.layer removeAllAnimations];
    [self.animationTimer invalidate];
}

BOOL isPointingUp;
BOOL stopAnimating;

- (void)rotateHand
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [RFRotate rotate180:rotatingHandView withDuration:0.5 andBlock:^{
            //
            isPointingUp ^= YES;
            
        } andCompletion:^{
            //
            
            if(isPointingUp) {
                [self animateToggleButtonAlpha:signUpButton withCompletion:^{
                    [self animateToggleButtonAlpha:signUpButton withCompletion:^{
                        
                    }];
                    
                }];
            } else {
                [self animateToggleButtonAlpha:loginButton withCompletion:^{
                    [self animateToggleButtonAlpha:loginButton withCompletion:^{
                        
                    }];
                    
                }];
                
            }
            
        }];
 
    });
    

   
}
- (IBAction)loginButtonTouchUpInside:(id)sender
{
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    HuLoginViewController *loginViewController = [delegate loginViewController];
    [[self navigationController]setViewControllers:@[loginViewController] animated:YES];
   
}


- (IBAction)signUpButtonTouchUpInside:(id)sender
{
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    HuSignUpViewController *signUpViewController = [delegate signUpViewController];
    [[self navigationController]setViewControllers:@[signUpViewController] animated:YES];
}

- (void)animateToggleButtonAlpha:(FUIButton *)button withCompletion:(BlockCallback)completion
{
    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        //
        if(button.alpha == 1.0) {
            button.alpha = 0.0;

        } else {
            button.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
        //
        if(completion) {
            completion();
        }
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
