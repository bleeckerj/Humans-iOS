//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "HuTwitterStatusEntities.h"
#import "HuTwitterEntitesHashtag.h"
#import "HuTwitterEntitiesSymbols.h"
#import "HuTwitterEntitiesURL.h"
#import "HuTwitterEntitiesUserMentions.h"
#import "HuTwitterStatusMedia.h"


@implementation HuTwitterStatusEntities


@synthesize hashtags = _hashtags;
@synthesize symbols = _symbols;
@synthesize urls = _urls;
@synthesize user_mentions = _user_mentions;
@synthesize media = _media;


- (void) dealloc
{
	

}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@ %@ %@", [self.user_mentions description], [self.symbols description], [self.urls description], [self.media description], [self.hashtags description]];
//    NSError *error = [[NSError alloc]init];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.user_mentions options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return jsonString;
}

- (id) initWithJSONDictionary:(NSDictionary *)dic
{
	if(self = [super init])
	{
		[self parseJSONDictionary:dic];
	}
	
	return self;
}

- (void) parseJSONDictionary:(NSDictionary *)dic
{
	// PARSER
	id hashtags_ = [dic objectForKey:@"hashtags"];
	if([hashtags_ isKindOfClass:[NSArray class]])
	{
		NSMutableArray *array = [NSMutableArray array];
		for(NSDictionary *itemDic in hashtags_)
		{
			HuTwitterEntitesHashtag *item = [[HuTwitterEntitesHashtag alloc] initWithJSONDictionary:itemDic];
			[array addObject:item];
		}
		self.hashtags = [NSArray arrayWithArray:array];
	}

	id symbols_ = [dic objectForKey:@"symbols"];
	if([symbols_ isKindOfClass:[NSArray class]])
	{
		NSMutableArray *array = [NSMutableArray array];
		for(NSDictionary *itemDic in symbols_)
		{
			HuTwitterEntitiesSymbols *item = [[HuTwitterEntitiesSymbols alloc] initWithJSONDictionary:itemDic];
			[array addObject:item];
		}
		self.symbols = [NSArray arrayWithArray:array];
	}

	id urls_ = [dic objectForKey:@"urls"];
	if([urls_ isKindOfClass:[NSArray class]])
	{
		NSMutableArray *array = [NSMutableArray array];
		for(NSDictionary *itemDic in urls_)
		{
			HuTwitterEntitiesURL *item = [[HuTwitterEntitiesURL alloc] initWithJSONDictionary:itemDic];
			[array addObject:item];
		}
		self.urls = [NSArray arrayWithArray:array];
	}

	id user_mentions_ = [dic objectForKey:@"user_mentions"];
	if([user_mentions_ isKindOfClass:[NSArray class]])
	{
		NSMutableArray *array = [NSMutableArray array];
		for(NSDictionary *itemDic in user_mentions_)
		{
			HuTwitterEntitiesUserMentions *item = [[HuTwitterEntitiesUserMentions alloc] initWithJSONDictionary:itemDic];
			[array addObject:item];
		}
		self.user_mentions = [NSArray arrayWithArray:array];
	}

	id media_ = [dic objectForKey:@"media"];
	if([media_ isKindOfClass:[NSArray class]])
	{
		NSMutableArray *array = [NSMutableArray array];
		for(NSDictionary *itemDic in media_)
		{
			HuTwitterStatusMedia *item = [[HuTwitterStatusMedia alloc] initWithJSONDictionary:itemDic];
			[array addObject:item];
		}
		self.media = [NSArray arrayWithArray:array];
	}

	
}

@end
