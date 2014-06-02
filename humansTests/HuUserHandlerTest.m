//
//  HuUserHandlerTest.m
//  humans
//
//  Created by julian on 12/17/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//
#define EXP_SHORTHAND
#import <Expecta.h>
#import <XCTest/XCTest.h>
#import "XCTestCase+AsyncTesting.h"
#import "HuUserHandler.h"
#import "HuFriend.h"
#import "defines.h"
#import "HuServiceUser.h"
#import "HuHuman.h"
#import <SBJson4.h>
#import "OCMock/OCMock.h"
#import "XCTest+Async.h"
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import "HuServiceStatus.h"
#import <AFNetworking.h>
#import "HuFoursquareUser.h"
#import "HuOnBehalfOf.h"
#import "HuUser.h"
#import <ObjectiveSugar.h>
#import "HuTwitterStatus.h"
#import "InstagramStatus.h"
#import "HuFlickrStatus.h"
#import "HuFoursquareCheckin.h"
#import "HuTwitterUser.h"

@interface HuUserHandlerTest : XCTestCase


@end
HuUserHandler *user_handler;


@implementation HuUserHandlerTest

- (void)setUp
{
    [super setUp];
    ASYNC_TEST_START
    user_handler = [[HuUserHandler alloc]init];
    [user_handler userRequestTokenForUsername:@"darthjulian" forPassword:@"darthjulian" withCompletionHandler:^(BOOL success, NSError *error) {
        ASYNC_DONE
        
    }];
    ASYNC_TEST_END
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}


- (void)test_getAuthForServices
{
    ASYNC_START
    HuUser *user = [user_handler humans_user];
    [[user services]each:^(id object) {
        //
        LOG_DEEBUG(0, @"%@", object);
        HuOnBehalfOf *equivalent = HuOnBehalfOf.new;
        [equivalent setServiceUsername:[object serviceUsername]];
        [equivalent setServiceUserID:[object serviceUserID]];
        [equivalent setServiceName:[object serviceName]];

        [user_handler getAuthForService:equivalent];
    }];
    ASYNC_TEST_DONE
    
    ASYNC_TEST_END_LONG_TIMEOUT
}

- (void)test_parseCreateNewUser
{
    ASYNC_START
    HuUser *newUser = [[HuUser alloc]init];
    [newUser setUsername:@"julian"];
    [newUser setEmail:@"julian@nearfuturelaboratory.com"];
    NSString *password = @"forbidden";
    LOG_TODO(0, @"%@", [newUser jsonString]);
    [user_handler parseCreateNewUser:newUser password:password withCompletionHandler:^(id data, BOOL success, NSError *error) {
        //
        LOG_TODO(0, @"%@ %d %@", data, success, error);
        ASYNC_TEST_DONE
    }];
    ASYNC_TEST_END_LONG_TIMEOUT
}




- (void)test_getStatusCountForHumanAfterTimestamp
{
    ASYNC_START
    
    [user_handler getHumansWithCompletionHandler:^(BOOL success, NSError *error) {
        NSArray *humans = [[user_handler humans_user]humans];
        assertThat(humans, isNot(isEmpty()));
        if([humans count] > 0) {

            NSDate *today = [NSDate date];
            
            NSDateComponents *sub_date = [[NSDateComponents alloc] init];
            [sub_date setDay:-1];
            NSDate *threeDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:sub_date
                                                                                 toDate:today
                                                                                options:0];
            
            NSTimeInterval interval = [threeDaysAgo timeIntervalSince1970];
            NSTimeInterval rounded = round(interval);
            
            [user_handler getStatusCountForHuman:[humans objectAtIndex:0] after:rounded withCompletionHandler:^(id data, BOOL success, NSError *error) {
                //
                ASYNC_TEST_DONE

                assertThatBool(success, is(equalToBool(YES)));
                assertThat(error, is(nilValue()));
                expect(data).to.beKindOf([NSDictionary class]);
                expect([data objectForKey:@"count"]).to.beGreaterThan(@0);
                
                LOG_TODO(0, @"status count=%@", data);
                
            }];
        }
        
    }];
    ASYNC_TEST_END_LONG_TIMEOUT
}

