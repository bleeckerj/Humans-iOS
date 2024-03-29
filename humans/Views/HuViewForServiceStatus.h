//
//  HuViewForServiceStatus.h
//  Humans
//
//  Created by julian on 1/2/13.
//  Copyright (c) 2013 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defines.h"
#import <TTTAttributedLabel.h>
#import "HuServiceStatus.h"
#import <ObjectiveSugar.h>
#import <MZFormSheetController.h>

@class HuTwitterStatus;
//@class HuServiceStatus;


@protocol HuViewControllerForStatusDelegate <NSObject>

@required
- (void)popWebViewFor:(NSURL *)url over:(UIView *)view;


@end

@interface HuViewForServiceStatus : UIView <TTTAttributedLabelDelegate>
@property (nonatomic, strong) id<HuServiceStatus> status;
@property (nonatomic, copy) Handler onTapBackButton;


//- (id)initWithStatus:(HuTwitterStatus *)mStatus;
- (HuViewForServiceStatus *)initWithFrame:(CGRect)frame forStatus:(id<HuServiceStatus>)mstatus with:(UIViewController *)mparent;
//+ (HuViewForServiceStatus *)viewForStatus:(id<HuServiceStatus>)mstatus withFrame:(CGRect)frame;
- (void)showOrRefreshPhoto;
- (UIView *)headerForServiceStatus:(id<HuServiceStatus>)mStatus;

#pragma mark TTTAttributedLabelDelegate method
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url;


@end
