//
//  Created by matt on 28/09/12.
//

#import "MGBox.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ResizeToFit.h"
#import "UIImage+Resize.h"

#import "SDWebImageManager.h"
#import "defines.h"

@interface PhotoBox : MGBox {
}
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) UIView<MGLayoutBox> *topParentBox;
@property (nonatomic, assign) BOOL hasLoaded;
@property (nonatomic, strong) UIImage *mask;
@property (nonatomic, strong) UIImage *serviceTinyTag;

+ (PhotoBox *)photoAddBoxWithSize:(CGSize)size;
//+ (PhotoBox *)photoBoxFor:(int)i size:(CGSize)size;
+ (PhotoBox *)photoBoxFor:(NSString *)url size:(CGSize)size;
+ (PhotoBox *)photoBoxFor:(NSString *)url size:(CGSize)size deferLoad:(BOOL)deferLoad;
- (void)loadPhoto;
- (void)loadPhotoWithCompletionHandler:(CompletionHandler)handler;

@end
