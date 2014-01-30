//
//  HuHumanLineStyled.h
//  
//
//  Created by julian on 1/29/14.
//
//

#import "MGLineStyled.h"
#import "HuHuman.h"
#import "HuUserHandler.h"

@interface HuHumanLineStyled : MGLineStyled

@property HuHuman *human;
@property NSNumber *count;

- (void)setUserHandler:(HuUserHandler *)aUserHandler;
- (void)refreshCounts;

@end
