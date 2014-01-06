//
//  HuHumanTest.m
//  humans
//
//  Created by julian on 12/26/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "HuHuman.h"
#import "XCTestCase+AsyncTesting.h"
#import "HuServiceUser.h"
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

@interface HuHumanTest : XCTestCase

@end

@implementation HuHumanTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)test_largestServiceUserProfileImage
{
    id mockServiceUser_1 = [OCMockObject mockForClass:[HuServiceUser class]];
    [[[mockServiceUser_1 stub] andReturn:@"https://irs0.4sqi.net/img/user/height48/54DBU2G2JAMKZTLI.jpg"] imageURL];
    
    id mockServiceUser_2 = [OCMockObject mockForClass:[HuServiceUser class]];
    [[[mockServiceUser_2 stub] andReturn:@"http://farm1.staticflickr.com/21/buddyicons/32512353@N00.jpg"] imageURL];
    
    id mockServiceUser_3 = [OCMockObject mockForClass:[HuServiceUser class]];
    [[[mockServiceUser_3 stub] andReturn:@"http://nearfuturelaboratory.com/img/logo_lift.jpg"] imageURL];
    
    id mockServiceUser_4 = [OCMockObject mockForClass:[HuServiceUser class]];
    [[[mockServiceUser_4 stub] andReturn:@"http://foo.com/profile_images/1128970552/lbmlogo2_normal.jpg"] imageURL];
    
    id mockServiceUser_5 = [OCMockObject mockForClass:[HuServiceUser class]];
    [[[mockServiceUser_5 stub] andReturn:@"http://localhost:9999/timeout"] imageURL];

    HuHuman *human = [[HuHuman alloc]init];
    
    [human setServiceUsers:@[mockServiceUser_1, mockServiceUser_2, mockServiceUser_3, mockServiceUser_4, mockServiceUser_5]];
    
    ASYNC_START

    
    [human loadServiceUsersProfileImagesWithCompletionHandler:^{
 
        UIImage *largest = [human largestServiceUserProfileImage];

        CGImageRef imageRef = [largest CGImage];
        LOG_GENERAL_IMAGE(0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef), UIImageJPEGRepresentation(largest, 1.0));
        
//        LOG_GENERAL(0, @"%zu %f %@", CGImageGetWidth(imageRef), largest.size.width, NSStringFromCGSize([largest size]));
//        LOG_GENERAL(0, @"%zu", CGImageGetHeight(imageRef));
#pragma warning These asserts caused linker errors after they once worked
//        assertThatFloat(largest.size.width, equalToFloat(215));
//        assertThatFloat(largest.size.height, equalToFloat(140));
        ASYNC_DONE

    }];
    
    ASYNC_END
}

- (void)test_loadServiceUsersProfileImagesWithCompletionHandler
{
    ASYNC_START
    id mockServiceUser_1 = [OCMockObject mockForClass:[HuServiceUser class]];
    [[[mockServiceUser_1 stub] andReturn:@"https://irs0.4sqi.net/img/user/height48/54DBU2G2JAMKZTLI.jpg"] imageURL];
    
    id mockServiceUser_2 = [OCMockObject mockForClass:[HuServiceUser class]];
    [[[mockServiceUser_2 stub] andReturn:@"http://farm1.staticflickr.com/21/buddyicons/32512353@N00.jpg"] imageURL];

    id mockServiceUser_3 = [OCMockObject mockForClass:[HuServiceUser class]];
    [[[mockServiceUser_3 stub] andReturn:@"http://nearfuturelaboratory.com/img/logo_lift.jpg"] imageURL];

    id mockServiceUser_4 = [OCMockObject mockForClass:[HuServiceUser class]];
    [[[mockServiceUser_4 stub] andReturn:@"http://foo.com/profile_images/1128970552/lbmlogo2_normal.jpg"] imageURL];

    id mockServiceUser_5 = [OCMockObject mockForClass:[HuServiceUser class]];
    [[[mockServiceUser_5 stub] andReturn:@"http://localhost:9999/timeout"] imageURL];
    
//    id mockHuman = [OCMockObject mockForClass:[HuHuman class]];
//    [[[mockHuman stub] andReturn:@[@"https://irs0.4sqi.net/img/user/height48/54DBU2G2JAMKZTLI.jpg",@"http://farm1.staticflickr.com/21/buddyicons/32512353@N00.jpg",@"http://pbs.twimg.com/profile_images/1128970552/lbmlogo2_normal.jpg",@"http://foo.com/blahblahbroken.jpg" ]] profile_images];
//    
    HuHuman *human = [[HuHuman alloc]init];

    [human setServiceUsers:@[mockServiceUser_1, mockServiceUser_2, mockServiceUser_3, mockServiceUser_4, mockServiceUser_5]];
    
    [human loadServiceUsersProfileImagesWithCompletionHandler:^{
        //
        LOG_GENERAL(0, @"Complete?");
        LOG_GENERAL(0, @"%@", [human profile_images]);
#pragma warning These asserts caused linker errors after they once worked

        //assertThat([human profile_images], isNot(isEmpty()));
        //assertThat([human profile_images], notNilValue());
        //assertThatInt((int)[[human profile_images]count] , equalToInt(5));
        
        [[human profile_images]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            //
            CGImageRef imageRef = [obj CGImage];
            LOG_GENERAL_IMAGE(0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef), UIImageJPEGRepresentation(obj, 1.0));

        }];
        
        ASYNC_DONE
    }];
    
    ASYNC_END
}


@end
