//
//  UIColor+UIColor_LighterDarker.m
//  MGBox Demo
//
//  Created by julian on 11/20/12.
//  Copyright (c) 2012 Big Paua. All rights reserved.
//

#import "UIColor+UIColor_LighterDarker.h"

@implementation UIColor (UIColor_LighterDarker)

- (UIColor *)lighterColor
{
    float h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:MIN(b * 1.3, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColor
{
    float h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.75
                               alpha:a];
    return nil;
}

@end
