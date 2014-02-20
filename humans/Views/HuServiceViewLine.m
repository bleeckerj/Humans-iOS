//
//  HuServiceViewLine.m
//  humans
//
//  Created by Julian Bleecker on 2/8/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuServiceViewLine.h"
#import <WSLObjectSwitch.h>
#import "Flurry.h"
#import <FontAwesome-iOS/NSString+FontAwesome.h>

@implementation HuServiceViewLine
UIImage *serviceImage;
@synthesize service = _service;
@synthesize delegate;

- (id)init
{
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithService:(HuServices *)aServices
{
    self = [super init];
    if(self) {
        [self setService:aServices];
    }
    return self;
}

- (void)commonInit
{
    self.topBorderColor = [UIColor orangeColor];
}

- (HuServices *)service
{
    return _service;
}

- (void)setService:(HuServices *)aService
{
    _service = aService;
    
    [WSLObjectSwitch switchOn:[aService serviceName] defaultBlock:^{
        LOG_UI(0, @"Default?");
        NSString *error = [NSString stringWithFormat:@"No service match for serviceName=%@ serviceUserID=%@", [aService serviceName], [aService serviceUserID]];
        [Flurry logError:error message:error error:nil];
    } cases:
     @"twitter", ^{
         serviceImage = [UIImage imageNamed:TWITTER_COLOR_IMAGE];
         
     },
     @"flickr", ^{
         serviceImage = [UIImage imageNamed:FLICKR_COLOR_IMAGE];
         
         
     },
     @"instagram", ^{
         serviceImage = [UIImage imageNamed:INSTAGRAM_COLOR_IMAGE];
         
     },
     @"foursquare", ^{
         serviceImage = [UIImage imageNamed:FOURSQUARE_COLOR_IMAGE];
         
         
     },
     @"tumblr", ^{
         serviceImage = [UIImage imageNamed:TUMBLR_COLOR_IMAGE];
         
         
     },
     @"facebook", ^{
         serviceImage = [UIImage imageNamed:FACEBOOK_COLOR_IMAGE];
         
         
     }
     ,nil
     ];
    //LOG_UI(0, @"%@ %@", aService, [aService serviceUsername]);
    NSString *trunc;
    if([[aService serviceUsername]length] > 20) {
        trunc = [[[NSString stringWithFormat:@"@%@", [aService serviceUsername]] substringToIndex:20] stringByAppendingString:@".."];
    } else {
        trunc = [NSString stringWithFormat:@"@%@", [aService serviceUsername]];
    }
    
//    UILabel *test = [[UILabel alloc]init];
//    [test setFont:[UIFont fontWithName:@"FontAwesome" size:28]];
//    test.text = [NSString awesomeIcon:FaTrashO];
   // NSString *left = [NSString awesomeIcon:FaFlickr];
    self.font = PROFILE_VIEW_FONT_LARGE;//[UIFont fontWithName:@"FontAwesome" size:28];
//    self.middleFont = PROFILE_VIEW_FONT_LARGE;
//    self.rightFont = PROFILE_VIEW_FONT_LARGE;
    self.leftItems = [NSMutableArray arrayWithObjects:serviceImage, @"  ", trunc, nil];
    
    UIImage *garbage = [UIImage imageNamed:@"garbage-gray"];
    __block MGLine *garbage_box = [MGLine lineWithSize:[garbage size]];
    __block HuServiceViewLine *bself = self;
    [[garbage_box leftItems]addObject:garbage];
    
    //
    //
    self.rightItems = [NSMutableArray arrayWithObject:garbage_box];
    
    UILongPressGestureRecognizer *__longpresser = [[UILongPressGestureRecognizer alloc]initWithTarget:garbage_box action:@selector(longPressed)];
    [__longpresser setMinimumPressDuration:2.0];
    [__longpresser setNumberOfTapsRequired:0];
    garbage_box.longPresser = __longpresser;
    garbage_box.onLongPress = ^{
        if (__longpresser.state == UIGestureRecognizerStateEnded) {
            LOG_UI(0, @"Deleting %@", bself.service);
            HuAppDelegate *app_delegate = [[UIApplication sharedApplication]delegate];
            HuUserHandler *userHandler = [app_delegate humansAppUser];
            [userHandler userRemoveService:self.service withCompletionHandler:^(BOOL success, NSError *error) {
                if(success && error == nil) {
                    LOG_UI(0, @"Successfully deleted service %@", self.service);
                    [bself.delegate lineDidDelete: bself];
                }
            }];
        }
    };
    
    
    
    //[self layout];
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
