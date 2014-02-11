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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSURLRequest* request = [NSURLRequest requestWithURL:authURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    NSURLRequest *logout = [NSURLRequest requestWithURL:logoutURL];
    NSURLResponse * response = nil;
    NSError * error = nil;
    [NSURLConnection sendSynchronousRequest:logout returningResponse:&response error:&error];
    if(webView == nil) {
            webView = [[UIWebView alloc]init];
    }
    [webView loadRequest:request];
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
    
    UIImage *small_exbox_img = [UIImage imageNamed:@"delete-x-22sq"];

    MGLine *ex_ = [MGLine lineWithLeft:small_exbox_img right:nil size:[small_exbox_img size]];
    ex_.onTap = ^{
        LOG_UI(0, @"Tapped Ex Box");
        NSArray *viewControllers = self.navigationController.viewControllers;
        UIViewController *rootViewController = [viewControllers objectAtIndex:viewControllers.count - 2];
        [rootViewController.view setNeedsLayout];
        [bself.navigationController popToRootViewControllerAnimated:YES];
    };

    
#pragma mark header setup
    //header
    self.header = [MGLineStyled lineWithLeft:ex_ right:nil size:(CGSize){self.view.width,HEADER_HEIGHT}];
    [self.header setMiddleFont:HEADER_FONT];
    [self.header setMiddleTextColor:[UIColor darkGrayColor]];
    NSString *header_text = [NSString stringWithFormat:@"Connect to %@", serviceName];
    [self.header setMiddleItems:[NSMutableArray arrayWithObject:header_text]];
    [self.header setMiddleItemsAlignment:NSTextAlignmentCenter];
    self.header.sidePrecedence = MGSidePrecedenceMiddle;
    self.header.padding = UIEdgeInsetsMake(4, 8, 4, 8);
    self.header.fixedPosition = (CGPoint){0,0};
    self.header.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    self.header.zIndex = 1;
    self.header.layer.cornerRadius = 0;
    self.header.layer.shadowOffset = CGSizeZero;
    [self.header setFrame:(CGRectMake(0, 0, self.view.width, HEADER_HEIGHT))];
    self.header.onTap = ^{
        LOG_UI(0, @"Tapped Header");
        //nextState++;
    };
    // add it to the view then lay it all out
    [self.view addSubview:self.header];
    [self.header layout];

    webView = [[UIWebView alloc]init];
    webView.delegate = self;
    [webView setSize:CGSizeMake(self.view.width, self.view.height - self.header.height)];
    [webView mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:self.header];
    [self.view addSubview:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(handleWebViewDidFinishLoad) {
        handleWebViewDidFinishLoad(webView);
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if(handleWebViewDidStartLoad) {
        handleWebViewDidStartLoad(webView);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if(handleWebViewDidFailLoadWithError) {
        handleWebViewDidFailLoadWithError(webView, error);
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    webView = nil;
}

@end
