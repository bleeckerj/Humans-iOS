//
//  HuUS2ConditionLowerAlphaEmotis.m
//  humans
//
//  Created by Julian Bleecker on 3/22/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuUS2ConditionLowerAlphaEmotis.h"
//    //\\U0001f300-\\U0001f5ff\\U0001f600-\\U0001f64f\\U0001f680-\\U0001f6c5]"
@implementation HuUS2ConditionLowerAlphaEmotis
#define REGEX_PATTERN @"(?!A-Z)[a-z][a-z0-9]"
//#define REGEX_PATTERN_WHITESPACE @"[a-z0-9\\s]"//\u1f300-\u1f5ff\u1f600-\u1f64f\u1f680-\u1f6c5"

- (BOOL)check:(NSString *)string
{
    if (nil == string || [string isEqualToString: @""])
        return NO;
    
    
//    unichar *c = [string characterAtIndex:[string length]-1];
//    LOG_UI(0, @"%x", c);
//    NSString *pattern = @"[a-z0-9]{1}[a-z0-9\U0001F004-\U0001F6C0]";
//    NSString *pattern = @"[a-z5-9r-za-b]{2}[0-4]";//[\U0001F004-\U0001F6C0]";
    NSString *pattern = REGEX_PATTERN;//\U0001F004-\U0001F6C0]";
//    NSString *pattern = @"[a-z5-9r-za-b]{2}[0-4]";
//    if (self.allowWhitespace)
//    {
//        pattern = REGEX_PATTERN_WHITESPACE;
//    }
    
    NSError *error             = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
    __block NSInteger length = 0;
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length)
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                length++;
                            }];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, length)];

    //LOG_UI(0, @"%d %@ =%d= %d %d %@ %@", numberOfMatches==string.length, (numberOfMatches == length?@"YES":@"NO"), (int)numberOfMatches, (int)length, (int)string.length, string, error);
    return numberOfMatches > 0;
}


#pragma mark - Allow violation

- (BOOL)shouldAllowViolation
{
    return YES;
}


#pragma mark - Localization

- (NSString *)createLocalizedViolationString
{
    return US2LocalizedString(@"HuUS2KeyConditionViolationAlphaEmotis", nil);
}

@end
