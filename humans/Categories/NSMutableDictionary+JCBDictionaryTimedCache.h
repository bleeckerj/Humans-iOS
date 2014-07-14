//
//  NSMutableDictionary+JCBDictionaryTimedCache.h
//  
//
//  Created by Julian Bleecker on 6/8/14.
//
//

#import <Foundation/Foundation.h>
typedef void(^NotifyHandler)(id<NSCopying>aKey);

@interface NSMutableDictionary (JCBDictionaryTimedCache)

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey removeAfter:(NSTimeInterval)timeInterval;
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey removeAfter:(NSTimeInterval)timeInterval notifyOnRemoval:(NotifyHandler)notifyHandler;
//- (void)invalidateTimeoutForKey:(id<NSCopying>)aKey;
//- (void)revalidateTimeoutForKey:(id<NSCopying>)aKey;


@end
