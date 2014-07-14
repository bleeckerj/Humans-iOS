//
//  NSMutableDictionary+JCBDictionaryTimedCache.m
//  
//
//  Created by Julian Bleecker on 6/8/14.
//
//

#import "NSMutableDictionary+JCBDictionaryTimedCache.h"

@implementation NSMutableDictionary (JCBDictionaryTimedCache)

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey removeAfter:(NSTimeInterval)timeInterval
{
    [self setObject:anObject forKey:aKey removeAfter:timeInterval notifyOnRemoval:nil];
    
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey removeAfter:(NSTimeInterval)timeInterval notifyOnRemoval:(NotifyHandler)notifyHandler
{
    NSAssert(timeInterval > 0, @"timeInterval must be greater than zero");
    [self setObject:anObject forKey:aKey];
    [self performBlock:^{
        [self removeObjectForKey:aKey];
        if(notifyHandler) {
            notifyHandler(aKey);
        }
    } afterDelay:timeInterval];
 
}


- (void)invalidateTimeoutForKey:(id<NSCopying>)aKey
{
    
}

- (void)revalidateTimeoutForKey:(id<NSCopying>)aKey
{
    
}

// perform a block after a specified number of seconds
- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end
