//
//  SearchTestViewController.m
//  Humans
//
//  Created by julian on 12/2/12.
//  Copyright (c) 2012 nearfuturelaboratory. All rights reserved.
//

#import "HuJediFindFriends_ViewController.h"
//#import "Flurry.h"


#define ROW_HEIGHT 70
#define EDGE_INSETS
#define PICTURE_ROW_HEIGHT 70
#define PICTURE_WIDTH 60
#define PICTURE_HEIGHT 60

@interface HuJediFindFriends_ViewController ()

@end

@implementation HuJediFindFriends_ViewController {
    MGBox *photosGrid;
    MGScrollView *resultsScroller;
    MGBox *picksGrid;
    MGScrollView *picksScroller;
    MGLine *check_;
    MGLineStyled *header;
    MGLineStyled *statusUserHeader;
    MGBox *resultsGrid;
    UISearchBar *namingTextField;
    
    //MGScrollView *finalStateScroller; // this'll have a scroll view of all the services.
    UIView *finalStateView;
    
    //UIView *namingTextFieldView;
    MBProgressHUD *HUD;
    //HuAppUser *appUser;
    
}
@synthesize stateMachine;
@synthesize checkMarkTapped;
@synthesize exTapped;
@synthesize appUser;

//@synthesize nextState, currentState;

UISearchBar *mSearchBar;

- (id)init
{
    self = [super init];
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
        //[self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        //[self commonInit ];
    }
    return self;
}

- (void)clearResults
{
    // remove everything from the results
    [resultsGrid.boxes removeAllObjects];
    [resultsGrid layoutWithSpeed:0.3 completion:nil];
    [mSearchBar setText:@""];
}

- (void)clearPicks
{
    // remove everything from the picks grid
    [picksGrid.boxes removeAllObjects];
    [self buildBlankPicksGrid];
    check_.alpha = 0.3;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initialState];
    // this'll stock us with the follows for all the appusers's "serviceuser" accounts
    [self loadAppUserServiceFollows];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self initialState];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)commonInit
{
    HuAppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    self.appUser = [appDel humansAppUser];
    LOG_GENERAL(0, @"HuUserHandler is now %@", self.appUser);
    
    StateInfo* initialState = [[StateInfo alloc] initWithStateName:@"initialState"];
    initialState.selector = @selector(initialState);
    stateMachine = [[StateMachine alloc] initWithInitialState:initialState];
    //self.stateNameLabel.text = initialState.stateName;
    
    StateInfo *returnToFindMainState = [[StateInfo alloc] initWithStateName:@"returnToFindMainState"];
    returnToFindMainState.selector = @selector(returnToFindMainState);
    
    StateInfo* searchResultsState = [[StateInfo alloc] initWithStateName:@"searchResultsState"];
    searchResultsState.selector = @selector(searchResultsState);
    
    StateInfo* nameFriendState = [[StateInfo alloc] initWithStateName:@"nameFriendState"];
    nameFriendState.selector = @selector(nameFriendState);
    
    StateInfo* finishAndExitState = [[StateInfo alloc] initWithStateName:@"finishAndExitState"];
    finishAndExitState.selector = @selector(finishAndExitState);
    
    [initialState registerNextState:searchResultsState withCondition:@"TRUEPREDICATE"];
    
    [searchResultsState registerNextState:nameFriendState withCondition:[NSString stringWithFormat:@"SELF.checkMarkTapped == YES"]];// == %d", HuNameFriendState]];
    [searchResultsState registerNextState:returnToFindMainState withCondition:[NSString stringWithFormat:@"SELF.exTapped == YES"]];//, HuReturnToFindMainState]];
    
    [nameFriendState registerNextState:searchResultsState withCondition:[NSString stringWithFormat:@"SELF.exTapped == YES"]];//, HuSearchResultsState]];
    [nameFriendState registerNextState:finishAndExitState withCondition:[NSString stringWithFormat:@"SELF.checkMarkTapped == YES || namingTextField.text.length > 2"]];// == %d", HuFinishAndExitState]];
    
    [returnToFindMainState registerNextState:initialState withCondition:@"TRUEPREDICATE"];
    
    [finishAndExitState registerNextState:initialState withCondition:@"TRUEPREDICATE"];
}

