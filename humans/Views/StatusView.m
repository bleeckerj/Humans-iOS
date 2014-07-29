//
//  StatusView.m
//  ScrollViewDynamicContentViewSize
//
//  Created by Julian Bleecker on 6/28/14.
//  Copyright (c) 2014 Julian Bleecker. All rights reserved.
//

#import "StatusView.h"
#import "UIColor+Expanded.h"
#import <UIColor+FPBrandColor.h>
#import "UIColor+UIColor_LighterDarker.h"
#import "UILabel+withDate.h"
#import <FXLabel.h>
#import <TTTAttributedLabel.h>
#import <Masonry.h>
#import "ColorPalette.h"
#import <UIImageView+AFNetworking.h>
#import <IDMPhotoBrowser.h>
#import <UIImageView+WebCache.h>
#import "UIImage+Resize.h"
#import "UIImage+ResizeToFit.h"
#import <BlocksKit+UIKit.h>


#import "HuTwitterStatus.h"
#import "HuTwitterPlace.h"
#import "HuTwitterStatusMedia.h"
#import "HuTwitterStatusEntities.h"
#import "HuTwitterServiceManager.h"
#import "HuTwitterUser.h"

#import "InstagramStatus.h"
#import "HuInstagramHTTPSessionManager.h"

#import "HuFlickrStatus.h"

@interface StatusView () <TTTAttributedLabelDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *nameView, *dateView, *locView, *statusContentView, *actionView;
@property (strong, nonatomic) UILabel *nameLabel, *dateLabel, *locLabel;
@property NSTextAlignment nameLabelAlignment, dateLabelAlignment, locLabelAlignment;

@property (strong, nonatomic) NSNumber *nameViewHeight, *dateViewHeight, *locViewHeight;
@property (strong, nonatomic) TTTAttributedLabel *statusContentLabel;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIColor *replyUserLabelColor, *replyUserLabelTextColor, *replyLabelTextColor, *replyLabelColor, *replyViewColor;
@property (strong, nonatomic) UIFont *replyLabelFont, *nameViewFont, *replyUserLabelFont;
@property (strong, nonatomic) NSNumber *replyViewHeight;

@property (strong, nonatomic) UIView *likeImageView;

@property (nonatomic) BOOL statusContentViewOpen;

@property (nonatomic, strong) ColorPalette *grey, *sea_and_sky, *melon_ball_surprise;
@property (nonatomic, strong) UIViewController<HuViewControllerForStatusDelegate> *parent;
@property (nonatomic, strong) UIView *repliesContainerView;
@property (nonatomic, strong) UIView *contentView, *sizingView;

@end

@implementation StatusView

@synthesize name, date, location;
@synthesize nameLabelAlignment, dateLabelAlignment, locLabelAlignment;
@synthesize nameViewColor;
@synthesize userIconImageView;

@synthesize repliesContainerView, contentView, sizingView;

@synthesize scrollView;
//@synthesize palette;
@synthesize imageOnTop;
@synthesize grey, sea_and_sky, melon_ball_surprise;
@synthesize onTapBackButton;
@synthesize onDoubleTap;
@synthesize onTapLikeButton;
@synthesize handleRepliesData;

//TTTAttributedLabel *statusContentLabel;
UIEdgeInsets padding;
CGFloat height;
BOOL containsViewableMedia;


- (id)init
{
    self = [super init];
    
    if (self) {
        //[self setupTwitter];
        [self commonInit];
        
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        //[self setupTwitter];
        [self commonInit];
        
    }
    
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        //[self setupTwitter];
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    //    ColorPalette *palette = ColorPalette.new;
    sea_and_sky = [ColorPalette seaAndSky];
    grey = [ColorPalette grey];
    melon_ball_surprise = [ColorPalette melonBallSurprise];
    self.nameView = UIView.new;
    self.nameLabel = UILabel.new;
    self.dateView = UIView.new;
    self.dateLabel = UILabel.new;
    self.locView = UIView.new;
    self.locLabel = UILabel.new;
    self.statusContentView = UIView.new;
    self.statusContentLabel = [TTTAttributedLabel new];
    self.userIconImageView = UIImageView.new;
    self.repliesContainerView = UIView.new;
    self.contentView = UIView.new;
    
    [self initReplies];
    [self applyGreyPalette];
    
    UITapGestureRecognizer *actTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(animateDate)];
    [self.dateView addGestureRecognizer:actTap];
}

- (void)applySeaAndSkyPalette
{
    [self applyColorPalette:[ColorPalette seaAndSky]];
    
}

- (void)applyGreyPalette
{
    [self applyColorPalette:[ColorPalette grey]];
    
}

- (void)applyMelonBallSurprise
{
    [self applyColorPalette:[ColorPalette melonBallSurprise]];
    
}

- (void)applyInstaFall
{
    [self applyColorPalette:[ColorPalette instaFall]];
}


- (void)applyColorPalette:(ColorPalette*)palette
{
    self.dateView.backgroundColor = palette.dateViewColor;
    self.dateLabel.textColor = palette.dateViewText;
    self.dateLabel.font = palette.dateViewFont;
    self.dateViewHeight = palette.dateViewHeight;
    self.dateLabelAlignment = palette.dateLabelAlignment;
    
    self.locView.backgroundColor = palette.locViewColor;
    self.locLabel.textColor = palette.locViewText;
    self.locLabel.font = palette.locViewFont;
    self.locViewHeight = palette.locViewHeight;
    self.locLabelAlignment = palette.locLabelAlignment;
    
    self.statusContentView.backgroundColor = palette.statusViewColor;
    self.statusContentLabel.textColor = palette.statusViewTextColor;
    self.statusContentLabel.font = palette.statusViewFont;
    
    self.replyUserLabelColor = palette.replyUserLabelColor;
    self.replyUserLabelFont = palette.replyUserLabelFont;
    self.replyUserLabelTextColor = palette.replyUserLabelTextColor;
    self.replyLabelFont = palette.replyLabelFont;
    self.replyLabelColor = palette.replyLabelColor;
    self.replyLabelTextColor = palette.replyLabelTextColor;
    
    self.nameViewHeight = palette.nameViewHeight;
    self.nameViewColor = palette.nameViewColor;
    self.nameViewFont = palette.nameViewFont;
    self.nameLabelAlignment = palette.nameLabelAlignment;
    
}

- (void)setName:(NSString *)_name
{
    name = _name;
    [self.nameLabel setText:name];
}

- (void)animateDate
{
    [self.dateLabel animateDate];
    //[self scrollToStatusTop];
}

- (void)showOrRefreshPhoto
{
    
}

- (void)scrollToStatusTop
{
    [self.scrollView setContentOffset:CGPointMake(0, self.statusContentLabel.frame.origin.y) animated:YES];
}

- (void)setDate:(NSDate *)_date
{
    date = _date;
    [self.dateLabel setDateToShow:date];
    
    [self.dateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameView.mas_bottom);//self.nameView.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.dateViewHeight);
    }];
    
    //    [self.dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self.locView).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    //    }];
}


- (void)initReplies
{
    [self.contentView addSubview:repliesContainerView];
    
    //[contentView setBackgroundColor:[UIColor yellowColor]];
    //[repliesContainerView setBackgroundColor:[UIColor GoogleBlue]];
    //    [repliesContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        //
    //        make.top.equalTo(@0);
    //        make.left.equalTo(@0);
    //        make.right.equalTo(contentView.mas_right);
    //        make.width.equalTo(contentView.mas_width);
    //        make.bottom.equalTo(@300);
    //    }];
    
}

- (void)setTwitterReplies:(NSArray *)replies
{
    //[self setLocation:@"Wherever in the World"];
    __block UIView *lastReplyView;
//    __block NSString *theUsername = @"I";
    
    if(replies != nil && [replies count] > 0) {
        
        [replies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
//            if(idx == [replies count]-1) {
//                LOG_DEEBUG(0, @"%@", obj);
//            theUsername = [obj objectForKey:@"user"];
//            } else {
            
            //if(idx < [replies count]) {
            UIView *replyView = UIView.new;
            //[replyView setBackgroundColor:self.replyViewColor];
            [self.repliesContainerView addSubview:replyView];
            [self.repliesContainerView setBackgroundColor:self.replyLabelColor];
            
            UILabel *replyUserLabel = UILabel.new;
            [replyUserLabel setFont:self.replyUserLabelFont];
            [replyUserLabel setTextColor:self.replyUserLabelTextColor];
            [replyView addSubview:replyUserLabel];
            
            
            [replyUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.statusContentLabel.mas_left);
                make.right.equalTo(self.statusContentLabel.mas_right);
                make.top.equalTo(@5);
            }];
            
            TTTAttributedLabel *replyLabel = TTTAttributedLabel.new;
            replyLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
            [replyView addSubview:replyLabel];
            [replyLabel setBackgroundColor:self.replyLabelColor];
            
            [replyView mas_makeConstraints:^(MASConstraintMaker *make) {
                if(idx == 0) {
                    make.top.equalTo(@0).priorityHigh();
                } else {
                    make.top.equalTo(lastReplyView.mas_bottom);
                }
                
                make.left.equalTo(@0);
                make.right.equalTo(@0);
                
                make.bottom.equalTo(replyLabel.mas_bottom).with.offset(10);
                //make.height.equalTo(@80);
                
            }];
            
            
            
            [replyUserLabel setTextColor:self.replyUserLabelTextColor];
            [replyUserLabel setFont:self.replyUserLabelFont];
            [replyUserLabel setNumberOfLines:1];
            [replyUserLabel setText:[NSString stringWithFormat:@"%@ said", [obj objectForKey:@"user"]]];
            
            [replyLabel setTextColor:self.replyLabelTextColor];
            //            [replyLabel setTextColor:self.replyLabelTextColor]];
            [replyLabel setFont:self.replyLabelFont];
            [replyLabel setNumberOfLines:0];
            [replyLabel setLineBreakMode:NSLineBreakByCharWrapping];
            [replyLabel setTextAlignment:NSTextAlignmentLeft];
            [replyLabel setContentMode:UIViewContentModeTop];
            /**/
            
            [replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                //make.top.equalTo(replyView.mas_top).with.offset(10);
                make.top.equalTo(replyUserLabel.mas_bottom).with.offset(5);
                make.left.equalTo(self.statusContentLabel.mas_left);
                make.right.equalTo(self.statusContentLabel.mas_right);
                make.height.greaterThanOrEqualTo(@30);
                // make.bottom.equalTo(replyView.mas_bottom);
            }];
            
            UIColor *activeTextColor = [UIColor darkGrayColor];//[[self.statusContentLabel textColor]colorByDarkeningToColor:[UIColor grayColor]];
            
            [replyLabel setLinkAttributes:@{(NSString*)kCTForegroundColorAttributeName : activeTextColor}];
            
            UIColor *replyLabelTextColor = replyLabel.textColor;
            [[UIColor blueColor]complementaryColor];
            UIColor *compColor = [replyLabelTextColor complementaryColor];
            [replyLabel setActiveLinkAttributes:@{(NSString *)kCTForegroundColorAttributeName :compColor}];
            [replyLabel setDelegate:self];
            replyLabel.enabledTextCheckingTypes = (NSTextCheckingTypeLink | NSTextCheckingTypeRegularExpression);
            
            
            [replyLabel setText:[obj objectForKey:@"text"] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                return mutableAttributedString;
            }];
            
            [self highlightMentionsInString:replyLabel.text withLabel:replyLabel withColor:activeTextColor isBold:NO isUnderlined:NO];
            
            lastReplyView = replyView;
            //}
        }];
        
        
        // last one
        
        UILabel *replyUserLabel = UILabel.new;
        [replyUserLabel setTextColor:self.replyUserLabelTextColor];
        //[replyUserLabel setBackgroundColor:self.replyUserLabelFontColor]
        [replyUserLabel setNumberOfLines:1];
        [replyUserLabel setFont:self.replyUserLabelFont];
        [replyUserLabel setText:[NSString stringWithFormat:@"So %@ said", [self name]]];
        
        [repliesContainerView addSubview:replyUserLabel];
        [replyUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.statusContentLabel.mas_left);
            make.right.equalTo(self.statusContentLabel.mas_right);
            make.top.equalTo(lastReplyView.mas_bottom);
            make.height.equalTo(@30);
        }];
        
        //        [repliesContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        //        }];
        
        [repliesContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.width.equalTo(contentView.mas_width);
            make.bottom.equalTo(replyUserLabel.mas_bottom);
        }];
        
        
        lastReplyView = replyUserLabel;
        
    }
    
    
    [self.statusContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(repliesContainerView.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        //make.bottom.equalTo(self.actionView.mas_top).with.offset(10);
        //make.height.equalTo(@(r.size.height));
        make.bottom.equalTo(self.statusContentLabel.mas_bottom).with.offset(120);
        //make.height.equalTo(@500);
    }];
    
    
    
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:.1 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        //
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
    
    
}

