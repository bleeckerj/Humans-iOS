//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InstagramUser;

@interface InstagramCommenter : NSObject



@property (strong, nonatomic) NSString *created_time;
@property (strong, nonatomic) InstagramUser *from;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *text;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
