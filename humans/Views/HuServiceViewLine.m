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

@implementation HuServiceViewLine
UIImage *serviceImage;
@synthesize services = _services;

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
        [self setServices:aServices];
    }
    return self;
}

- (void)commonInit
{
    self.topBorderColor = [UIColor orangeColor];
}

- (HuServices *)services
{
    return self.services;
}

- (void)setServices:(HuServices *)aService
{
    _services = aService;
    
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
    LOG_UI(0, @"%@ %@", aService, [aService serviceUsername]);
    self.leftItems = [NSMutableArray arrayWithObjects:serviceImage, @"  ", [NSString stringWithFormat:@"@%@", [aService serviceUsername]], nil];
    
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
