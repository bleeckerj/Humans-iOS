//
//  JBAttributedAwareScrollView.m
//
//  Created by Julian Bleecker on 4/10/14.
//  Copyright (c) 2014 Julian Bleecker. All rights reserved.
//

#import "JBAttributedAwareScrollView.h"
@interface JBAttributedAwareScrollView()
@property (strong, nonatomic) UIScrollView *scrollView;
@end
@implementation JBAttributedAwareScrollView
@synthesize text, font;

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor = self.superview.backgroundColor;
    [self addSubview:scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.scrollView setBounces:NO];
    
    // We create a dummy contentView that will hold everything (necessary to use scrollRectToVisible later)
    UIView* contentView = UIView.new;
    [self.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).with.offset(0);
        make.left.equalTo(self.scrollView.mas_left);
        make.right.equalTo(self.scrollView.mas_right);
        make.bottom.equalTo(self.scrollView.mas_bottom);
        make.width.equalTo(self.scrollView.mas_width);
    }];
    UIView *lastView;
    
    self.label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    
    [contentView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
    
    [self.label setLineBreakMode:NSLineBreakByWordWrapping];
    [self.label setNumberOfLines:0];
    
    self.label.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    self.label.font = [UIFont systemFontOfSize:14];
    self.label.textColor = [UIColor blackColor];
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    self.label.numberOfLines = 0;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    lastView = self.label;
    
    UIView *sizingView = UIView.new;
    [scrollView addSubview:sizingView];
    [sizingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom);
        make.bottom.equalTo(contentView.mas_bottom);
    }];
    return self;
    
}

- (void)setTextColor:(UIColor *)_color
{
    self.label.textColor = _color;
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)_font
{
    self.label.font = _font;
}

- (void)setText:(NSString *)str
{
    // __block JBTestScrollView *bself = self;
    text = str;
    //    NSString *text = @"Lorem Ipsum is http://simply text of the printing and #typesetting industry. Lorem Ipsum http://has.com been the industry's @standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";
    
    [self.label setText:self.text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        //NSArray *lorems = [bself rangesOfString:@"Lorem Ipsum" inString:bself.text];
        
        //NSRange boldRange = [[mutableAttributedString string] rangeOfString:@"Lorem Ipsum" options:NSCaseInsensitiveSearch];
        // NSRange strikeRange = [[mutableAttributedString string] rangeOfString:@"sed diam nonumy eirmod tempor invidunt" options:NSCaseInsensitiveSearch];
        
        // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
        //UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:14];
        //CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        //        if (font) {
        //
        //            for(int i=0; i<lorems.count; i++) {
        //                NSValue *v = [lorems objectAtIndex:i];
        //                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:[v rangeValue]];
        //
        //            }
        //
        //            //[mutableAttributedString addAttribute:(NSString *)kCT value:<#(id)#> range:<#(NSRange)#>]
        //            //[mutableAttributedString addAttribute:kTTTStrikeOutAttributeName value:[NSNumber numberWithBool:YES] range:strikeRange];
        //            CFRelease(font);
        //        }
        
        return mutableAttributedString;
    }];
    
    [self highlightMentionsInString:self.label.text withColor:[UIColor crayolaRazzleDazzleRoseColor] isBold:YES isUnderlined:NO];
    
    //self.label.enabledTextCheckingTypes = NSTextCheckingTypeLink; // Automatically detect links when the label text is subsequently changed
    //self.label.delegate = self;
    
    // dummy view, which determines the size of the contentView size and therefore the scrollView contentSize
    
}


- (void)boldText:(NSString *)str withFont:(UIFont *)boldFont
{
    //text = str;
    __block JBAttributedAwareScrollView *bself = self;
    [self.label setText:self.text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSArray *lorems = [bself rangesOfString:str inString:bself.text];
        
        //NSRange boldRange = [[mutableAttributedString string] rangeOfString:@"Lorem Ipsum" options:NSCaseInsensitiveSearch];
        //NSRange strikeRange = [[mutableAttributedString string] rangeOfString:@"sed diam nonumy eirmod tempor invidunt" options:NSCaseInsensitiveSearch];
        
        // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
        //UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:14];
        CTFontRef ctBoldFont = CTFontCreateWithName((__bridge CFStringRef)boldFont.fontName, boldFont.pointSize, NULL);
        if (ctBoldFont) {
            //
            for(int i=0; i<lorems.count; i++) {
                NSValue *v = [lorems objectAtIndex:i];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)ctBoldFont range:[v rangeValue]];
                
            }
            
            //[mutableAttributedString addAttribute:(NSString *)kCT value:<#(id)#> range:<#(NSRange)#>]
            //[mutableAttributedString addAttribute:kTTTStrikeOutAttributeName value:[NSNumber numberWithBool:YES] range:strikeRange];
            CFRelease(ctBoldFont);
        }
        
        return mutableAttributedString;
    }];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)highlightMentionsWithColor:(UIColor *)color isUnderlined:(BOOL)underlined
{
    NSRegularExpression *mentionExpression = [NSRegularExpression regularExpressionWithPattern:@"(?:^|\\s)((#|@)\\w+)" options:NO error:nil];
    
    NSArray *matches = [mentionExpression matchesInString:text
                                                  options:0
                                                    range:NSMakeRange(0, [text length])];
    for (NSTextCheckingResult *match in matches) {
        //        NSRange matchRange = [match rangeAtIndex:1];
        //        NSString *mentionString = [text substringWithRange:matchRange];
        //NSRange linkRange = [text rangeOfString:mentionString];
        //        NSString* user = [mentionString substringFromIndex:1];
        //        NSString* linkURLString = [NSString stringWithFormat:@"user:%@", user];
        
        NSArray *keys = [[NSArray alloc] initWithObjects:(id)kCTForegroundColorAttributeName,(id)kCTUnderlineStyleAttributeName
                         , nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:color,[NSNumber numberWithInt:underlined ? kCTUnderlinePatternSolid : 0], nil];
        NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
        
        
        [self.label addLinkWithTextCheckingResult:match attributes:linkAttributes];
        // [self.label addLinkToURL:[NSURL URLWithString:linkURLString] withRange:linkRange];
    }
    
}

- (void)highlightMentionsInString:(NSString *)string withColor:(UIColor *)color isBold:(BOOL)bold isUnderlined:(BOOL)underlined
{
    NSRegularExpression *mentionExpression = [NSRegularExpression regularExpressionWithPattern:@"(?:^|\\s)((#|@)\\w+)" options:NO error:nil];
    
    NSArray *matches = [mentionExpression matchesInString:text
                                                  options:0
                                                    range:NSMakeRange(0, [text length])];
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
        
        [self.label addLinkWithTextCheckingResult:match attributes:linkAttributes];
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
