#import <Foundation/Foundation.h>

@class CCLayer;

@interface StateInfo : NSObject
{
	NSString* _stateName;
	NSMutableArray* _transitions;
	SEL _selector;
}

@property (nonatomic, retain) NSMutableArray* transitions;
@property (nonatomic, retain) NSString* stateName;
@property (nonatomic) SEL selector;

-(id) initWithStateName:(NSString*)stateName;
-(StateInfo*) executeTransition:(id)anObject;
-(BOOL) canExecuteTransition:(id)anObject;
-(void) registerNextState:(StateInfo*)nextState withCondition:(NSString*)condition;
@end

//--transition to next state if predicate is true
@interface Transition : NSObject
{
	NSString* _condition;
	StateInfo* _nextState;
}
@property (nonatomic,retain) NSString* condition;
@property (nonatomic, retain) StateInfo* nextState;

-(id)initWithCondition:(NSString*)condition andState:(StateInfo*)state;
-(StateInfo*)execute:(id)anObject;
@end

@interface StateMachine : NSObject {
	NSMutableArray* _states;
	StateInfo* _currentState;
}

@property (nonatomic, assign) StateInfo* currentState;
@property (nonatomic, retain) NSMutableArray* states;

-(id)initWithInitialState:(StateInfo*)state;
-(void) registerState:(StateInfo*)state;
-(StateInfo*) nextState:(id)anObject;
-(void) registerInitialState:(StateInfo*)state;
-(BOOL) canTransition:(id)anObject;
-(BOOL) isCurrentState:(NSString*)stateName;
@end


