//
//  HuSocialServiceUserProfileImagePhotoBox.m
//  Humans
//
//  Created by julian on 12/8/12.
//  Copyright (c) 2012 nearfuturelaboratory. All rights reserved.
//

#import "HuServiceUserProfilePhoto.h"

@implementation HuServiceUserProfilePhoto

@synthesize mFriend;
@synthesize longPresser, longPressable, onLongPress;

- (id)init
{
    self = [super init];
    if(self) {
        [self commonInit];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
   // UILongPressGestureRecognizer *foo;
}

+ (HuServiceUserProfilePhoto *)photoBoxForSocialServiceUser:(HuFriend*)_friend size:(CGSize)size
{
    return [HuServiceUserProfilePhoto photoBoxForSocialServiceUser:_friend size:size deferLoad:NO];
}


+ (HuServiceUserProfilePhoto *)photoBoxForSocialServiceUser:(HuFriend*)_friend size:(CGSize)size deferLoad:(BOOL)deferLoad
{
    HuServiceUserProfilePhoto *box = [HuServiceUserProfilePhoto boxWithSize:size];
    [box setMFriend:_friend];
    box.urlStr = [_friend imageURL];
    
    // add a loading spinner
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.center = CGPointMake(box.width / 2, box.height / 2);
    spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin
    | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleLeftMargin;
    spinner.color = UIColor.lightGrayColor;
    [box addSubview:spinner];
    [spinner startAnimating];
    
    if(deferLoad == NO) {
        // do the photo loading async, because internets
        __block id bbox = box;
        box.asyncLayoutOnce = ^{
            [bbox loadPhoto];
        };
    }
    return box;
}

- (void)setOnLongPress:(LongPressHandler)_onLongPress {
    onLongPress = _onLongPress;
    if (onLongPress) {
        self.longPressable = YES;
    }
}

- (void)longPressed:(UILongPressGestureRecognizer *)longPressRecognizer {
    if (self.onLongPress) {
        self.onLongPress(longPressRecognizer);
    }
}

- (void)setLongPressable:(BOOL)aLongPressable
{
    [super setLongPressable:aLongPressable];
}

- (UILongPressGestureRecognizer *)longPresser {
    if (!longPresser) {
        longPresser = [[UILongPressGestureRecognizer alloc]
                       initWithTarget:self action:@selector(longPressed:)];
    }
    return longPresser;
}

- (void)loadPhotoWithCompletionHandler:(CompletionHandler)handler {
    
    if(self.hasLoaded == NO) {
        
        
        if(self.imageView == nil) {
            self.imageView = [[UIImageView alloc]init];
            [self addSubview:self.imageView];
        } else {
            [self.imageView removeFromSuperview];
        }
        
        //NSAssert(self.urlStr, @"%@", self);
        NSURL *url = [[NSURL alloc]initWithString:self.urlStr];
        
        __weak HuServiceUserProfilePhoto* bself = self;
        
        [self.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"angry_unicorn"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if(error == nil) {
                bself.hasLoaded = YES;
            } else {
                LOG_ERROR(0, @"Error getting image at %@ with error=%@", [url description], error);
                image = [UIImage imageNamed:@"angry_unicorn.png"];
            }
            Boolean notFromCache = (cacheType == SDImageCacheTypeNone);
            
            LOG_UI_VERBOSE(0, @"Got it from cache? %@ %@", (notFromCache == YES)?@"NO":@"YES", error);

            CGSize dstSize = [image aspectMaintainedSizeToFit:[bself size]];
            //LOG_UI_VERBOSE(0, @"Profile Image Is %zu by %zu", CGImageGetWidth(image.CGImage) ,CGImageGetHeight(image.CGImage));
            
            UIImage *resized_image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:dstSize interpolationQuality:kCGInterpolationHigh];
            bself.autoresizingMask = UIViewAutoresizingNone;
                        
            [bself.imageView setImage:resized_image];
            //LOG_UI_VERBOSE(0, @"Resized Profile Image Is %zu by %zu", CGImageGetWidth(resized_image.CGImage) ,CGImageGetHeight(resized_image.CGImage));

            if(bself.mask != nil) {
                CALayer *mask_layer = [CALayer layer];
                //UIImage *mask_img = self.mask;
                mask_layer.contents = (id)[bself.mask CGImage];
                mask_layer.frame = CGRectMake(0, 0, CGImageGetWidth([bself.mask CGImage]), CGImageGetHeight([bself.mask CGImage]));
                bself.imageView.layer.mask = mask_layer;
                bself.imageView.layer.masksToBounds = YES;
            }
            
            
            
            // do UI stuff back in UI land
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // ditch the spinner
                UIActivityIndicatorView *spinner = [bself.subviews objectAtIndex:0];
                [spinner stopAnimating];
                [spinner removeFromSuperview];
                
                [bself.imageView removeFromSuperview];
                
                // [bself.imageView setImage:[UIImage imageNamed:@"arrow"]];
                //[bself.imageView setImage:resized_image];
                
                // failed to get the photo?
                if (error) {
                    bself.alpha = 0.3;
                    return;
                }
                
                // but wait..it might already contain the UIImageView, right?
                bself.imageView.size = resized_image.size;
                bself.imageView.alpha = 0;
                bself.imageView.backgroundColor = [UIColor clearColor];
                bself.imageView.autoresizingMask = UIViewAutoresizingNone;
                bself.imageView.contentMode = UIViewContentModeScaleAspectFit | UIViewContentModeCenter;
                
                [bself addSubview:bself.imageView];
                
                // center the image..
                
                //[bself setSize:CGSizeMake(bself.size.width, bself.imageView.size.height)];
                // will this center us??
                [bself.imageView setCenter:CGPointMake(bself.size.width/2, bself.size.height/2)];
                
                if(bself.serviceTinyTag != nil) {
                    UIImageView *badgeView = [[UIImageView alloc]initWithImage:bself.serviceTinyTag ];
                    int badge_width = CGImageGetWidth([bself serviceTinyTag].CGImage);
                    int badge_height = CGImageGetHeight([bself serviceTinyTag].CGImage);
                    
                    
                    
                    [badgeView setFrame:CGRectMake(bself.imageView.size.width-badge_width, bself.imageView.size.height-badge_height, badge_width, badge_height)];
                    [bself addSubview:badgeView];
                }
                
                
                
                [bself.topParentBox layout];
                [bself setNeedsDisplay];
                
                if(handler) {
                    handler();
                }
                
                
                // fade the image in
                [UIView animateWithDuration:0.4 animations:^{
                    bself.imageView.alpha = 1;
                }];
                
                
                
                
            });
        }];
    }
}

-(BOOL)isEqual:(id)object
{
    BOOL result = NO;
    if([object isKindOfClass:[HuServiceUserProfilePhoto class]]) {
        
        result = [[self mFriend] isEqual:[(HuServiceUserProfilePhoto *)object mFriend]];
    }
    return result;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash += [[[self mFriend]serviceUserID] hash];
    hash += [[[self mFriend]serviceName] hash];
    return hash;
}


-(UIImage *)drawImage:(UIImage*)profileImage withBadge:(UIImage *)badge
{
    UIGraphicsBeginImageContextWithOptions(profileImage.size, NO, 0.0f);
    [profileImage drawInRect:CGRectMake(0, 0, profileImage.size.width, profileImage.size.height)];
    [badge drawInRect:CGRectMake(0, profileImage.size.height - badge.size.height, badge.size.width, badge.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
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
