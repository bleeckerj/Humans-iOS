//
//  HuSimpleViewController.m
//  humans
//
//  Created by Julian Bleecker on 6/21/14.
//  Copyright (c) 2014 nearfuturelaboratory. All rights reserved.
//

#import "HuSimpleViewController.h"

@interface HuSimpleViewController ()
@property (nonatomic, strong) Class viewClass;
@end

@implementation HuSimpleViewController

- (id)initWithTitle:(NSString *)title viewClass:(Class)viewClass {
    self = [super init];
    if (!self) return nil;
    
    self.title = title;
    self.viewClass = viewClass;
    
    return self;
}

- (id)initWithView:(UIView*)aView
{
    self = [super init];
    if (!self) return nil;
    
    self.view = aView;
    
    return self;
}

- (void)loadView {
    self.view = self.viewClass.new;
    self.view.backgroundColor = [UIColor whiteColor];
}

#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
