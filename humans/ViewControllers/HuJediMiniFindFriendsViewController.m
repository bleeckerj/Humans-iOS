//
//  HuJediMiniFindFriendsViewController.m
//  humans
//
//  Created by Julian Bleecker on 3/2/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuJediMiniFindFriendsViewController.h"

#define ROW_HEIGHT 45
#define EDGE_INSETS
#define PICTURE_ROW_HEIGHT 75
#define PICTURE_WIDTH 55
#define PICTURE_HEIGHT 55

@interface HuJediMiniFindFriendsViewController ()

@end

@implementation HuJediMiniFindFriendsViewController {
    MGBox *photosGrid;
    MGScrollView *resultsScroller;
    MGBox *picksGrid;
    MGScrollView *picksScroller;
    MGLineStyled *header;
    MGLineStyled *statusUserHeader;
    MGBox *resultsGrid;
    UIEdgeInsets picture_insets;
    FUITextField *searchField;
    HuUserHandler *userHandler;
    UIView *resultsView;
    FUIButton *acceptButton;
    FUIButton *cancelButton;

}

@synthesize maxNewUsers;
@synthesize human;
@synthesize invokingViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        maxNewUsers = 0;
//        picture_insets = UIEdgeInsetsMake(5, 20, 5, 20);
        picture_insets = UIEdgeInsetsMake(8, 11, 8, 8);
        HuAppDelegate *appDel = [[UIApplication sharedApplication]delegate];
        userHandler = [appDel humansAppUser];

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSAssert(self.human !=nil, @"Why is human nil here?");
    
        LOG_UI(0, @"presented within here: %@ %@ %@ %@",NSStringFromCGRect(self.view.frame), NSStringFromCGSize(self.view.size), NSStringFromCGRect(self.formSheetController.view.bounds), self.formSheetController.view);
    
    [searchField setSize:CGSizeMake(self.view.width, 50)];
    [searchField setBackgroundColor:[UIColor Garmin]];
    [searchField setTextFieldColor:[UIColor whiteColor]];
    
    
    resultsView = [[UIView alloc]init];
    
    
    //CGFloat x = picksGrid.bottom;
    [resultsView setSize:CGSizeMake(self.view.size.width, 2.9*(PICTURE_HEIGHT+picture_insets.bottom + picture_insets.top))];
    [resultsView setBackgroundColor:[UIColor crayolaQuickSilverColor]];
    [resultsView mc_setRelativePosition:MCViewPositionUnder toView:searchField withMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    
    resultsScroller = [MGScrollView scrollerWithSize:resultsView.size];
    [resultsScroller setContentSize:resultsView.size];
   // [resultsScroller setBackgroundColor:[[UIColor crayolaQuickSilverColor]lighterColor]];
    [resultsScroller setBounces:YES];
    [resultsView addSubview:resultsScroller];
    
    resultsGrid = [MGBox boxWithSize:[resultsScroller size]];
    resultsGrid.contentLayoutMode = MGLayoutGridStyle;
    [resultsGrid setBackgroundColor:[[UIColor crayolaQuickSilverColor]lighterColor]];
    [resultsScroller.boxes addObject:resultsGrid];
    
    [self.view addSubview:resultsView];
    
    [resultsScroller layoutWithSpeed:0.3 completion:nil];
    
    [self.view addSubview:resultsScroller];

    [resultsScroller mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:searchField withMargins:UIEdgeInsetsMake(0, 0, 0, 0)];

    picksScroller = [MGScrollView scroller];
    [picksScroller setBackgroundColor:[UIColor crayolaQuickSilverColor]];
    [picksScroller setBounces:NO];
    picksScroller.padding = UIEdgeInsetsZero;
    picksScroller.margin = UIEdgeInsetsZero;
    
    [picksScroller setPagingEnabled:YES];
    [picksScroller setShowsHorizontalScrollIndicator:NO];
    
    picksGrid = [MGBox boxWithSize:CGSizeMake(self.view.width, PICTURE_ROW_HEIGHT)];
    picksGrid.contentLayoutMode = MGLayoutGridStyle;
    picksGrid.backgroundColor = [UIColor whiteColor];
    //picksGrid.padding = UIEdgeInsetsMake(10, 0, 10, 0);
    
    // build picksGrid
    [self buildBlankPicksGrid];
    
    [picksGrid layout];

    LOG_UI(0, @"%@ %@ %f %f self.view.bottom=%f %f", NSStringFromCGRect(self.view.bounds), NSStringFromCGRect(self.view.frame), self.view.bottom, self.view.boundsHeight, resultsView.bottom, resultsView.origin.y);
    [picksScroller setFrame:CGRectMake(0, 0, self.view.width, picksGrid.height)];
    [picksScroller setContentSize:CGSizeMake(picksGrid.size.width, picksGrid.height)];
    [picksScroller addSubview:picksGrid];
    [self.view addSubview:picksScroller];
    [picksScroller mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:resultsView  withMargins:UIEdgeInsetsMake(2, 0, 0, 0)];
    
    acceptButton = [[FUIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width/2, PICTURE_ROW_HEIGHT)];
    acceptButton.buttonColor = [UIColor emerlandColor];
    acceptButton.shadowColor = acceptButton.buttonColor;
    acceptButton.shadowHeight = 0.0f;
    acceptButton.cornerRadius = 0.0f;
    acceptButton.titleLabel.font = BUTTON_FONT_LARGE;
    [acceptButton setHighlightedColor:[[UIColor emerlandColor]lighterColor]];
    [acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [acceptButton setTitle:@"Add" forState:UIControlStateNormal];
    [self.view addSubview:acceptButton];
    [acceptButton mc_setRelativePosition:MCViewRelativePositionUnderAlignedRight toView:picksScroller withMargins:UIEdgeInsetsMake(2, 0, 0, 0)];
    

    __block HuJediMiniFindFriendsViewController *bself = self;
    [acceptButton bk_addEventHandler:^(id sender) {
        //
        [picksGrid.boxes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // GROSS
            HuServiceUserProfilePhoto *p = (HuServiceUserProfilePhoto*)obj;
            if([p isKindOfClass:[HuProfilePhotoBlank class]]) {
                return;
            }
            HuFriend *f = [p mFriend];
            HuServiceUser *service_user = [[HuServiceUser alloc]initWithFriend:f];
            
           
            [userHandler humanAddServiceUser:service_user forHuman:human withCompletionHandler:^(id data, BOOL success, NSError *error) {
                //
                LOG_GENERAL(0, @"added service user? %@ %@ %@", success?@"YES":@"NO", data, error);
                if(success) {
                        [self performBlock:^{
                            [bself mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                                // do sth
                            }];
                        } afterDelay:1.0];
                }
            }];
            
            LOG_UI(0, @"service_user=%@", [service_user jsonString]);
            
        }];
    } forControlEvents:UIControlEventTouchUpInside];

    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        LOG_UI(0, @"presented within here: %@ %@ %@ %@",NSStringFromCGRect(self.view.frame), NSStringFromCGSize(self.view.size), NSStringFromCGRect(self.formSheetController.view.bounds), self.formSheetController.view);
    
    
    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
    if([userHandler friends] == nil || [[userHandler friends]count] == 0) {
        
        MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:mainWindow.subviews[0] animated:YES];
        progressView.mode = MRProgressOverlayViewModeIndeterminate;
        progressView.tintColor = [UIColor carrotColor];
        progressView.titleLabelText = @"Finding Friends";
        [self performBlock:^{
            //
            progressView.titleLabelText = @"I know this takes awhile..";
        } afterDelay:5.0];
        
        [self performBlock:^{
            progressView.titleLabelText = @"I'm working on it..";
        } afterDelay:8.0];
        
        [self performBlock:^{
            //
            progressView.titleLabelText = @"Finding Friends..";
        } afterDelay:12.0];
        
        [userHandler userFriendsGet:^(NSMutableArray *results) {
            //[MRProgressOverlayView dismissOverlayForView:mainWindow.subviews[0] animated:YES];
            
            //MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
            progressView.mode = MRProgressOverlayViewModeCheckmark;
            progressView.titleLabelText = [NSString stringWithFormat:@"Found %lu Friends",  [[userHandler friends] count]];
            [self performBlock:^{
                [progressView dismiss:YES];
            } afterDelay:4.0];
            
        }];
        
    }
    
    

    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    searchField = [[FUITextField alloc]init];
    [searchField setDelegate:self];
    [searchField setFont:TEXTFIELD_FONT_LARGE];
    searchField.adjustsFontSizeToFitWidth = YES;
    searchField.minimumFontSize = 10;
    searchField.spellCheckingType = UITextSpellCheckingTypeNo;
    searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchField.textAlignment = NSTextAlignmentCenter;
    
    searchField.bk_shouldChangeCharactersInRangeWithReplacementStringBlock = ^(UITextField *textField, NSRange range, NSString *replacement) {
        if([[textField text]length] > 15 && replacement.length > 0) {
            return NO;
        } else {
            return YES;
        }
    };
    
    __block HuJediMiniFindFriendsViewController *weakself = self;

    
    searchField.bk_shouldReturnBlock = ^(UITextField *textField) {
        if([[textField text]length] > 2) {
            LOG_UI(0, @"Search with %@", [textField text]);
            [weakself searchFor:[textField text]];
        }
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

        return YES;
    };
    
    [searchField bk_addEventHandler:^(id sender) {
        //
        LOG_UI(0, @"You typed %@", sender);
    } forControlEvents:UIControlEventEditingChanged];
