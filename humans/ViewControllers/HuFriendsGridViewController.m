//
//  HuFriendsGridViewController.m
//  humans
//
//  Created by julian on 12/13/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//
#import "defines.h"
#import <QuartzCore/QuartzCore.h>
#import "GMGridView.h"
#import "LoggerClient.h"
#import "HuFriend.h"
#import "HuFriendsGridViewController.h"
#import <AFNetworking.h>
#import <RestKit.h>

@interface HuFriendsGridViewController () <GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate>
{
    __gm_weak GMGridView *_gmGridView;
    NSMutableArray *_data;
    NSMutableArray *_data2;
    NSMutableArray *_currentData;
    NSInteger _lastDeleteItemIndexAsked;
}

- (void)addMoreItem;
- (void)removeItem;
- (void)refreshItem;
- (void)presentInfo;
- (void)presentOptions:(UIBarButtonItem *)barButton;
- (void)optionsDoneAction;
- (void)dataSetChange:(UISegmentedControl *)control;

@end

@implementation HuFriendsGridViewController

- (id)init
{
    self = [super init];
    if(self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _currentData  = [NSMutableArray new];
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // _gmGridView.mainSuperView = self.navigationController.view; //[UIApplication sharedApplication].keyWindow.rootViewController.view;
    _gmGridView.mainSuperView = self.view;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _gmGridView = nil;
    _currentData = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    //[_gmGridView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}


- (void)loadView
{
    [super loadView];
    _currentData  = [NSMutableArray new];
    
    [self preloadFriendProfileDataWithCompletionHandler:^{
        //
        [self reloadFriendsGridView];
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // NSInteger spacing = INTERFACE_IS_PHONE ? 10 : 15;
    NSInteger spacing = 10;
    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:gmGridView];
    _gmGridView = gmGridView;
    
    [_gmGridView setContentSize:[[UIScreen mainScreen] bounds].size];
    
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gmGridView.centerGrid = YES;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.transformDelegate = self;
    _gmGridView.dataSource = self;
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    infoButton.frame = CGRectMake(self.view.bounds.size.width - 40,
                                  self.view.bounds.size.height - 40,
                                  40,
                                  40);
    infoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [infoButton addTarget:self action:@selector(presentInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoButton];
    
}


- (void)reloadFriendsGridView
{
    [_gmGridView reloadData];
}

#pragma mark

- (void)preloadFriendProfileDataWithCompletionHandler:(CompletionHandler)completionHandler
{
    
    
}




#pragma mak GMGridViewDataSource
-(NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_currentData count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (INTERFACE_IS_PHONE)
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return CGSizeMake(170, 135);
        }
        else
        {
            //return CGSizeMake(170, 135);
            
            return CGSizeMake(_gmGridView.frame.size.width/2, 60);
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return CGSizeMake(285, 205);
        }
        else
        {
            return CGSizeMake(230, 175);
        }
    }
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //LOG_UI_VERBOSE(0, @"%d", index);
    
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    HuFriend *friend = [_currentData objectAtIndex:index];
    
    
    if (!cell && [friend profileImage])
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"delete-x-22sq.png"];
        cell.deleteButtonOffset = CGPointMake(15, 15);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        view.backgroundColor = [UIColor lightGrayColor];
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 8;//size.width/2.0;
        view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        view.layer.borderWidth = 0;
        
        UIImageView *friendImageView;
        friendImageView = [[UIImageView alloc] initWithImage:[friend profileImage]];
        [friendImageView setFrame:CGRectMake(0, 0, 60, 60)];
        [friendImageView setContentMode:UIViewContentModeScaleAspectFit];
        [friendImageView setBackgroundColor:[UIColor blueColor]];
        //[friendImageView setImageWithURL:[NSURL URLWithString:[friend imageURL]]];
        //[friendImageView setImage:[friend profileImage]];
        
        CGImageRef imageRef = [[friend profileImage] CGImage];
        LOG_INSTAGRAM_IMAGE(0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef), UIImageJPEGRepresentation([friend profileImage], 1.0));

        
        [view addSubview:friendImageView];
        
        
        cell.contentView = view;
    }
    
    
    return cell;
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES; //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    [_gmGridView reloadData];
}

-(void)refreshStatusForFriend:(HuFriend *)f
{
    
}

// clears and loads everything
-(void)loadStatusForFriend:(HuFriend *)f
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
