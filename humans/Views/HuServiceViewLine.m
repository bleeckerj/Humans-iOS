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
#import <UIImage+Resize.h>


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
    self.topBorderColor = [UIColor whiteColor];
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
    
    serviceImage = [serviceImage resizedImageToSize:CGSizeMake(35, 35)];


    NSString *trunc;
    if([[aService serviceUsername]length] > 20) {
        trunc = [[[NSString stringWithFormat:@"@%@", [aService serviceUsername]] substringToIndex:20] stringByAppendingString:@".."];
    } else {
        trunc = [NSString stringWithFormat:@"@%@", [aService serviceUsername]];
    }

    self.font = PROFILE_VIEW_FONT_SMALL;
    self.leftItems = [NSMutableArray arrayWithObjects:serviceImage, @"  ", trunc, nil];
    
    UIImage *garbage = [UIImage imageNamed:@"garbage-gray"];
    garbage = [garbage resizedImageToSize:CGSizeMake(35, 35)];
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
        MRProgressOverlayView *overlay = [MRProgressOverlayView overlayForView:self.superview];
        [overlay setTintColor:[UIColor crayolaRadicalRedColor]];
        [overlay setTitleLabelText:[NSString stringWithFormat:@"bye bye %@", [aService serviceName]]];
        overlay.mode = MRProgressOverlayViewModeIndeterminateSmall;
        if (__longpresser.state == UIGestureRecognizerStateEnded) {
            LOG_UI(0, @"Deleting %@", bself.service);
            HuAppDelegate *app_delegate = [[UIApplication sharedApplication]delegate];
            HuUserHandler *userHandler = [app_delegate humansAppUser];
            [userHandler userRemoveService:self.service withCompletionHandler:^(BOOL success, NSError *error) {
                if(success && error == nil) {
                    LOG_UI(0, @"Successfully deleted service %@", self.service);
                    [userHandler getHumansWithCompletionHandler:^(BOOL success, NSError *error) {
                        [bself.delegate lineDidDelete: bself];
                        [overlay dismiss:YES];
                    }];

                } else {
                    
                    overlay.mode = MRProgressOverlayViewModeIndeterminateSmall;
                    [overlay setTitleLabelText:@"Uh oh.."];
                    [self performBlock:^{
                        [overlay dismiss:YES];
                    } afterDelay:2.0];
                }
            }];
        }
    };
    
    
    
    //[self layout];
    
}
- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
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
