//
//  HuScrollViewHeader.m
//  Humans
//
//  Created by julian on 12/28/12.
//  Copyright (c) 2012 nearfuturelaboratory. All rights reserved.
//

#import "HuHeaderForServiceStatusView.h"
#import "HuFriend.h"
#import "UILabel+withDate.h"
#import <AFNetworking/AFNetworking.h>
#import <UIView+FLKAutoLayout.h>
#import "UIImage+ResizeToFit.h"
//#import "HuInstagramStatus.h"

@implementation HuHeaderForServiceStatusView
{
    UIImageView *serviceIconView;
    UIImageView *profileImageView;
    UILabel *usernameLabel;
    UILabel *dateLabel;
    //id<HuServiceStatus>status;
}

@synthesize username;
@synthesize serviceIcon;
@synthesize profileImage;
@synthesize statusDate;
@synthesize status;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self setup];
    }
    return self;
}


// call after setting all the properties and crap
- (void)layoutSubviews
{
    [super layoutSubviews];
    if(self.status) {
        // UIColor *bg = [self.status serviceSolidColor];
        self.backgroundColor = [self.status serviceSolidColor];//[serviceUser serviceSolidColor];
        
        
        self.serviceIcon = [UIImage imageNamed:[self.status tinyMonochromeServiceImageBadgeName]];
        
        if([self.status userProfileImageURL]) {
            UIImageView *profile_image_view = [[UIImageView alloc]init];
            LOG_GENERAL(0, @"profile image url %@", [self.status userProfileImageURL]);
            NSAssert([self.status userProfileImageURL] != nil, @"Why is userProfileImageURL nil for %@", status);
            
            NSURLRequest *req = [[NSURLRequest alloc]initWithURL:[self.status userProfileImageURL]];
            [profile_image_view setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"angry_unicorn_tiny.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                self.profileImage = image;
                [profileImageView layoutSubviews];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                //
                LOG_ERROR(0, @"Wasn't able to load the profile image %@", error);
                self.profileImage = [UIImage imageNamed:@"angry_unicorn_tiny.png"];
            }];
            
            //self.profileImage =   //[status userProfileImageURL];
            //self.profileImage = [UIImage imageNamed:@"angry_unicorn_tiny.png"];
            LOG_GENERAL(2, @"Service User In Header is %@ %@", [self.status serviceUsername], status);
            self.username = [self.status serviceUsername];//[serviceUser username];
            self.statusDate = [status dateForSorting];
        } else {
            self.profileImage = [UIImage imageNamed:@"angry_unicorn_tiny.png"];
        }
        if(profileImageView == nil) {
            profileImageView = [[UIImageView alloc]initWithImage:profileImage];
           // [profileImageView constrainWidth:@"100" height:@"100"];
            
            profileImageView.contentMode = UIViewContentModeScaleAspectFit | UIViewContentModeCenter;
            [self addSubview:profileImageView];
        }
        if(serviceIconView == nil) {
            serviceIconView = [[UIImageView alloc]initWithImage:serviceIcon];
            serviceIconView.contentMode = UIViewContentModeScaleAspectFit | UIViewContentModeLeft;
            //serviceIconView.backgroundColor = [UIColor greenColor];
            [self addSubview:serviceIconView];
            
        }
        
        if(usernameLabel == nil) {
            usernameLabel = [[UILabel alloc]init];
            [usernameLabel setFont:HEADER_FONT_LARGE];
            [usernameLabel setTextColor:[UIColor whiteColor]];
            [usernameLabel setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:usernameLabel];
        }
        // set the name
        [usernameLabel setText:[NSString stringWithFormat:@"@%@", [self username]]];
        
        
//        CGSize label_size = [usernameLabel.text boundingRectWithSize:(CGSizeMake(ceil(0.5*self.frame.size.width), HEADER_HEIGHT)) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size;
        
//        usernameLabel.frame = CGRectMake(0, 0,label_size.width, HEADER_HEIGHT);
//        usernameLabel.center = (CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)));
        usernameLabel.backgroundColor = [UIColor clearColor];
        
        usernameLabel.numberOfLines = 1;
        usernameLabel.minimumScaleFactor = .8;
        usernameLabel.adjustsFontSizeToFitWidth = YES;
        [usernameLabel alignCenterYWithView:self predicate:nil];
        [usernameLabel alignCenterXWithView:self predicate:nil];
        
        [profileImageView setImage:[self.profileImage resizedImageToSize:(CGSizeMake(self.frame.size.height, self.frame.size.height))]];
        //profileImageView.frame = CGRectMake(0, CGRectGetMidY(self.frame), self.frame.size.height,self.frame.size.height);
        
        [profileImageView alignTopEdgeWithView:self predicate:nil];
        //[profileImageView setCenter:(CGPointMake(profileImageView.center.x, CGRectGetMidY(usernameLabel.frame)))];
        
        [serviceIconView setImage:self.serviceIcon];
        [serviceIconView alignCenterYWithView:self predicate:nil];
        [serviceIconView constrainLeadingSpaceToView:profileImageView predicate:@"5"];
//        serviceIconView.frame = CGRectMake(CGRectGetMinX(usernameLabel.frame)-CGImageGetWidth([serviceIcon CGImage]), CGRectGetMinY(usernameLabel.frame), CGImageGetWidth([serviceIcon CGImage]), CGImageGetHeight([serviceIcon CGImage]));
//        [serviceIconView setCenter:(CGPointMake(serviceIconView.center.x-ceil(CGImageGetWidth([serviceIcon CGImage])/3), CGRectGetMidY(self.frame)))];
//        
        if(dateLabel == nil) {
            //dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, CGRectGetMinY(usernameLabel.frame), 320-200-8, HEADER_HEIGHT)];
            dateLabel = [[UILabel alloc]init];
            [self addSubview:dateLabel];
        }
        
        LOG_DEBUG(0, @"statusText=%@ serviceUsername=%@ dateForSorting=%@ created=(%@)", [status statusText], [status serviceUsername], [status dateForSorting], [status created]);
        NSAssert([status dateForSorting] != nil, @"Why is status dateForSorting nil for %@", status);
        [dateLabel setDateToShow:[status dateForSorting]];
        [dateLabel setTextColor:[UIColor whiteColor]];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
        [dateLabel setFont:INFO_FONT_MEDIUM];
        [dateLabel setTextAlignment:NSTextAlignmentRight];
        [dateLabel setNumberOfLines:1];
        [dateLabel alignCenterYWithView:self predicate:nil];
        [dateLabel alignTrailingEdgeWithView:self predicate:@"-5"];

        [usernameLabel performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
        [dateLabel performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
        
        //    UIPanGestureRecognizer *reco = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAway:)];
        //    //reco.delegate = self;
        //    [self setUserInteractionEnabled:YES];
        //    [self addGestureRecognizer:reco];
        
    }
}
//-(void)swipeAway:(id)gesture
//{
//    LOG_UI(0, @"Swipe Away from %@", gesture);
//}

//id<HuSocialServiceUser>lastServiceUser;

-(void)setStatus:(id<HuServiceStatus>)mstatus
{
    status = mstatus;
    
    [self layoutSubviews];
}

#warning this method is so fucked up. this sets the new views in the header..then it calls layoutSubviews which does it all again. WTF?
-(void)transitionTo:(id<HuServiceStatus>)newStatus
{
    LOG_UI(0, @"Transition To: %@", [newStatus serviceUsername]);
    //    if([status isEqual:newStatus]) {
    //        return;
    //    } else {
    //        status = newStatus;
    //    }
    //    id<HuSocialServiceUser>serviceUser;
    //
    //    // track what the last serviceUser was so we don't do animations if we're showing
    //    // status from the same service (ie animating a change in the service profile image or service icon
    //    if([newStatus serviceUser] != nil) {
    //        if(lastServiceUser == nil) {
    //            lastServiceUser = [newStatus serviceUser];
    //        }
    //        serviceUser = [newStatus serviceUser];
    //        if([newStatus serviceUser] != lastServiceUser) {
    //            lastServiceUser = serviceUser;
    //        }
    //    } else {
    //        // no good..
    //        LOG_ERROR(1, @"WTF: Service User is nil for %@", newStatus);
    //        [serviceIconView setImage:[UIImage imageNamed:MISSING_PROFILE_IMAGE_NAME]];
    //        [usernameLabel setText:@"angryunicorn"];
    //        [profileImageView setImage:[UIImage imageNamed:MISSING_PROFILE_IMAGE_NAME]];
    //        [dateLabel setDateToShow:[newStatus dateForSorting]];
    //    }
    //
    //    [self layoutSubviews];
    //
}

- (void)animateSomething
{
    [UIView animateWithDuration:1.0 animations:^{
        [dateLabel setBackgroundColor:[UIColor lightGrayColor]];
    } completion:^(BOOL finished) {
        [dateLabel setBackgroundColor:[UIColor clearColor]];
    }];
}

- (NSString *)description
{
    NSString *result;
    result = [NSString stringWithFormat:@"%@ with status[%@]", [super description], status];
    return result;
}

//- (void)animateDate
//{
//    NSString *stringDayFromDate = [formatter_2 stringFromDate:dateToShow];
//    //NSDate *hCurrentStatusItemDate = [self dateToShow];
//    NSString *stringTimeAgo = [date fdateToStringInterval:self.statusDate];
//
//    [UIView animateWithDuration:1 animations:^{
//        [self setAlpha:0.75];
//    } completion:^(BOOL finished) {
//
//        [UIView animateWithDuration:2 animations:^{
//            [self setText:stringDayFromDate];
//            [self setAlpha:1.0];
//        } completion:^(BOOL finished) {
//            [self setText:stringTimeAgo];
//            [self setAlpha:1.0];
//
//        }];
//    }];
//}


//-(void)setProfileImage:(UIImage *)m_profileImage
//{
//    [profileImageView setImage:m_profileImage];
//}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
