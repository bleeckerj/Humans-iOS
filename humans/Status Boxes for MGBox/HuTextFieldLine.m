//
//  HuTextFieldLine.m
//  Humans
//
//  Created by julian on 12/6/12.
//  Copyright (c) 2012 nearfuturelaboratory. All rights reserved.
//

#import "HuTextFieldLine.h"

@implementation HuTextFieldLine
@class MGLine;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)wrapRawContents:(NSMutableArray *)items
              placement:(MGItemPlacement)placement {

//    SEL s = @selector(wrapRawContents:placement:);
//    [super performSelector:s withObject:items withObject:nil];
    for (int i = 0; i < items.count; i++) {
        id item = items[i];
        
        if([item isKindOfClass:UITextField.class]) {
            items[i] = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"angry_unicorn"]];
        } else {
            //
        }
    }
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