#pragma mark State machine methods
- (void)initialState
{
    LOG_GENERAL(0, @"Initial State");
    // clear results, picks and search bar text
    [self clearPicks];
    [self clearResults];
    [picksGrid layout];
    [resultsGrid layout];
    finalStateView.left = self.view.width;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        //
        mSearchBar.left = 0;
        namingTextField.left = 1*self.view.width;
        self.resultsView.left = 0;
    }];
    [stateMachine nextState:self];
    
}

- (void)searchResultsState
{
    LOG_GENERAL(0, @"Search Results State");
    
    __block UILabel *labelView;
    [[header middleItems]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // get the views..it's only one
        if([obj isKindOfClass:[UIView class]]) {
            //[obj setAlpha:0.4];
            labelView = obj;
        }
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        //
        mSearchBar.left = 0;
        namingTextField.left = 1*self.view.width;
        self.resultsView.left = 0;
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        //
        [labelView setAlpha:0.0];
        
    } completion:^(BOOL finished) {
        //
        [labelView setText:@"Search"];
        
        [UIView animateWithDuration:0.5 animations:^{
            //
            [labelView setAlpha:1.0];
        }];
        
    }];
}


- (void)nameFriendState
{
    LOG_GENERAL(0, @"Name Friend State");
    __block UILabel *labelView;
    check_.alpha = 0.3;
    [[header middleItems]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // get the views..it's only one
        if([obj isKindOfClass:[UIView class]]) {
            //[obj setAlpha:0.4];
            labelView = obj;
        }
    }];
    
    
    if([self countHumansInPicksGrid] > 0) {
        // slide the searcher out, slide in the namer
        namingTextField.text = @"";
        [UIView animateWithDuration:0.2 animations:^{
            //
            mSearchBar.left = -1*mSearchBar.size.width;
            //mSearchBar.x = -1*320;
            namingTextField.left = 0;
            //self.resultsView.x = -1*320;
            self.resultsView.left = -1*self.resultsView.size.width;
            
        }];
        [UIView animateWithDuration:0.3 animations:^{
            //
            [labelView setAlpha:0.0];
            
        } completion:^(BOOL finished) {
            //
            [labelView setText:@"Name Friend"];
            [UIView animateWithDuration:0.3 animations:^{
                //
                [labelView setAlpha:1.0];
            }];
        }];
    }
    
}

- (void)finishAndExitState
{
    LOG_GENERAL(0, @"Finish And Exit State");
    // get a handle on the UILabel in the header
    __block UILabel *labelView;
    
    [[header middleItems]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // get the views..it's only one
        if([obj isKindOfClass:[UIView class]]) {
            //[obj setAlpha:0.4];
            labelView = obj;
        }
    }];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [labelView setText:@"Done"];
    
    [UIView animateWithDuration:0.5 animations:^{
        //
        //mSearchBar.x = -1*320;
        //self.resultsView.x = -1*320;
        finalStateView.left = 0;
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        //
        mSearchBar.left = -1*mSearchBar.size.width;
        
    } completion:^(BOOL finished) {
        // save the new human
        //
        HuHuman *newHuman = [[HuHuman alloc]init];
        [newHuman setName:[namingTextField text]];
        [picksGrid.boxes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if([obj isKindOfClass:[HuServiceUserProfilePhoto class]]) {
                HuServiceUserProfilePhoto *pobj = obj;
                [[newHuman serviceUsers]addObject:[pobj mFriend]];
            }
        }];
        
        __block MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
        progressView.mode = MRProgressOverlayViewModeIndeterminateSmall;
        progressView.titleLabelText = [NSString stringWithFormat:@"Making New Human %@", [newHuman name]];
        [progressView setTintColor:[UIColor sunflowerColor]];
        
        
        LOG_GENERAL(0, @"%@", [newHuman description]);
        
        [self.appUser userAddHuman:newHuman withCompletionHandler:^(BOOL success, NSError *error) {
            //[Flurry logEvent:[NSString stringWithFormat:@"Add Human" , (success ? @"YES":@"NO"), [newHuman name], error]];
            NSDictionary *dimensions = @{@"user": [[self.appUser humans_user]username], @"": [newHuman name], @"success": success?@"YES":@"NO", @"error": error==nil?@"nil":[[error userInfo]description]};
            [Flurry logEvent:@"Add Human" withParameters:dimensions];
            if(success) {

                
                [self.appUser getHumansWithCompletionHandler:^(BOOL success, NSError *error) {
                    HuJediFindFriends_ViewController *bself = self;
                    
                    if(success) {
                        progressView.titleLabelText = @"Good deal. New Humans.";
                        // reload the representation of ourself..our profile data and list of humans
                        // so that when we go back to the main humans scroll view, the new human could
                        // appear.
                        // it's up to HuHumansScrollViewController to refresh the scroll view, though.
                        LOG_UI(0, @"Now we have %ld humans", [[[self.appUser humans_user]humans]count]);
                        
                        // this'll take us back to initialState for the next time
                        // which will clear everything up..
                        [stateMachine nextState:bself];
                        
                        
                        
                        
                    } else {
                        
                    }
                    
                    [self performBlock:^{
                        [progressView dismiss:YES];
                    } afterDelay:3.0];
                    // now pop back
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //[[bself navigationController]popToRootViewControllerAnimated:YES];
                        [[bself navigationController]popViewControllerAnimated:YES];
                    });
                    
                }];
            } else {
                [progressView setTitleLabelText:@"There was a problem saving the human"];
                
                [self performBlock:^{
                    [progressView dismiss:YES];
                } afterDelay:2.0];
                
            }
            
        }];
    }];
    
    
}

