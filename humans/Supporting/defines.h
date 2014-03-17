#import "LoggerClient.h"
#import <Parse/Parse.h>
#import "Flurry.h"

#define IMAGEDEBUG
#define CA_DEBUG_TRANSACTIONS
#define ARC4RANDOM_MAX      0x100000000

#ifndef DEPRECATED_ATTRIBUTE_M
#if __has_attribute(deprecated)
#define DEPRECATED_ATTRIBUTE_M(...) __attribute__((deprecated(__VA_ARGS__)))
#else
#define DEPRECATED_ATTRIBUTE_M(...) DEPRECATED_ATTRIBUTE
#endif
#endif

#define ASYNC_START    __block BOOL hasCalledBack = NO;
#define ASYNC_DONE     hasCalledBack = YES;
#define ASYNC_END      NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10]; \
while (hasCalledBack == NO && [loopUntil timeIntervalSinceNow] > 0) { \
[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil]; \
} \
if (!hasCalledBack) { assert(@"Timeout"); }


#ifdef DEBUG


#define LOG_TODO(level, ...)    LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"todo",level,__VA_ARGS__)
#define LOG_DEEBUG(level, ...)   LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"debug",level,__VA_ARGS__)
#define LOG_TEST(level, ...)    LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"test",level,__VA_ARGS__)
#define LOG_DEBUG(level, ...)   LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"debug",level,__VA_ARGS__)

#define LOG_ERROR(level, ...)    LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"error",level,__VA_ARGS__)

#define LOG_NETWORK(level, ...)    LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"network",level,__VA_ARGS__)
#define LOG_GENERAL(level, ...)    LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"general",level,__VA_ARGS__)
#define LOG_GRAPHICS(level, ...)   LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"graphics",level,__VA_ARGS__)
#define LOG_GENERAL_IMAGE(level, ...) LogImageDataF(__FILE__, __LINE__, __FUNCTION__, @"general-image", level, __VA_ARGS__)
#define LOG_CONSOLE(...) LogMessageCompat(@"HEYYYYAYAYAYYA")

#define LOG_UI(level, ...) LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"ui",level,__VA_ARGS__)
#define LOG_UI_VERBOSE(level, ...) LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"ui-verbose",level,__VA_ARGS__)

#define LOG_INSTAGRAM(level, ...)   LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"instagram",level,__VA_ARGS__)
#define LOG_INSTAGRAM_VERBOSE(level, ...) LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"instagram-verbose",level,__VA_ARGS__)
#define LOG_INSTAGRAM_IMAGE(level, ...) LogImageDataF(__FILE__, __LINE__, __FUNCTION__, @"instagram-image", level, __VA_ARGS__)

#define LOG_TWITTER(level, ...)   LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"twitter",level,__VA_ARGS__)
#define LOG_TWITTER_VERBOSE(level, ...)   LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"twitter-verbose",level,__VA_ARGS__)
#define LOG_TWITTER_IMAGE(level, ...)   LogImageDataF(__FILE__, __LINE__, __FUNCTION__, @"twitter-image", level, __VA_ARGS__)

#define LOG_FLICKR(level, ...)   LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"flickr",level,__VA_ARGS__)
#define LOG_FLICKR_VERBOSE(level, ...)   LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"flickr-verbose",level,__VA_ARGS__)
#define LOG_FLICKR_IMAGE(level, ...)   LogImageDataF(__FILE__, __LINE__, __FUNCTION__, @"flickr-image", level, __VA_ARGS__)

#define LOG_FOURSQUARE(level, ...)   LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"foursquare",level,__VA_ARGS__)
#define LOG_FOURSQUARE_VERBOSE(level, ...)   LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"foursquare-verbose",level,__VA_ARGS__)
#define LOG_FOURSQUARE_IMAGE(level, ...)   LogImageDataF(__FILE__, __LINE__, __FUNCTION__, @"foursquare-image", level, __VA_ARGS__)


#else
#define LOG_TODO(...)    do{}while(0)
#define LOG_DEEBUG(...)    do{}while(0)
#define LOG_DEBUG(...)    do{}while(0)

