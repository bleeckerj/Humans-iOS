//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HuFoursquareStats : NSObject



@property (strong, nonatomic) NSString *checkinsCount;
@property (strong, nonatomic) NSString *tipCount;
@property (strong, nonatomic) NSString *usersCount;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
