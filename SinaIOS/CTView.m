

#import "CTView.h"
#import <CoreText/CoreText.h>
#import "MarkupParser.h"
#import "CTColumnView.h"

@implementation CTView

@synthesize attString;
@synthesize frames;
@synthesize images;
@synthesize rangeOfText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        columnIndex = 0;
    }
    return self;
}
-(void) reset{
    for(UIView * v in self.subviews){
        [v removeFromSuperview];
        v=nil;
    }
    [self setContentSize:self.frame.size];
    [self setContentOffset:CGPointMake(0, 0) animated:NO];
//    [self scrollRectToVisible:CGRectMake(0, 0, 320, 460) animated:NO];
}

- (void)viewLoadFrame {
    self.contentSize = CGSizeMake(self.contentSize.width + self.bounds.size.width, self.bounds.size.height);
}

- (void)nextView {
    [self setContentOffset:CGPointMake(self.contentOffset.x + self.bounds.size.width, self.contentOffset.y) animated:NO];
}

- (void)buildFrames
{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor clearColor];
    frameXOffset = 10; //1
    frameYOffset = 10;
    self.pagingEnabled = YES;
    //self.delegate = self;
    self.frames = [NSMutableArray array];
    
    CGMutablePathRef path = CGPathCreateMutable(); //2
    CGRect textFrame = CGRectInset(self.bounds, frameXOffset, frameYOffset);
    CGPathAddRect(path, NULL, textFrame );
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    
    
    NSInteger textPos = 0; //3
    columnIndex = 0;
    
    while (textPos < [attString length]) { //4
        CGPoint colOffset = CGPointMake((columnIndex+1)*frameXOffset*2 + columnIndex*(textFrame.size.width), 20);
        CGRect colRect = CGRectMake(0, 0 , textFrame.size.width-10, textFrame.size.height-10);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, colRect);
        
        //use the column path
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame); //5
        
        //create an empty column view
        CTColumnView* content = [[[CTColumnView alloc] initWithFrame: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)] autorelease];
        content.backgroundColor = [UIColor clearColor];
        content.frame = CGRectMake(colOffset.x, colOffset.y, colRect.size.width, colRect.size.height) ;
        
		//set the column view contents and add it as subview
        [content setCTFrame:(id)frame];  //6  
        [self attachImagesWithFrame:frame inColumnView: content];
        [self.frames addObject: (id)frame];
        [self addSubview: content];
        
        //prepare for next frame
        textPos += frameRange.length;
        if([self.delegate respondsToSelector:@selector(setLocationByChapter:columnNumber:)]) {
            [self.delegate setLocationByChapter:textPos columnNumber:columnIndex];
        }
        
//        NSLog(@"textPos %ld - %d", frameRange.length, textPos);
//        NSLog(@"attString %@", attString);
        //CFRelease(frame);
        CFRelease(path);
        
        columnIndex++;
    }
    //set the total width of the scroll view
//    int totalPages = columnIndex; //7
    self.contentSize = CGSizeMake(columnIndex * self.bounds.size.width, textFrame.size.height);
//    self.contentOffset = CGPointMake(0, 0);
//    [self scrollRectToVisible:CGRectMake(0, 0, 320, 460) animated:YES];
  
}

-(void)setAttString:(NSAttributedString *)string withImages:(NSArray*)imgs
{
    self.attString = string;
    self.images = imgs;
}

-(void)attachImagesWithFrame:(CTFrameRef)f inColumnView:(CTColumnView*)col
{
    //drawing images
    NSArray *lines = (NSArray *)CTFrameGetLines(f); //1
    
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(f, CFRangeMake(0, 0), origins); //2
    
    int imgIndex = 0; //3
    NSDictionary* nextImage = [self.images objectAtIndex:imgIndex];
    int imgLocation = [[nextImage objectForKey:@"location"] intValue];
    
    //find images for the current column
    CFRange frameRange = CTFrameGetVisibleStringRange(f); //4
    while ( imgLocation < frameRange.location ) {
        imgIndex++;
        if (imgIndex>=[self.images count]) return; //quit if no images for this column
        nextImage = [self.images objectAtIndex:imgIndex];
        imgLocation = [[nextImage objectForKey:@"location"] intValue];
    }
    
    NSUInteger lineIndex = 0;
    for (id lineObj in lines) { //5
        CTLineRef line = (CTLineRef)lineObj;
        
        for (id runObj in (NSArray *)CTLineGetGlyphRuns(line)) { //6
            CTRunRef run = (CTRunRef)runObj;
            CFRange runRange = CTRunGetStringRange(run);
            
            if ( runRange.location <= imgLocation && runRange.location+runRange.length > imgLocation ) { //7
	            CGRect runBounds;
	            CGFloat ascent;//height above the baseline
	            CGFloat descent;//height below the baseline
	            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
	            runBounds.size.height = ascent + descent;
                
	            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
	            runBounds.origin.x = origins[lineIndex].x + self.frame.origin.x + xOffset + frameXOffset;
	            runBounds.origin.y = origins[lineIndex].y + self.frame.origin.y + frameYOffset;
	            runBounds.origin.y -= descent;
                
                UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[nextImage objectForKey:@"fileName"]]]];
//                UIImage *img = [UIImage imageNamed: [nextImage objectForKey:@"fileName"] ];
                //NSLog(@"%@", f);
                CGPathRef pathRef = CTFrameGetPath(f); //10
                CGRect colRect = CGPathGetBoundingBox(pathRef);
                CGRect imgBounds = CGRectOffset(runBounds, colRect.origin.x - frameXOffset - self.contentOffset.x, colRect.origin.y - frameYOffset - self.frame.origin.y);
                [col.images addObject: //11
                 [NSArray arrayWithObjects:img, NSStringFromCGRect(imgBounds) , nil]
                 ];
                
                //load the next image //12
                imgIndex++;
                if (imgIndex < [self.images count]) {
                    nextImage = [self.images objectAtIndex: imgIndex];
                    imgLocation = [[nextImage objectForKey: @"location"] intValue];
                }
                
            }
        }
        lineIndex++;
    }
}

- (void) setTextPos:(int)index {
    
}

-(void)dealloc
{
    self.attString = nil;
    self.frames = nil;
    self.images = nil;
    [super dealloc];
}

@end
