//
//  HuUserHandlerTest.m
//  humans
//
//  Created by julian on 12/17/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//
//#define EXP_SHORTHAND
#import "Expecta.h"
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

//- (void)userAddHuman:(HuHuman *)aHuman withCompletionHandler:(CompletionHandlerWithResult)completionHandler
//{
//    
//}

- (void)test_userAddHuman
{
    
}


- (void)test_foogetStatusCountForHuman
{
//    [Expecta setAsynchronousTestTimeout:10];
//    EXP_expect(@"foo").to.equal(@"foo");
//    [user_handler getHumansWithCompletionHandler:^(BOOL success, NSError *error) {
//        NSArray *humans = [[user_handler humans_user]humans];
//        expect(humans).toNot.beEmpty();
//
//        if([humans count] > 0) {
//            
//            [user_handler getStatusCountForHuman:[humans objectAtIndex:0] withCompletionHandler:^(id data, BOOL success, NSError *error) {
//                //
//                expect(success).to.beTruthy();
//                expect(error).to.beNil();
//                
//                LOG_TODO(0, @"status count=%@", data);
//                
//            }];
//        }
//        
//    }];
}


- (void)test_getStatusCountForHumanAfterTimestamp
{
    ASYNC_START
    
    [user_handler getHumansWithCompletionHandler:^(BOOL success, NSError *error) {
        NSArray *humans = [[user_handler humans_user]humans];
        //if([humans count] < 1) {
        assertThat(humans, isNot(isEmpty()));
        if([humans count] > 0) {
            //}
            //long timestamp;
            NSDate *today = [NSDate date];
            
            NSDateComponents *sub_date = [[NSDateComponents alloc] init];
            [sub_date setDay:-3];
            NSDate *threeDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:sub_date
                                                                               toDate:today
                                                                              options:0];

            NSTimeInterval interval = [threeDaysAgo timeIntervalSince1970];
            NSTimeInterval rounded = round(interval);
            
            [user_handler getStatusCountForHuman:[humans objectAtIndex:0] after:rounded withCompletionHandler:^(id data, BOOL success, NSError *error) {
                //
                assertThatBool(success, is(equalToBool(YES)));
                
                LOG_TODO(0, @"status count=%@", data);
                ASYNC_TEST_DONE
                
            }];
        }
        
    }];
    ASYNC_TEST_END
}

- (void)test_getStatusCountForHuman
{
    ASYNC_TEST_START

    [user_handler getHumansWithCompletionHandler:^(BOOL success, NSError *error) {
        NSArray *humans = [[user_handler humans_user]humans];
        //if([humans count] < 1) {
        assertThat(humans, isNot(isEmpty()));
        if([humans count] > 0) {
        //}
        [user_handler getStatusCountForHuman:[humans objectAtIndex:0] withCompletionHandler:^(id data, BOOL success, NSError *error) {
            //
            assertThatBool(success, is(equalToBool(YES)));
            
            LOG_TODO(0, @"status count=%@", data);
            ASYNC_TEST_DONE

        }];
        }

    }];
    ASYNC_TEST_END
   }


- (void)test_userGet
{
    [user_handler getHumansWithCompletionHandler:nil];
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
    [user_handler getStatusForHuman:[humans objectAtIndex:3] atPage:0 withCompletionHandler:^(BOOL success, NSError *error) {
        ASYNC_TEST_DONE
        
        HuRestStatusHeader *head = [user_handler lastStatusResultHeader];
        NSString *human_id = [head human_id];
        HuHuman *human = [humans objectAtIndex:3];
        
        XCTAssertNotNil(head, @"The 'head' from the status query is nil. No bueno.");
        XCTAssertNotEqual(human_id, [human humanid], @"The 'head' human_id is different from the one we asked for. %@ %@", [head human_id], [human humanid]);
        

        
        NSArray *status = [[user_handler statusForHumanId] objectForKey:human_id];
        XCTAssertNotNil(status, @"Status for human_id=%@ is nil. No bueno. %@", human_id, [humans objectAtIndex:0]);
#pragma warning All of the asserts below caused linker errors after they once worked / wont work fo 64-bit tests
        
        assertThat(status, isNot(isEmpty()));
        
        for (int i=0; i<[status count]; i++) {
            id obj = [status objectAtIndex:i];
            NSDate *date = [obj dateForSorting];
            assertThat(obj, conformsTo(@protocol(HuServiceStatus)));
            assertThat(obj, anyOf(instanceOf([HuTwitterStatus class]), instanceOf([InstagramStatus class]), nil));
            assertThat(date, is(greaterThan([NSDate dateWithTimeIntervalSince1970:0])));
            if([obj isKindOfClass:[HuTwitterStatus class]]) {
                assertThat([(HuTwitterStatus *)obj user], notNilValue());
                HuTwitterUser *user =[(HuTwitterStatus *)obj user];
                assertThat([user profile_image_url], equalTo([[obj userProfileImageURL]absoluteString]));
            }
            if([obj isKindOfClass:[InstagramStatus class]]) {
                assertThat([(InstagramStatus *)obj user], notNilValue());
                InstagramUser *user = [(InstagramStatus *)obj user];
                assertThat([user profile_picture], equalTo([[obj userProfileImageURL]absoluteString]));
            }
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
        ASYNC_TEST_DONE
        LOG_GENERAL(0, @"%@", results);
        
        friends = [NSMutableArray arrayWithArray:results];
        for(HuFriend *friend in friends) {
            [friend getProfileImageWithCompletionHandler:^(UIImage *image, NSError *error) {
                

                LOG_INSTAGRAM_IMAGE(0, CGImageGetWidth([image CGImage]), CGImageGetHeight([image CGImage]), UIImageJPEGRepresentation(image, 1.0));
                LOG_GENERAL(0, @"%@ %@ %@",[friend username], [friend serviceName], [friend profileImage]);

            }];
        }

    }];
    
    ASYNC_TEST_END
}

//- (void)testExample
//{
//    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

@end
