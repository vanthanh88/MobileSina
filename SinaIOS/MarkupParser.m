#import "MarkupParser.h"

/* Callbacks */
static void deallocCallback( void* ref ){
    [(id)ref release];
}
static CGFloat ascentCallback( void *ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"height"] floatValue];
}
static CGFloat descentCallback( void *ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"descent"] floatValue];
}
static CGFloat widthCallback( void* ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"width"] floatValue];
}

@implementation MarkupParser

@synthesize font, color, strokeColor, strokeWidth, fontSize;
@synthesize images, alignment;


-(id)init
{
    self = [super init];
    if (self) {
        self.font = DEFAULT_FONT_FAMILY_NAME; //@"Tahoma";
        self.color = [UIColor blackColor];
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
        self.fontSize = 14.f;
        self.images = [NSMutableArray array];
        self.alignment = kCTJustifiedTextAlignment;
    }
    return self;
}

-(NSAttributedString*)attrStringFromMarkup:(NSString*)markup
{
    NSMutableAttributedString* aString =
    [[NSMutableAttributedString alloc] initWithString:@""]; //1
    
    NSRegularExpression* regex = [[NSRegularExpression alloc]
                                  initWithPattern:@"(.*?)(<[^>]+>|\\Z)"
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil]; //2
    NSArray* chunks = [regex matchesInString:markup options:0
                                       range:NSMakeRange(0, [markup length])];
    [regex release];
    
    for (NSTextCheckingResult* b in chunks) {
        NSArray* parts = [[markup substringWithRange:b.range]
                          componentsSeparatedByString:@"<"]; //1
        
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font,
                                                 self.fontSize, NULL);
//        CTTextAlignment textAl = kCTJustifiedTextAlignment;
        
//        CTTextAlignment alignment = kCTCenterTextAlignment;
//        CTTextAlignment alignment = kCTCenterTextAlignment;
        CTParagraphStyleSetting settings[] = {
            {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
        };
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
        
        //apply the current text style //2
        NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               (id)self.color.CGColor, kCTForegroundColorAttributeName,
                               (id)[UIColor clearColor].CGColor, kCTForegroundColorAttributeName,
                               (id)fontRef, kCTFontAttributeName,
                               (id)self.strokeColor.CGColor, (NSString *) kCTStrokeColorAttributeName,
                               (id)[NSNumber numberWithFloat: self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
                               (id)paragraphStyle, (NSString*)kCTParagraphStyleAttributeName,
                               nil];
        
        [aString appendAttributedString:[[[NSAttributedString alloc] initWithString:[parts objectAtIndex:0] attributes:attrs] autorelease]];
        
        CFRelease(fontRef);
        
        //handle new formatting tag //3
        if ([parts count]>1) {
            NSString* tag = (NSString*)[parts objectAtIndex:1];
            
            if ([tag hasPrefix:@"font"]) {
                //stroke color
                NSRegularExpression* scolorRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=strokeColor=\")\\w+" options:0 error:NULL] autorelease];
                [scolorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    if ([[tag substringWithRange:match.range] isEqualToString:@"none"]) {
                        self.strokeWidth = 0.0;
                    } else {
                        self.strokeWidth = -3.0;
                        SEL colorSel = NSSelectorFromString([NSString stringWithFormat: @"%@Color", [tag substringWithRange:match.range]]);
                        self.strokeColor = [UIColor performSelector:colorSel];
                    }
                }];
                
                //color
                NSRegularExpression* colorRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=color=\")\\w+" options:0 error:NULL] autorelease];
                [colorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    SEL colorSel = NSSelectorFromString([NSString stringWithFormat: @"%@Color", [tag substringWithRange:match.range]]);
                    self.color = [UIColor performSelector:colorSel];
                }];
                
                //face
                NSRegularExpression* faceRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=face=\")[^\"]+" options:0 error:NULL] autorelease];
                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    self.font = [tag substringWithRange:match.range];
                }];
            } //end of font parsing
            