- (void)test_getStatusCounts
{
    ASYNC_TEST_START
    
    [user_handler getStatusCountsWithCompletionHandler:^(id data, BOOL success, NSError *error) {
        //
        assertThatBool(success, is(equalToBool(YES)));
        expect(success).to.beTruthy();
        expect(error).to.beNil();
        expect(data).to.beKindOf([NSDictionary class]);
        
        LOG_TODO(0, @"status counts=%@", data);
        ASYNC_TEST_DONE
        
    }];
    
    ASYNC_TEST_END
    
}

- (void)test_getStatusCountForHuman
{
    ASYNC_TEST_START
    
    [user_handler getHumansWithCompletionHandler:^(BOOL success, NSError *error) {
        NSArray *humans = [[user_handler humans_user]humans];
        //if([humans count] < 1) {
        assertThat(humans, is(notNilValue()));
        assertThat(humans, isNot(isEmpty()));
        assertThat(error, is(nilValue()));
        assertThat([NSNumber numberWithInt:[humans count]], greaterThanOrEqualTo(@1));
        if([humans count] > 0) {
            //}
            [user_handler getStatusCountForHuman:[humans objectAtIndex:0] withCompletionHandler:^(id data, BOOL success, NSError *error) {
                //
                assertThatBool(success, is(equalToBool(YES)));
                expect(success).to.beTruthy();
                expect(error).to.beNil();
                expect(data).to.beKindOf([NSDictionary class]);
                LOG_TODO(0, @"status count=%@", data);
                ASYNC_TEST_DONE
                
            }];
        }
        
    }];
    ASYNC_TEST_END
}

- (void)test_getStatusCountsForUsersHumans
{
    ASYNC_TEST_START
    [user_handler getStatusCountsWithCompletionHandler:^(id data, BOOL success, NSError *error) {
        //
        assertThatBool(success, is(equalToBool(YES)));
        expect(success).to.beTruthy();
        expect(error).to.beNil();
        expect(data).to.beKindOf([NSDictionary class]);
        
        LOG_TODO(0, @"status counts=%@", data);
        
        ASYNC_TEST_DONE
    }];
    ASYNC_TEST_END
}


- (void)test_getHumansWithCompletionHandler
{
    
    ASYNC_TEST_START
    
    
    [user_handler getHumansWithCompletionHandler:^(BOOL success, NSError *error) {
        ASYNC_TEST_DONE
        assertThatBool(success, is(equalToBool(YES)));
    }];
    ASYNC_TEST_END
    [user_handler humans_user];
    XCTAssertNotNil([user_handler humans_user], @"Attempted to get user and failed");
    
    
}

- (void)test_userRequestTokenForUsername
{
    ASYNC_TEST_START
    [user_handler userRequestTokenForUsername:@"darthjulian" forPassword:@"darthjulian" withCompletionHandler:^(BOOL success, NSError *error) {
        //
        assertThat([user_handler access_token], is(notNilValue()));
        
        ASYNC_TEST_DONE
    }];
    ASYNC_TEST_END_LONG_TIMEOUT
    //XCTAssertNotNil([user_handler access_token], @"Attempted to request token for valid username and failed");
}

