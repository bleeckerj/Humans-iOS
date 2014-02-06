//
//  FlickrStatus_Box.h
//  Humans
//
//  Created by julian on 7/30/12.
//
//

#import "DateyMGStyledBox.h"
//#import "HuFlickrStatus.h"
//#import "ScrollingBoxes_ViewController.h"
#import "HuStatusPhotoBox.h"
#import "MGLine.h"
#import "MGTableBox.h"

@interface HuFlickrStatus_Box : MGTableBox
{
    int count;
    MGLine *statusTextBox;
    MGLine *statusLine;
    MGLine *dateLine;
    //NSArray *imgArray;
    HuStatusPhotoBox *mainPhotoBox;

}

@property (nonatomic, retain) FlickrStatus *status;
@property (nonatomic, assign) BOOL deferImageLoad;
//@property (nonatomic, retain) PhotoBox *mainPhotoBox;


- (void)buildContentBoxes;
//- (void)setStatus:(FlickrStatus *)_status;
- (void)showOrRefreshPhoto;

@end
