//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HuOnBehalfOf : NSObject


@property (strong, nonatomic) NSString *serviceName;
@property (strong, nonatomic) NSString *serviceUserID;
@property (strong, nonatomic) NSString *serviceUsername;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