//            if ([tag hasPrefix:@"/br"]) {
//                [aString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
//            }
            
            if ([tag hasPrefix:@"b"]) {
////                NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
////                                       (id)self.color.CGColor, kCTForegroundColorAttributeName,
////                                       (id)[UIColor clearColor].CGColor, kCTForegroundColorAttributeName,
////                                       (id)fontRef, kCTFontAttributeName,
////                                       (id)self.strokeColor.CGColor, (NSString *) kCTStrokeColorAttributeName,
////                                       (id)[NSNumber numberWithFloat: self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
////                                       (id)paragraphStyle, (NSString*)kCTParagraphStyleAttributeName,
////                                       nil];
//                NSDictionary *boldFont = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:self.fontSize]
//                                                                     forKey: (NSString*)kCTFontAttributeName];
//                [aString appendAttributedString:[[[NSAttributedString alloc] initWithString:@" " attributes:boldFont] autorelease]];
            }
            
            if ([tag hasPrefix:@"center"]) {
                
                
                CTTextAlignment alignment1 =  kCTCenterTextAlignment;
                CTParagraphStyleSetting settings[] = {
                    {kCTParagraphStyleSpecifierAlignment, sizeof(alignment1), &alignment1},
                };
                CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
                NSDictionary *attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        //set the delegate
                                                        (id)paragraphStyle, (NSString*)kCTParagraphStyleAttributeName,
                                                        nil];
                
                [aString appendAttributedString:[[[NSAttributedString alloc] initWithString:@" " attributes:attrDictionaryDelegate] autorelease]];
            }
            /*
            if ([tag hasPrefix:@"img"]) {
                
                __block NSNumber* width = [NSNumber numberWithInt:0];
                __block NSNumber* height = [NSNumber numberWithInt:0];
                __block NSString* fileName = @"";
                
                //width
                NSRegularExpression* widthRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=width=\")[^\"]+" options:0 error:NULL] autorelease];
                [widthRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){ 
                    width = [NSNumber numberWithInt: [[tag substringWithRange: match.range] intValue] ];
                }];
                
                //height
                NSRegularExpression* faceRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=height=\")[^\"]+" options:0 error:NULL] autorelease];
                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    height = [NSNumber numberWithInt: [[tag substringWithRange:match.range] intValue]];
                }];
                
                //image
                NSRegularExpression* srcRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=src=\")[^\"]+" options:0 error:NULL] autorelease];
                [srcRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    fileName = [tag substringWithRange: match.range];
                }];
                
                //add the image for drawing
                [self.images addObject:
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  width, @"width",
                  height, @"height",
                  fileName, @"fileName",
                  [NSNumber numberWithInt: [aString length]], @"location",
                  nil]
                 ];
                
                //render empty space for drawing the image in the text //1
                CTRunDelegateCallbacks callbacks;
                callbacks.version = kCTRunDelegateVersion1;
                callbacks.getAscent = ascentCallback;
                callbacks.getDescent = descentCallback;
                callbacks.getWidth = widthCallback;
                callbacks.dealloc = deallocCallback;
                
                NSDictionary* imgAttr = [[NSDictionary dictionaryWithObjectsAndKeys: //2
                                          width, @"width",
                                          height, @"height",
                                          nil] retain];
                
                CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, imgAttr); //3
                NSDictionary *attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        //set the delegate
                                                        (id)delegate, (NSString*)kCTRunDelegateAttributeName,
                                                        nil];
                
                //add a space to the text so that it can call the delegate
                [aString appendAttributedString:[[[NSAttributedString alloc] initWithString:@" " attributes:attrDictionaryDelegate] autorelease]];
            } */
        }
    }
    
    return (NSAttributedString*)aString;
}

-(void)dealloc
{
    self.font = nil;
    self.color = nil;
    self.strokeColor = nil;
    self.images = nil;
    
    [super dealloc];
}

@end