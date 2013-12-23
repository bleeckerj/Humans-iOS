//
//  HuServiceStatus.h
//  humans
//
//  Created by julian on 12/22/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HuServiceStatus <NSObject>

@property (nonatomic, assign) BOOL hasBeenRead;
@property (nonatomic, assign) BOOL doNotShow;
//@property (nonatomic, retain) id<HuSocialServiceUser> serviceUser; don't know why this doesn't work..it's like it doesn't retain
// instead all the visual things we need to embellish when we draw the status in the UI is broken out here..color, username, etc.
@property (nonatomic, retain) UIColor *serviceSolidColor;
@property (nonatomic, retain) NSString *serviceUsername;
@property NSTimeInterval statusTime;
@property NSString *statusText;

@required
-(NSDate *) dateForSorting;
-(NSUInteger)hash;
-(BOOL)isEqual:(id)object;


@end
