//
//  HuHumanStatusScrollView.h
//  humans
//
//  Created by Julian Bleecker on 6/21/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
@interface HuHumanStatusScrollView : UIView

- (void)configureWithStatusItems:(NSArray *)statusItems withParentViewController:(UIViewController*)parent;

@end
