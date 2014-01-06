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
#import "XCTest+Async.h"
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import "HuServiceStatus.h"

@interface HuUserHandlerTest : XCTestCase


@end
HuUserHandler *user_handler;

@implementation HuUserHandlerTest

- (void)setUp
{
    [super setUp];
    user_handler = [[HuUserHandler alloc]init];
    ASYNC_TEST_START
    [user_handler userRequestTokenForUsername:@"darthjulian" forPassword:@"darthjulian" withCompletionHandler:^(BOOL success, NSError *error) {
        //
        ASYNC_TEST_DONE

    }];
    ASYNC_TEST_END
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
    [user_handler userRequestTokenForUsername:@"fabien" forPassword:@"fabien" withCompletionHandler:^(BOOL success, NSError *error) {
        //
    }];
    [self waitForTimeout:10];
//    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:30]
    XCTAssertNotNil([user_handler access_token], @"Attempted to request token for valid username and failed");
    //assertThat([user_handler access_token], is(notNilValue()));
}

- (void)test_getStatusForHuman
{
    //    [[[mockArrayOfHumans stub] andReturnValue:OCMOCK_VALUE(five)] count];
    ASYNC_TEST_START
    NSArray *humans = [[user_handler humans_user]humans];
    [user_handler getStatusForHuman:[humans objectAtIndex:0] atPage:0 withCompletionHandler:^(BOOL success, NSError *error) {
        ASYNC_TEST_DONE
        
        HuRestStatusHeader *head = [user_handler lastStatusResultHeader];
        NSString *human_id = [head human_id];
        HuHuman *human = [humans objectAtIndex:0];
        
        XCTAssertNotNil(head, @"The 'head' from the status query is nil. No bueno.");
        XCTAssertNotEqual(human_id, [human humanid], @"The 'head' human_id is different from the one we asked for. %@ %@", [head human_id], [human humanid]);
        

        
        NSArray *status = [[user_handler statusForHumanId] objectForKey:human_id];
        XCTAssertNotNil(status, @"Status for human_id=%@ is nil. No bueno. %@", human_id, [humans objectAtIndex:0]);
#pragma warning All of the asserts below caused linker errors after they once worked / won't work fo 64-bit tests
        
        assertThat(status, isNot(isEmpty()));
        
        for (int i=0; i<[status count]; i++) {
            id obj = [status objectAtIndex:i];
            NSDate *date = [obj dateForSorting];
            assertThat(obj, conformsTo(@protocol(HuServiceStatus)));
            assertThat(obj, anyOf(instanceOf([TwitterStatus class]), instanceOf([InstagramStatus class]), nil));
            assertThat(date, is(greaterThan([NSDate dateWithTimeIntervalSince1970:0])));
        }
        
        
        LOG_GENERAL(0, @"Status: %@", [[user_handler statusForHumanId] objectForKey:human_id]);
        LOG_GENERAL(0, @"Header: %@", head);
    }];
    ASYNC_TEST_END
    
    //[self waitForTimeout:30];
    
}

- (void)test_getStatusForHuman_ServerError
{
    id human = [OCMockObject mockForClass:[HuHuman class]];
    [[[human stub] andReturn:@"x0x0x0"] humanid];

    ASYNC_TEST_START
    [user_handler getStatusForHuman:human atPage:0 withCompletionHandler:^(BOOL success, NSError *error) {
        ASYNC_TEST_DONE
        
        HuRestStatusHeader *head = [user_handler lastStatusResultHeader];
        NSString *human_id = [head human_id];
#pragma warning These asserts caused linker errors after they once worked
        //assertThatBool(success, equalToBool(NO));
        //assertThat(error, isNot(nil));
        //assertThat([error localizedDescription], containsString(@"none such human found for"));
        HuRestStatusHeader *header = [user_handler lastStatusResultHeader];
        //assertThat(header, equalTo(nil));
        
        NSArray *status = [[user_handler statusForHumanId] objectForKey:human_id];
        //assertThat(status, anyOf(isEmpty(), equalTo(nil), nil));
        LOG_GENERAL(0, @"All these asserts stopped linking, wtf?");
    }];
    ASYNC_TEST_END_LONG_TIMEOUT
    
}


- (void)test_userFriendsGet
{
    //6fa703c8a13704477ba923062c678ccf
    __block NSMutableArray *friends;
    ASYNC_TEST_START
    [user_handler userFriendsGet:^(NSMutableArray *results) {
        //
        //LOG_GENERAL(0, @"%@", results);
        friends = [NSMutableArray arrayWithArray:results];

    }];
    ASYNC_TEST_END
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
