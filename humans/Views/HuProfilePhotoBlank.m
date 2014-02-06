//
//  HuProfilePhotoBlank.m
//  Humans
//
//  Created by julian on 12/9/12.
//  Copyright (c) 2012 nearfuturelaboratory. All rights reserved.
//

#import "HuProfilePhotoBlank.h"

@implementation HuProfilePhotoBlank

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+(HuProfilePhotoBlank *)boxWithSize:(CGSize)aSize
{
    HuProfilePhotoBlank *box = [super boxWithSize:aSize];
    
    UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blank-for-user-profile-image"]];
    [box addSubview:iv];

    
    return box;
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
