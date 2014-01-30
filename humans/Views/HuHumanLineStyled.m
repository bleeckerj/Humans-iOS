//
//  HuHumanLineStyled.m
//
//
//  Created by julian on 1/29/14.
//
//

#import "HuHumanLineStyled.h"

@interface HuHumanLineStyled ()
{
    HuUserHandler *userHandler;
    
}
@end

@implementation HuHumanLineStyled

@synthesize human;

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (id)init
{
    if(self = [super init]) {
        //[self commonInit];
    }
    return self;
}

+ (id)lineWithLeft:(NSObject *)left right:(NSObject *)right size:(CGSize)size
{
    return [super lineWithLeft:left right:right size:size];
}

+ (id)lineWithLeft:(id)left multilineRight:(NSString *)right width:(CGFloat)width
         minHeight:(CGFloat)height
{
    return [super lineWithLeft:left multilineRight:right width:width minHeight:height];
}

- (void)setup
{
    [super setup];
    self.count = [[NSNumber alloc]initWithInt:0];
}

- (void)setUserHandler:(HuUserHandler *)aUserHandler
{
    userHandler = aUserHandler;
}

- (void)setHuman:(HuHuman *)aHuman
{
    human = aHuman;
    
    NSMutableArray *a = [[NSMutableArray alloc]initWithArray:@[[self.human name]]];
    [self setMiddleItems:a];
    //[self refreshCounts];
}

- (void)refreshCounts
{
    __block HuHumanLineStyled *bself = self;
    
    [userHandler getStatusCountForHuman:self.human withCompletionHandler:^(id data, BOOL success, NSError *error) {
        //
        if(success) {
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            bself.count = [f numberFromString:[data description]];
            NSString *str_count = [bself.count stringValue];
            NSMutableArray *count = [[NSMutableArray alloc]initWithArray:@[str_count]];
            [bself setRightItems:count];

            UIFont *font = [UIFont fontWithName:@"Creampuff" size:10];
            [bself setRightFont:font];
            //[human_mgline setRightFont:font];
            LOG_UI(0, @"Showing count of %@ for %@", bself.count, [human name]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [bself layout];
            });
        } else {
            LOG_UI(0, @"Couldn't get a count for %@", bself.human.name);
            bself.count = [[NSNumber alloc]initWithInt:65535];
            [bself layout];
        }
        
    }];
    
}

- (HuHuman *)human
{
    return human;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