#define LOG_TEST(...)    do{}while(0)

#define LOG_NETWORK(...)    do{}while(0)
#define LOG_GENERAL(...)    do{}while(0)
#define LOG_GRAPHICS(...)   do{}while(0)
#define LOG_GENERAL_IMAGE(...) do{}while(0)
#define LOG_CONSOLE(level, ...) do{}while(0)
#define LOG_UI(level, ...) do{}while(0)
#define LOG_UI_VERBOSE(level, ...) do{}while(0)



#define LOG_INSTAGRAM(...)   do{}while(0)
#define LOG_INSTAGRAM_VERBOSE(...) do{}while(0)
#define LOG_INSTAGRAM_IMAGE(...) do{}while(0)

#define LOG_TWITTER(...)   do{}while(0)
#define LOG_TWITTER_VERBOSE(...) do{}while(0)
#define LOG_TWITTER_IMAGE(level, ...) do{}while(0)

#define LOG_FLICKR(...)   do{}while(0)
#define LOG_FLICKR_VERBOSE(level, ...) do{}while(0)
#define LOG_FLICKR_IMAGE(level, ...) do{}while(0)

#define LOG_FOURSQUARE(...) do {}while(0)
#define LOG_FOURSQUARE_VERBOSE(level, ...) do{}while(0)
#define LOG_FOURSQUARE_IMAGE(level, ...) do{}while(0)


#endif

#define LOG_ERROR(level, ...) LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"error",level,__VA_ARGS__)

#define MISSING_PROFILE_IMAGE_NAME  @"angry_unicorn_tiny"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UNIQUE_APP_KEYCHAIN_SERVICE_NAME  @"humans-ios"
#define CLIENT_NAME                         @"ioshumans"

#define UICOLOR_FRONT           [UIColor whiteColor];
#define UICOLOR_SHADOW          [UIColor lightGrayColor];
#define UICOLOR_BACK            [UIColor darkGrayColor];

#define BUTTON_FONT_SMALL       [UIFont fontWithName:@"AvenirNext-Regular" size:18]
#define BUTTON_FONT_LARGE       [UIFont fontWithName:@"AvenirNext-Medium" size:26]
#define TEXTFIELD_FONT_LARGE    [UIFont fontWithName:@"AvenirNext-Medium" size:26]
#define TEXTFIELD_FONT_SMALL    [UIFont fontWithName:@"AvenirNext-Regular" size:18]

#define ALERT_FONT_LIGHT     [UIFont fontWithName:@"AvenirNext-Regular" size:16]

#define HEADLINE_FONT           [UIFont fontWithName:@"AvenirNext-Medium" size:18]
#define HEADLINE_FONT_LIGHT     [UIFont fontWithName:@"AvenirNext-Regular" size:16]
#define HEADLINE_FONT_SMALL     [UIFont fontWithName:@"AvenirNext-Regular" size:14]
#define HEADLINE_FONT_SMALL_BOLD [UIFont fontWithName:@"AvenirNext-Medium" size:14]

#define HEADER_FONT             [UIFont fontWithName:@"AvenirNext-Medium" size:14]
#define HEADER_FONT_LARGE       [UIFont fontWithName:@"AvenirNext-Medium" size:20]

#define LOGIN_VIEW_FONT_LARGE    [UIFont fontWithName:@"AvenirNext-Medium" size:32]

#define PROFILE_VIEW_FONT_LARGE  [UIFont fontWithName:@"AvenirNext-Medium" size:24]
#define PROFILE_VIEW_FONT_SMALL  [UIFont fontWithName:@"AvenirNext-Medium" size:16]
#define PROFILE_VIEW_FONT_COLOR  [UIColor whiteColor]
#define PROFILE_HALF_HEIGHT_VIEW_BORDER_COLOR [UIColor lightGrayColor]

#define TWITTER_FONT           [UIFont fontWithName:@"AvenirNext-Regular" size:16]

