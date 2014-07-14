//
//  UIColor+UIColor_LighterDarker.h
//  humans
//
//  Created by Julian Bleecker on 6/24/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UIColor_LighterDarker)
- (UIColor *)lighterColor;
- (UIColor *)lighterColorRemoveSaturation:(CGFloat)removeS
                              resultAlpha:(CGFloat)alpha;

@end
