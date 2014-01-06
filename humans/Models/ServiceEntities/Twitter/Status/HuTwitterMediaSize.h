//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HuTwitterMediaSize : NSObject



@property (strong, nonatomic) NSDecimalNumber *w;
@property (strong, nonatomic) NSDecimalNumber *h;
@property (strong, nonatomic) NSString *resize;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
