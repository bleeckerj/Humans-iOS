//
//  HuScrollViewHeader.h
//  Humans
//
//  Created by julian on 12/28/12.
//  Copyright (c) 2012 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defines.h"
#import "HuServiceStatus.h"

@interface HuHeaderForServiceStatusView : UIView

@property (nonatomic, copy) NSString *username;
@property (nonatomic, strong) UIImage *serviceIcon;
@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic, strong) NSDate *statusDate;
@property (nonatomic, retain) id<HuServiceStatus>status;

- (void)animateSomething;
-(void)transitionTo:(id<HuServiceStatus>)newStatus;
//-(void)setup;
@end
