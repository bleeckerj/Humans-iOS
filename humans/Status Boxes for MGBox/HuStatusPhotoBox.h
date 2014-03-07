//
//  Created by matt on 28/09/12.
//

#import "MGBox.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Resize.h"
#import "UIImage+ResizeToFit.h"
//#import "Flurry.h"
#import <SDWebImage/SDWebImageManager.h>
#import "defines.h"

@interface HuStatusPhotoBox : MGBox {
}
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) UIView<MGLayoutBox> *topParentBox;
@property (nonatomic, assign) BOOL hasLoaded;
@property (nonatomic, strong) UIImage *mask;
@property (nonatomic, strong) UIImage *serviceTinyTag;

+ (HuStatusPhotoBox *)photoAddBoxWithSize:(CGSize)size;
//+ (HuStatusPhotoBox *)photoBoxFor:(int)i size:(CGSize)size;
+ (HuStatusPhotoBox *)photoBoxFor:(NSString *)url size:(CGSize)size;
+ (HuStatusPhotoBox *)photoBoxFor:(NSString *)url size:(CGSize)size deferLoad:(BOOL)deferLoad;
- (void)loadPhoto;
- (void)loadPhotoWithCompletionHandler:(CompletionHandlerWithResult)handler;

@end
