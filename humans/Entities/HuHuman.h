//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSArray;

@interface HuHuman : NSObject



@property (strong, nonatomic) NSString *humanid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *serviceUsers;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
