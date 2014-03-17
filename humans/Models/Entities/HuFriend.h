//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WSLObjectSwitch.h>

@class HuOnBehalfOf;

@interface HuFriend : NSObject



@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *largeImageURL;
@property (strong, nonatomic) HuOnBehalfOf *onBehalfOf;
@property (strong, nonatomic) NSString *serviceName;
@property (strong, nonatomic) NSString *serviceUserID;
@property (strong, nonatomic) NSString *username;

@property (strong, nonatomic) UIImage *profileImage;

@property (nonatomic, copy) NSString *lastname;
@property (nonatomic, copy) NSString *firstname;
@property (copy, nonatomic) NSString *fullname;
@property (strong, nonatomic) NSString *lastUpdated;

@property (strong, nonatomic) UIImage *largeProfileImage;
//
@property (atomic, copy) NSString *serviceImageBadge;
@property (atomic, copy) NSString *tinyServiceImageBadge;
@property (atomic, copy) NSString *monochromeServiceImageBadge;
@property (atomic, copy) NSString *monochromeTinyServiceImageBadge;
@property (atomic, copy) NSString *serviceSolidColor;


- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;
//- (void)getProfileImageWithCompletionHandler:(FetchImageHandler)completionHandler;

@end
