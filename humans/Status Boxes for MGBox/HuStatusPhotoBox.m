//
//  Created by matt on 28/09/12.
//

#import "HuStatusPhotoBox.h"
#import "defines.h"
#import "LoggerClient.h"
//#import "AppDelegate.h"

@implementation HuStatusPhotoBox
@synthesize topParentBox, serviceTinyTag;
@synthesize urlStr;

#pragma mark - Init

- (void)setup {
    
    self.hasLoaded = NO;
    // positioning
    self.topMargin = 0;
    self.leftMargin = 0;
    self.bottomMargin = 0;
    self.bottomPadding = 0;
    // background
    self.backgroundColor = [UIColor whiteColor];
    
    // shadow
//    self.layer.shadowColor = [UIColor colorWithWhite:0.12 alpha:1].CGColor;
//    self.layer.shadowOffset = CGSizeMake(0, 0.5);
//    self.layer.shadowRadius = 1;
//    self.layer.shadowOpacity = 1;
}

#pragma mark - Factories

+ (HuStatusPhotoBox *)photoAddBoxWithSize:(CGSize)size {
    
    // basic box
    HuStatusPhotoBox *box = [HuStatusPhotoBox boxWithSize:size];
    
    // style and tag
    box.backgroundColor = UIColorFromRGB(0xF0F0F0);
    box.tag = -1;
    return box;
}

+ (HuStatusPhotoBox *)photoBoxFor:(NSString *)_urlStr size:(CGSize)size deferLoad:(BOOL)deferLoad
{
    HuStatusPhotoBox *box = [HuStatusPhotoBox boxWithSize:size];
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
    spinner.color = UIColor.darkGrayColor;
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



+ (HuStatusPhotoBox *)photoBoxFor:(NSString *)_urlStr size:(CGSize)size
{
    return [self photoBoxFor:_urlStr size:size deferLoad:NO];
}


#pragma mark - Layout

- (void)layout {
    [super layout];
    
    // speed up shadows
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (void)setUrlStr:(NSString *)murlStr
{
    if([murlStr compare:urlStr] != NSOrderedSame) {
        urlStr = murlStr;
        self.hasLoaded = NO;
    }
}

#pragma mark - Photo box loading

- (void)loadPhoto
{
    [self loadPhotoWithCompletionHandler:nil];
}

- (void)loadPhotoWithCompletionHandler:(CompletionHandlerWithResult)handler {
    
    if(self.hasLoaded == NO) {
        if(self.imageView == nil) {
            self.imageView = [[UIImageView alloc]init];
            [self addSubview:self.imageView];
        } else {
            [self.imageView removeFromSuperview];
        }
        
        NSAssert(self.urlStr, @"No urlStr %@", self);
        
        if(self.urlStr == nil) {
            if(handler) {
                //[Flurry logEvent:[NSString stringWithFormat:@"No url for photo"]];
                handler(NO, nil);
            }
        }
        
        NSURL *url = [[NSURL alloc]initWithString:self.urlStr];
        
        __weak HuStatusPhotoBox* bself = self;
        
      
        [self.imageView setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //
            LOG_UI(0, @"Progress for image %d %d", receivedSize, expectedSize);
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            LOG_UI(0, @"Was image cached? %d", cacheType);

            if(error == nil) {
                bself.hasLoaded = YES;
            } else {
                bself.hasLoaded = NO;
                bself.alpha = 0.3;
                if(handler) {
                    handler(NO, error);
                }
            }
            //                //dispatch_async(dispatch_get_main_queue(), ^{
            //                AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
            //                [delegate annunciate:@"Woops. Bad Internet. Angry Unicorns."];
            //                [self.imageView setImage:[UIImage imageNamed:@"angry_unicorn"]];
            //                //});
            //                //return;

            CGSize paddedSize = CGSizeMake(bself.width-bself.leftPadding - bself.rightPadding, bself.height - bself.topPadding - bself.bottomPadding);
            
            CGSize dstSize = [image aspectMaintainedSizeToFit:paddedSize];
        
            UIImage *resized_image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:dstSize interpolationQuality:kCGInterpolationHigh];
            
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
                
                // but wait..it might already contain the UIImageView, right?
                bself.imageView.size = resized_image.size;
                bself.imageView.alpha = 0;
                bself.imageView.backgroundColor = [UIColor blueColor];
                bself.imageView.autoresizingMask = UIViewAutoresizingNone;
                bself.imageView.contentMode = UIViewContentModeScaleAspectFit | UIViewContentModeCenter;
                [bself addSubview:bself.imageView];
                // center the image..
                [bself setFrame:CGRectMake(0, 0, bself.imageView.size.width, bself.imageView.size.height)];
                [bself.imageView setCenter:CGPointMake(bself.size.width/2, bself.imageView.height/2)];
                
                
                [bself layoutWithSpeed:0.2 completion:nil];
                [bself performSelectorOnMainThread:@selector(needsDisplay) withObject:nil waitUntilDone:YES];
                
                [bself.topParentBox layout];
                //[bself setNeedsDisplay];
                
                
                
                // fade the image in
                [UIView animateWithDuration:0.5 animations:^{
                    bself.imageView.alpha = 1;
                }];
                
                if(handler) {
                    handler(YES, nil);
                }

                
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
