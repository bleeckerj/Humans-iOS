//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InstagramImage : NSObject



@property (strong, nonatomic) NSDecimalNumber *height;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSDecimalNumber *width;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