- (void)setCLLocation:(CLLocation *)_location
{
    CLGeocoder *reverse_geocoder = [CLGeocoder new];
    
    [reverse_geocoder reverseGeocodeLocation:_location completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error == nil && placemarks != nil && [placemarks count] > 0) {
            
            CLPlacemark *mark = [placemarks objectAtIndex:0];
            NSDictionary *address = [mark addressDictionary];
            LOG_DEEBUG(0, @"%@", placemarks);
            LOG_DEEBUG(0, @"%@", address);
            [self setLocation:[NSString stringWithFormat:@"%@ %@ %@ %@ %@", [mark thoroughfare], [mark subLocality], [mark locality], [mark administrativeArea], [mark ISOcountryCode]]];
            //[self setLocation:[[mark addressDictionary]description]];
        }
    }];

}

- (void)setLocation:(NSString *)_location
{
    
    location = _location;
    
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width-10, MAXFLOAT);
    NSStringDrawingOptions options;
    options = NSStringDrawingTruncatesLastVisibleLine |
    NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    NSDictionary *attr = @{NSFontAttributeName: self.locLabel.font};
    CGRect labelBounds = [location boundingRectWithSize:maximumLabelSize
                                                options:options
                                             attributes:attr
                                                context:nil];
    CGFloat height = labelBounds.size.height;
    //CGFloat width = labelBounds.size.width;
    [self.locLabel setText:location];
    [self.locLabel setNumberOfLines:0];
    [self.locLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    [self.locView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateView.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        if(1.15*height < self.locViewHeight.doubleValue) {
            make.height.equalTo(self.locViewHeight);
        } else {
            make.height.equalTo(@(1.25*height));
        }
    }];
    
    [self.locLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.locView).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    //[self updateConstraints];
}

- (void)doSomething
{
    //[self.nameLabel setText:@"WooWooWoo"];
    UIImage *like = [UIImage imageNamed:@"like_icon.png"];
    self.likeImageView = [[UIImageView alloc]initWithImage:like];
    [self.likeImageView setUserInteractionEnabled:YES];
    [self.actionView addSubview:self.likeImageView ];
    
    UITapGestureRecognizer *actTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actTap:)];
    [self.likeImageView addGestureRecognizer:actTap];
    
    //UIEdgeInsets padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.actionView.mas_height).with.offset(-10);
        make.width.equalTo(self.actionView.mas_height).with.offset(-12);
        make.left.equalTo(@5);
        make.top.equalTo(@5);
        
    }];
    [self setNeedsDisplay];
}

- (void)onTapSomething:(id)sender
{
    if(onTapBackButton) {
        self.onTapBackButton();
    }
}

- (void)resetupView
{
    [self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self commonInit];
    //[self setupTwitter:NO];
    //[self setName:@"Foo"];
}

#pragma mark TWITTER STUFF

- (void)setHandleRepliesData:(CompletionHandlerWithData)mhandleRepliesData
{
    id data = [mhandleRepliesData data];
    LOG_DEEBUG(0, @"%@", data);
    [self setName:[NSString stringWithFormat:@"%@", data]];
}

- (void)handleRepliesData:(CompletionHandlerWithData)handler
{
    LOG_DEEBUG(0, @"%@", handler);
}

- (void)setupTwitterWithStatus:(HuTwitterStatus *)status fromViewController:(UIViewController<HuViewControllerForStatusDelegate> *)mparent
{
    NSString *status_text = [self cleanUpEntities:[status text]];//[[status text] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    NSMutableArray *imageURLs = [NSMutableArray new];

    HuTwitterStatusEntities *entities = [status entities];
    if(entities && [entities instagramURLs] != nil) {
        NSArray *instagramURLs = [entities instagramURLs];
        // http://instagr.am/p/BUG/media/?size=t
        // extract media id from instagram url
        if([instagramURLs count] > 0) {
            NSString *instagram_url = [[entities instagramURLs]objectAtIndex:0];
            NSString *media_id = [instagram_url substringFromIndex:16];
            NSString *media_id_iso = [media_id substringToIndex:[media_id length]-1];
            [imageURLs addObject:[NSString stringWithFormat:@"http://instagr.am/p/%@/media/?size=l", media_id_iso]];
        }
    }
    if([status containsMedia]) {
        [imageURLs addObject:[status statusImageURL]];
    }
    
    [entities urls];
    
    [self setupTwitterWithStatusText:status_text imageURLStrings:imageURLs fromViewController:mparent];
 
}

