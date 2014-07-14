//
//  HuHumanStatusScrollView.m
//  humans
//
//  Created by Julian Bleecker on 6/21/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuHumanStatusScrollView.h"
#import "HuViewForServiceStatus.h"

@interface HuHumanStatusScrollView ()
@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) UIViewController *parentViewController;
@end


@implementation HuHumanStatusScrollView
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    return self;
}


- (void)configureWithStatusItems:(NSArray *)statusItems withParentViewController:(UIViewController*)parent {
    [self setParentViewController:parent];
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor = [UIColor grayColor];
    [self addSubview:scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    // We create a dummy contentView that will hold everything (necessary to use scrollRectToVisible later)
    UIView* contentView = UIView.new;
    [self.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView.mas_width);
    }];
    
    __block UIView *lastView;
    __block CGFloat height = 100;
    __block CGFloat i_height = height;

    
#pragma mark -- set up the HuViewForServiceStatus based on the status
    [statusItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        HuViewForServiceStatus *result = HuViewForServiceStatus.new;
        result = [[HuViewForServiceStatus alloc]initWithFrame:CGRectMake(0, 0, 100, 100) forStatus:[statusItems objectAtIndex:idx] with:[self appName_viewController]];
        [result setOnTapBackButton:^(){
            LOG_UI(0, @"On Tap");
//            [carousel scrollToItemAtIndex:0 duration:0.5];
            [self performBlock:^{
                [[[self parentViewController]navigationController] popViewControllerAnimated:YES];
            } afterDelay:0.6];
            
        }];
        if(idx < 10) {
            [result showOrRefreshPhoto];
        }
        
        [contentView addSubview:result];

        [result mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView ? lastView.mas_bottom : @0);
            make.left.equalTo(@0);
            make.width.equalTo(contentView.mas_width);
            //make.height.equalTo(@(i_height));
        }];
        LOG_UI(0, @"%f", result.frame.size.height);
        height += result.frame.size.height + i_height;
        lastView = result;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [result setNeedsDisplay];
            
        });
        
    }];

    
    
    
    
//    for (int i = 0; i < 10; i++) {
//        UIView *view = UIView.new;
//        view.backgroundColor = [self randomColor];
//
//        
//        // Tap
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
//        [view addGestureRecognizer:singleTap];
//        i_height = 50+(int)(arc4random_uniform(100)+1);
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(lastView ? lastView.mas_bottom : @0);
//            make.left.equalTo(@0);
//            make.width.equalTo(contentView.mas_width);
//            make.height.equalTo(@(i_height));
//        }];
//        
//        height += i_height;
//        lastView = view;
//    }
    
    // dummy view, which determines the size of the contentView size and therefore the scrollView contentSize
    UIView *sizingView = UIView.new;
    [scrollView addSubview:sizingView];
    [sizingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom);
        make.bottom.equalTo(contentView.mas_bottom);
    }];
    
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)singleTap:(UITapGestureRecognizer*)sender {
    [sender.view setAlpha:sender.view.alpha / 1.20]; // To see something happen on screen when you tap :O
    [self.scrollView scrollRectToVisible:sender.view.frame animated:YES];
};

- (UIViewController *)appName_viewController {
    /// Finds the view's view controller.
    
    // Take the view controller class object here and avoid sending the same message iteratively unnecessarily.
    Class vcc = [UIViewController class];
    
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: vcc])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
