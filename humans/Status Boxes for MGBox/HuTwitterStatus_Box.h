//
//  TwitterStatus_Box.h
//  Humans
//
//  Created by Julian Bleecker on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGBox.h"
#import "HuTwitterStatus.h"
#import "MGLineStyled.h"
#import "MGLine.h"
#import "MGTableBoxStyled.h"
#import "SwipeAwayMGLineStyled.h"
#import "UIImage+Resize.h"
#import "defines.h"

@interface HuTwitterStatus_Box : MGTableBoxStyled

@property (nonatomic, retain) HuTwitterStatus *status;

- (id)initWithTwitterStatus:(HuTwitterStatus *)_status;
- (void)buildContentBoxes;
- (void)setStatus:(HuTwitterStatus *)_status;
@end