#define TWITTER_COLOR           [UIColor Twitter]
#define TWITTER_STATUS_VIEW_BGCOLOR  UIColorFromRGB(0x000000)
#define TWITTER_STATUS_VIEW_FGCOLOR  UIColorFromRGB(0xF0F0F0)
#define TWITTER_COLOR_IMAGE     @"twitter-bird-color.png"
#define TWITTER_GRAY_IMAGE      @"twitter-bird-gray.png"
#define TWITTER_TINY_GRAY_IMAGE @"twitter-bird-gray-tiny.png"

#define INSTAGRAM_STATUS_TEXT_FONT            [UIFont fontWithName:@"AvenirNext-Regular" size:16]
#define INSTAGRAM_TEXT_COLOR    [UIColor blackColor]
#define INSTAGRAM_COLOR         [UIColor Instagram]
#define INSTAGRAM_COLOR_HEX     0xffc03f
#define INSTAGRAM_COLOR_IMAGE   @"instagram-camera-color.png"
#define INSTAGRAM_GRAY_IMAGE    @"instagram-camera.png"
#define INSTAGRAM_TINY_GRAY_IMAGE @"instagram-camera-gray-tiny.png"

#define FLICKR_FONT             [UIFont fontWithName:@"AvenirNext-Regular" size:16]
#define FLICKR_TEXT_COLOR       [UIColor blackColor]
#define FLICKR_COLOR            [UIColor FlickrPink]
#define FLICKR_COLOR_IMAGE      @"flickr-peepers-color.png"
#define FLICKR_GRAY_IMAGE       @"flickr-peepers.png"
#define FLICKR_TINY_GRAY_IMAGE  @"flickr-peepers-gray-tiny.png"


#define FOURSQUARE_FONT         [UIFont fontWithName:@"AvenirNext-Regular" size:16]
#define FOURSQUARE_TEXT_COLOR   [UIColor blackColor]
#define FOURSQUARE_COLOR        [UIColor Foursquare]
#define FOURSQUARE_COLOR_IMAGE @"foursquare-icon-36x36.png"
#define FOURSQUARE_GRAY_IMAGE @"foursquare-icon-gray-36x36.png"
#define FOURSQUARE_TINY_GRAY_IMAGE @"foursquare-icon-gray-16x16.png"

#define TUMBLR_COLOR_IMAGE @"angry_unicorn_tiny.png"
#define TUMBLR_TINY_GRAY_IMAGE @"angry_unicorn_tiny.png"

#define FACEBOOK_COLOR_IMAGE @"angry_unicorn_tiny.png"
#define FACEBOOK_TINY_GRAY_IMAGE @"angry_unicorn_tiny.png"

#define COUNT_LABEL_FONT        [UIFont fontWithName:@"AvenirNext-Regular" size:12]

#define INFO_FONT_LARGE         [UIFont fontWithName:@"AvenirNext-Medium" size:16]
#define INFO_FONT_MEDIUM        [UIFont fontWithName:@"AvenirNext-Regular" size:14]
#define INFO_FONT_SMALL         [UIFont fontWithName:@"AvenirNext-Regular" size:12]

#define SEARCH_AVATAR_SIZE      (CGSize){80,80}

//#define ROW_SIZE                (CGSize){320, 180}
#define ROW_SIZE               (CGSize){304, 44}



#define ROW_SIZE_WITH_IMAGE_IPHONE     (CGSize){320, 340}
#define ROW_SIZE_WITH_IMAGE_IPHONE_5     (CGSize){320, 400}

#define DATELINE_ROW_SIZE       (CGSize){320, 30}
#define DATELINE_TEXT_COLOR     [UIColor lightGrayColor]
#define DATELINE_FONT           [UIFont fontWithName:@"HelveticaNeue" size:12]


#define TEXT_LEFT_PADDING       10.0
#define TEXT_RIGHT_PADDING      10.0
#define TEXT_TOP_PADDING        4.0
#define TEXT_BOTTOM_PADDING     10.0

#define kOFFSET_FOR_KEYBOARD        216.0f


#define WIDTH       320.0
#define TOP_MARGIN    0.0
#define BOTTOM_MARGIN 0.0
#define LEFT_MARGIN   0.0
#define CORNER_RADIUS 2.0

