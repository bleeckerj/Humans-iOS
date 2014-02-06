//
//  HuSocialServiceUserProfileImagePhotoBox.h
//  Humans
//
//  Created by julian on 12/8/12.
//  Copyright (c) 2012 nearfuturelaboratory. All rights reserved.
//

#import "PhotoBox.h"
#import "HuFriend.h"
#import "HuProfilePhotoBlank.h"
#import "defines.h"
#import "LoggerClient.h"

@interface HuServiceUserProfilePhoto : PhotoBox

@property (nonatomic, strong) HuFriend *mFriend;
@property (nonatomic, copy) LongPressHandler onLongPress;

+ (HuServiceUserProfilePhoto *)photoBoxForSocialServiceUser:(HuFriend*)aFriend size:(CGSize)size;
+ (HuServiceUserProfilePhoto *)photoBoxForSocialServiceUser:(HuFriend*)aFriend size:(CGSize)size deferLoad:(BOOL)deferLoad;

@end
