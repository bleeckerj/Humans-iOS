//
//  HuUS2ConditionEmojiStringRange.m
//  humans
//
//  Created by Julian Bleecker on 3/22/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuUS2ConditionEmojiStringRange.h"

@implementation HuUS2ConditionEmojiStringRange

#pragma mark - Violation check

- (BOOL)check:(NSString *)string
{
    BOOL success = NO;

    
    
    if (0 == _range.location
        && 0 == _range.length)
        success = YES;
    
    if (nil == string)
        string = [NSString string];
    
    __block NSInteger length = 0;
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length)
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                length++;
                            }];
    

    
    
    if(length >= _range.location && length <= _range.length)
    {
        success = YES;
    }
    
    return success;
}


@end
