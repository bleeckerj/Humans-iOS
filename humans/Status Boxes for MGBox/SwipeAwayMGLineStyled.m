//
//  SwipeAwayMGLineStyled.m
//  Humans
//
//  Created by julian on 11/21/12.
//  Copyright (c) 2012 nearfuturelaboratory. All rights reserved.
//

#import "SwipeAwayMGLineStyled.h"

@implementation SwipeAwayMGLineStyled

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setup {
    [super setup];
    self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
    self.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.borderStyle = MGBorderEtchedTop | MGBorderEtchedBottom;
    self.bottomBorderColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1];
    
    self.leftMargin = 0;
    self.itemPadding = 10;
    self.layer.cornerRadius = 30;
    
    __weak SwipeAwayMGLineStyled *bself = self;
    self.onTap =  ^{
        
        // if the line is positioned at 0, it hasn't been slid either left or right,
        // so let's slide it to reveal the action buttons
        if (bself.x == 0) {
            [UIView animateWithDuration:0.2 animations:^{
                bself.x = -260;
                
            }];
            
            // the line must be slid, so let's slide it back to zero
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                bself.x = 0;
            }];
        }
    };
    
    self.onSwipe = ^{
        
        // if the line is positioned at 0, it hasn't been slid either left or right,
        // so let's slide it to reveal the delete button
        if (bself.x == 0) {
            
            // change the swiper's accepted direction,
            // to allow swiping the line back to its original position
            bself.swiper.direction = UISwipeGestureRecognizerDirectionLeft;
            [UIView animateWithDuration:0.2 animations:^{
                bself.x = 60;
            }];
            
        } else {
            
            // change the swiper's accepted direction,
            // to allow it to be swiped to reveal delete again
            bself.swiper.direction = UISwipeGestureRecognizerDirectionRight;
            [UIView animateWithDuration:0.2 animations:^{
                bself.x = 0;
            }];
        }
    };

    
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