/*
- (void)test_getStatusForHuman
{
    ASYNC_START
    
    NSArray *humans = [[user_handler humans_user]humans];
    LOG_TODO(0, @"humans %@", humans);
    assertThat(humans, is(notNilValue()));
    assertThat([NSNumber numberWithInt:[humans count]], greaterThan(@0));
    expect([humans count]).to.beGreaterThan(0);
    NSUInteger r = arc4random_uniform([humans count]);
    LOG_TODO(0, @"r=%lu", (unsigned long)r);
    [humans eachWithIndex:^(id object, NSUInteger index) {
        //
        [user_handler getStatusForHuman:[humans objectAtIndex:index] atPage:0 withCompletionHandler:^(BOOL success, NSError *error) {
            
            NSDictionary *head = [user_handler lastStatusResultHeader];
            NSString *human_id = [head objectForKey:@"human_id"];
            HuHuman *human = [humans objectAtIndex:3];
            
            XCTAssertNotNil(head, @"The 'head' from the status query is nil. No bueno.");
            XCTAssertNotEqual(human_id, [human humanid], @"The 'head' human_id is different from the one we asked for. %@ %@", human_id, [human humanid]);
            
            LOG_GENERAL(0, @"Status: %@", [[user_handler statusForHumanId] objectForKey:human_id]);
            
            
            NSArray *status = [[user_handler statusForHumanId] objectForKey:human_id];
            //LOG_TODO(0, @"%@", status);
            XCTAssertNotNil(status, @"Status for human_id=%@ is nil. No bueno. %@", human_id, [humans objectAtIndex:0]);
            
            assertThat(status, isNot(isEmpty()));
            
            for (int i=0; i<[status count]; i++) {
                id obj = [status objectAtIndex:i];
                NSDate *date = [obj dateForSorting];
                assertThat(obj, conformsTo(@protocol(HuServiceStatus)));
                assertThat(obj, anyOf(instanceOf([HuTwitterStatus class]), instanceOf([InstagramStatus class]), instanceOf([HuFlickrStatus class]), instanceOf([HuFoursquareCheckin class]), nil));
                
//                if([obj isKindOfClass:[HuTwitterStatus class]]) {
//                    assertThat([(HuTwitterStatus *)obj text], notNilValue());
//                    assertThat([(HuTwitterStatus *)obj user], notNilValue());
//                    HuTwitterUser *user =[(HuTwitterStatus *)obj user];
//                    assertThat([user profile_image_url], equalTo([[obj userProfileImageURL]absoluteString]));
//                    assertThat(date, is(greaterThan([NSDate dateWithTimeIntervalSince1970:0])));
//
//                }
                if([obj isKindOfClass:[InstagramStatus class]]) {
                    assertThat([(InstagramStatus *)obj user], notNilValue());
                    assertThat([(InstagramStatus *)obj images], notNilValue());
                    //assertThat([(InstagramStatus *)obj caption], notNilValue());
                               
                    InstagramUser *user = [(InstagramStatus *)obj user];
                    assertThat([user profile_picture], equalTo([[obj userProfileImageURL]absoluteString]));
                    assertThat(date, is(greaterThan([NSDate dateWithTimeIntervalSince1970:0])));

                }
                if([obj isKindOfClass:[HuFoursquareCheckin class]]) {
                    LOG_TODO(0, @"FOURSQUARE %@", obj);
                    assertThat([(HuFoursquareCheckin *)obj user], notNilValue());
                    assertThat([(HuFoursquareCheckin *)obj venue], notNilValue());
                    HuFoursquareUser *user = [(HuFoursquareCheckin *)obj user];
                    assertThat([user photo], notNilValue());
                    assertThat(date, is(greaterThan([NSDate dateWithTimeIntervalSince1970:0])));

                    
                }
            }
            
            
            LOG_GENERAL(0, @"Header: %@", head);
            if(index == [humans count]-1) {
                ASYNC_TEST_DONE
            }
        }];
       
    }];

    
    
    ASYNC_TEST_END
    //[self waitForTimeout:30];
    
}
*/
- (void)test_getStatusForHumanAtPage
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);

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
        [friends each:^(HuFriend *obj) {
            
            assertThat([obj username], notNilValue());
            assertThat([obj serviceName], notNilValue());
            assertThat([obj serviceName], anyOf(@"twitter", @"foursquare", @"flickr", @"instagram", nil));
            assertThat([obj profileImage], notNilValue());
        }];
        
    }];
    
    ASYNC_TEST_END
}

- (void)test_getAuthForService
{
    ASYNC_TEST_START
    
    NSArray *services = [[user_handler humans_user]services];
    
    HuServices *service = [services objectAtIndex:0];
    
    [user_handler getAuthForService:service with:^(id data, BOOL success, NSError *error) {
        //
        ASYNC_TEST_DONE
        assertThatBool(success, is(equalToBool(YES)));
        assertThat(error, is(nilValue()));
        assertThat([data objectForKey:@"consumer_key"], notNilValue());
        assertThat([data objectForKey:@"token_key"], notNilValue());
        assertThat([data objectForKey:@"consumer_secret"], notNilValue());
        assertThat([data objectForKey:@"token_secret"], notNilValue());
        
    }];
    ASYNC_TEST_END
    
    
}