- (void)returnToFindMainState
{
    LOG_GENERAL(0, @"Return To Find Main State");
    [[self navigationController]popViewControllerAnimated:YES];
    [stateMachine nextState:self];
}


-(void)keyboardDidShowNotification:(NSNotification *)notifcation
{
    //    NSDictionary* keyboardInfo = [notifcation userInfo];
    //    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    //    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
}

-(void)keyboardDidHideNotification:(NSNotification *)notification
{
    
}

+(HuProfilePhotoBlank *)blank
{
    HuProfilePhotoBlank *blank = [HuProfilePhotoBlank boxWithSize:(CGSizeMake(PICTURE_WIDTH, PICTURE_HEIGHT))];
    blank.margin = UIEdgeInsetsMake(8, 10, 10, 10);
    return blank;
}

-(void)buildBlankPicksGrid
{
    for(int i=0; i<MAX_USERS_PER_FRIEND; i++) {
        [picksGrid.boxes addObject:[HuJediFindFriends_ViewController blank]];
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor orangeColor]];
    
    
    [stateMachine nextState:self];
    HuAppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    self.appUser = [appDel humansAppUser];
    
    __block HuJediFindFriends_ViewController *bself = self;
    
    // Do any additional setup after loading the view.
    UIImage *small_exbox_img = [UIImage imageNamed:@"delete-x-22sq"];//resizedImage:(CGSize){22,22}
    
    MGLine *ex_ = [MGLine lineWithLeft:small_exbox_img right:nil size:[small_exbox_img size]];
    ex_.onTap = ^{
        LOG_UI(0, @"Tapped Ex Box");
        LOG_GENERAL(0, @"%@", stateMachine.currentState.stateName);
        bself.exTapped = YES;
        [bself.stateMachine nextState:bself];
        bself.exTapped = NO;
        LOG_GENERAL(0, @"%@", stateMachine.currentState.stateName);
    };
    
    UIImage *small_checkbox_img = [UIImage imageNamed:@"checkmark-gray"];
    
    check_ = [MGLine lineWithLeft:small_checkbox_img right:nil size:[small_checkbox_img size]];
    check_.alpha = 0.3;
    check_.onTap = ^{
        LOG_UI(0, @"Tapped Check Mark");
        //LOG_GENERAL(0, @"%@", stateMachine.currentState.stateName);
        if([bself countHumansInPicksGrid] > 0) {
            bself.checkMarkTapped = YES;
            [bself.stateMachine nextState:bself];
            bself.checkMarkTapped = NO;
            LOG_GENERAL(0, @"%@", bself.stateMachine.currentState.stateName);
            
        }
    };
