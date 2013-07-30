

#import <UIKit/UIKit.h>
#import "CTColumnView.h"

@protocol CTViewDelegate <NSObject>

@optional
- (void)setLocationByChapter:(NSInteger)len columnNumber:(int)number;

@end

@interface CTView : UIScrollView {

    float frameXOffset;
    float frameYOffset;
    
    int columnIndex;
    id<CTViewDelegate> delegate;

    NSAttributedString* attString;
    
    NSMutableArray* frames;
    NSArray* images;
    
    NSMutableArray * rangeOfText;
}

@property (nonatomic, strong) id<CTViewDelegate> delegate;
@property (retain, nonatomic) NSAttributedString* attString;
@property (retain, nonatomic) NSMutableArray* frames;
@property (retain, nonatomic) NSArray* images;
@property (retain, nonatomic) NSMutableArray * rangeOfText;

-(void) reset;
-(void)buildFrames;
-(void)viewLoadFrame;
-(void)nextView;
-(void)setAttString:(NSAttributedString *)attString withImages:(NSArray*)imgs;
-(void)attachImagesWithFrame:(CTFrameRef)f inColumnView:(CTColumnView*)col;
//- (void)setLocationByChapter:(NSInteger)len columnNumber:(int)number;
@end