- (void)setupTwitterWithStatusText:(NSString *)statusText imageURLStrings:(NSArray *)imageURLStrings fromViewController:(UIViewController<HuViewControllerForStatusDelegate>*)mparent
{
    
    //BOOL containsViewableMedia = [status containsMedia] | ([instagramURLs count] > 0);
    self.parent = mparent;
    containsViewableMedia = (imageURLStrings != nil && [imageURLStrings count] > 0);
    
    UIView *topView = UIView.new;
    topView.backgroundColor = [UIColor Amazon];
    [self addSubview:topView];
    
    self.scrollView = UIScrollView.new;
    [self.scrollView setAutoresizesSubviews:YES];
    
    self.scrollView.backgroundColor = self.statusContentView.backgroundColor;//[[self.statusContentView.backgroundColor triadicColors]objectAtIndex:0]; //[UIColor blueColor];
    [self addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(self);
        make.top.equalTo(topView.mas_bottom);
        //make.top.equalTo(@0);
        
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
    [self.scrollView addSubview:contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView.mas_width);
    }];
    
    self.statusContentViewOpen = NO;
    //self.nameView = UIView.new;
    self.nameView.backgroundColor = self.nameViewColor;
    self.actionView = UIView.new;
    self.actionView.backgroundColor = [UIColor colorWithHexString:@"F1F1F2"];
    
    
    
    
    if(containsViewableMedia) {
        self.imageView = UIImageView.new;
        self.imageView.backgroundColor = [self.statusContentView.backgroundColor lighterColor];
    }
    [topView addSubview:self.nameView];
    [topView addSubview:self.dateView];
    [topView addSubview:self.locView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        //make.height.equalTo(@120);
        make.bottom.equalTo(self.locView.mas_bottom);
        make.left.equalTo(@0);
        make.right.equalTo(self.mas_right);
    }];
    
    
    [contentView addSubview:self.statusContentView];
    
    
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.nameViewHeight);
    }];
    
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameView.mas_bottom);//self.nameView.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.dateViewHeight);
    }];
    
    // this is in case there is no location specified
    [self.locView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateView.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@0);
    }];
    
    
    //self.nameLabel = [UILabel new];
    [self.nameLabel setFont: self.nameViewFont];
    [self.nameView addSubview:self.nameLabel];
    [self.nameLabel setTextColor:[UIColor whiteColor]];
    [self.nameLabel setTextAlignment:self.nameLabelAlignment];
    
    
    //[self.userIconImageView setContentMode:(UIViewContentModeScaleAspectFit)];
    [self.nameView addSubview:self.userIconImageView];
    [self.userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameView.mas_left);
        make.width.equalTo(self.nameView.mas_height);
        //make.left.equalTo(topView.mas_left);
        make.top.equalTo(self.nameView.mas_top);
        make.bottom.equalTo(self.nameView.mas_bottom);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.nameView).with.insets(UIEdgeInsetsMake(0, 5, 0, 5));
        make.left.equalTo(self.userIconImageView.mas_right).with.offset(2);
        make.right.equalTo(self.nameView.mas_right).with.offset(-5);
        make.top.equalTo(self.nameView.mas_top).with.offset(-2);
        make.bottom.equalTo(self.nameView.mas_bottom);
    }];
    
    [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapSomething:)];
    [gesture setNumberOfTapsRequired:1];
    [self.nameLabel setUserInteractionEnabled:YES];
    [self.nameLabel addGestureRecognizer:gesture];
    
    [self.dateView addSubview:_dateLabel];
    
    [self.dateLabel setTextAlignment:self.dateLabelAlignment];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.dateView).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    
    [self.locView addSubview:self.locLabel];
    //
    [self.locLabel setTextAlignment:self.locLabelAlignment];
    
    [self.statusContentView addSubview:self.statusContentLabel];
    
    if(containsViewableMedia == YES) {
        [self.statusContentView addSubview:self.imageView];
        [self.imageView setUserInteractionEnabled:YES];
        //        [self.imageView setImage:[UIImage imageNamed:@"michael-caine.jpg"]];
        

        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusContentView.mas_top);
            make.left.equalTo(self.statusContentView.mas_left);
            make.width.equalTo(self.statusContentView.mas_width);
            make.height.equalTo(self.statusContentView.mas_width);
        }];
        
        __block UIImageView *bphotoView = self.imageView;
        
        UILongPressGestureRecognizer *longPress = [UILongPressGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            if(state == UIGestureRecognizerStateBegan) {
                LOG_UI(0, @"Long Press.");
                
                IDMPhoto *idmphoto = [IDMPhoto photoWithImage:bphotoView.image];
                
                NSArray *photo = @[idmphoto];
                IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photo];
                [mparent presentViewController:browser animated:NO completion:nil];
            }
            
        }];
        [self.imageView addGestureRecognizer:longPress];
        
        
        
        //[self.imageView setClipsToBounds:YES];
        
        NSString *image_url = [imageURLStrings objectAtIndex:0];
        if([image_url containsString:@"instagr"]) {
            [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [self.imageView setClipsToBounds:YES];
        } else {
            [self.imageView setContentMode:(UIViewContentModeCenter | UIViewContentModeScaleAspectFit)];
            [self.imageView setClipsToBounds:YES];
        }
        //LOG_TWITTER(0, @"image urls=%@", imageURLStrings);
        [self.imageView setImageWithURL:[NSURL URLWithString:image_url] placeholderImage: [UIImage imageNamed:@"BoozyBear.png"] options:(SDWebImageRetryFailed) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if(error == nil) {
                //CGSize resizeSize = CGSizeMake(320, 320);
                
                //bphotoView.image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:resizeSize interpolationQuality:kCGInterpolationDefault];
                //image = img;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [bphotoView setNeedsDisplay];
                    
                });
            } else {
                // do something if there was a problem loading the image?
                bphotoView.image = [UIImage imageNamed:@"BoozyBear.png"];
                
            }
        }];
    }
    
    
    self.statusContentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    //[self.statusContentLabel setBackgroundColor:[UIColor greenColor]];
    [self.statusContentLabel setNumberOfLines:0];
    [self.statusContentLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [self.statusContentLabel setTextAlignment:NSTextAlignmentLeft];
    [self.statusContentLabel setContentMode:UIViewContentModeTop];
    //UIColor *activeTextColor = [self.statusContentView.backgroundColor colorByDarkeningTo:.6];
    
    UIColor *activeTextColor = [[self.statusContentLabel textColor]colorByDarkeningTo:.85];
    
    [self.statusContentLabel setLinkAttributes:@{(NSString*)kCTForegroundColorAttributeName : activeTextColor}];
    
    
    [self.statusContentLabel setActiveLinkAttributes:@{(NSString *)kCTForegroundColorAttributeName : [UIColor redColor ]}];
    [self.statusContentLabel setDelegate:self];
    self.statusContentLabel.enabledTextCheckingTypes = (NSTextCheckingTypeLink | NSTextCheckingTypeRegularExpression);
    
    NSString *clean = [statusText stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    [self.statusContentLabel setText:clean afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        //
        return mutableAttributedString;
        //
    }];
    
    
    [self highlightMentionsInString:self.statusContentLabel.text withLabel:self.statusContentLabel withColor:activeTextColor isBold:NO isUnderlined:NO];
    
    UITapGestureRecognizer *singleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        LOG_UI(0, @"Single tap.");
    } delay:0.18];
    [self.statusContentView addGestureRecognizer:singleTap];
    [singleTap setDelegate:self];
    
    UITapGestureRecognizer *doubleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [singleTap bk_cancel];
        LOG_UI(0, @"Double tap.");
        if(onDoubleTap) {
            onDoubleTap();
        }
    }];
    doubleTap.numberOfTapsRequired = 2;
    [self.statusContentView addGestureRecognizer:doubleTap];
    [doubleTap setDelegate:self];
    
    
    //        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    //        [self.statusContentView addGestureRecognizer:singleTap];
    //        singleTap.delegate = self;
    
    // padding = UIEdgeInsetsMake(10, 10, 10, 2);
    
    
    // dummy view, which determines the size of the contentView size and therefore the scrollView contentSize
    sizingView = UIView.new;
    [self.scrollView addSubview:sizingView];
    [sizingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusContentView.mas_bottom).with.offset(60);
        make.bottom.equalTo(contentView.mas_bottom);
    }];
    
    [self addSubview:self.scrollView];
    [self addSubview:self.actionView];
    
    
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@50);
    }];
    
    
    [self.statusContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if(containsViewableMedia == YES) {
            make.top.equalTo(self.imageView.mas_bottom).with.offset(10).priorityHigh();
        }
        else
        {
            make.top.equalTo(@0).with.offset(10).priorityHigh();
        }
        make.left.equalTo(@10);
        make.right.equalTo(self.statusContentView.mas_right).with.offset(-10);
        //make.bottom.equalTo(self.actionView.mas_height);
        //make.height.greaterThanOrEqualTo(@400);
        //        make.width.equalTo(self.statusContentView.mas_width);
        //        make.edges.equalTo(self.statusContentView).with.insets(padding);
        //make.center.equalTo(self.statusContentView);
    }];
    
    //[self.statusContentView setBackgroundColor:[UIColor purpleColor]];
    [self.statusContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(repliesContainerView.mas_bottom);
        //make.top.equalTo(self.locLabel.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        //make.bottom.equalTo(self.actionView.mas_top).with.offset(10);
        //make.height.equalTo(@(r.size.height));
        make.bottom.equalTo(self.statusContentLabel.mas_bottom).with.offset(120);
    }];
    
    UIImage *like = [UIImage imageNamed:@"like_icon.png"];
    self.likeImageView = [[UIImageView alloc]initWithImage:like];
    [self.likeImageView setUserInteractionEnabled:YES];
    [self.actionView addSubview:self.likeImageView ];
    
    UIImageView *bottomUserImageView = [[UIImageView alloc]initWithImage:self.userIconImageView.image];
    [self.actionView addSubview:bottomUserImageView];
    [bottomUserImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.actionView.mas_height);
        make.width.equalTo(self.actionView.mas_height);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
    }];
    
    //    UITapGestureRecognizer *actTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actTap:)];
    //    [self.likeImageView addGestureRecognizer:actTap];
    
    UITapGestureRecognizer *likeTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        LOG_UI(0, @"Like That");
        //[self actTap:likeTap];
        if(onDoubleTap) {
            onDoubleTap();
        }
//         HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
//        [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]like:status];
    }];
    [self.likeImageView addGestureRecognizer:likeTap];
    
    
    //UIEdgeInsets padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.actionView.mas_height).with.offset(-10);
        make.width.equalTo(self.actionView.mas_height).with.offset(-12);
        make.left.equalTo(@5);
        make.top.equalTo(@5);
        
    }];
    
    //    UITapGestureRecognizer *singleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
    //        LOG_UI(0, @"Single tap.");
    //    } delay:0.18];
    //    [self.statusContentView addGestureRecognizer:singleTap];
    //
    //    UITapGestureRecognizer *doubleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
    //        [singleTap bk_cancel];
    //        LOG_UI(0, @"Double tap.");
    //        HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
    //        [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]like:status];
    //    }];
    //    doubleTap.numberOfTapsRequired = 2;
    //    [contentView addGestureRecognizer:doubleTap];
    
    
}