//    [searchField setBackgroundColor:[UIColor asbestosColor]];
//    [searchField setFont:TEXTFIELD_FONT_SMALL];
    [searchField setBorderStyle:UITextBorderStyleLine];
    searchField.layer.borderWidth = 0;
    
    [self.view addSubview:searchField];
    
}


-(HuProfilePhotoBlank *)blank
{
    HuProfilePhotoBlank *blank = [HuProfilePhotoBlank boxWithSize:(CGSizeMake(PICTURE_WIDTH,  PICTURE_HEIGHT))];
    blank.margin = picture_insets;
    return blank;
}

-(void)buildBlankPicksGrid
{
    for(int i=0; i<self.maxNewUsers; i++) {
        [picksGrid.boxes addObject:[self blank]];
    }
    
}

-(void)searchFor:(NSString *)string {
    NSError* error = nil;
    NSRegularExpression* regex;
    NSString *str = [NSString stringWithFormat:@"%@", string];
    
    NSMutableString *regexPattern = [[NSMutableString alloc]initWithString:@""];
    NSMutableArray *splitByWordBoundaries = [NSMutableArray array];
    [str enumerateSubstringsInRange:NSMakeRange(0, [str length]) options:NSStringEnumerationByWords usingBlock:^(NSString* word, NSRange wordRange, NSRange enclosingRange, BOOL* stop){
        [splitByWordBoundaries addObject:word];
        [regexPattern appendFormat:@".*%@.*", word];
    }];
    
    regex = [NSRegularExpression
             regularExpressionWithPattern:regexPattern
             options:NSRegularExpressionCaseInsensitive | NSRegularExpressionAllowCommentsAndWhitespace
             error:&error];
    
    
    LOG_GENERAL(0, @"Search For %@ across xxxx", string);
    
    [userHandler searchFriendsWith:regex withCompletionHandler:^(NSMutableArray *results) {
        [resultsGrid.boxes removeAllObjects];
        [resultsGrid layoutWithSpeed:0.3 completion:nil];
        [resultsScroller layoutWithSpeed:0.3 completion:nil];
        
        NSMutableArray* uniqueValues = [[NSMutableArray alloc] init];
        for(id e in results)
        {
            if(![uniqueValues containsObject:e])
            {
                [uniqueValues addObject:e];
            }
        }
        
        //sort
        [uniqueValues sortUsingDescriptors:[NSArray arrayWithObjects:
                                            [NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES],
                                            [NSSortDescriptor sortDescriptorWithKey:@"serviceName" ascending:YES],
                                            [NSSortDescriptor sortDescriptorWithKey:@"fullname" ascending:YES ], nil]];
        
        LOG_GENERAL(0, @"Found %@", uniqueValues);
        
        // see if they're already in picksGrid.boxes
        [uniqueValues enumerateObjectsUsingBlock:^(HuFriend *friend, NSUInteger idx, BOOL *stop) {
            //
            CGSize profilePhotoSize = (CGSizeMake(PICTURE_WIDTH, PICTURE_HEIGHT));
            
            HuServiceUserProfilePhoto *img = [HuServiceUserProfilePhoto photoBoxForSocialServiceUser:friend size:profilePhotoSize];
            
            // skip it if it's already in the picksGrid
            if([picksGrid.boxes containsObject:img]) {
                return;
            }
            
            __block HuServiceUserProfilePhoto *bimg = img;
            
            //[img setMargin:(UIEdgeInsetsZero)];
            [img setMargin:(UIEdgeInsetsMake(8, 11, 8, 8))];
            [img setPadding:UIEdgeInsetsZero];
            
            //[img setPadding:(UIEdgeInsetsMake(12, 12, 12, 12))];
            [img setBackgroundColor:[UIColor colorWithWhite:0.97 alpha:1.0]];
            img.layer.cornerRadius = 4;
            [img.layer setShadowColor:[UIColor clearColor].CGColor];
            img.layer.shadowOffset = CGSizeZero;
            
            [img setMask:[UIImage imageNamed:@"user-profile-image-mask-55px"]];
            
            [img setServiceTinyTag:[UIImage imageNamed:[friend tinyServiceImageBadge ]]];
            
            [img setTappable:YES];
            img.onTap = ^{
                
                LOG_UI_VERBOSE(0, @"TAPPED ON %@ for %@",[friend username], [friend serviceName]);
                
                if([bimg superview] == resultsGrid) {
                    if(([self countHumansInPicksGrid] < MAX_USERS_PER_FRIEND) && ([self countHumansInPicksGrid] < 4)) {
                        
                        if([picksGrid.boxes containsObject:bimg] == NO) {
                            
                            [picksGrid.boxes insertObject:bimg atIndex:0];
                            // remove the last one
                            [picksGrid.boxes removeObjectAtIndex:[picksGrid.boxes count]-1];
                            [bimg setBackgroundColor:[picksGrid backgroundColor]];
                            [resultsGrid.boxes removeObject:bimg];
                            [picksGrid layoutWithSpeed:0.3 completion:nil];
                            [resultsGrid layoutWithSpeed:0.3 completion:nil];
                        }
                    }
                } else
                    if([bimg superview] == picksGrid) {
                        if([resultsGrid.boxes containsObject:bimg] == NO) {
                            [resultsGrid.boxes insertObject:bimg atIndex:0];
                            [picksGrid.boxes removeObject:bimg];
                            // add a blank at the end
                            [picksGrid.boxes addObject:[self blank]];
                            [bimg setBackgroundColor:[resultsGrid backgroundColor]];
                            [resultsGrid layoutWithSpeed:0.1 completion:nil];
                            [picksGrid layoutWithSpeed:0.1 completion:nil];
                            
                            // sort when we move something out of the picksGrid
                            [resultsGrid.boxes sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                                if(YES == ([obj1 isKindOfClass:[HuProfilePhotoBlank class]] &&
                                           [obj2 isKindOfClass:[HuServiceUserProfilePhoto class]])) {
                                    return NSOrderedAscending;
                                }
                                if(YES == ([obj2 isKindOfClass:[HuProfilePhotoBlank class]] &&
                                           [obj1 isKindOfClass:[HuServiceUserProfilePhoto class]])) {
                                    return NSOrderedDescending;
                                }
                                return NSOrderedSame;
                            }];
                        }
                    }
//                if([self countHumansInPicksGrid] > 0) {
//                    check_.alpha = 1.0;
//                } else {
//                    check_.alpha = 0.3;
//                }
                
            };
            
            [img setLongPressable:YES];
            img.onLongPress = ^(UILongPressGestureRecognizer *recog){
                if(recog == nil) {
                    LOG_UI_VERBOSE(0, @"WTF? %@", [friend username]);
                } else {
                    LOG_UI_VERBOSE(0, @"LONG PRESS %@\nFor %@", recog, friend);
                    NSString *string = [NSString stringWithFormat:@"%@", [friend username]];
                    statusUserHeader.middleItems = [NSMutableArray arrayWithObject:string];//[NSArray arrayWithObject:string];
                    [statusUserHeader layout];
                    if(recog.state == UIGestureRecognizerStateBegan) {
                        [UIView animateWithDuration:0.3 animations:^{
                            header.left = header.size.width * -1; // should vary based on orientation & screen size
                            statusUserHeader.left = 0;
                        }];
                    }
                    if(recog.state == UIGestureRecognizerStateEnded) {
                        [UIView animateWithDuration:0.3 animations:^{
                            //
                            header.left = 0.0;
                            statusUserHeader.left = statusUserHeader.width;
                        }];
                    }
                }
            };
            [resultsGrid.boxes addObject:img];
            int count = [resultsGrid.boxes count];
            //int mod = 1+count/4;
            //LOG_UI(0, @"%d %d", count, mod);
            [resultsScroller setContentSize:CGSizeMake(resultsGrid.size.width, (1+(4+count - 1)/4) * (22 + profilePhotoSize.height))];
            [resultsGrid layoutWithSpeed:0.3 completion:nil];
            [resultsScroller layoutWithSpeed:0.3 completion:nil];
            
        }];
    }];
    
    
    
}

-(NSUInteger)countHumansInPicksGrid
{
    __block NSUInteger count = 0;
    [picksGrid.boxes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //
        if ([obj isKindOfClass:[HuServiceUserProfilePhoto class]]) {
            count++;
        }
    }];
    return count;
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
