//
//  HuHumanProfileViewController.m
//  humans
//  Profile View for a single "Human" // could contain Stats, a view of all the users in the human, etc.
//  Right now, it's the only way to add or delete users to a human
//
//  Created by Julian Bleecker on 2/28/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuEditHumanViewController.h"


@interface HuEditHumanViewController ()
{
    NSMutableArray *textFields;
    //UIStoryboard *storyBoard;
    HuUserHandler *user_handler;
}
@end

@implementation HuEditHumanViewController

//HuHumansScrollViewController *statusCarouselViewController;

@synthesize editButton;
@synthesize deleteButton;
@synthesize goBackButton;
@synthesize nameLabel;
@synthesize human;
@synthesize nameTextField;
@synthesize keyboardAvoidingScrollView;
@synthesize refreshOnReturn;
@synthesize humansProfileCarouselViewController;

- (id)init
{
    self = [super init];
    if(self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self commonInit];
    }
    return self;
}

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
    textFields = [[NSMutableArray alloc]init];
   // storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    refreshOnReturn = NO;
    HuAppDelegate *delegate =  [[UIApplication sharedApplication]delegate];
    user_handler = [delegate humansAppUser];
    
}

CGRect frame;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:2.0];
    
    frame = [nameLabel frame];
	// Do any additional setup after loading the view.
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat status_bar_height = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    //CGFloat elementWidth = roundf(applicationFrame.size.width - 2 * 20);
    CGRect scrollViewFrame = CGRectMake(self.navigationController.view.frame.origin.x, self.navigationController.view.frame.origin.y + 2*status_bar_height, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
    self.keyboardAvoidingScrollView = [[RDVKeyboardAvoidingScrollView alloc] initWithFrame:scrollViewFrame];
    self.view = self.keyboardAvoidingScrollView;
    
    [keyboardAvoidingScrollView setAutoresizingMask:UIViewAutoresizingNone];
    [keyboardAvoidingScrollView setBackgroundColor:[UIColor whiteColor]];
    [keyboardAvoidingScrollView setAlwaysBounceVertical:YES];
    
    
    [editButton setButtonColor:[UIColor crayolaTealBlueColor]];
    editButton.shadowColor = editButton.buttonColor;
    editButton.shadowHeight = 0.0f;
    editButton.cornerRadius = 0.0f;
    editButton.titleLabel.font = BUTTON_FONT_LARGE;
    [editButton setHighlightedColor:[UIColor crayolaGrannySmithAppleColor]];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
#pragma mark Edit Button event handler
    [editButton bk_addEventHandler:^(id sender) {
        //
        __block HuEditHumanViewController *weakSelf = self;
        
        
        HuAddDeleteServiceUserCarouselViewController *vc = [[HuAddDeleteServiceUserCarouselViewController alloc]init];
        [vc setHuman:human];
        
        MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
        [formSheet setCornerRadius:3.0f];
        
        [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = weakSelf;
        __weak MZFormSheetController *weakFormSheet = formSheet;
        
        formSheet.presentedFormSheetSize = CGSizeMake(300, 150);
        formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
        formSheet.shadowRadius = 4.0;
        formSheet.shadowOpacity = 0.5;
        formSheet.shouldDismissOnBackgroundViewTap = YES;
        formSheet.shouldCenterVertically = YES;
        formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
        
        // If you want to animate status bar use this code
        formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
            if([vc deletesWereMade] == YES) {
                // gettyup
                refreshOnReturn = YES;
                
            }
            
            UINavigationController *navController = self.navigationController;
            if ([navController.topViewController isKindOfClass:[HuEditHumanViewController class]]) {
                HuEditHumanViewController *mzvc = (HuEditHumanViewController *)navController.topViewController;
                mzvc.showStatusBar = NO;
            }
            
            
            [UIView animateWithDuration:0.3 animations:^{
                if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                    [weakFormSheet setNeedsStatusBarAppearanceUpdate];
                }
            }];
        };
        
        
        formSheet.didDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
            LOG_UI(0, @"Dismissed %@ deletesWereMade=%@ wantsNewUser=%@", presentedFSViewController, [vc deletesWereMade]?@"YES":@"NO", [vc addMoreHuman]?@"YES":@"NO");
            [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = nil;
            
            //update our human just in case
            HuUser *user = [user_handler humans_user];
            self.human = [user getHumanByID:self.human.humanid];
            //  bit gauche..
            //            self.human = [vc human];
            //
            if([vc addMoreHuman]) {
                [self performBlock:^{
                    [self addServiceUser];
                    
                } afterDelay:.1];
            }
        };
        
        formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
            LOG_UI(0, @"willPresentCompletionHandler for %@", presentedFSViewController);
        };
        
        
        [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
            
        }];
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [keyboardAvoidingScrollView addSubview:editButton];
    
    
#pragma mark -- delete button
    [deleteButton setButtonColor:[UIColor crayolaRazzleDazzleRoseColor]];
    deleteButton.shadowColor = editButton.buttonColor;
    deleteButton.shadowHeight = 0.0f;
    deleteButton.cornerRadius = 0.0f;
    deleteButton.titleLabel.font = BUTTON_FONT_LARGE;
    [deleteButton setHighlightedColor:[UIColor Garmin]];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
