//
//  UIColor+UIColor_LighterDarker.m
//  humans
//
//  Created by Julian Bleecker on 6/24/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "UIColor+UIColor_LighterDarker.h"

@implementation UIColor (UIColor_LighterDarker)
- (UIColor *)lighterColor {
    CGFloat h,s,b,a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
        return [UIColor colorWithHue:h
                          saturation:MAX(s - 0.3, 0.0)
                          brightness:b /*MIN(b * 1.3, 1.0)*/
                               alpha:a];
    }
    return nil;
}

- (UIColor *)lighterColorRemoveSaturation:(CGFloat)removeS
                              resultAlpha:(CGFloat)alpha {
    CGFloat h,s,b,a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
        return [UIColor colorWithHue:h
                          saturation:MAX(s - removeS, 0.0)
                          brightness:b
                               alpha:alpha == -1? a:alpha];
    }
    return nil;
}


@end
