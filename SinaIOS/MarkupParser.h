#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface MarkupParser : NSObject {
    
    NSString* font;
    UIColor* color;
    UIColor* strokeColor;
    float strokeWidth;
    float fontSize;
    CTTextAlignment alignment;
    
    
    NSMutableArray* images;
}

@property (retain, nonatomic) NSString* font;
@property (retain, nonatomic) UIColor* color;
@property (retain, nonatomic) UIColor* strokeColor;
@property (assign, readwrite) float strokeWidth;
@property (assign, readwrite) float fontSize;
@property (assign, nonatomic) CTTextAlignment alignment;


@property (retain, nonatomic) NSMutableArray* images;

-(NSAttributedString*)attrStringFromMarkup:(NSString*)html;

@end