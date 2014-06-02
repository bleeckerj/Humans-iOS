//
//  HuConnectServicesViewController.m
//  humans
//
//  Created by Julian Bleecker on 2/8/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuConnectServicesViewController.h"
#import <UIView+MCLayout.h>
@class ServiceLine;
@interface ServiceLine : MGLine
{
}
@end

@implementation ServiceLine

HuAuthenticateServiceWebViewController *authenticateViewController;
HuUserHandler *userHandler;

+ (ServiceLine *)lineWithImage:(UIImage *)aImage serviceName:(NSString *)aServiceName size:(CGSize)aSize
{
    ServiceLine *result = [super lineWithSize:aSize];
    [result commonInit];
    result.leftItems = [NSMutableArray arrayWithObjects:aImage, @"  ", aServiceName, nil];
    return result;
}

- (void)commonInit
{
    UIView *bottomBorderView = [[UIView alloc]initWithFrame:(CGRectMake(10, 0, self.width-10, 1))];
    [bottomBorderView setSize:(CGSizeMake(self.width-2*10, 1))];
    
    [bottomBorderView setBackgroundColor:[UIColor lightGrayColor]];
    self.bottomBorderColor = [UIColor orangeColor];
    [self.bottomBorder addSubview:bottomBorderView];
    [self.bottomBorder setBackgroundColor:self.backgroundColor];
    
    [self setPadding:UIEdgeInsetsMake(5, 20, 5, 20)];
    [self setFont:HEADER_FONT_LARGE];
    
    HuAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    userHandler = [delegate humansAppUser];
}


@end

@interface HuConnectServicesViewController ()
{
    BOOL didSomething;
}
@end