#define MAX_THEN_TRIM_SERVICE_STATUS_ARRAY 10000
#define STATUS_PER_LOAD  @"40"
#define ANCIENT_MONTHS_AGO      6
//#define MAX_INSTAGRAM_FETCH     @"30"

// for the launcher in HuFriendsLauncher_ViewController
#define FRIEND_LAUNCHER_ROW_SIZE (CGSize){320, 205}
#define PROFILE_IMAGE_CORNER_RADIUS 20
#define PROFILE_IMAGE_SIZE_FACTOR 0.8

#define HEADER_HEIGHT 65
#define HEADER_SIZE (CGSize){320, HEADER_HEIGHT}



#define TOOLBAR_HEIGHT 55

#define LARGE_HEADER_HEIGHT 80
#define LARGE_HEADER_SIZE (CGSize){320, LARGE_HEADER_HEIGHT}

#define IPHONE_PORTRAIT_PHOTO  (CGSize){148, 148}
#define IPHONE_LANDSCAPE_PHOTO (CGSize){152, 152}

#define IPHONE_PORTRAIT_GRID   (CGSize){312, 0}
#define IPHONE_LANDSCAPE_GRID  (CGSize){160, 0}
#define IPHONE_TABLES_GRID     (CGSize){320, 0}

#define IPAD_PORTRAIT_PHOTO    (CGSize){128, 128}
#define IPAD_LANDSCAPE_PHOTO   (CGSize){122, 122}

#define IPAD_PORTRAIT_GRID     (CGSize){136, 0}
#define IPAD_LANDSCAPE_GRID    (CGSize){390, 0}
#define IPAD_TABLES_GRID       (CGSize){624, 0}




#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#define INTERFACE_IS_PAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

// full height of iphone5 including status bar is 568 (108 pixels taller than previous iphones
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


#define IS_IPHONE (  [ [ [ UIDevice currentDevice ] model ] rangeOfString: @"iPhone" ].location  != NSNotFound )
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] rangeOfString: @"iPod touch" ].location != NSNotFound )
#define IS_IPHONE_5 ( IS_IPHONE && IS_WIDESCREEN )
#define IPHONE_5_PORTRAIT_SIZE  (CGSize){320, 548}
#define IPHONE_PORTRAIT_SIZE  (CGSize){320, 460}
#define IPHONE_5_PORTRAIT_RECT (CGRect){0,0,320,548}
#define IPHONE_PORTRAIT_RECT (CGRect){0,0,320,460}
#define IPHONE_5_PORTRAIT_SIZE_HEIGHT 548
#define IPHONE_PORTRAIT_SIZE_HEIGHT 460

#define kNetworkLostErrorDomain @"kNetworkLostError"

#define MAX_USERS_PER_FRIEND 12

#pragma mark -------- TYPEDEFS -----------------
typedef void(^UIImageViewResultsHandler)(UIImageView *image_view);
typedef void(^ArrayOfResultsHandler)(NSMutableArray *results);
typedef void(^BlockIteratorHandler)(id status, NSUInteger idx, BOOL *stop);
typedef void(^FetchStatusHandler)(BOOL success, NSMutableArray *status, NSError *error);
typedef void(^FetchDataHandler)(BOOL success, NSError *error);
typedef void(^FetchProfileDataHandler)(BOOL success, UIImage* profileImage, id JSON);
typedef void(^SearchResultsHandler)(id JSON, NSError *error);
typedef void(^FetchImageHandler)(UIImage *image, NSError *error);
typedef void(^CompletionHandler)(void);
typedef void(^CompletionHandlerWithResult)(BOOL success, NSError *error);
typedef void(^CompletionHandlerWithData)(id data, BOOL success, NSError *error);
typedef void(^StatusAwareCompletionHandler)(BOOL success, NSError *error);
typedef void(^LongPressHandler)(UILongPressGestureRecognizer *recog);
typedef void(^Handler)();
typedef void(^WebViewHandler)(UIWebView *webView);
typedef void(^WebViewHandlerWithError)(UIWebView *webView, NSError *error);
typedef void(^BlockCallback)();
typedef enum {
    kListGridView = 0,
    kHalfHeightScrollView,
    kFullHeightScrollView
} tViewType;