// deprecated
/*
- (void)setupTwitterWithStatus:(HuTwitterStatus *)status andReplies:(NSArray *)replies fromViewController:(UIViewController<HuViewControllerForStatusDelegate>*)mparent
{
    
    HuTwitterStatusEntities *entities = [status entities];
    NSArray *instagramURLs = nil;
    if(entities) {
        instagramURLs = [entities instagramURLs];
    }
    
    BOOL containsViewableMedia = [status containsMedia] | ([instagramURLs count] > 0);
    self.parent = mparent;
    
    
    UIView *topView = UIView.new;
    topView.backgroundColor = [UIColor Amazon];
    [self addSubview:topView];
    
    self.scrollView = UIScrollView.new;
    [self.scrollView setAutoresizesSubviews:YES];
    
    self.scrollView.backgroundColor = self.statusContentView.backgroundColor;//[[self.statusContentView.backgroundColor triadicColors]objectAtIndex:0]; //[UIColor blueColor];
    [self addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(self);
        make.top.equalTo(topView.mas_bottom);
        //make.top.equalTo(@0);
        
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    contentView = UIView.new;
    [self.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView.mas_width);
    }];
    
    self.statusContentViewOpen = NO;
    //self.nameView = UIView.new;
    self.nameView.backgroundColor = self.nameViewColor;
    self.actionView = UIView.new;
    self.actionView.backgroundColor = [UIColor colorWithHexString:@"F1F1F2"];
    
    

    
    if(containsViewableMedia) {
        self.imageView = UIImageView.new;
        self.imageView.backgroundColor = [self.statusContentView.backgroundColor lighterColor];
    }
    [topView addSubview:self.nameView];
    [topView addSubview:self.dateView];
    [topView addSubview:self.locView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        //make.height.equalTo(@120);
        make.bottom.equalTo(self.locView.mas_bottom);
        make.left.equalTo(@0);
        make.right.equalTo(self.mas_right);
    }];
    
    
    [contentView addSubview:self.statusContentView];
    
    
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.nameViewHeight);
    }];
    
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameView.mas_bottom);//self.nameView.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@40);
    }];
    
    // this is in case there is no location specified
    [self.locView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateView.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@0);
    }];
    
    
    //self.nameLabel = [UILabel new];
    [self.nameLabel setFont: self.nameViewFont];
    [self.nameView addSubview:self.nameLabel];
    [self.nameLabel setTextColor:[UIColor whiteColor]];
    [self.nameLabel setTextAlignment:self.nameLabelAlignment];


    //[self.userIconImageView setContentMode:(UIViewContentModeScaleAspectFit)];
    [self.nameView addSubview:self.userIconImageView];
    [self.userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameView.mas_left);
        make.width.equalTo(self.nameView.mas_height);
        //make.left.equalTo(topView.mas_left);
        make.top.equalTo(self.nameView.mas_top);
        make.bottom.equalTo(self.nameView.mas_bottom);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.nameView).with.insets(UIEdgeInsetsMake(0, 5, 0, 5));
        make.left.equalTo(self.userIconImageView.mas_right).with.offset(2);
        make.right.equalTo(self.nameView.mas_right).with.offset(-5);
        make.top.equalTo(self.nameView.mas_top).with.offset(-2);
        make.bottom.equalTo(self.nameView.mas_bottom);
    }];
    
    [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapSomething:)];
    [gesture setNumberOfTapsRequired:1];
    [self.nameLabel setUserInteractionEnabled:YES];
    [self.nameLabel addGestureRecognizer:gesture];
    
    //_dateLabel = [UILabel new];
    //[_dateLabel setFont:sea_and_sky.dateViewFont];//           [UIFont fontWithName:@"DIN-Light" size:22]];
    [self.dateView addSubview:_dateLabel];
    
    [self.dateLabel setTextAlignment:self.dateLabelAlignment];
    //[self.dateLabel setTextColor:sea_and_sky.dateViewText];  //[UIColor colorWithHexString:@"BED2D9"]];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.dateView).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    
    //self.locLabel = [UILabel new];
    // [self.locLabel setFont:sea_and_sky.locViewFont];  // [UIFont fontWithName:@"DIN-Light" size:22]];
    //[self.locLabel setTextColor:sea_and_sky.locViewText];
    [self.locView addSubview:self.locLabel];
    //
    [self.locLabel setTextAlignment:self.locLabelAlignment];
//    [self.locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.locView).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
//        ///make.center.equalTo(self.locView);
//    }];
    
    [self.statusContentView addSubview:self.statusContentLabel];

    if(containsViewableMedia == YES) {
        [self.statusContentView addSubview:self.imageView];
        [self.imageView setUserInteractionEnabled:YES];
//        [self.imageView setImage:[UIImage imageNamed:@"michael-caine.jpg"]];
        //[self.imageView setContentMode:(UIViewContentModeCenter | UIViewContentModeScaleAspectFit)];
        [self.imageView setClipsToBounds:YES];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusContentView.mas_top);
            make.left.equalTo(self.statusContentView.mas_left);
            make.width.equalTo(self.statusContentView.mas_width);
            make.height.equalTo(self.statusContentView.mas_width);
        }];

        __block UIImageView *bphotoView = self.imageView;

        UILongPressGestureRecognizer *longPress = [UILongPressGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            if(state == UIGestureRecognizerStateBegan) {
                LOG_UI(0, @"Long Press.");
                
                IDMPhoto *idmphoto = [IDMPhoto photoWithImage:bphotoView.image];
                
                NSArray *photo = @[idmphoto];
                IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photo];
                [mparent presentViewController:browser animated:NO completion:nil];
            }
            
        }];
        [self.imageView addGestureRecognizer:longPress];
        

        
        //[self.imageView setClipsToBounds:YES];
        
        NSString *image_url;
        
        if([status statusImageURL] != nil) {
            image_url = [status statusImageURL];
        } else {
            // http://instagr.am/p/BUG/media/?size=t
            // extract media id from instagram url
            if([instagramURLs count] > 0) {
            NSString *instagram_url = [[entities instagramURLs]objectAtIndex:0];
            NSString *media_id = [instagram_url substringFromIndex:16];
            NSString *media_id_iso = [media_id substringToIndex:[media_id length]-1];
            image_url = [NSString stringWithFormat:@"http://instagr.am/p/%@/media/?size=l", media_id_iso];
            }
        }
        
        [self.imageView setImageWithURL:[NSURL URLWithString:image_url] placeholderImage: [UIImage imageNamed:@"BoozyBear.png"] options:(SDWebImageRetryFailed) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if(error == nil) {
                //CGSize resizeSize = CGSizeMake(320, 320);
                
                //bphotoView.image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:resizeSize interpolationQuality:kCGInterpolationDefault];
                //image = img;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [bphotoView setNeedsDisplay];
                    
                });
            } else {
                // do something if there was a problem loading the image?
                bphotoView.image = [UIImage imageNamed:@"BoozyBear.png"];
                
            }
        }];
    }
    

    self.statusContentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    [self.statusContentLabel setBackgroundColor:[UIColor clearColor]];
    [self.statusContentLabel setNumberOfLines:0];
    [self.statusContentLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [self.statusContentLabel setTextAlignment:NSTextAlignmentLeft];
    [self.statusContentLabel setContentMode:UIViewContentModeTop];
    //UIColor *activeTextColor = [self.statusContentView.backgroundColor colorByDarkeningTo:.6];
    
    UIColor *activeTextColor = [[self.statusContentLabel textColor]colorByDarkeningTo:.85];
    
    [self.statusContentLabel setLinkAttributes:@{(NSString*)kCTForegroundColorAttributeName : activeTextColor}];
    
    
    [self.statusContentLabel setActiveLinkAttributes:@{(NSString *)kCTForegroundColorAttributeName : [UIColor redColor ]}];
    [self.statusContentLabel setDelegate:self];
    self.statusContentLabel.enabledTextCheckingTypes = (NSTextCheckingTypeLink | NSTextCheckingTypeRegularExpression);
    
    NSString *clean = [[status statusText]stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];

    [self.statusContentLabel setText:clean afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        //
        return mutableAttributedString;
        //
    }];
    
    
    [self highlightMentionsInString:self.statusContentLabel.text withLabel:self.statusContentLabel withColor:activeTextColor isBold:NO isUnderlined:NO];
    
    UITapGestureRecognizer *singleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        LOG_UI(0, @"Single tap.");
    } delay:0.18];
    [self.statusContentView addGestureRecognizer:singleTap];
    [singleTap setDelegate:self];
    
    UITapGestureRecognizer *doubleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [singleTap bk_cancel];
        LOG_UI(0, @"Double tap.");
        if(onDoubleTap) {
            onDoubleTap();
        }
//        HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
//        [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]like:status];
    }];
    doubleTap.numberOfTapsRequired = 2;
    [self.statusContentView addGestureRecognizer:doubleTap];
    [doubleTap setDelegate:self];

    
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
//        [self.statusContentView addGestureRecognizer:singleTap];
//        singleTap.delegate = self;
    
   // padding = UIEdgeInsetsMake(10, 10, 10, 2);
    
    
    // dummy view, which determines the size of the contentView size and therefore the scrollView contentSize
    sizingView = UIView.new;
    [self.scrollView addSubview:sizingView];
    [sizingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusContentView.mas_bottom).with.offset(60);
        make.bottom.equalTo(contentView.mas_bottom);
    }];
    
    [self addSubview:self.scrollView];
    [self addSubview:self.actionView];
    
    
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@50);
    }];
    
    
    // handle any replies
    __block UIView *lastReply;

    if([status in_reply_to_status_id] != nil) {
        HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
        [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]getStatus:[status in_reply_to_status_id] withStatuses:@[status] withCompletion:^(id data, BOOL success, NSError *error) {
            if(success) {
                //NSString *t = statusView.text;
                NSLog(0, @"reply: %@", data);
                //NSString *f = [NSString stringWithFormat:@"%@\n%@", data, t];
                //[statusView setText:f];
                
            }
        }];
    }

    
    
    if(replies != nil && [replies count] > 0) {
        [replies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            HuTwitterStatus *status = (HuTwitterStatus*)obj;
            HuTwitterUser *user = [status user];
            UIView *replyView = UIView.new;
            UIView *replyUserView = UIView.new;
            
            [self.statusContentView addSubview:replyView];
            
            [replyUserView setBackgroundColor:[UIColor clearColor]];
            [replyView addSubview:replyUserView];
            [replyUserView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@0);
                make.width.equalTo(self.statusContentView.mas_width);
                make.top.equalTo(@0);
                make.height.greaterThanOrEqualTo(self.replyViewHeight).priorityHigh();
            }];
            UILabel *replyUserLabel = UILabel.new;
            [replyUserLabel setTextColor:self.replyUserLabelColor];
            [replyUserLabel setNumberOfLines:1];
            [replyUserLabel setFont:self.replyUserLabelFont];
            [replyUserLabel setText:[NSString stringWithFormat:@"%@ said", [user screen_name]]];
            
            [replyUserView addSubview:replyUserLabel];
            [replyUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.statusContentLabel.mas_left);
                make.right.equalTo(self.statusContentLabel.mas_right);
                make.top.equalTo(@5);
            }];
            
            TTTAttributedLabel *replyLabel = TTTAttributedLabel.new;
            replyLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
            //UIColor *bg = [UIColor whiteColor];//[self.statusContentView.backgroundColor complementaryColor];
            //[replyView setBackgroundColor:self.replyViewColor];
            
            [replyLabel setTextColor:self.replyLabelTextColor];
            [replyLabel setFont:[self.statusContentLabel font]];
            [replyLabel setNumberOfLines:0];
            [replyLabel setLineBreakMode:NSLineBreakByCharWrapping];
            [replyLabel setTextAlignment:NSTextAlignmentLeft];
            [replyLabel setContentMode:UIViewContentModeTop];
            
            [replyView addSubview:replyLabel];
            
            [replyView setBackgroundColor:[UIColor whiteColor]];
            
            [replyView mas_makeConstraints:^(MASConstraintMaker *make) {
                if(containsViewableMedia && idx == 0) {
                    make.top.equalTo(self.imageView.mas_bottom).priorityHigh();
                } else {
                    if(idx == 0) {
                        make.top.equalTo(@0).priorityHigh();
                    } else {
                        make.top.equalTo(lastReply.mas_bottom);
                    }
                }
                make.left.equalTo(@0);
                make.right.equalTo(@0);
                make.bottom.equalTo(replyLabel.mas_bottom).with.offset(10);
                //make.height.equalTo(@100);
            }];
            [replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                //make.top.equalTo(replyView.mas_top).with.offset(10);
                make.top.equalTo(replyUserView.mas_bottom).with.offset(5);
                make.left.equalTo(self.statusContentLabel.mas_left);
                make.right.equalTo(self.statusContentLabel.mas_right);
            }];
            
            UIColor *activeTextColor = [UIColor darkGrayColor];//[[self.statusContentLabel textColor]colorByDarkeningToColor:[UIColor grayColor]];
            
            [replyLabel setLinkAttributes:@{(NSString*)kCTForegroundColorAttributeName : activeTextColor}];
            
            UIColor *replyLabelTextColor = replyLabel.textColor;
            [[UIColor blueColor]complementaryColor];
            UIColor *compColor = [replyLabelTextColor complementaryColor];
            [replyLabel setActiveLinkAttributes:@{(NSString *)kCTForegroundColorAttributeName :compColor}];
            [replyLabel setDelegate:self];
            replyLabel.enabledTextCheckingTypes = (NSTextCheckingTypeLink | NSTextCheckingTypeRegularExpression);
            
            
            [replyLabel setText:[status statusText] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                return mutableAttributedString;
            }];
            
            [self highlightMentionsInString:replyLabel.text withLabel:replyLabel withColor:activeTextColor isBold:NO isUnderlined:NO];
            
            lastReply = replyView;
        }];
        
        // last one
        UIView *replyView = UIView.new;
        UIView *replyUserView = UIView.new;
        [replyView addSubview:replyUserView];
        [self.statusContentView addSubview:replyView];
        
        [replyUserView setBackgroundColor:self.replyUserLabelColor];
        [replyUserView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.width.equalTo(self.statusContentView.mas_width);
            make.top.equalTo(lastReply.mas_bottom);
            make.height.greaterThanOrEqualTo(self.replyViewHeight).priorityHigh();
        }];
        UILabel *replyUserLabel = UILabel.new;
        [replyUserLabel setTextColor:[UIColor whiteColor]];
        [replyUserLabel setNumberOfLines:1];
        [replyUserLabel setFont:self.replyUserLabelFont];
        [replyUserLabel setText:[NSString stringWithFormat:@"So %@ said", @"lizziearmanto"]];
        
        [replyUserView addSubview:replyUserLabel];
        [replyUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.statusContentLabel.mas_left);
            make.right.equalTo(self.statusContentLabel.mas_right);
            make.top.equalTo(@0);
        }];
        
        [replyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastReply.mas_bottom);
            make.left.equalTo(lastReply.mas_left);
            make.right.equalTo(lastReply.mas_right);
            make.bottom.equalTo(replyUserView.mas_bottom);
        }];
        lastReply = replyView;
    }
    
    
    //NSArray *replies = nil;
    
    [self.statusContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if(containsViewableMedia == YES && replies == nil) {
            make.top.equalTo(self.imageView.mas_bottom).with.offset(10).priorityHigh();
        }
        else
            if(containsViewableMedia && replies != nil) {
                make.top.equalTo(lastReply.mas_bottom).with.offset(10).priorityHigh();
            }
            else
                if(containsViewableMedia == NO && replies == nil) {
                    make.top.equalTo(@0).with.offset(10).priorityHigh();
                }
                else
                    if(containsViewableMedia == NO && replies != nil) {
                        make.top.equalTo(lastReply.mas_bottom).with.offset(10).priorityHigh();
                    }
                    else {
                        make.top.equalTo(@0).with.offset(10).priorityHigh();
                    }
        make.left.equalTo(@10);
        make.right.equalTo(self.statusContentView.mas_right).with.offset(-10);
        //make.bottom.equalTo(self.actionView.mas_height);
        //make.height.greaterThanOrEqualTo(@400);
        //        make.width.equalTo(self.statusContentView.mas_width);
        //        make.edges.equalTo(self.statusContentView).with.insets(padding);
        //make.center.equalTo(self.statusContentView);
    }];
    
    [self.statusContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        //make.top.equalTo(self.locLabel.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        //make.bottom.equalTo(self.actionView.mas_top).with.offset(10);
        //make.height.equalTo(@(r.size.height));
        make.bottom.equalTo(self.statusContentLabel.mas_bottom).with.offset(120);
    }];
    
    UIImage *like = [UIImage imageNamed:@"like_icon.png"];
    self.likeImageView = [[UIImageView alloc]initWithImage:like];
    [self.likeImageView setUserInteractionEnabled:YES];
    [self.actionView addSubview:self.likeImageView ];
    
    UIImageView *bottomUserImageView = [[UIImageView alloc]initWithImage:self.userIconImageView.image];
    [self.actionView addSubview:bottomUserImageView];
    [bottomUserImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.actionView.mas_height);
        make.width.equalTo(self.actionView.mas_height);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
    }];
    
//    UITapGestureRecognizer *actTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actTap:)];
//    [self.likeImageView addGestureRecognizer:actTap];
    
    UITapGestureRecognizer *likeTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        LOG_UI(0, @"Like That");
        HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
        [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]like:status];
    }];
    [self.likeImageView addGestureRecognizer:likeTap];
    
    //UIEdgeInsets padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.actionView.mas_height).with.offset(-10);
        make.width.equalTo(self.actionView.mas_height).with.offset(-12);
        make.left.equalTo(@5);
        make.top.equalTo(@5);
        
    }];
    
//    UITapGestureRecognizer *singleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
//        LOG_UI(0, @"Single tap.");
//    } delay:0.18];
//    [self.statusContentView addGestureRecognizer:singleTap];
//
//    UITapGestureRecognizer *doubleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
//        [singleTap bk_cancel];
//        LOG_UI(0, @"Double tap.");
//        HuOnBehalfOf *on_behalf_of = [status status_on_behalf_of];
//        [[HuTwitterServiceManager sharedTwitterClientOnBehalfOf:on_behalf_of ]like:status];
//    }];
//    doubleTap.numberOfTapsRequired = 2;
//    [contentView addGestureRecognizer:doubleTap];


}
*/

