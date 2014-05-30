//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "defines.h"

@class NSArray;
@class HuOnBehalfOf;

@interface HuHuman : NSObject



@property (strong, nonatomic) NSString *humanid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *serviceUsers;
@property (strong, atomic) NSMutableArray *profile_images;
@property BOOL isYouMan;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;
-(NSDictionary *)dictionary;
-(NSDictionary *)proxyForJson;
-(NSArray *)serviceUserProfileImageURLs;
-(void)loadServiceUsersProfileImagesWithCompletionHandler:(CompletionHandler)completionHandler;
-(UIImage *)largestServiceUserProfileImage;
-(NSString *)jsonString;
-(HuOnBehalfOf *)getOnBehalfOfForServiceUserWithServiceUserID:(NSString *)serviceUserID withServiceName:(NSString *)serviceName withServiceUsername:(NSString *)serviceUsername;

@end
