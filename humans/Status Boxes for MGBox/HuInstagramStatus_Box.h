//
//  InstagramMedia_Box.h
//  Humans
//
//  Created by Julian Bleecker on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MGTableBoxStyled.h"
#import "InstagramStatus.h"
#import "SwipeAwayMGLineStyled.h"
#import "UIImageView+AFNetworking.h"
#import "HuStatusPhotoBox.h"

@interface HuInstagramStatus_Box : MGTableBoxStyled {
    int count;
    MGLine *statusTextBox;
    MGLine *statusLine;
    MGLine *dateLine;
    NSArray *imgArray;
    HuStatusPhotoBox *mainPhotoBox;

}

@property (nonatomic, retain) InstagramStatus *status;
@property (nonatomic, assign) BOOL deferImageLoad;
//@property (nonatomic, retain) PhotoBox *mainPhotoBox;

    
- (void)buildContentBoxes;
- (void)setStatus:(InstagramStatus *)_status;
- (void)showOrRefreshPhoto;
@end
