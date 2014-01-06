//
//  HuViewForServiceStatus.h
//  Humans
//
//  Created by julian on 1/2/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuServiceStatus.h"

@interface HuViewForServiceStatus : UIView

- (UIView *)initWithFrame:(CGRect)frame forStatus:(id<HuServiceStatus>)mstatus;
//+ (UIView *)viewForStatus:(id<HuServiceStatus>)mstatus;

@end
