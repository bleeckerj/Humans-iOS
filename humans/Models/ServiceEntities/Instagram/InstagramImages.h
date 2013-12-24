//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InstagramImage;
@class InstagramImage;
@class InstagramImage;

@interface InstagramImages : NSObject



@property (strong, nonatomic) InstagramImage *low_resolution;
@property (strong, nonatomic) InstagramImage *standard_resolution;
@property (strong, nonatomic) InstagramImage *thumbnail;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
