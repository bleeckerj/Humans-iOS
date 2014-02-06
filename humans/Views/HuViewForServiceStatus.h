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

- (HuViewForServiceStatus *)initWithFrame:(CGRect)frame forStatus:(id<HuServiceStatus>)mstatus;
+ (HuViewForServiceStatus *)viewForStatus:(id<HuServiceStatus>)mstatus withFrame:(CGRect)frame;
- (void)showOrRefreshPhoto;

@end
