//
//  humansTests.m
//  humansTests
//
//  Created by julian on 12/13/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//
#import <XCTest/XCTest.h>
#import "XCTestCase+AsyncTesting.h"

#import "HuUserHandler.h"
#import "HuFlickrServicer.h"

@interface humansTests : XCTestCase

@end

@implementation humansTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    HuUserHandler *handler = [[HuUserHandler alloc]init];

    [handler usernameExists:@"fabien" withCompletionHandler:^(BOOL success, NSError *error) {
        LOG_GENERAL(0, @"Hello %@", (success ? @"Exists" : @"Doesn't Exist"));

    }];
    
    [self waitForTimeout:30];

    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testFlickr
{
    HuFlickrServicer *flickr = [[HuFlickrServicer alloc]init];
    [flickr like];
}

@end