- (void)test_userRemoveHuman
{
    ASYNC_START
    NSArray *humans = [[user_handler humans_user]humans];
    assertThatInt([humans count], is(greaterThan(@0)));
    HuHuman *human = [humans objectAtIndex:[humans count]-1];
    [user_handler userRemoveHuman:human withCompletionHandler:^(BOOL success, NSError *error) {
        //ASYNC_DONE
        assertThatBool(success, is(equalToBool(YES)));
        assertThat(error, is(nilValue()));
        
        [user_handler userAddHuman:human withCompletionHandler:^(BOOL success, NSError *error) {
            //
            ASYNC_DONE
            assertThatBool(success, is(equalToBool(YES)));
            assertThat(error, is(nilValue()));

        }];
        
    }];
    ASYNC_TEST_END
   // XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)test_userAddHuman
{
    ASYNC_TEST_START
    HuHuman *aHuman = [[[user_handler humans_user]humans]objectAtIndex:0];
    assertThat(aHuman, is(notNilValue()));
    
//    aHuman setHumanid:@"530ac0deef869bc141d11d3f"
    [aHuman setHumanid:@""];
    NSString* buildNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CWBuildNumber"];

    [aHuman setName:[NSString stringWithFormat:@"Test Human %@", buildNumber]];
    [user_handler userAddHuman:aHuman withCompletionHandler:^(BOOL success, NSError *error) {
        //
        //ASYNC_TEST_DONE
        assertThatBool(success, is(equalToBool(YES)));
        assertThat(error, is(nilValue()));
    }];
    
    ASYNC_TEST_END
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    
}



- (void)test_userGettyUpdate
{
    ASYNC_START
    NSArray *humans = [[user_handler humans_user]humans];
    HuHuman *human = (HuHuman*)[humans objectAtIndex:0];
    [user_handler userGettyUpdate:human withCompletionHandler:^(BOOL success, NSError *error) {
        ASYNC_DONE
        assertThatBool(success, is(equalToBool(YES)));
        assertThat(error, is(nilValue()));
    }];
    
    ASYNC_TEST_END
}


- (void)test_userGettyUpdateFriends
{
    ASYNC_START
    [user_handler userGettyUpdateFriends:^(BOOL success, NSError *error) {
        ASYNC_DONE
        assertThatBool(success, is(equalToBool(YES)));
        assertThat(error, is(nilValue()));
    }];
    ASYNC_TEST_END
}

- (void)test_userRemoveServiceUser
{
    ASYNC_START
    __block HuServiceUser *remove;
    NSArray *humans = [[user_handler humans_user]humans];
    //NSNumber *count =  [NSNumber numberWithInt:[humans count]];

   // [humans each:^(id object) {
        HuHuman *human = (HuHuman*)[humans objectAtIndex:[humans count]-1];
        NSArray *service_users = [human serviceUsers];
        assertThatInt([service_users count], is(greaterThan(@0)));
        remove = (HuServiceUser*)[service_users objectAtIndex:0];
        [user_handler humanRemoveServiceUser:remove forHuman:human withCompletionHandler:^(BOOL success, NSError *error) {
            assertThatBool(success, is(equalToBool(YES)));
            assertThat(error, is(nilValue()));
            [user_handler getHumansWithCompletionHandler:^(BOOL success, NSError *error) {
                ASYNC_TEST_DONE
                assertThatBool(success, is(equalToBool(YES)));
                assertThat(error, is(nilValue()));
                NSArray *after = [[user_handler humans_user]humans];
                [after each:^(id object) {
                    HuHuman *after_human = (HuHuman*)object;
                    if([[after_human humanid]isEqualToString:[human humanid]]) {
                        NSArray *after_service_users = [after_human serviceUsers];
                        assertThatInt([after_service_users count], is(equalToInt([service_users count]-1)));
                    }
                }];
                
            }];
        }];
   // }];
    ASYNC_TEST_END
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)test_userRemoveService
{
    
    ASYNC_START
    NSArray *services = [[user_handler humans_user]services];
    expect(services).toNot.beNil();
    expect([services count]).to.beGreaterThan(@0);
    HuServices *service = [services objectAtIndex:0];
    int before_count = [services count];
    [user_handler userRemoveService:service withCompletionHandler:^(BOOL success, NSError *error) {
        
        expect(success).to.beTruthy();
        expect(error).to.beNil();
        [user_handler getHumansWithCompletionHandler:^(BOOL success, NSError *error) {
            ASYNC_DONE
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            NSArray *after_services = [[user_handler humans_user]services];
            expect(after_services).toNot.contain(service);
            int after_count = [after_services count];
            expect(after_count).to.equal(before_count - 1);
        }];
    }];
    
    
    ASYNC_TEST_END
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);

}

