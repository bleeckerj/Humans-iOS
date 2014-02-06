//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InstagramLike : NSObject



@property (strong, nonatomic) NSString *full_name;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *profile_picture;
@property (strong, nonatomic) NSString *username;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
