//
//  HuFindFollows_ViewController.m
//  Humans
//
//  Created by julian on 12/4/12.
//  Copyright (c) 2012 nearfuturelaboratory. All rights reserved.
//

#import "HuFindFollowsMain_ViewController.h"

#define ROW_HEIGHT 70
#define EDGE_INSETS 
@interface HuFindFollowsMain_ViewController ()

@end

@implementation HuFindFollowsMain_ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (id)init
{
    self = [super init];
    if(self) {
        [self commonInit];
    }
    return self;
}

NSArray *icons, *titles, *descriptions, *viewControllers;
- (void)commonInit
{
    // do stuff to initialize the various "Follow" search-y options
    icons = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"address-book-gray"],
             [UIImage imageNamed:@"twitter-bird-gray"],
             [UIImage imageNamed:@"instagram-camera"],
             [UIImage imageNamed:@"flickr-peepers"],
             [UIImage imageNamed:@"magic-search"], nil];
    
    titles = [[NSArray alloc]initWithObjects:@"Contacts", @"Twitter", @"Instagram", @"Flickr", @"Magic", nil];
    
    descriptions = [[NSArray alloc]initWithObjects:@"Use your address book",
                    @"Search Twitter friends",
                    @"Search Instagram",
                    @"Find humans from your Flickr",
                    @"Find humans from Jedi-type shit.", nil];
    
   // HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    //LOG_TODO(0, @"Does the delegate need an instance of JEDI!?");
    
    ///HuJediFindFriends_ViewController *jedi = [delegate jediFindFriendsViewController];
    
//    viewControllers = [[NSArray alloc]initWithObjects:jedi,
//                       jedi, jedi, jedi, jedi, nil];
    
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // a header row
        
    MGScrollView *scroller = [MGScrollView scrollerWithSize:self.view.bounds.size];
    scroller.bounces = NO;
    [self.view addSubview:scroller];
    
    scroller.padding = UIEdgeInsetsZero;
    scroller.margin = UIEdgeInsetsZero;
    scroller.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    [self.view addSubview:scroller];

    __block HuFindFollowsMain_ViewController *bself = self;
    // Do any additional setup after loading the view.
    UIImage *small_exbox_img = [UIImage imageNamed:@"delete-x-22sq"];//resizedImage:(CGSize){22,22}
    
    MGLine *ex_ = [MGLine lineWithLeft:small_exbox_img right:nil size:[small_exbox_img size]];
    //[check_.boxes addObject:check];
    ex_.onTap = ^{
        LOG_UI(0, @"Tapped Ex Box");
        if([bself navigationController]) {
            [[bself navigationController]popViewControllerAnimated:YES];
        } else {
            UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            
            [bself presentViewController:rootViewController animated:YES completion:nil];
        }
    };
    
    
    //header
    MGLineStyled *header = [MGLineStyled lineWithLeft:ex_ right:nil size:(CGSize){320,HEADER_HEIGHT}];
    header.middleFont = HEADER_FONT;
    [header setMiddleTextColor:[UIColor darkGrayColor]];
    [header setMiddleItems:[NSMutableArray arrayWithObject:@"Connect To Services"]];
    //[header setMiddleItemsTextAlignment:NSTextAlignmentCenter];
    [header setMiddleItemsAlignment:NSTextAlignmentCenter];
    
    header.sidePrecedence = MGSidePrecedenceMiddle;
    header.padding = UIEdgeInsetsMake(4, 8, 4, 8);
    header.fixedPosition = (CGPoint){0,0};
    header.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    header.zIndex = 1;
    [header setFrame:(CGRectMake(0, 0, 320, HEADER_HEIGHT))];
    [self.view addSubview:header];
    header.onTap = ^{
        LOG_UI(0, @"Tapped Header");
    };
    
    [scroller.boxes addObject:header];
    
        
    MGLine *space = [[MGLine alloc]initWithFrame:(CGRectMake(0, 0, 320, HEADER_HEIGHT))];

    [scroller.boxes addObject:space];
    
    UIView *instructionsBorderView = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, 320, 2))];
    [instructionsBorderView setBackgroundColor:[UIColor lightGrayColor]];
    
    // A Line. We'll add that to the Table Box of content
    MGLine *instruction_line = [MGLine lineWithSize:(CGSize){320,HEADER_HEIGHT*1.5}];
    [instruction_line setFont:INFO_FONT_MEDIUM];
    [instruction_line setMultilineMiddle:@"Lorey ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor."];
    instruction_line.middleItemsAlignment = NSTextAlignmentLeft;
    //instruction_line.middleFont = INFO_FONT_MEDIUM;
    instruction_line.padding = UIEdgeInsetsMake(4, 20, 4, 8);
    [instruction_line setBorderColors:[scroller backgroundColor]];
    
    [instruction_line.bottomBorder addSubview:instructionsBorderView];
    
    [scroller.boxes addObject:instruction_line];