#pragma mark header setup
    //header
    header = [MGLineStyled lineWithLeft:ex_ right:check_ size:(CGSize){320,HEADER_HEIGHT}];
    [header setMiddleFont:HEADER_FONT_LARGE];
    [header setMiddleTextColor:[UIColor darkGrayColor]];
    [header setMiddleItems:[NSMutableArray arrayWithObject:@"Find Friends"]];
    [header setMiddleItemsAlignment:NSTextAlignmentCenter];
    header.sidePrecedence = MGSidePrecedenceMiddle;
    header.padding = UIEdgeInsetsMake(4, 8, 4, 8);
    header.fixedPosition = (CGPoint){0,0};
    header.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    header.zIndex = 1;
    header.layer.cornerRadius = 0;
    header.layer.shadowOffset = CGSizeZero;
    [header setFrame:(CGRectMake(0, 0, 320, HEADER_HEIGHT))];
    header.onTap = ^{
        LOG_UI(0, @"Tapped Header");
        //nextState++;
    };
    // add it to the view then lay it all out
    [self.view addSubview:header];
    [header layout];
    
#pragma mark statusUserHeader setup
    // status user header..this'll slide in when you long press on someone
    statusUserHeader = [MGLineStyled lineWithSize:(CGSize){320,HEADER_HEIGHT}];//[MGLineStyled lineWithLeft:nil right:check_ size:(CGSize){320,HEADER_HEIGHT}];
    [statusUserHeader setMiddleFont:HEADER_FONT_LARGE];
    [statusUserHeader setMiddleTextColor:[UIColor darkGrayColor]];
    //[header setMiddleItems:[NSMutableArray arrayWithObject:@"Connect To Services"]];
    [statusUserHeader setMiddleItemsAlignment:NSTextAlignmentCenter];
    statusUserHeader.sidePrecedence = MGSidePrecedenceMiddle;
    statusUserHeader.padding = UIEdgeInsetsMake(4, 8, 4, 8);
    statusUserHeader.fixedPosition = (CGPoint){321,0};
    statusUserHeader.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    statusUserHeader.zIndex = 1;
    [statusUserHeader setFrame:(CGRectMake(self.view.width, 0, self.view.width, HEADER_HEIGHT))];
    //[self.view addSubview:header];
    statusUserHeader.onTap = ^{
        LOG_UI(0, @"Tapped Service UserHeader");
    };
    [self.view addSubview:statusUserHeader];
    [statusUserHeader layout];
    