#pragma mark INSTAGRAM STUFF // shouldnt depend on the actual InstagramStatus class

- (void)setupInstagramWithStatus:(InstagramStatus *)mstatus fromViewController:(UIViewController<HuViewControllerForStatusDelegate>*)mparent
{
    UIView *topView = UIView.new;
    topView.backgroundColor = [UIColor Amazon];
    [self addSubview:topView];
    
    self.scrollView = UIScrollView.new;
    [self.scrollView setAutoresizesSubviews:YES];
    
    self.scrollView.backgroundColor = self.statusContentView.backgroundColor;//[[self.statusContentView.backgroundColor triadicColors]objectAtIndex:0]; //[UIColor blueColor];
    [self addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(self);
        make.top.equalTo(topView.mas_bottom);
        //make.top.equalTo(@0);
        
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    contentView = UIView.new;
    [self.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView.mas_width);
    }];
    
    self.statusContentViewOpen = NO;
    //self.nameView = UIView.new;
    self.nameView.backgroundColor = self.nameViewColor;
    self.actionView = UIView.new;
    self.actionView.backgroundColor = [UIColor colorWithHexString:@"F1F1F2"];
    
    self.imageView = UIImageView.new;
    self.imageView.backgroundColor = [self.statusContentView.backgroundColor lighterColor];
    [topView addSubview:self.nameView];
    [topView addSubview:self.dateView];
    [topView addSubview:self.locView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        //make.height.equalTo(@120);
        make.bottom.equalTo(self.locView.mas_bottom);
        make.left.equalTo(@0);
        make.right.equalTo(self.mas_right);
    }];
    
    
    [contentView addSubview:self.statusContentView];
    
    
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.nameViewHeight);
    }];
    
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameView.mas_bottom);//self.nameView.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.dateViewHeight);
    }];
    
    // this is in case there is no location specified
    [self.locView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateView.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@0);
    }];
    
    
    //self.nameLabel = [UILabel new];
    [self.nameLabel setFont: self.nameViewFont];
    [self.nameView addSubview:self.nameLabel];
    [self.nameLabel setTextColor:[UIColor whiteColor]];
    [self.nameLabel setTextAlignment:self.nameLabelAlignment];
    
    
    //[self.userIconImageView setContentMode:(UIViewContentModeScaleAspectFit)];
    [self.nameView addSubview:self.userIconImageView];
    [self.userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameView.mas_left);
        make.width.equalTo(self.nameView.mas_height);
        //make.left.equalTo(topView.mas_left);
        make.top.equalTo(self.nameView.mas_top);
        make.bottom.equalTo(self.nameView.mas_bottom);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.nameView).with.insets(UIEdgeInsetsMake(0, 5, 0, 5));
        make.left.equalTo(self.userIconImageView.mas_right).with.offset(2);
        make.right.equalTo(self.nameView.mas_right).with.offset(-5);
        make.top.equalTo(self.nameView.mas_top).with.offset(-2);
        make.bottom.equalTo(self.nameView.mas_bottom);
    }];
    
    [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapSomething:)];
    [gesture setNumberOfTapsRequired:1];
    [self.nameLabel setUserInteractionEnabled:YES];
    [self.nameLabel addGestureRecognizer:gesture];
    
    //_dateLabel = [UILabel new];
    //[_dateLabel setFont:sea_and_sky.dateViewFont];//           [UIFont fontWithName:@"DIN-Light" size:22]];
    [self.dateView addSubview:_dateLabel];
    
    [self.dateLabel setTextAlignment:self.dateLabelAlignment];
    //[self.dateLabel setTextColor:sea_and_sky.dateViewText];  //[UIColor colorWithHexString:@"BED2D9"]];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.dateView).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    
    [self.locView addSubview:self.locLabel];
    //
    [self.locLabel setTextAlignment:self.locLabelAlignment];
    //    [self.locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self.locView).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    //        ///make.center.equalTo(self.locView);
    //    }];
    
    [self.statusContentView addSubview:self.statusContentLabel];
    
        [self.statusContentView addSubview:self.imageView];
        [self.imageView setUserInteractionEnabled:YES];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.imageView setClipsToBounds:YES];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusContentView.mas_top);
            make.left.equalTo(self.statusContentView.mas_left);
            make.width.equalTo(self.statusContentView.mas_width);
            make.height.equalTo(self.statusContentView.mas_width);
        }];
        
        __block UIImageView *bphotoView = self.imageView;
        
        UILongPressGestureRecognizer *longPress = [UILongPressGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            if(state == UIGestureRecognizerStateBegan) {
                LOG_UI(0, @"Long Press.");
                
                IDMPhoto *idmphoto = [IDMPhoto photoWithImage:bphotoView.image];
                
                NSArray *photo = @[idmphoto];
                IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photo];
                [mparent presentViewController:browser animated:NO completion:nil];
            }
            
        }];
        [self.imageView addGestureRecognizer:longPress];
    
        [self.imageView setImageWithURL:[NSURL URLWithString:[mstatus statusImageURL]] placeholderImage: [UIImage imageNamed:@"BoozyBear.png"] options:(SDWebImageRetryFailed) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if(error == nil) {
                //CGSize resizeSize = CGSizeMake(320, 320);
                
                //bphotoView.image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:resizeSize interpolationQuality:kCGInterpolationDefault];
                //image = img;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [bphotoView setNeedsDisplay];
                    
                });
            } else {
                // do something if there was a problem loading the image?
                bphotoView.image = [UIImage imageNamed:@"BoozyBear.png"];
                
            }
        }];
    self.statusContentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    [self.statusContentLabel setBackgroundColor:[UIColor clearColor]];
    [self.statusContentLabel setNumberOfLines:0];
    [self.statusContentLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [self.statusContentLabel setTextAlignment:NSTextAlignmentLeft];
    [self.statusContentLabel setContentMode:UIViewContentModeTop];
    //UIColor *activeTextColor = [self.statusContentView.backgroundColor colorByDarkeningTo:.6];
    
    UIColor *activeTextColor = [[self.statusContentLabel textColor]colorByDarkeningTo:.85];
    
    [self.statusContentLabel setLinkAttributes:@{(NSString*)kCTForegroundColorAttributeName : activeTextColor}];
    
    
    [self.statusContentLabel setActiveLinkAttributes:@{(NSString *)kCTForegroundColorAttributeName : [UIColor redColor ]}];
    [self.statusContentLabel setDelegate:self];
    self.statusContentLabel.enabledTextCheckingTypes = (NSTextCheckingTypeLink | NSTextCheckingTypeRegularExpression);
    
    NSString *clean = [self cleanUpEntities:[mstatus statusText]]; //[[mstatus statusText]stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    [self.statusContentLabel setText:clean afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        //
        return mutableAttributedString;
        //
    }];
    
    
    [self highlightMentionsInString:self.statusContentLabel.text withLabel:self.statusContentLabel withColor:activeTextColor isBold:NO isUnderlined:NO];
    
    UITapGestureRecognizer *singleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        LOG_UI(0, @"Single tap.");
    } delay:0.18];
    [self.imageView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [singleTap bk_cancel];
        LOG_UI(0, @"Double tap.");
        if(onDoubleTap) {
            onDoubleTap();
        }
        //[[HuInstagramHTTPSessionManager sharedInstagramClient]like:mstatus];
        //            [[HuInstagramHTTPSessionManager sharedInstagramClient]like:status];
    }];
    doubleTap.numberOfTapsRequired = 2;
    [self.imageView addGestureRecognizer:doubleTap];

    [doubleTap setDelegate:self];
    
    
    //        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    //        [self.statusContentView addGestureRecognizer:singleTap];
    //        singleTap.delegate = self;
    
    // padding = UIEdgeInsetsMake(10, 10, 10, 2);
    
    
    // dummy view, which determines the size of the contentView size and therefore the scrollView contentSize
    sizingView = UIView.new;
    [self.scrollView addSubview:sizingView];
    [sizingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusContentView.mas_bottom).with.offset(60);
        make.bottom.equalTo(contentView.mas_bottom);
    }];
    
    [self addSubview:self.scrollView];
    [self addSubview:self.actionView];
    
    
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@50);
    }];
    
    
    
    //NSArray *replies = nil;
    
    [self.statusContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).with.offset(10).priorityHigh();
        make.left.equalTo(@10);
        make.right.equalTo(self.statusContentView.mas_right).with.offset(-10);
        //make.bottom.equalTo(self.actionView.mas_height);
        //make.height.greaterThanOrEqualTo(@400);
        //        make.width.equalTo(self.statusContentView.mas_width);
        //        make.edges.equalTo(self.statusContentView).with.insets(padding);
        //make.center.equalTo(self.statusContentView);
    }];
    
    [self.statusContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        //make.top.equalTo(self.locLabel.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        //make.bottom.equalTo(self.actionView.mas_top).with.offset(10);
        //make.height.equalTo(@(r.size.height));
        make.bottom.equalTo(self.statusContentLabel.mas_bottom).with.offset(120);
    }];
    
    UIImage *like = [UIImage imageNamed:@"like_icon.png"];
    self.likeImageView = [[UIImageView alloc]initWithImage:like];
    [self.likeImageView setUserInteractionEnabled:YES];
    [self.actionView addSubview:self.likeImageView ];
    
    UIImageView *bottomUserImageView = [[UIImageView alloc]initWithImage:self.userIconImageView.image];
    [self.actionView addSubview:bottomUserImageView];
    [bottomUserImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.actionView.mas_height);
        make.width.equalTo(self.actionView.mas_height);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
    }];
    
    //    UITapGestureRecognizer *actTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actTap:)];
    //    [self.likeImageView addGestureRecognizer:actTap];
    
    UITapGestureRecognizer *likeTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        LOG_UI(0, @"Like That");
         [[HuInstagramHTTPSessionManager sharedInstagramClient]like:mstatus];
    }];
    [self.likeImageView addGestureRecognizer:likeTap];
    
    //UIEdgeInsets padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.actionView.mas_height).with.offset(-10);
        make.width.equalTo(self.actionView.mas_height).with.offset(-12);
        make.left.equalTo(@5);
        make.top.equalTo(@5);
        
    }];
    
}



