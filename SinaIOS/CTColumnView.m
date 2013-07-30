
#import "CTColumnView.h"

@implementation CTColumnView

@synthesize images;

-(id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]!=nil) {
        self.images = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)dealloc
{
    self.images= nil;
    [super dealloc];
}

-(void)setCTFrame: (id) f
{
    ctFrame = f;
    
}

-(void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [[UIColor clearColor] set];
    CTFrameDraw((CTFrameRef)ctFrame, context);
    [[UIColor clearColor] set];
//    if (self.images != nil) {
//        for (NSArray* imageData in self.images) { 
//            UIImage* img = [imageData objectAtIndex:0];
//            CGRect imgBounds = CGRectFromString([imageData objectAtIndex:1]);
//            NSLog(@"imgBounds: %.0f - %.0f = %.0f - %.0f", imgBounds.origin.x, imgBounds.origin.y, imgBounds.size.width, imgBounds.size.height);
//            CGContextDrawImage(context, imgBounds, img.CGImage);
//        }
//        
//    }

}

@end