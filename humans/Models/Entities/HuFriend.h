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

@property (atomic, readonly) NSString *serviceImageBadge;
@property (atomic, readonly) NSString *tinyServiceImageBadge;
@property (atomic, readonly) NSString *monochromeServiceImageBadge;
@property (atomic, readonly) NSString *monochromeTinyServiceImageBadge;
@property (atomic, readonly) NSString *serviceSolidColor;


- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
