//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HuFoursquareContact;
//@class HuFoursquareLists;
@class HuFoursquareUserPhoto;
@class HuFoursquareTips;

@interface HuFoursquareUser : NSObject
{
	NSString *bio;
	HuFoursquareContact *contact;
	NSString *firstName;
	NSString *gender;
	NSString *homeCity;
	NSString *id;
	NSString *lastName;
	NSString *lastUpdated;
	//HuFoursquareLists *lists;
	HuFoursquareUserPhoto *photo;
	NSString *relationship;
	HuFoursquareTips *tips;
	NSDecimalNumber *version;
}

@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) HuFoursquareContact *contact;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *homeCity;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *lastUpdated;
//@property (strong, nonatomic) HuFoursquareLists *lists;
@property (strong, nonatomic) HuFoursquareUserPhoto *photo;
@property (strong, nonatomic) NSString *relationship;
@property (strong, nonatomic) HuFoursquareTips *tips;
@property (strong, nonatomic) NSDecimalNumber *version;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
