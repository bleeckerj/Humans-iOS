//
//  HuAuthenticateServiceWebViewController.m
//  humans
//
//  Created by Julian Bleecker on 2/9/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuAuthenticateServiceWebViewController.h"
#import <UIView+MCLayout.h>

@interface HuAuthenticateServiceWebViewController ()

@end

@implementation HuAuthenticateServiceWebViewController

UIWebView *webView;
NSURL *authURL;
NSURL *logoutURL;
NSString *serviceName;
HuUserHandler *userHandler;

@synthesize handleWebViewDidFailLoadWithError;
@synthesize handleWebViewDidStartLoad;
@synthesize handleWebViewDidFinishLoad;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id)initWithAuthURL:(NSURL *)aAuthURL logoutURL:(NSURL *)aLogoutURL serviceName:(NSString *)aServiceName
{
    self = [super init];
    if(self) {
        authURL = aAuthURL;
        logoutURL = aLogoutURL;
        serviceName = aServiceName;
        HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        userHandler = [delegate humansAppUser];
                       
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MRProgressOverlayView showOverlayAddedTo:self.view
                                            title:[NSString stringWithFormat:@"Waiting for %@", serviceName]
                                             mode:MRProgressOverlayViewModeIndeterminate animated:YES];

    });
    // give the progress overlay time to show up
    [self performBlock:^{
        
        NSURLRequest* request = [NSURLRequest requestWithURL:authURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
        NSURLRequest *logout = [NSURLRequest requestWithURL:logoutURL];
        NSURLResponse * response = nil;
        NSError * error = nil;
        [NSURLConnection sendSynchronousRequest:logout returningResponse:&response error:&error];
        if(webView == nil) {
            webView = [[UIWebView alloc]init];
        }
        [webView loadRequest:request];
    } afterDelay:0.5];


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    webView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    HuAuthenticateServiceWebViewController *bself = self;

    UIView *settings_bar_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HEADER_SIZE.width, HEADER_SIZE.height)];
    [settings_bar_view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:settings_bar_view];
    
    FUIButton *ex_button = [[FUIButton alloc]initWithFrame:CGRectMake(0, 0, HEADER_SIZE.height, HEADER_SIZE.height)];
    [ex_button setButtonColor:[UIColor whiteColor]];
    [ex_button setImage:[UIImage imageNamed:@"delete-x-22sq"] forState:UIControlStateNormal];
    [ex_button bk_addEventHandler:^(id sender) {
        [bself.navigationController popViewControllerAnimated:YES];
        
    } forControlEvents:UIControlEventTouchUpInside];

    
    [settings_bar_view addSubview:ex_button];
    
    
#pragma mark header setup
    //header

    webView = [[UIWebView alloc]init];
    webView.delegate = self;
    [webView setSize:CGSizeMake(self.view.width, self.view.height - ex_button.height)];
    //[webView mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:self.header];
    [self.view addSubview:webView];

    [webView mc_setRelativePosition:MCViewRelativePositionUnderAlignedLeft toView:ex_button];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(handleWebViewDidFinishLoad) {
        [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
        handleWebViewDidFinishLoad(webView);
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if(handleWebViewDidStartLoad) {
        [MRProgressOverlayView showOverlayAddedTo:self.view title:@"Loading.." mode:MRProgressOverlayViewModeIndeterminate animated:YES];

        handleWebViewDidStartLoad(webView);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if(handleWebViewDidFailLoadWithError) {
        handleWebViewDidFailLoadWithError(webView, error);
    }
}


- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    webView = nil;
}

@end
