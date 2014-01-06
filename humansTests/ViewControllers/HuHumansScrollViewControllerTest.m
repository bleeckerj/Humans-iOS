//
//  HuHumansScrollViewControllerTest.m
//  humans
//
//  Created by julian on 12/21/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTestCase+AsyncTesting.h"
#import "HuHumansScrollViewController.h"
#import <OCMock/OCMock.h>
#import "HuHuman.h"

@interface HuHumansScrollViewControllerTest : XCTestCase

@end

@implementation HuHumansScrollViewControllerTest

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

- (void)testExample
{
    HuHumansScrollViewController *controller = [[HuHumansScrollViewController alloc]init];
    NSUInteger five = (long)4;
    id mockArrayOfHumans = [OCMockObject mockForClass:[NSArray class]];
    //[[[mockArrayOfHumans stub] andReturnValue:OCMOCK_VALUE(five)] count];
    id mockHuman = [OCMockObject mockForClass:[HuHuman class]];
    [[[mockHuman stub] andReturn:@"Shecky"] name];
    [controller setArrayOfHumans:mockArrayOfHumans];
    [[[mockArrayOfHumans stub] andReturn:mockHuman] objectAtIndex:0];
    [[[mockArrayOfHumans stub] andReturn:mockHuman] objectAtIndex:1];
    [[[mockArrayOfHumans stub] andReturn:mockHuman] objectAtIndex:2];
    [[[mockArrayOfHumans stub] andReturn:mockHuman] objectAtIndex:3];
    UIViewController *main = [[[[UIApplication sharedApplication]delegate]window]rootViewController];
    [main presentViewController:controller animated:YES completion:^{
        //
        
        
    }];
        
    // XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
