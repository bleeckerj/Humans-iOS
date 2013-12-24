//
//  HuRestStatusHeader.h
//  humans
//
//  Created by julian on 12/24/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HuRestStatusHeader : NSObject

@property NSDecimalNumber *count;
@property NSString *human_id;
@property NSString *human_name;
@property NSDecimalNumber *page;
@property NSDecimalNumber *pages;
@property NSDecimalNumber *total_status;


@end
