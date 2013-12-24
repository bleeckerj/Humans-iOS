//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InstagramCounts : NSObject



@property (strong, nonatomic) NSNumber *followed_by;
@property (strong, nonatomic) NSNumber *follows;
@property (strong, nonatomic) NSNumber *media;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
