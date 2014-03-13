//
//  HuViewForServiceStatus.h
//  Humans
//
//  Created by julian on 1/2/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuServiceStatus.h"
#import <UIColor+FPBrandColor.h>
@interface HuViewForServiceStatus : UIView
//@property (nonatomic, strong) id<HuServiceStatus> status;

- (HuViewForServiceStatus *)initWithFrame:(CGRect)frame forStatus:(id<HuServiceStatus>)mstatus;
+ (HuViewForServiceStatus *)viewForStatus:(id<HuServiceStatus>)mstatus withFrame:(CGRect)frame;
- (void)showOrRefreshPhoto;

@end