@implementation HuConnectServicesViewController
MGLine *check_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [userHandler getHumansWithCompletionHandler:^(BOOL success, NSError *error) {
        [super viewWillAppear:animated];
    }];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [userHandler getHumansWithCompletionHandler:^(BOOL success, NSError *error) {
        [super viewWillDisappear:animated];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    didSomething = NO;
    HuConnectServicesViewController *bself = self;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImage *small_exbox_img = [UIImage imageNamed:@"delete-x-22sq"];//resizedImage:(CGSize){22,22}
    
    MGLine *ex_ = [MGLine lineWithLeft:small_exbox_img right:nil size:[small_exbox_img size]];
    ex_.onTap = ^{
        LOG_UI(0, @"Tapped Ex Box");
        [bself.navigationController popViewControllerAnimated:YES];


    };
#pragma mark header setup
    //header
    self.header = [MGLineStyled lineWithLeft:ex_ right:check_ size:(CGSize){self.view.width,HEADER_HEIGHT}];
    [self.header setMiddleFont:HEADER_FONT];
    [self.header setMiddleTextColor:[UIColor darkGrayColor]];
    [self.header setMiddleItems:[NSMutableArray arrayWithObject:@"Connect Services"]];
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
    
    ServiceLine *twitterLine = [ServiceLine lineWithImage:[UIImage imageNamed:TWITTER_GRAY_IMAGE] serviceName:@"Twitter" size:CGSizeMake(self.view.width, 1.5*HEADER_HEIGHT)];
    
    ServiceLine *instagramLine = [ServiceLine lineWithImage:[UIImage imageNamed:INSTAGRAM_GRAY_IMAGE] serviceName:@"Instagram" size:CGSizeMake(self.view.width, 1.5*HEADER_HEIGHT)];
    
    ServiceLine *flickrLine = [ServiceLine lineWithImage:[UIImage imageNamed:FLICKR_GRAY_IMAGE] serviceName:@"Flickr" size:CGSizeMake(self.view.width, 1.5*HEADER_HEIGHT)];

//    ServiceLine *foursquareLine = [ServiceLine lineWithImage:[UIImage imageNamed:FOURSQUARE_GRAY_IMAGE] serviceName:@"Foursquare" size:CGSizeMake(self.view.width, 1.5*HEADER_HEIGHT)];

    
    [twitterLine mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:self.header];
    [twitterLine layout];
    twitterLine.onTap = ^ {
        [self authWithTwitter];
    };

    
    [instagramLine mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:twitterLine];
    [instagramLine layout];
    instagramLine.onTap = ^{
        [self authWithInstagram];
    };

    
    [flickrLine mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:instagramLine];
    [flickrLine layout];
    flickrLine.onTap = ^ {
        [self authWithFlickr];
    };

    
//    [foursquareLine mc_setRelativePosition:MCViewRelativePositionUnderCentered toView:flickrLine];
//    [foursquareLine layout];
//    foursquareLine.onTap = ^ {
//        [self authWithFoursquare];
//    };

    
    [self.view addSubview:twitterLine];
    [self.view addSubview:instagramLine];
    [self.view addSubview:flickrLine];
//    [self.view addSubview:foursquareLine];
}

- (void)authWithInstagram
{
    
    authenticateViewController = [[HuAuthenticateServiceWebViewController alloc]initWithAuthURL:[userHandler urlForInstagramAuthentication]
                                                                                      logoutURL:[NSURL URLWithString:@"https://instagram.com/accounts/logout/"]
                                                                                    serviceName:@"Instagram"];
    
    [authenticateViewController setHandleWebViewDidFinishLoad:^(UIWebView *webView) {
        didSomething = YES;
        LOG_UI(0, @"webView=%@", webView);
        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
        LOG_UI(0, @"HTML=%@", html);
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        LOG_UI(0, @"json=%@", json);
        LOG_UI(0, @"username=%@", [json objectForKey:@"username"]);

    }];
    
    [authenticateViewController.view setBackgroundColor:[UIColor redColor]];
    
    [self.navigationController pushViewController:authenticateViewController animated:YES];

}

- (void)authWithTwitter
{
    authenticateViewController = [[HuAuthenticateServiceWebViewController alloc]initWithAuthURL:[userHandler urlForTwitterAuthentication]
                                                                                      logoutURL:[NSURL URLWithString:@"https://twitter.com/logout"]
                                                                                    serviceName:@"Twitter"];
    
    [authenticateViewController setHandleWebViewDidFinishLoad:^(UIWebView *webView) {
        didSomething = YES;

        LOG_UI(0, @"webView=%@", webView);
        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
        LOG_UI(0, @"HTML=%@", html);
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        LOG_UI(0, @"json=%@", json);
        LOG_UI(0, @"username=%@", [json objectForKey:@"username"]);
        
    }];
    
    [authenticateViewController.view setBackgroundColor:[UIColor redColor]];
    
    [self.navigationController pushViewController:authenticateViewController animated:YES];

}

- (void)authWithFlickr
{
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        
        if([[cookie domain] rangeOfString:@"flickr"].location != NSNotFound) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            //LOG_UI(0, @" DROP=%@", [cookie domain]);
            
        }
        if([[cookie domain] rangeOfString:@"yahoo"].location != NSNotFound) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            //LOG_UI(0, @" DROP=%@", [cookie domain]);
            
        }

    }

    authenticateViewController = [[HuAuthenticateServiceWebViewController alloc]initWithAuthURL:[userHandler urlForFlickrAuthentication] logoutURL:[NSURL URLWithString:@"http://www.flickr.com/logout.gne"] serviceName:@"Flickr"];
    [authenticateViewController setHandleWebViewDidFinishLoad:^(UIWebView *webView) {
        didSomething = YES;

        LOG_UI(0, @"webView=%@", webView);
        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
        LOG_UI(0, @"HTML=%@", html);
        LOG_UI(0, @"HTML=%@", [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"]);
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        LOG_UI(0, @"json=%@", json);
        LOG_UI(0, @"username=%@", [json objectForKey:@"username"]);
        
    }];
    
    [authenticateViewController.view setBackgroundColor:[UIColor redColor]];
    
    [self.navigationController pushViewController:authenticateViewController animated:YES];
 
}

- (void)authWithFoursquare
{
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {

        if([[cookie domain] rangeOfString:@"foursquare"].location != NSNotFound) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            LOG_UI(0, @" DROP=%@", [cookie domain]);

        }
    }

    
    authenticateViewController = [[HuAuthenticateServiceWebViewController alloc]initWithAuthURL:[userHandler urlForFoursquareAuthentication] logoutURL:[NSURL URLWithString:@"https://foursquare.com/logout"] serviceName:@"Foursquare"];
    [authenticateViewController setHandleWebViewDidFinishLoad:^(UIWebView *webView) {
        didSomething = YES;

        LOG_UI(0, @"webView=%@", webView);
        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
        LOG_UI(0, @"HTML=%@", html);
        LOG_UI(0, @"HTML=%@", [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"]);
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        LOG_UI(0, @"json=%@", json);
        LOG_UI(0, @"username=%@", [json objectForKey:@"username"]);
        
    }];
    
    //[authenticateViewController.view setBackgroundColor:[UIColor yellowColor]];
    
    [self.navigationController pushViewController:authenticateViewController animated:YES];
   
}

#pragma mark UIWebViewDelegate methods
- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    //LOG_UI(0, @"Web view did finish load %@", aWebView);
    NSString *html = [aWebView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
    LOG_UI(0, @"HTML=%@", html);
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    LOG_UI(0, @"json=%@", json);
    LOG_UI(0, @"username=%@", [json objectForKey:@"username"]);
    if(json != nil && ([json objectForKey:@"username"] != nil || [json objectForKey:@"screen_name"] != nil)) {
        MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:aWebView animated:YES];
        progressView.mode = MRProgressOverlayViewModeCheckmark;
        progressView.titleLabelText = @"Good to go.";
        [self performBlock:^{
            //
            [progressView dismiss:YES];
        } afterDelay:3];
        
        [self performBlock:^{
            //
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } afterDelay:4];
        
    }
    if(json != nil && [json objectForKey:@"result"] != nil && [[json objectForKey:@"result"] caseInsensitiveCompare:@"error"] == NSOrderedSame )
    {
        NSString *msg;
        
        msg = [NSString stringWithFormat:@"%@", [json objectForKey:@"message"]];
        
        MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:aWebView animated:YES];
        progressView.mode = MRProgressOverlayViewModeCross;
        progressView.titleLabelText = [NSString stringWithFormat:@"There was a problem authenticating. %@", msg];
        NSDictionary *dimensions = @{@"key": CLUSTERED_UUID,@"msg": msg};
        LELog *log = [LELog sharedInstance];
        [log log:dimensions];
        [self performBlock:^{
            [progressView dismiss:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } afterDelay:5.0];
        
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
}

@end

