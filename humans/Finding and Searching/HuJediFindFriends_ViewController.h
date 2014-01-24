//
//  SearchTestViewController.h
//  Humans
//
//  Created by julian on 12/2/12.
//  Copyright (c) 2012 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defines.h"
#import "LoggerClient.h"
#import "HuAppDelegate.h"
#import "HuUserHandler.h"
#import "UIImage+Resize.h"
#import "MGTableBoxStyled.h"
#import "MGBox.h"
#import "PhotoBox.h"
#import "MGScrollView.h"
#import "MGLineStyled.h"
#import "HuTextFieldLine.h"
#import "HuServiceUserProfilePhoto.h"
#import "StateMachine.h"
#import "MBProgressHUD.h"

@interface HuJediFindFriends_ViewController : UIViewController <UINavigationControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate, UISearchBarDelegate, MBProgressHUDDelegate>
typedef enum {
    HuReturnToFindMainState     = -1,
    HuInitialState          = 0,
    HuSearchResultsState = 1,
    HuNameFriendState = 2,
    HuFinishAndExitState = 3,
} HuJediFindState;


@property (nonatomic, retain) IBOutlet UIView *resultsView;
//@property HuJediFindState nextState, currentState;
@property BOOL checkMarkTapped, exTapped;
@property (nonatomic, retain) HuUserHandler *appUser;
@property (nonatomic, retain) StateMachine *stateMachine;

//+(HuProfilePhotoBlank *)blank;
-(void)clearResults;
-(void)clearPicks;
-(IBAction)somethingHappened:(id)sender;
-(IBAction)valueChanged:(id)sender;
-(void)keyboardDidShowNotification:(NSNotification *)notifcation;
-(void)keyboardDidHideNotification:(NSNotification *)notification;



@end
