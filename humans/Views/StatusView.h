//
//  StatusView.h
//  ScrollViewDynamicContentViewSize
//
//  Created by Julian Bleecker on 6/28/14.
//  Copyright (c) 2014 Julian Bleecker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defines.h"

@class ColorPalette;
@class HuTwitterStatus;
@class InstagramStatus;
@class HuFlickrStatus;
//@protocol HuViewControllerForStatusDelegate <NSObject>
//
//@required
//- (void)popWebViewFor:(NSURL *)url over:(UIView *)view;
//
//@end

@interface StatusView : UIView

@property (strong, nonatomic) NSString *name, *location, *statusText;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSDate *date;
@property BOOL imageOnTop;
@property (strong, nonatomic) UIColor *nameViewColor;
@property (strong, nonatomic) UIImageView *userIconImageView;
@property (nonatomic, copy) Handler onTapBackButton;
@property (nonatomic, copy) Handler onDoubleTap;
@property (nonatomic, copy) Handler onTapLikeButton;
@property (nonatomic, copy) CompletionHandlerWithData handleRepliesData;

//@property (strong, nonatomic) ColorPalette *palette;

//- (void)setup;
- (void)applyColorPalette:(ColorPalette*)palette;
//- (void)setupTwitter:(BOOL)withImage;

// this is entirely for testing and debugging without having to run the entire larger app, just to do
// visual ux fixes and design prototyping, etc.
//- (void)setupTwitterWithStatus:(NSString *)statusText hasImage:(BOOL)hasImage inReplyTo:(NSArray *)replies;
- (void)setCLLocation:(CLLocation *)_location;
- (void)setTwitterReplies:(NSArray *)replies;

- (void)setupTwitterWithStatus:(HuTwitterStatus *)status fromViewController:(UIViewController<HuViewControllerForStatusDelegate> *)mparent;
- (void)setupInstagramWithStatus:(InstagramStatus*)status fromViewController:(UIViewController<HuViewControllerForStatusDelegate> *)mparent;
- (void)setupFlickrWithStatus:(HuFlickrStatus *)status fromViewController:(UIViewController<HuViewControllerForStatusDelegate> *)mparent;

- (void)scrollToStatusTop;
- (void)showOrRefreshPhoto;
- (void)applySeaAndSkyPalette;
- (void)applyGreyPalette;
- (void)applyMelonBallSurprise;

- (void)resetupView;
- (void)animateDate;

@end