#pragma mark -- delete button event handler
    [deleteButton bk_addEventHandler:^(id sender) {
        //
        MRProgressOverlayView *noticeView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
        noticeView.mode = MRProgressOverlayViewModeIndeterminateSmall;
        noticeView.tintColor = [UIColor crayolaRazzleDazzleRoseColor];
        noticeView.titleLabelText = @"Deleting..";
        
        [user_handler userRemoveHuman:human withCompletionHandler:^(BOOL success, NSError *error) {
            //
            if(success) {
                [user_handler getHumansWithCompletionHandler:^(BOOL success, NSError *error) {

                
                    refreshOnReturn = YES;
                    [self performBlock:^{
                        [noticeView dismiss:YES];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    } afterDelay:1.0];
                }];
                
            } else {
                noticeView.titleLabelText = @"There was a problem deleting..";
                NSDictionary *dimensions = @{@"user-remove-human": human, @"user" : [user_handler humans_user],  @"success": success?@"YES":@"NO", @"error" : error};
                [PFAnalytics trackEvent:@"user-remove-human" dimensions:dimensions];
                //[Flurry logEvent:@"user-remove-human" withParameters:dimensions];
                
                [self performBlock:^{
                    [noticeView dismiss:YES];
                    //[self.navigationController popViewControllerAnimated:YES];
                    
                } afterDelay:4.0];
                
            }
            
            
        }];
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [keyboardAvoidingScrollView addSubview:deleteButton];
    
    
#pragma mark -- name text field
    //[nameTextField setFrame:[nameLabel frame]];
    [nameTextField setFont:[nameLabel font]];
    [nameTextField setBackgroundColor:[UIColor asbestosColor]];
    
    [nameTextField setDelegate:self];
    [nameTextField bk_addEventHandler:^(id sender) {
        //
    } forControlEvents:UIControlEventTouchUpInside];
    [textFields addObject:nameTextField];
    
    [keyboardAvoidingScrollView addSubview:nameTextField];
    [keyboardAvoidingScrollView addSubview:nameLabel];
    
    [[self nameLabel]setText:[human name]];
    [[self nameTextField]setText:[human name]];
    [[self nameTextField]setHidden:YES];
    [nameLabel setBackgroundColor:[UIColor asbestosColor]];
    
    [keyboardAvoidingScrollView setContentSize:CGSizeMake(applicationFrame.size.width, CGRectGetMaxY(deleteButton.frame) + 20)];
    
#pragma mark -- go back button
    //FUIButton *goBack = [[FUIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    //goBackButton.titleLabel.text = @"GO BACK";
    goBackButton.titleLabel.textColor = [UIColor whiteColor];
    [goBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    goBackButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    goBackButton.buttonColor = [UIColor crayolaRadicalRedColor];
    [keyboardAvoidingScrollView addSubview:goBackButton];
    
     //[goBackButton mc_setPosition:MCViewPositionHorizontalCenter inView:self.view withMargins:UIEdgeInsetsMake(-35, 0, 0, 0) size:CGSizeMake(right-left, 55)];
    [goBackButton bk_addEventHandler:^(id sender) {
        if(refreshOnReturn == YES) {
            refreshOnReturn = NO;
            
            [user_handler userGettyUpdate:self.human withCompletionHandler:nil];
            
            [user_handler getHumansWithCompletionHandler:^(BOOL success, NSError *error) {
                if(success) {
                    
                    MRProgressOverlayView *noticeView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
                    noticeView.mode = MRProgressOverlayViewModeIndeterminateSmall;
                    noticeView.tintColor = [UIColor crayolaRazzleDazzleRoseColor];
                    noticeView.titleLabelText = @"Knolling changes..";
                    //[humansProfileCarouselViewController updateHumansForView];
                    [self performBlock:^{
                        [noticeView dismiss:YES];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    } afterDelay:2.0];
                } else {
                    MRProgressOverlayView *noticeView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
                    noticeView.mode = MRProgressOverlayViewModeIndeterminateSmall;
                    noticeView.titleLabelText = [NSString stringWithFormat:@"There was a Knolling error.. %@", [error localizedDescription]];
                    noticeView.tintColor = [UIColor crayolaRazzmicBerryColor];
                    
                    [self performBlock:^{
                        [noticeView dismiss:YES];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    } afterDelay:4.0];
                    
                }
                
            }];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)addServiceUser
{
    LOG_UI(0, @"Add Service User");
    //
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:2.0];
    
    
    
    
    HuJediMiniFindFriendsViewController *vc = [[HuJediMiniFindFriendsViewController alloc]init];
    [vc setMaxNewUsers:4];
    [vc setHuman:self.human];
    [vc setInvokingViewController:self];
    MZFormSheetController *addUserFormSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    [addUserFormSheet setCornerRadius:3.0f];
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    // __weak MZFormSheetController *weakFormSheet = addUserFormSheet;
    
    
    addUserFormSheet.presentedFormSheetSize = CGSizeMake(300, 400);
    addUserFormSheet.portraitTopInset = 20.0;
    addUserFormSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromBottom;
    addUserFormSheet.shadowRadius = 5.0;
    addUserFormSheet.shadowOpacity = 0.5;
    addUserFormSheet.shouldDismissOnBackgroundViewTap = YES;
    addUserFormSheet.shouldCenterVertically = NO;
    addUserFormSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    
    [self mz_presentFormSheetController:addUserFormSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger textFieldIndex = [textFields indexOfObject:textField];
    
    if (textFieldIndex <textFields.count - 1) {
        [[textFields objectAtIndex:0] becomeFirstResponder];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [textField resignFirstResponder];
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            if([[textField text]length] > 0) {
                [human setName:[textField text]];
                [nameLabel setText:[human name]];
                [nameTextField setHidden:YES];
                [nameLabel setHidden:NO];
                [nameLabel setFrame:frame];
            }
        });
    }
    
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return self.showStatusBar; // your own visibility code
}


#pragma mark MZFormSheetBackgroundWindowDelegate methods
- (void)formSheetBackgroundWindow:(MZFormSheetBackgroundWindow *)formSheetBackgroundWindow didChangeStatusBarToOrientation:(UIInterfaceOrientation)orientation
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)formSheetBackgroundWindow:(MZFormSheetBackgroundWindow *)formSheetBackgroundWindow didChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)formSheetBackgroundWindow:(MZFormSheetBackgroundWindow *)formSheetBackgroundWindow didRotateToOrientation:(UIDeviceOrientation)orientation animated:(BOOL)animated
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
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
