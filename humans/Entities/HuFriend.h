//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HuOnBehalfOf;

@interface HuFriend : NSObject



@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *largeImageURL;
@property (strong, nonatomic) HuOnBehalfOf *onBehalfOf;
@property (strong, nonatomic) NSString *service;
@property (strong, nonatomic) NSString *serviceID;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) UIImage *largeProfileImage;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
