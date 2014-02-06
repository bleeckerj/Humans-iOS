//
//  TwitterStatus.h
//  CocoaPodsExample
//
//  Created by julian on 12/11/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitterUser.h"
#import "HuServiceStatus.h"

@interface TwitterStatus : NSObject <HuServiceStatus>
@property (copy, nonatomic) NSString *tweet_id;
@property (copy, nonatomic) NSString *text;
//@property (copy, nonatomic) NSString *user_id;
@property (copy, nonatomic) NSDate *created_at;
//@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) TwitterUser *user;

@property (nonatomic, strong) NSString *statusTextNoURL;
@end
