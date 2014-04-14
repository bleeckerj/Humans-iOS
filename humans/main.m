//
//  main.m
//  humans
//
//  Created by julian on 12/13/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lecore.h"
#import "lelib.h"

#import "HuAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        
        le_init();
        le_set_token("caa60344-2c01-4c67-b2c4-393b425abf84");
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([HuAppDelegate class]));
    }
}
