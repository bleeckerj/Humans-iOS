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
    BOOL result = [handler usernameExists:@"fabien"];
    
    LOG_GENERAL(0, @"Hello %@", (result ? @"Exists" : @"Doesn't Exist"));
    [self waitForTimeout:30];
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