#pragma mark Flickr Stuff

- (void)setupFlickrWithStatus:(HuFlickrStatus *)status fromViewController:(UIViewController<HuViewControllerForStatusDelegate> *)mparent
{
    [self setupFlickrWithStatusText:[status statusText] imageURLStrings:@[[status statusImageURL]] fromViewController:mparent];
}

- (void)setupFlickrWithStatusText:(NSString *)statusText imageURLStrings:(NSArray *)imageURLStrings fromViewController:(UIViewController<HuViewControllerForStatusDelegate>*)mparent
{
    UIView *topView = UIView.new;
    topView.backgroundColor = [UIColor Amazon];
    [self addSubview:topView];
    
    self.scrollView = UIScrollView.new;
    [self.scrollView setAutoresizesSubviews:YES];
    
    self.scrollView.backgroundColor = self.statusContentView.backgroundColor;//[[self.statusContentView.backgroundColor triadicColors]objectAtIndex:0]; //[UIColor blueColor];
    [self addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(self);
        make.top.equalTo(topView.mas_bottom);
        //make.top.equalTo(@0);
        
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    contentView = UIView.new;
    [self.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView.mas_width);
    }];
    
    self.statusContentViewOpen = NO;
    //self.nameView = UIView.new;
    self.nameView.backgroundColor = self.nameViewColor;
    self.actionView = UIView.new;
    self.actionView.backgroundColor = [UIColor colorWithHexString:@"F1F1F2"];
    
    self.imageView = UIImageView.new;
    self.imageView.backgroundColor = [self.statusContentView.backgroundColor lighterColor];
    [topView addSubview:self.nameView];
    [topView addSubview:self.dateView];
    [topView addSubview:self.locView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        //make.height.equalTo(@120);
        make.bottom.equalTo(self.locView.mas_bottom);
        make.left.equalTo(@0);
        make.right.equalTo(self.mas_right);
    }];
    
    
    [contentView addSubview:self.statusContentView];
    
    
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.nameViewHeight);
    }];
    
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameView.mas_bottom);//self.nameView.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.dateViewHeight);
    }];
    
    // this is in case there is no location specified
    [self.locView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateView.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@0);
    }];
    
    
    //self.nameLabel = [UILabel new];
    [self.nameLabel setFont: self.nameViewFont];
    [self.nameView addSubview:self.nameLabel];
    [self.nameLabel setTextColor:[UIColor whiteColor]];
    [self.nameLabel setTextAlignment:self.nameLabelAlignment];
    
    
    //[self.userIconImageView setContentMode:(UIViewContentModeScaleAspectFit)];
    [self.nameView addSubview:self.userIconImageView];
    [self.userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameView.mas_left);
        make.width.equalTo(self.nameView.mas_height);
        //make.left.equalTo(topView.mas_left);
        make.top.equalTo(self.nameView.mas_top);
        make.bottom.equalTo(self.nameView.mas_bottom);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.nameView).with.insets(UIEdgeInsetsMake(0, 5, 0, 5));
        make.left.equalTo(self.userIconImageView.mas_right).with.offset(2);
        make.right.equalTo(self.nameView.mas_right).with.offset(-5);
        make.top.equalTo(self.nameView.mas_top).with.offset(-2);
        make.bottom.equalTo(self.nameView.mas_bottom);
    }];
    
    [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapSomething:)];
    [gesture setNumberOfTapsRequired:1];
    [self.nameLabel setUserInteractionEnabled:YES];
    [self.nameLabel addGestureRecognizer:gesture];
    
    //_dateLabel = [UILabel new];
    //[_dateLabel setFont:sea_and_sky.dateViewFont];//           [UIFont fontWithName:@"DIN-Light" size:22]];
    [self.dateView addSubview:_dateLabel];
    
    [self.dateLabel setTextAlignment:self.dateLabelAlignment];
    //[self.dateLabel setTextColor:sea_and_sky.dateViewText];  //[UIColor colorWithHexString:@"BED2D9"]];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.dateView).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    
    [self.locView addSubview:self.locLabel];
    //
    [self.locLabel setTextAlignment:self.locLabelAlignment];
    //    [self.locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self.locView).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    //        ///make.center.equalTo(self.locView);
    //    }];
    
    [self.statusContentView addSubview:self.statusContentLabel];
    
    [self.statusContentView addSubview:self.imageView];
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView setClipsToBounds:YES];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusContentView.mas_top);
        make.left.equalTo(self.statusContentView.mas_left);
        make.width.equalTo(self.statusContentView.mas_width);
        make.height.equalTo(self.statusContentView.mas_width);
    }];
    
    __block UIImageView *bphotoView = self.imageView;
    
    UILongPressGestureRecognizer *longPress = [UILongPressGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        if(state == UIGestureRecognizerStateBegan) {
            LOG_UI(0, @"Long Press.");
            
            IDMPhoto *idmphoto = [IDMPhoto photoWithImage:bphotoView.image];
            
            NSArray *photo = @[idmphoto];
            IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photo];
            [mparent presentViewController:browser animated:NO completion:nil];
        }
        
    }];
    [self.imageView addGestureRecognizer:longPress];
    NSString *image_url = nil;
    if(imageURLStrings != nil && [imageURLStrings count] > 0) {
        image_url = [imageURLStrings objectAtIndex:0];
    }
    [self.imageView setImageWithURL:[NSURL URLWithString:image_url] placeholderImage: [UIImage imageNamed:@"BoozyBear.png"] options:(SDWebImageRetryFailed) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if(error == nil) {
            //CGSize resizeSize = CGSizeMake(320, 320);
            
            //bphotoView.image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:resizeSize interpolationQuality:kCGInterpolationDefault];
            //image = img;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [bphotoView setNeedsDisplay];
                
            });
        } else {
            // do something if there was a problem loading the image?
            bphotoView.image = [UIImage imageNamed:@"BoozyBear.png"];
            
        }
    }];
    self.statusContentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    [self.statusContentLabel setBackgroundColor:[UIColor clearColor]];
    [self.statusContentLabel setNumberOfLines:0];
    [self.statusContentLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [self.statusContentLabel setTextAlignment:NSTextAlignmentLeft];
    [self.statusContentLabel setContentMode:UIViewContentModeTop];
    //UIColor *activeTextColor = [self.statusContentView.backgroundColor colorByDarkeningTo:.6];
    
    UIColor *activeTextColor = [[self.statusContentLabel textColor]colorByDarkeningTo:.85];
    
    [self.statusContentLabel setLinkAttributes:@{(NSString*)kCTForegroundColorAttributeName : activeTextColor}];
    
    
    [self.statusContentLabel setActiveLinkAttributes:@{(NSString *)kCTForegroundColorAttributeName : [UIColor redColor ]}];
    [self.statusContentLabel setDelegate:self];
    self.statusContentLabel.enabledTextCheckingTypes = (NSTextCheckingTypeLink | NSTextCheckingTypeRegularExpression);
    
    NSString *clean = [self cleanUpEntities:statusText]; //[[mstatus statusText]stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    [self.statusContentLabel setText:clean afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        //
        return mutableAttributedString;
        //
    }];
    
    
    [self highlightMentionsInString:self.statusContentLabel.text withLabel:self.statusContentLabel withColor:activeTextColor isBold:NO isUnderlined:NO];
    
    UITapGestureRecognizer *singleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        LOG_UI(0, @"Single tap.");
    } delay:0.18];
    [self.imageView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [singleTap bk_cancel];
        LOG_UI(0, @"Double tap.");
        if(onDoubleTap != nil) {
            onDoubleTap();
        }
        //mgr = [[HuFlickrServiceManager alloc]initFor:status];
        //[mgr like:status]
        
        //[[HuInstagramHTTPSessionManager sharedInstagramClient]like:mstatus];
        //            [[HuInstagramHTTPSessionManager sharedInstagramClient]like:status];
    }];
    doubleTap.numberOfTapsRequired = 2;
    [self.imageView addGestureRecognizer:doubleTap];
    
    [doubleTap setDelegate:self];
    
    
    //        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    //        [self.statusContentView addGestureRecognizer:singleTap];
    //        singleTap.delegate = self;
    
    // padding = UIEdgeInsetsMake(10, 10, 10, 2);
    
    
    // dummy view, which determines the size of the contentView size and therefore the scrollView contentSize
    sizingView = UIView.new;
    [self.scrollView addSubview:sizingView];
    [sizingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusContentView.mas_bottom).with.offset(60);
        make.bottom.equalTo(contentView.mas_bottom);
    }];
    
    [self addSubview:self.scrollView];
    [self addSubview:self.actionView];
    
    
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@50);
    }];
    
    
    
    //NSArray *replies = nil;
    
    [self.statusContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).with.offset(10).priorityHigh();
        make.left.equalTo(@10);
        make.right.equalTo(self.statusContentView.mas_right).with.offset(-10);
        //make.bottom.equalTo(self.actionView.mas_height);
        //make.height.greaterThanOrEqualTo(@400);
        //        make.width.equalTo(self.statusContentView.mas_width);
        //        make.edges.equalTo(self.statusContentView).with.insets(padding);
        //make.center.equalTo(self.statusContentView);
    }];
    
    [self.statusContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        //make.top.equalTo(self.locLabel.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(self.mas_width);
        //make.bottom.equalTo(self.actionView.mas_top).with.offset(10);
        //make.height.equalTo(@(r.size.height));
        make.bottom.equalTo(self.statusContentLabel.mas_bottom).with.offset(120);
    }];
    
    UIImage *like = [UIImage imageNamed:@"like_icon.png"];
    self.likeImageView = [[UIImageView alloc]initWithImage:like];
    [self.likeImageView setUserInteractionEnabled:YES];
    [self.actionView addSubview:self.likeImageView ];
    
    UIImageView *bottomUserImageView = [[UIImageView alloc]initWithImage:self.userIconImageView.image];
    [self.actionView addSubview:bottomUserImageView];
    [bottomUserImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.actionView.mas_height);
        make.width.equalTo(self.actionView.mas_height);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
    }];
    
    //    UITapGestureRecognizer *actTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actTap:)];
    //    [self.likeImageView addGestureRecognizer:actTap];
    
    UITapGestureRecognizer *likeTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        LOG_UI(0, @"Like That");
        //[[HuInstagramHTTPSessionManager sharedInstagramClient]like:mstatus];
    }];
    [self.likeImageView addGestureRecognizer:likeTap];
    
    //UIEdgeInsets padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.actionView.mas_height).with.offset(-10);
        make.width.equalTo(self.actionView.mas_height).with.offset(-12);
        make.left.equalTo(@5);
        make.top.equalTo(@5);
        
    }];
    
}


