
#import "StateMachine.h"

@implementation StateInfo
@synthesize transitions = _transitions, stateName = _stateName, selector = _selector;

-(id)init
{
	if((self = [super init])!=nil)
	{
		self.transitions = [[NSMutableArray alloc] init];
	}
	
	return self;
}

-(id) initWithStateName:(NSString*)stateName
{
	if((self = [self init])!=nil)
	{
		self.stateName = stateName;
	}
	
	return self;
	
}

-(void) registerNextState:(StateInfo*)state withCondition:(NSString*)condition
{
	Transition* transition = [[Transition alloc] initWithCondition:condition andState:state];
	[self.transitions addObject:transition];
	[transition release];
}

-(StateInfo*) executeTransition:(id)anObject
{
	for (Transition* item in self.transitions) {
		StateInfo* state = [item execute:anObject];
		if(state!=nil) return state;
	}
	
	return nil;
}

-(BOOL) canExecuteTransition:(id)anObject
{
	for (Transition* item in self.transitions) {
		StateInfo* state = [item execute:anObject];
		if(state!=nil) return YES;
	}
	
	return NO;
}

-(void)dealloc
{
    [self.transitions removeAllObjects];
    [self.transitions release];
	[super dealloc];
}
@end

@implementation Transition
@synthesize condition = _condition, nextState = _nextState;

-(id)initWithCondition:(NSString*)condition andState:(StateInfo*)state
{
	if((self = [super init])!=nil)
	{
		self.condition = condition;
		self.nextState = state;
	}
	
	return self;
}

-(StateInfo*)execute:(id)anObject
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:self.condition];
    BOOL willTransition = [predicate evaluateWithObject:anObject];
	return willTransition ? self.nextState : nil;
}

-(void)dealloc
{
    [self.nextState release];
    [super dealloc];
}
@end


@implementation StateMachine

@synthesize currentState = _currentState, states = _states;

-(id) init
{
	if((self = [super init])!=nil)
	{
		self.states = [[NSMutableArray alloc] init];
	}
	
	return self;
}

-(id)initWithInitialState:(StateInfo*)state
{
	if((self = [self init])!=nil)
	{
		[self registerState:state];
		self.currentState = state;
	}
	
	return self;
}

-(StateInfo*) nextState:(id)anObject
{
	StateInfo* nextState = [_currentState executeTransition:anObject];
	
	if(nextState==nil) return nil;
	
	self.currentState = nextState;
	
	if(self.currentState.selector!=nil)
	{
		if(![anObject respondsToSelector:self.currentState.selector])
		{
			@throw [NSException exceptionWithName:@"transition failed" reason:@"the target object does not respond to the selector specified" userInfo:nil];
		}
		
		[anObject performSelector:self.currentState.selector];
	}
	
	return self.currentState;
}

-(BOOL) canTransition:(id)anObject
{
	return [self.currentState canExecuteTransition:anObject];
}

-(void)registerState:(StateInfo*)state
{
	if(state.stateName==nil)
	{
		@throw [NSException exceptionWithName:@"InvalidState" reason:@"State name required" userInfo:nil];
	}
	
	for(StateInfo* item in self.states)
	{
		if([item.stateName isEqual:state.stateName])
		{
			@throw [NSException exceptionWithName:@"Failed to add state" reason:@"State exists" userInfo:nil];
		}
	}
	
	[self.states addObject:state];
}

-(void) registerInitialState:(StateInfo*)state
{
	[self registerState:state];
	self.currentState = state;
}

-(BOOL) isCurrentState:(NSString*)stateName
{
	if(self.currentState==nil) return NO;
	if(self.currentState.stateName==nil)return NO;
	
	NSString* state = self.currentState.stateName;
	
	if([state caseInsensitiveCompare:stateName]==NSOrderedSame)
	{
		return YES;
	};
	
	return NO;
}

-(void)dealloc
{
    [self.states removeAllObjects];
	[self.states release];
	[super dealloc];
}

@end
