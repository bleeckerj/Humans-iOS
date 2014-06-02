//
//  HuHumanProfileViewController.h
//  humans
//
//  Created by Julian Bleecker on 2/28/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defines.h"
#import <MZFormSheetController.h>

@class HuHumansProfileCarouselViewController;
@class FUIButton;
@class HuHuman;
@class RDVKeyboardAvoidingScrollView;


@interface HuEditHumanViewController : UIViewController  <UITextFieldDelegate, MZFormSheetBackgroundWindowDelegate>
@property (strong, nonatomic) IBOutlet FUIButton *editButton;
@property (strong, nonatomic) IBOutlet FUIButton *deleteButton;
@property (strong, nonatomic) IBOutlet FUIButton *goBackButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) HuHuman *human;
@property (retain, nonatomic) IBOutlet RDVKeyboardAvoidingScrollView *keyboardAvoidingScrollView;
@property (nonatomic, assign) BOOL showStatusBar;
@property (nonatomic, assign) BOOL refreshOnReturn;
@property (weak, nonatomic) HuHumansProfileCarouselViewController *humansProfileCarouselViewController;


@end