//- (void)setup
//{
//    UIView *topView = UIView.new;
//    topView.backgroundColor = [UIColor Amazon];
//    [self addSubview:topView];
//
//    self.scrollView = UIScrollView.new;
//    [self.scrollView setAutoresizesSubviews:YES];
//
//    self.scrollView.backgroundColor = [self.statusContentView.backgroundColor complementaryColor]; //[UIColor blueColor];
//    [self addSubview:self.scrollView];
//
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        //make.edges.equalTo(self);
//        make.top.equalTo(topView.mas_bottom);
//        make.left.equalTo(@0);
//        make.width.equalTo(self.mas_width);
//        make.bottom.equalTo(self.mas_bottom);
//    }];
//
//    contentView = UIView.new;
//    [self.scrollView addSubview:contentView];
//    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.scrollView);
//        make.width.equalTo(self.scrollView.mas_width);
//    }];
//
//    self.statusContentViewOpen = NO;
//    self.nameView = UIView.new;
//    self.nameView.backgroundColor = [UIColor Twitter];//[UIColor colorWithRed:63/255.0f green:114/255.0f blue:155/255.0f alpha:1.0f];
//    self.dateView = UIView.new;
//    self.dateView.backgroundColor = [UIColor colorWithHexString:@"F6F8FC"];//[UIColor colorWithRed:128/255.0f green:130/255.0f blue:132/255.0f alpha:1.0f];;
//    self.locView = UIView.new;
//    self.locView.backgroundColor = [UIColor colorWithHexString:@"ECF1F1"];//[UIColor colorWithRed:140/255.0f green:198/255.0f blue:62/255.0f alpha:1.0f];
//    self.statusContentView = UIView.new;
//    self.statusContentView.backgroundColor = [UIColor colorWithHexString:@"BED2D9"];[UIColor colorWithHexString:@"30aaac"];
//    self.actionView = UIView.new;
//    self.actionView.backgroundColor = [UIColor colorWithHexString:@"F1F1F2"];
//
//    [topView addSubview:self.nameView];
//    [topView addSubview:self.dateView];
//    [topView addSubview:self.locView];
//
//    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).with.offset(0);
//        //make.height.equalTo(@120);
//        make.bottom.equalTo(self.locView.mas_bottom);
//        make.left.equalTo(@0);
//        make.right.equalTo(self.mas_right);
//    }];
//
//
//    [contentView addSubview:self.statusContentView];
//
//
//    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(topView.mas_top);
//        make.left.equalTo(@0);
//        make.width.equalTo(self.mas_width);
//        make.height.equalTo(@40);
//    }];
//
//    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.nameView.mas_bottom);//self.nameView.mas_bottom);
//        make.left.equalTo(@0);
//        make.width.equalTo(self.mas_width);
//        make.height.equalTo(@40);
//    }];
//
//    [self.locView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.dateView.mas_bottom);
//        make.left.equalTo(@0);
//        make.width.equalTo(self.mas_width);
//        make.height.equalTo(@5);
//    }];
//
//
//    self.nameLabel = [UILabel new];
//    [self.nameLabel setFont:[UIFont fontWithName:@"DIN-Light" size:22]];
//    [self.nameView addSubview:self.nameLabel];
//    //    [self.nameLabel setText:[user screen_name]];
//    [self.nameLabel setTextColor:[UIColor whiteColor]];
//    [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.nameView).with.insets(UIEdgeInsetsMake(0, 5, 0, 5));
//
//    }];
//
//    _dateLabel = [UILabel new];
//    [_dateLabel setFont:[UIFont fontWithName:@"DIN-Light" size:22]];
//    [self.dateView addSubview:_dateLabel];
//    //    [dateLabel setDateToShow:[twitterStatus dateForSorting]];
//    //[dateLabel setText:@"2 days ago"];
//    [self.dateLabel setTextAlignment:NSTextAlignmentCenter];
//    [self.dateLabel setTextColor:[UIColor colorWithHexString:@"BED2D9"]];
//    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.dateView).with.insets(UIEdgeInsetsMake(5, 5, 0, 5));
//    }];
//
//
//    self.locLabel = [UILabel new];
//    [self.locLabel setFont:[UIFont fontWithName:@"DIN-Light" size:22]];
//    //[self.locLabel setText:@"Here"];
//    [self.locView addSubview:self.locLabel];
//    //
//    [self.locLabel setTextAlignment:NSTextAlignmentCenter];
//    [self.locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.locView).with.insets(UIEdgeInsetsMake(5, 5, 0, 5));
//    }];
//
//    //statusContentLabel = [TTTAttributedLabel new];
//
//    [self.statusContentView addSubview:self.statusContentLabel];
//
//
//
//    //[statusContentLabel setFont:[UIFont fontWithName:@"DIN-Medium" size:22]];
//
//    self.statusContentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
//    [self.statusContentLabel setTextColor:[UIColor whiteColor]];
//    [self.statusContentLabel setBackgroundColor:[UIColor clearColor]];
//    [self.statusContentLabel setNumberOfLines:0];
//    [self.statusContentLabel setLineBreakMode:NSLineBreakByCharWrapping];
//    [self.statusContentLabel setTextAlignment:NSTextAlignmentLeft];
//    [self.statusContentLabel setContentMode:UIViewContentModeTop];
//    UIColor *activeTextColor = [self.statusContentView.backgroundColor colorByDarkeningTo:.6];
//    [self.statusContentLabel setLinkAttributes:@{(NSString*)kCTForegroundColorAttributeName : activeTextColor}];
//    [self.statusContentLabel setActiveLinkAttributes:@{(NSString *)kCTForegroundColorAttributeName : [UIColor redColor]}];
//    [self.statusContentLabel setDelegate:self];
//    self.statusContentLabel.enabledTextCheckingTypes = (NSTextCheckingTypeLink | NSTextCheckingTypeRegularExpression);
//
//    [self.statusContentLabel setText:@"There are 2 people in the world who can help me understand this @aaronofmontreal and @ibogost and #dragonkittens https://pic.twitter.com/cLihBxzddH There are 2 people in the world who can help me understand this There are 2 people in the world who can help me understand this Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut nec massa a ante dignissim mattis. Pellentesque gravida odio vel diam cras amet." afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//        //
//        return mutableAttributedString;
//        //
//    }];
//    /*
//     [label setText:[twitterStatus statusText] afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//     return mutableAttributedString;
//     }];
//     */
//
//    [self highlightMentionsInString:self.statusContentLabel.text withLabel:self.statusContentLabel withColor:activeTextColor isBold:NO isUnderlined:NO];
//
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
//    [self.statusContentView addGestureRecognizer:singleTap];
//    singleTap.delegate = self;
//
//    padding = UIEdgeInsetsMake(10, 10, 10, 2);
//
//
//    [self.statusContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.statusContentView.mas_top).with.offset(10);
//        make.left.equalTo(@10);
//        make.right.equalTo(self.statusContentView.mas_right).with.offset(-10);
//        //        make.width.equalTo(self.statusContentView.mas_width);
//        //        make.edges.equalTo(self.statusContentView).with.insets(padding);
//        //make.center.equalTo(self.statusContentView);
//    }];
//
//
//
//
//    // dummy view, which determines the size of the contentView size and therefore the scrollView contentSize
//    sizingView = UIView.new;
//    [self.scrollView addSubview:sizingView];
//    [sizingView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.statusContentView.mas_bottom).with.offset(50);
//        make.bottom.equalTo(contentView.mas_bottom);
//    }];
//
//    [self addSubview:self.scrollView];
//    [self addSubview:self.actionView];
//
//
//    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_bottom);
//        make.left.equalTo(@0);
//        make.width.equalTo(self.mas_width);
//        make.height.equalTo(@40);
//    }];
//
//
//    [self.statusContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@0);
//        //make.top.equalTo(self.locLabel.mas_bottom);
//        make.left.equalTo(@0);
//        make.width.equalTo(self.mas_width);
//        //make.bottom.equalTo(self.actionView.mas_top).with.offset(-10);
//        //make.height.equalTo(@(r.size.height));
//        make.bottom.equalTo(self.statusContentLabel.mas_bottom).with.offset(20);
//        //make.bottom.equalTo(@500);
//    }];
//
//}

