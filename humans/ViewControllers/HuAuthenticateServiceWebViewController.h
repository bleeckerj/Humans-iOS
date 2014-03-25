//
//  HuAuthenticateServiceWebViewController.h
//  humans
//
//  Created by Julian Bleecker on 2/9/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defines.h"
#import "LoggerClient.h"
#import "HuAppDelegate.h"
#import "HuUserHandler.h"
#import "UIImage+Resize.h"
#import "MGBox.h"
#import <MRProgress.h>
#import "Flurry.h"
#import <FUIButton.h>
#import <MRProgress.h>

@interface HuAuthenticateServiceWebViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic, retain) MGLineStyled *header;

// handler (service specific) for the web view so we can do the right thing
// depending on how the heterogeneous whacky services reply to authentication
@property (nonatomic, copy) WebViewHandler handleWebViewDidFinishLoad;
@property (nonatomic, copy) WebViewHandler handleWebViewDidStartLoad;
@property (nonatomic, copy) WebViewHandlerWithError handleWebViewDidFailLoadWithError;

- (id)initWithAuthURL:(NSURL *)aAuthURL logoutURL:(NSURL *)aLogoutURL serviceName:(NSString *)aServiceName;

@end