- (void)test_humanAddServiceUser
{
    ASYNC_START
    NSArray *humans = [[user_handler humans_user]humans];
    assertThatInt([humans count], greaterThan(@0));
    
    HuHuman *before_human = [humans objectAtIndex:0];
    NSArray *before_service_users = [before_human serviceUsers];
    LOG_TEST(0, @"%@", before_human);

    expect([before_service_users count]).to.beGreaterThan(@0);
    //int before_count = [before_service_users count];
    
    HuServiceUser *before_service_user = [[before_human serviceUsers]objectAtIndex:0];
    LOG_TEST(0, @"before_service_user=%@", [before_service_user jsonString]);
    [before_service_user setId:nil];
    [before_service_user setServiceName:@"testtesttest"];
    [user_handler humanAddServiceUser:before_service_user forHuman:before_human withCompletionHandler:^(id data, BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();
    
        [user_handler getHumansWithCompletionHandler:^(BOOL success, NSError *error) {
            ASYNC_DONE

            NSArray *after_humans = [[user_handler humans_user]humans];
            HuHuman *after_human = [after_humans objectAtIndex:0];
            LOG_TEST(0, @"%@", after_human);
            expect([[after_human serviceUsers]count]).to.beGreaterThan(@0);
            //NSArray *after_service_users = [after_human serviceUsers];
            //expect([after_service_users count]).to.equal(before_count +1);
            

        }];
        
    }];
    ASYNC_TEST_END_LONG_TIMEOUT
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);

}

- (void)test_userAddServiceUsers
{
    HuServiceUser *su_1 = [[HuServiceUser alloc]initWithJSONDictionary:@{
                                                                        @"serviceName" : @"test_1",
                                                                        @"serviceUserID" : @"test_1",
                                                                        @"username" : @"test_1",
                                                                         @"imageURL" : @"http://test",
                                                                         @"id" : @"",
                                                                         @"lastUpdated": @""}];
    
    HuServiceUser *su_2 = [[HuServiceUser alloc]initWithJSONDictionary:@{
                                                                         @"serviceName" : @"test_2",
                                                                         @"serviceUserID" : @"test_2",
                                                                         @"username" : @"test_2",
                                                                         @"imageURL" : @"http://test",
                                                                         @"id" : @"",
                                                                         @"lastUpdated" : @""}];
    
    HuOnBehalfOf *ob_1 = [[HuOnBehalfOf alloc]initWithJSONDictionary:@{@"serviceName" : @"test",
                                                                       @"serviceUserID" : @"16463713",
                                                                       @"serviceUsername" : @"test"}];
    
    NSError *error;
    
     [NSJSONSerialization dataWithJSONObject:ob_1 options:NSJSONWritingPrettyPrinted error:&error];
    [su_1 setOnBehalfOf:ob_1];
    [su_2 setOnBehalfOf:ob_1];
    
    NSArray *sus = @[su_1, su_2];

    NSArray *humans = [[user_handler humans_user]humans];
    HuHuman *before_human = [humans objectAtIndex:0];
    assertThat(before_human, is(notNilValue()));
    
    LOG_TEST(0, @"before_human = %@", [before_human name]);
    [user_handler humanAddServiceUsers:sus forHuman:before_human withCompletionHandler:^(id data, BOOL success, NSError *error) {
        expect(success).to.beTruthy();
        expect(error).to.beNil();
    }];
    
            
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);

}

/*
 - (void)test_doSomethingWithTwitter:(NSString *)key secret:(NSString*)secret
 {
 
 
 AFOAuth1Client *client = [[AFOAuth1Client alloc]initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/"] key:key secret:secret];
 
 //[NSURL URLWithString:@"https://api.twitter.com/1.1/"]];
 [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
 
 [client getPath:@"statuses/user_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
 //
 
 LOG_GENERAL(0, @"%@", responseObject);
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 //
 LOG_ERROR(0, @"%@", error);
 }];
 
 
 }
 */


@end