- (void)actTap:(id)sender
{
    [self setName:[NSString stringWithFormat:@"BooBooBooBoo %@", sender]];//   @"BooBooBooBah"];
}





//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    CGPoint touchLocation = [_tileMap convertTouchToNodeSpace: touch];
//    // use your CGPoint
//    return YES;
//}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    CGPoint contentViewTap = [touch locationInView:self.statusContentView];
    CGPoint p = CGPointMake(contentViewTap.x-padding.left, contentViewTap.y-padding.top);
    //NSLog(@"point is=%@", NSStringFromCGPoint(p));
    
    if([self.statusContentLabel linkAtPoint:p] == nil) {
        return YES;
    } else {
        
        return NO;
    }
}




- (void)singleTap:(id)sender
{
    // where was the tap??
    CGPoint contentViewTap = [sender locationInView:self.statusContentView];
    // shift for any padding
    CGPoint p = CGPointMake(contentViewTap.x-padding.left, contentViewTap.y-padding.top);
    if([self.statusContentLabel linkAtPoint:p] == nil) {
        
        //        CGFloat actionBottom = self.actionView.frame.origin.y + self.actionView.frame.size.height;
        //        CGFloat r = self.frame.size.height-actionBottom;
        if(height == 0) {
            height = self.statusContentView.frame.size.height;
        }
        LOG_UI(0, @"Hello SIngle Tap");
        NSLog(@"Hello Single Tap");
        NSLog(@"%f", height);
        NSLog(@"%f", self.actionView.frame.origin.y);
#pragma mark open up the status content view
        if(self.statusContentViewOpen == NO) {
            [self.statusContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                //make.top.equalTo(self.locView.mas_bottom);
                //make.left.equalTo(@0);
                make.height.equalTo(@800);
                //make.bottom.equalTo(@800);
                //make.bottom.equalTo(self.actionView.mas_top).with.offset(250);
                //make.width.equalTo(self.mas_width);
            }];
            
        } else {
            [self.statusContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@0);
                make.left.equalTo(@0);
                make.width.equalTo(self.mas_width);
                //make.bottom.equalTo(label.mas_bottom);
                make.height.equalTo(@(height));
            }];
            /*
             [self.statusContentView mas_updateConstraints:^(MASConstraintMaker *make) {
             
             //make.bottom.equalTo(label.mas_bottom);
             
             make.height.equalTo(@(height));
             //make.bottom.equalTo(@400);
             // make.bottom.equalTo(self.actionView.mas_top).with.offset(-10);
             //make.top.equalTo(self.locView.mas_bottom);
             //make.left.equalTo(@0);
             //make.width.equalTo(self.mas_width);
             }];
             */
        }
        
        
        [self setNeedsUpdateConstraints];
        
        // update constraints now so we can animate the change
        [self updateConstraintsIfNeeded];
        
        [UIView animateWithDuration:.2 animations:^{
            [self layoutIfNeeded];
        }];
        
        self.statusContentViewOpen ^= YES;
        
    }
}

#pragma mark this is how we highlight @ style mentions and hashtags
- (void)highlightMentionsInString:(NSString *)string withLabel:(TTTAttributedLabel*)label withColor:(UIColor *)color isBold:(BOOL)bold isUnderlined:(BOOL)underlined
{
    NSRegularExpression *mentionExpression = [NSRegularExpression regularExpressionWithPattern:@"(?:^|\\s)((#|@)\\w+)" options:NO error:nil];
    
    NSArray *matches = [mentionExpression matchesInString:string
                                                  options:0
                                                    range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *match in matches) {
        //        NSRange matchRange = [match rangeAtIndex:1];
        //        NSString *mentionString = [text substringWithRange:matchRange];
        // NSRange linkRange = [text rangeOfString:mentionString];
        //        NSString* user = [mentionString substringFromIndex:1];
        //        NSString* linkURLString = [NSString stringWithFormat:@"user:%@", user];
        //        NSLog(@"%@", linkURLString);
        
        NSArray *keys = [[NSArray alloc] initWithObjects:(id)kCTForegroundColorAttributeName,(id)kCTUnderlineStyleAttributeName
                         , nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:color,[NSNumber numberWithInt:underlined ? kCTUnderlinePatternSolid : 0], nil];
        NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
        
        [label addLinkWithTextCheckingResult:match attributes:linkAttributes];
        // [self.label addLinkToURL:[NSURL URLWithString:linkURLString] withRange:linkRange];
    }
}


- (NSArray *)rangesOfString:(NSString *)searchString inString:(NSString *)str {
    NSMutableArray *results = [NSMutableArray array];
    NSRange searchRange = NSMakeRange(0, [str length]);
    NSRange range;
    while ((range = [str rangeOfString:searchString options:NSCaseInsensitiveSearch range:searchRange]).location != NSNotFound) {
        [results addObject:[NSValue valueWithRange:range]];
        searchRange = NSMakeRange(NSMaxRange(range), [str length] - NSMaxRange(range));
    }
    return results;
}


#pragma mark TTTAttributedLabelDelegate method
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    LOG_DEEBUG(0, @"clicked: %@", url);
    if(self.parent != nil) {
        [self.parent popWebViewFor:url over:self];
    }
}


- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithURL:(NSURL *)url atPoint:(CGPoint)point
{
    LOG_DEEBUG(0, @"%@ %@ %@", label, url, NSStringFromCGPoint(point));
    if(self.parent != nil) {
        [self.parent popWebViewFor:url over:self];
    }
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result
{
    NSString *link = [label.text substringWithRange:[result rangeAtIndex:1]];
    NSLog(@"link result=%@", link);
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (NSString *)cleanUpEntities:(NSString *)dirtyString
{
    //NSMutableString *result = dirtyString;
    NSString *x = [[[
                     dirtyString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]
                    stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"]
                   stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    
    return x;
    
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
