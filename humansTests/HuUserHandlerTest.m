//
//  HuUserHandlerTest.m
//  humans
//
//  Created by julian on 12/17/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTestCase+AsyncTesting.h"
#import "HuUserHandler.h"
#import "HuFriend.h"
#import "defines.h"
#import "HuServiceUser.h"
#import "HuHuman.h"
#import <SBJson/SBJson.h>
#import "OCMock/OCMock.h"

@interface HuUserHandlerTest : XCTestCase


@end
HuUserHandler *user_handler;

@implementation HuUserHandlerTest

- (void)setUp
{
    [super setUp];
    user_handler = [[HuUserHandler alloc]init];
    [user_handler setAccess_token:@"c1b93c987f0cdfe70a376243b891ff3a"];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)test_userGet
{
    [user_handler userGetWithCompletionHandler:nil];
    [self waitForTimeout:2];
    HuUser *user = [user_handler humans_user];
    
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *user_json = [writer stringWithObject:[user dictionary]];
    LOG_GENERAL(0, @"%@", user_json);
    NSArray *humans = [user humans];
    HuHuman *first = [humans firstObject];
    HuServiceUser *su = [[first serviceUsers]firstObject];
    NSString *json = [writer stringWithObject:[su dictionary]];
    LOG_GENERAL(0, @"%@", json);
    XCTAssertNotNil([user_handler humans_user], @"Attempted to get user and failed");

    id human =  [OCMockObject mockForClass:[HuHuman class]];
    LOG_GENERAL(0, @"%@", human);

}

- (void)test_userRequestTokenForUsername
{
    //HuUserHandler *handler = [[HuUserHandler alloc]init];
    [user_handler userRequestTokenForUsername:@"darthjulian" forPassword:@"darthjulian"];
    [self waitForTimeout:10];
//    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:30]
    XCTAssertNotNil([user_handler access_token], @"Attempted to request token for valid username and failed");
    //assertThat([user_handler access_token], is(notNilValue()));
}



- (void)test_userFriendsGet
{
    //6fa703c8a13704477ba923062c678ccf
    __block NSMutableArray *friends;
    [user_handler setAccess_token:@"6fa703c8a13704477ba923062c678ccf"];
    [user_handler userFriendsGet:^(NSMutableArray *results) {
        //
        //LOG_GENERAL(0, @"%@", results);
        friends = [NSMutableArray arrayWithArray:results];

    }];
    [self waitForTimeout:30];
    for(HuFriend *friend in friends) {
        UIImage *image = [friend largeProfileImage];
        LOG_GENERAL(0, @"%@ %@",[friend username], [friend service]);
        LOG_INSTAGRAM_IMAGE(0, CGImageGetWidth([image CGImage]), CGImageGetHeight([image CGImage]), UIImageJPEGRepresentation(image, 1.0));
    }
}

//- (void)testExample
//{
//    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

@end
