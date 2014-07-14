//
//  HuSimpleViewController.h
//  humans
//
//  Created by Julian Bleecker on 6/21/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HuSimpleViewController : UIViewController
- (id)initWithTitle:(NSString *)title viewClass:(Class)viewClass;
- (id)initWithView:(UIView*)aView;

@end