//    [content.topLines addObject:instruction_line];
    

    [icons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //
        UIView *borderView = [[UIView alloc]initWithFrame:(CGRectMake(10, 0, 300, 1))];
        [borderView setBackgroundColor:[UIColor lightGrayColor]];
        
        MGLineStyled *line = [MGLineStyled lineWithSize:(CGSize){320,ROW_HEIGHT}];//[MGLine lineWithSize:(CGSize){320,ROW_HEIGHT}];
        line.backgroundColor = [scroller backgroundColor];
        line.padding = UIEdgeInsetsMake(2, 8, 0, 12);

        line.leftItems = [NSMutableArray arrayWithObject:[icons objectAtIndex:idx]];
        
        line.multilineMiddle = [NSString stringWithFormat:@"**%@**\n%@|mush", [titles objectAtIndex:idx], [descriptions objectAtIndex:idx]];
        line.sidePrecedence = MGSidePrecedenceRight;
        
        [line setRightItems:[NSMutableArray arrayWithObject:[UIImage imageNamed:@"right-arrowhead-gray"]]];
        line.middleItemsAlignment = NSTextAlignmentLeft;// UITextAlignmentLeft;
        
        // whacky. have to set the border to some color besides clear in order to set the
        // borders to a custom UIView. just the way it is for now.
        // cf https://github.com/sobri909/MGBox2/issues/26
        [line setBorderColors:[scroller backgroundColor]];
        [line.topBorder addSubview:borderView];
        //__block MGLine *bline = line;
        line.onTap = ^{
            //LOG_UI_VERBOSE(0, @"Swiped %@", bline);
            if([viewControllers objectAtIndex:idx] != nil) {
                if([[viewControllers objectAtIndex:idx] isKindOfClass:[HuJediFindFriends_ViewController class]]) {
                    HuJediFindFriends_ViewController *h = [viewControllers objectAtIndex:idx];
                    [h clearResults];
                }
                [[bself navigationController]pushViewController:[viewControllers objectAtIndex:idx] animated:YES];
            }
        };
        [scroller.boxes addObject:line];

    }];
    
    
    for(int i=0; i<0; i++) {
        UIView *borderView = [[UIView alloc]initWithFrame:(CGRectMake(10, 0, 300, 1))];
        [borderView setBackgroundColor:[UIColor lightGrayColor]];

        MGLine *line = [MGLine lineWithSize:(CGSize){320,ROW_HEIGHT}];
        line.padding = UIEdgeInsetsMake(4, 8, 4, 12);
        [line setMiddleItems:[NSMutableArray arrayWithObject:[NSString stringWithFormat:@"Line green top border %d", i]]];
        [line setRightItems:[NSMutableArray arrayWithObject:[UIImage imageNamed:@"right-arrowhead-gray"]]];
        
        
        // whacky. have to set the border to some color besides clear in order to set the
        // borders to a custom UIView. just the way it is for now.
        // cf https://github.com/sobri909/MGBox2/issues/26
        [line setBorderColors:[scroller backgroundColor]];
        [line.topBorder addSubview:borderView];
        [line.bottomBorder addSubview:borderView];
        [scroller.boxes addObject:line];
        //[content.bottomLines addObject:line];
    }
    
    
    
    [scroller layout];
    //[scroller scrollToView:section withMargin:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
