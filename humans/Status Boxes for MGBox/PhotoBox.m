//
//  Created by matt on 28/09/12.
//

#import "PhotoBox.h"
#import "defines.h"
#import "LoggerClient.h"

@implementation PhotoBox
@synthesize topParentBox;


#pragma mark - Init

- (void)setup {
    
    self.hasLoaded = NO;
    // positioning
    self.topMargin = 8;
    self.leftMargin = 8;
    
    // background
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    // shadow
    self.layer.shadowColor = [UIColor colorWithWhite:0.12 alpha:1].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 1;
}

#pragma mark - Factories

+ (PhotoBox *)photoAddBoxWithSize:(CGSize)size {
    
    // basic box
    PhotoBox *box = [PhotoBox boxWithSize:size];
    
    // style and tag
    box.backgroundColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.75 alpha:1];
    box.tag = -1;
    
    // add the add image
    UIImage *add = [UIImage imageNamed:@"add"];
    UIImageView *addView = [[UIImageView alloc] initWithImage:add];
    [box addSubview:addView];
    addView.center = (CGPoint){box.width / 2, box.height / 2};
    addView.alpha = 0.2;
    addView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin
    | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleLeftMargin;
    
    return box;
}

+ (PhotoBox *)photoBoxFor:(NSString *)_urlStr size:(CGSize)size deferLoad:(BOOL)deferLoad
{
    PhotoBox *box = [PhotoBox boxWithSize:size];
    box.urlStr = _urlStr;
    //box.topParentBox = _topParentBox;
    
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



+ (PhotoBox *)photoBoxFor:(NSString *)_urlStr size:(CGSize)size
{
    return [self photoBoxFor:_urlStr size:size deferLoad:NO];
}


#pragma mark - Layout

- (void)layout {
    [super layout];
    
    // speed up shadows
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

#pragma mark - Photo box loading

- (void)loadPhoto
{
    [self loadPhotoWithCompletionHandler:nil];
}

- (void)loadPhotoWithCompletionHandler:(CompletionHandler)handler {
    
    if(self.hasLoaded == NO) {
        
        
        if(self.imageView == nil) {
            self.imageView = [[UIImageView alloc]init];
            [self addSubview:self.imageView];
        } else {
            [self.imageView removeFromSuperview];
        }
        
        NSAssert(self.urlStr, @"%@", self);
    NSURL *url = [[NSURL alloc]initWithString:self.urlStr];
    
    __weak PhotoBox* bself = self;
    
    [self.imageView setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSUInteger receivedSize, long long expectedSize) {
        //
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        LOG_UI_VERBOSE(0, @"Got it from none=0, disk=1, memory2 [%d] %@", cacheType, error);

        if(error == nil) {
            bself.hasLoaded = YES;
        }
        CGSize paddedSize = CGSizeMake(bself.width-bself.leftPadding - bself.rightPadding -  bself.margin.left - bself.margin.right, bself.height - bself.leftPadding - bself.rightPadding);
        
        
        CGSize dstSize = [image aspectMaintainedSizeToFit:paddedSize];

        UIImage *resized_image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:dstSize interpolationQuality:kCGInterpolationHigh];
        bself.autoresizingMask = UIViewAutoresizingNone;
 
        [bself.imageView setImage:resized_image];
        
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
            
            // got the photo, so lets show it
            //UIImage *image = [UIImage imageWithData:data];
            //UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            
//            [self.imageView setBackgroundColor:[UIColor greenColor]];
            
            // but wait..it might already contain the UIImageView, right?
            bself.imageView.size = resized_image.size;
            bself.imageView.alpha = 0;
            bself.imageView.backgroundColor = [UIColor clearColor];
            bself.imageView.autoresizingMask = UIViewAutoresizingNone;
            bself.imageView.contentMode = UIViewContentModeScaleAspectFit | UIViewContentModeCenter;
            [bself addSubview:bself.imageView];
            
            // center the image..
            
            //[bself setSize:CGSizeMake(bself.size.width, bself.imageView.size.height)];
            [bself.imageView setCenter:CGPointMake(45, 45)];

            if(bself.serviceTinyTag != nil) {
                //UIImage *badge = [UIImage imageNamed:bself.serviceTinyTag];
                //resized_image = [bself drawImage:resized_image withBadge:bself.serviceTinyTag];
                //bself.imageView.image = [bself drawImage:bself.imageView.image withBadge:bself.serviceTinyTag];
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
            [UIView animateWithDuration:0.8 animations:^{
                bself.imageView.alpha = 1;
            }];
            
            
            
            
        });
    }];
    }
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


-(NSString *)description
{
    NSString *result = [NSString stringWithFormat:@"%@ %@ Has Loaded[%@]", [super description], self.urlStr, (self.hasLoaded?@"YES":@"NO")];
    return result;
}

@end