#pragma mark first Search Bar
    // search bar
    mSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, HEADER_HEIGHT, 320, HEADER_HEIGHT)];
    
    [mSearchBar setShowsSearchResultsButton:YES];
    [mSearchBar setDelegate:self];
    for(int i =0; i<[mSearchBar.subviews count]; i++) {
        if([[mSearchBar.subviews objectAtIndex:i] isKindOfClass:[UITextField class]])
            [(UITextField*)[mSearchBar.subviews objectAtIndex:i] setFont:HEADLINE_FONT];
    }
    [mSearchBar setPlaceholder:@"Start typing a name"];
    
    // yank out subviews in order ot make the search bar background custom
    for (UIView *subview in mSearchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
        }
        
    }
    [mSearchBar setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
    // [mSearchBar mc_setPosition:MCViewPositionCenters withMargins:UIEdgeInsetsZero size:mSearchBar.size];
    [self.view addSubview:mSearchBar];
    
    
#pragma mark now this is the second set of views for naming the aggregate
    // the text field that's really a UISearchBar — it will be where the
    // user types in the name for the friend they're creating
    namingTextField = [[UISearchBar alloc]initWithFrame:CGRectMake(320, HEADER_HEIGHT, 320, HEADER_HEIGHT)];
    [namingTextField setImage:[UIImage imageNamed:@"blank-square"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [namingTextField setShowsSearchResultsButton:NO];
    for(int i =0; i<[namingTextField.subviews count]; i++) {
        if([[namingTextField.subviews objectAtIndex:i] isKindOfClass:[UITextField class]])
            [(UITextField*)[namingTextField.subviews objectAtIndex:i] setFont:HEADLINE_FONT];
    }
    [namingTextField setDelegate:self];
    [namingTextField setPlaceholder:@"What's this Human's name?"];
    
    // yank out subviews in order ot make the search bar background custom
    for (UIView *subview in namingTextField.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    
    for (UIView *searchBarSubview in [namingTextField subviews]) {
        
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
            
            @try {
                
                [(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDone];
                [(UITextField *)searchBarSubview setKeyboardAppearance:UIReturnKeyDone];
            }
            @catch (NSException * e) {
                
                // ignore exception
            }
        }
    }
    
    [namingTextField setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
    
    [self.view addSubview:namingTextField];
    
    // top, horizontally scrolling thing that holds your "picks"
    picksScroller = [MGScrollView scroller];
    [picksScroller setBackgroundColor:[UIColor clearColor]];
    [picksScroller setBounces:NO];
    picksScroller.padding = UIEdgeInsetsZero;
    picksScroller.margin = UIEdgeInsetsZero;
    
    [picksScroller setPagingEnabled:YES];
    [picksScroller setShowsHorizontalScrollIndicator:NO];
    
    picksGrid = [MGBox boxWithSize:CGSizeMake(MAX_USERS_PER_FRIEND*90, PICTURE_ROW_HEIGHT)];
    picksGrid.contentLayoutMode = MGLayoutGridStyle;
    picksGrid.backgroundColor =[UIColor crayolaLicoriceColor];
    picksGrid.padding = UIEdgeInsetsZero;
    
    // build picksGrid
    [self buildBlankPicksGrid];
    
    [picksScroller setContentSize:CGSizeMake(picksGrid.size.width, picksGrid.size.height)];
    [picksScroller setFrame:CGRectMake(0, HEADER_HEIGHT+mSearchBar.bounds.size.height, 320, picksGrid.size.height+10)];
    [picksScroller addSubview:picksGrid];
    [picksGrid layout];
    
    [self.view addSubview:picksScroller];
    
    // the view that contains the results of your search as profile images
    self.resultsView = [[UIView alloc]init];
    
    CGFloat x = picksGrid.bottom;
    [self.resultsView setSize:CGSizeMake(self.view.width, self.view.height - x)];
    [self.resultsView setBackgroundColor:[UIColor blueColor]];
    [self.resultsView mc_setRelativePosition:MCViewPositionUnder toView:picksScroller withMargins:UIEdgeInsetsMake(-2, 0, 0, 0)];
    
    
    resultsScroller = [MGScrollView scrollerWithSize:self.resultsView.size];
    [resultsScroller setContentSize:self.resultsView.size];
    [resultsScroller setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
    [resultsScroller setBounces:YES];
    [self.resultsView addSubview:resultsScroller];
    
    resultsGrid = [MGBox boxWithSize:[resultsScroller size]];
    resultsGrid.contentLayoutMode = MGLayoutGridStyle;
    [resultsScroller.boxes addObject:resultsGrid];
    
    [self.view addSubview:self.resultsView];
    
    UISwipeGestureRecognizer *recog = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    [self.resultsView addGestureRecognizer:recog];
    
    [resultsScroller layoutWithSpeed:0.3 completion:nil];
    
    
    finalStateView = [[UIView alloc]init];
    [finalStateView setSize:[resultsScroller size]];
    [finalStateView setBackgroundColor:[UIColor crayolaManateeColor]];
    [finalStateView mc_setRelativePosition:MCViewPositionToTheRight toView:self.resultsView];
    [finalStateView setTop:namingTextField.bottom];
    [finalStateView setLeft:[self resultsView].right];
    
    //[finalStateView mc_setRelativePosition:MCViewPositionUnder toView:picksScroller];
    [self.view addSubview:finalStateView];
    
}

-(void)swipe:(UISwipeGestureRecognizer *)sender
{
    if([sender direction] == UISwipeGestureRecognizerDirectionRight)
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    LOG_UI(0, @"Should begin editing");
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    LOG_UI(0, @"Search.");
    NSString *currentStateStr = [[stateMachine currentState]stateName];
    
    if([currentStateStr compare:@"nameFriendState" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        LOG_UI(0, @"Name Friend Done");
        if([[searchBar text]length] > 2) {
            [searchBar resignFirstResponder];
            [stateMachine nextState:self];
        }
    }
    
    if([currentStateStr compare:@"searchResultsState" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        if([searchBar text].length > 2) {
            [searchBar resignFirstResponder];
            [self searchFor:[NSString stringWithFormat:@"%@", [searchBar text]]];
        }
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    LOG_UI(0, @"Text Did Change at %@ %@", [[stateMachine currentState]stateName], searchText);
    NSString *currentStateStr = [[stateMachine currentState]stateName];
    if([currentStateStr compare:@"nameFriendState" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        if([searchText length] > 2) {
            check_.alpha = 1.0;
        } else {
            check_.alpha = 0.3;
        }
    }
}


-(void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar
{
    LOG_UI(0, @"began");  // this executes as soon as i tap on the searchbar, so I'm guessing this is the place to put whatever solution is available
}
-(BOOL) textFieldShouldReturn: (UITextField *) aTextField
{
    [aTextField resignFirstResponder];
    LOG_UI(0, @"DONE!");
    
    // You can access textField.text and do what you need to do with the text here
    
    return YES; // We'll let the textField handle the rest!
}

NSUInteger lastLength;

- (BOOL)textField:(UITextField *)aTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    lastLength = [[aTextField text]length]+1;
    // if we're backspacing, don't do anything.
    
    if(range.length == 1) {
        LOG_UI_VERBOSE(0, @"BACKSPACE?");
        [resultsGrid.boxes removeAllObjects];
        [resultsGrid layoutWithSpeed:0.1 completion:nil];
        
    } else
        if( ([[aTextField text]length] >= 2) && range.length != 1) {
            
            [self searchFor:[NSString stringWithFormat:@"%@%@", [aTextField text], string]];
        }
    
    LOG_UI(0, @"%@ %@", [aTextField text], string);
    
    return YES;
}

-(IBAction)valueChanged:(id)sender
{
    LOG_UI(0, @"Hello");
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

#pragma mark -- This is where the search happens
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
    
    HuAppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    self.appUser = [appDel humansAppUser];
    
    
    LOG_GENERAL(0, @"Search Via %@ For %@ across %@", self.appUser, string, [self.appUser friends]);
    
    [appUser searchFriendsWith:regex withCompletionHandler:^(NSMutableArray *results) {
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
            img.layer.cornerRadius = 10;
            [img.layer setShadowColor:[UIColor clearColor].CGColor];
            img.layer.shadowOffset = CGSizeZero;
            
            [img setMask:[UIImage imageNamed:@"user-profile-image-mask-60px"]];
            
            [img setServiceTinyTag:[UIImage imageNamed:[friend tinyServiceImageBadge ]]];
            
            [img setTappable:YES];
            img.onTap = ^{
                LOG_UI_VERBOSE(0, @"TAPPED ON %@ for %@",[friend username], [friend serviceName]);
                if([bimg superview] == resultsGrid) {
                    if([self countHumansInPicksGrid] < MAX_USERS_PER_FRIEND) {
                        
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
                            [picksGrid.boxes addObject:[HuJediFindFriends_ViewController blank]];
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
                if([self countHumansInPicksGrid] > 0) {
                    check_.alpha = 1.0;
                } else {
                    check_.alpha = 0.3;
                }
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
            NSUInteger count = [resultsGrid.boxes count];
            
            NSUInteger mod = 1+[resultsGrid.boxes count]/4;
            LOG_UI(0, @"%lu %lu", count, (unsigned long)mod);
            [resultsScroller setContentSize:CGSizeMake(resultsGrid.size.width, (1+(4+count - 1)/4) * (22 + profilePhotoSize.height))];
            [resultsGrid layoutWithSpeed:0.3 completion:nil];
            [resultsScroller layoutWithSpeed:0.3 completion:nil];
            
        }];
    }];
    
    
    
}


// basically load all the "friends" for all the serviceUsers for the AppUser
- (void)loadAppUserServiceFollows
{
    
    //    dispatch_group_t group = dispatch_group_create();
    //    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    progressView.mode = MRProgressOverlayViewModeIndeterminate;
    progressView.titleLabelText = @"Finding Friends";
    
    
    HuAppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    appUser = [appDel humansAppUser];//[[HuAppUser alloc]init];
    
    [appUser userFriendsGet:^(NSMutableArray *results) {
        // now appUser has all my friends..
        LOG_GENERAL(0, @"Load Follows of %@ found %ld follows/friends.", [[appUser humans_user]username], [[appUser friends] count]);
        
//        [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
//        
//        MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
        progressView.mode = MRProgressOverlayViewModeCheckmark;
        progressView.titleLabelText = [NSString stringWithFormat:@"Found %ld Friends",  [[appUser friends] count]];
        [self performBlock:^{
            [progressView dismiss:YES];
        } afterDelay:3.5];
        
        
    }];
    
}

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

//- (void)hideHUD
//{
//    [HUD hide:YES afterDelay:1];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

@end
