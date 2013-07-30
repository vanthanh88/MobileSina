//
//  SinaEbookViewController.m
//  SinaIos
//
//  Created by macos on 11/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SinaEbookViewController.h"
#import "MainViewController.h"
#import "LoadingView.h"
#import "CustomNavigationBar.h"
#import "CustomAlert.h"
#import "CTView.h"
#import "MarkupParser.h"
#import "SearchWordInBookViewController.h"
#import "GestureRecognizerForEbookView.h"

//define text
#define WHITE_BG_COLOR          0xffffff
#define WHITE_FG_COLOR          0x111111
#define WHITE_HIGHLIGHT_COLOR   0xffff9b
#define WHITE_TITLE_COLOR       0x999999
#define WHITE_INSERT_BG_COLOR   0xcccccc
#define SEPIA_BG_COLOR          0xFBF0D9
#define SEPIA_FG_COLOR          0x5F4B32
#define SEPIA_HIGHLIGHT_COLOR   0xffff9b
#define SEPIA_TITLE_COLOR       0x84725B
#define SEPIA_INSERT_BG_COLOR   0xd8c69f
#define BLACK_BG_COLOR          0x000000
#define BLACK_FG_COLOR          0xFFFFFF
#define BLACK_HIGHLIGHT_COLOR   0x003193
#define BLACK_TITLE_COLOR       0x999999
#define BLACK_INSERT_BG_COLOR   0x333333

#define FONT_SIZE_1             14.f
#define FONT_SIZE_2             16.f
#define FONT_SIZE_3             18.f
#define FONT_SIZE_4             20.f
#define FONT_SIZE_5             22.f


#define TAG_ALERT_LOCATION 2121

#define TAG_FONT1       10
#define TAG_FONT2       11
#define TAG_FONT3       12
#define TAG_FONT4       13
#define TAG_FONT5       14
#define TAG_BG_BLACK    15
#define TAG_BG_WHITE    16
#define TAG_BG_SAPIE    17

//fixed value -- not change
#define FIXEDVALUE      10


//define font-size
#define FONT_SIZE_16    18.0

//for goto view controller

#define kCacChuong          @"cacchuong"
#define kBatDauDoc          @"batdaudoc"
#define kViTriTrangSach     @"vitritrangsach"

//for scrollview book
enum {
    kPagePrevious,
    kPageCurrent,
    kPageNext,
    kNumberOfPages
};

#pragma mark - BookViewProperties class header

@interface BookViewProperties : UIView {
    
    UIButton * btChangeFontFamily;
    Toolbar2 * barChangeTextSize;
    UIView * viewBGColor;
    UISlider * sliderBrightness;
    id<BookViewPropertiesDelegate> delegate;
    
    NSInteger current_tag_disable_text_size;
    NSInteger current_tag_disable_background_color;
    
}

@property (nonatomic, assign) float _currentBacklightLevel;

@property (nonatomic, strong) id<BookViewPropertiesDelegate> delegate;


@end

#pragma mark - BookViewProperties class content
@implementation BookViewProperties

@synthesize _currentBacklightLevel, delegate;

-(void) buildView{
    
    //khoi tao cac gia tri ban dau
    self._currentBacklightLevel = 0.2f;
    current_tag_disable_text_size = TAG_FONT2;
    current_tag_disable_background_color = TAG_BG_WHITE;
    
    UIView * line = nil;
    UIView * viewChangeFontFamily = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/4)];
    btChangeFontFamily = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, self.frame.size.width-40, 30)];
    [btChangeFontFamily setTitle:@"Times New Roman" forState:UIControlStateDisabled];
    [btChangeFontFamily setEnabled:NO];
    [btChangeFontFamily setBackgroundColor:[UIColor grayColor]];
    [Utils addGradient:btChangeFontFamily AndCorectRadius:5.f];
    [viewChangeFontFamily addSubview:btChangeFontFamily];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(5, viewChangeFontFamily.frame.size.height, self.frame.size.width-10, 1)];
    line.backgroundColor = [UIColor brownColor];
    [self addSubview:line];
    
    barChangeTextSize = [[Toolbar2 alloc] initWithFrame:CGRectMake(0, viewChangeFontFamily.frame.size.height, self.frame.size.width, self.frame.size.height/4) AndBackgroundColor:[UIColor clearColor]];
    [barChangeTextSize AddToolbarItemWithImage:[UIImage imageNamed:@"font-one.png"] Target:self Selector:@selector(chooseFontClick:) andTag:TAG_FONT1];
    [barChangeTextSize AddToolbarItemWithImage:[UIImage imageNamed:@"font-two.png"] Target:self Selector:@selector(chooseFontClick:) andTag:TAG_FONT2];
    [barChangeTextSize AddToolbarItemWithImage:[UIImage imageNamed:@"font-three.png"] Target:self Selector:@selector(chooseFontClick:) andTag:TAG_FONT3];
    [barChangeTextSize AddToolbarItemWithImage:[UIImage imageNamed:@"font-four.png"] Target:self Selector:@selector(chooseFontClick:) andTag:TAG_FONT4];
    [barChangeTextSize AddToolbarItemWithImage:[UIImage imageNamed:@"font-five.png"] Target:self Selector:@selector(chooseFontClick:) andTag:TAG_FONT5];
    
    [barChangeTextSize ButtonAtIndex:current_tag_disable_text_size - FIXEDVALUE SetEnabled:NO];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(5, 2*viewChangeFontFamily.frame.size.height, self.frame.size.width-10, 1)];
    line.backgroundColor = [UIColor brownColor];
    [self addSubview:line];
    
    
    viewBGColor = [[UIView alloc] initWithFrame:CGRectMake(0, barChangeTextSize.frame.size.height*2, self.frame.size.width, self.frame.size.height/4)];
    
    UIButton * btBGWhite = [Utils newButtonWithTitle:@"Trắng" target:self selector:@selector(backgroundClick:) frame:CGRectMake(10, 10, viewBGColor.frame.size.width/3 - 4*10, 30) image:nil hilightImage:nil];
    btBGWhite.backgroundColor = [UIColor whiteColor];
    btBGWhite.tag = TAG_BG_WHITE;
    btBGWhite.layer.cornerRadius = 5.f;
    btBGWhite.layer.masksToBounds = YES;
//    btBGWhite.titleLabel.textColor = [UIColor blackColor];
//    [btBGWhite setEnabled:NO];
    [btBGWhite setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btBGWhite setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    
    UIButton * btBGBlack = [Utils newButtonWithTitle:@"Đen" target:self selector:@selector(backgroundClick:) frame:CGRectMake(2*btBGWhite.frame.size.width - 10, 10, viewBGColor.frame.size.width/3 - 4*10, 30) image:nil hilightImage:nil];
//    btBGBlack.titleLabel.textColor = [UIColor whiteColor];
    btBGBlack.backgroundColor = parserColor(BLACKCOLOR);
    btBGBlack.tag = TAG_BG_BLACK;
    btBGBlack.layer.cornerRadius = 5.f;
    btBGBlack.layer.masksToBounds = YES;
    [btBGBlack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btBGBlack setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    UIButton * btBGSapie = [Utils newButtonWithTitle:@"Sapie" target:self selector:@selector(backgroundClick:) frame:CGRectMake(viewBGColor.frame.size.width -10 - btBGBlack.frame.size.width, 10, viewBGColor.frame.size.width/3 - 4*10, 30) image:nil hilightImage:nil];
    btBGSapie.backgroundColor = parserColor(SAPHIACOLOR);
    btBGSapie.layer.cornerRadius = 5.f;
    btBGSapie.tag = TAG_BG_SAPIE;
    btBGSapie.layer.masksToBounds = YES;
//    btBGSapie.titleLabel.textColor = [UIColor blackColor];
    [btBGSapie setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btBGSapie setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    
    [viewBGColor addSubview:btBGBlack];
    [viewBGColor addSubview:btBGWhite];
    [viewBGColor addSubview:btBGSapie];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(5, 3*viewChangeFontFamily.frame.size.height, self.frame.size.width-10, 1)];
    line.backgroundColor = [UIColor brownColor];
    [self addSubview:line];
    
    sliderBrightness = [[UISlider alloc] initWithFrame:CGRectMake(25, barChangeTextSize.frame.size.height*3, self.frame.size.width-50, self.frame.size.height/4)];
    sliderBrightness.backgroundColor = [UIColor clearColor];
    [sliderBrightness addTarget:self action:@selector(slideBrightness:) forControlEvents:UIControlEventValueChanged];
    sliderBrightness.minimumValue = 0;
    sliderBrightness.maximumValue = 1;
    sliderBrightness.continuous = YES;
	sliderBrightness.value = self._currentBacklightLevel;
    
    UIImage * brightnessimg = [UIImage imageNamed:@"brightness-big.png"];
    UIImageView * imgView = nil;
    imgView = [[UIImageView alloc] initWithImage:brightnessimg];
    imgView.frame = CGRectMake(sliderBrightness.frame.size.width + imgView.frame.size.width, barChangeTextSize.frame.size.height*3 + barChangeTextSize.frame.size.height/2 - imgView.frame.size.height/2, imgView.frame.size.width, imgView.frame.size.height);
    [self addSubview:imgView];
    
    imgView = [[UIImageView alloc] initWithImage:brightnessimg];
    imgView.frame = CGRectMake(imgView.frame.size.width/3.5 , barChangeTextSize.frame.size.height*3 + barChangeTextSize.frame.size.height/2 - imgView.frame.size.height/4 , imgView.frame.size.width/1.5, imgView.frame.size.height/1.5);
    [self addSubview:imgView];
    
    
    [self addSubview:barChangeTextSize];
    [self addSubview:viewBGColor];
    [self addSubview:sliderBrightness];
    [self addSubview:viewChangeFontFamily];
}
-(void) chooseFontClick: (Toolbar2*)bar{

    if([self.delegate respondsToSelector:@selector(selectPropertyWithTagId:)]){
        [self.delegate selectPropertyWithTagId:bar.tag];
        [barChangeTextSize ButtonAtIndex:current_tag_disable_text_size - FIXEDVALUE SetEnabled:YES];
        current_tag_disable_text_size = bar.tag; 
        
        [barChangeTextSize ButtonAtIndex:bar.tag - FIXEDVALUE SetEnabled:NO];
    }
}
-(void) backgroundClick:(UIButton*)button{
    if([self.delegate respondsToSelector:@selector(selectPropertyWithTagId:)]){
        [self.delegate selectPropertyWithTagId:button.tag];
        
        UIButton * curentB = (UIButton*)[viewBGColor viewWithTag:current_tag_disable_background_color];
        [curentB setEnabled:YES];
        current_tag_disable_background_color = button.tag;
        UIButton * beforeB = (UIButton*)[viewBGColor viewWithTag:button.tag];
        [beforeB setEnabled:NO];
        
    }
}

- (void)setBacklightLevel: (float)newLevel {
    [(id)[UIApplication sharedApplication] setBacklightLevel:newLevel];
}

-(void)slideBrightness:(UISlider*)slider{
    
    
    [self setBacklightLevel:slider.value];
   
    
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self buildView];

    }
    return self;
}


@end

#pragma mark - SinaEbookViewController 
@interface SinaEbookViewController(){
    BOOL chapterselected;
    GestureRecognizerForEbookView * tapView;
    
    //for text
    MarkupParser * markup;
    
    CGFloat currentFontSize;
    UIColor * currentTextColor;
    UIColor * currentBackgoundColor;
    
    BOOL pageControlBeingUsed;
    BOOL isPreView;
    BOOL isSiler;
    unsigned int locationId;
    unsigned int locationIdByChapter;
    unsigned int stepLocation;
    float frameXOffset; // ContentOffset X for view
    NSUInteger lenghtFrameRange;
    NSMutableArray *beginLocationByView;
}
- (NSArray *) getListSpanNewWithBookId:(NSString*)bookId chapterId:(NSString* )chapterId;
- (NSInteger)getChapterByLocation:(NSInteger)location;
- (NSInteger) getLocationInChapter:(int)chId;
-(void) addChapterContentToListSpanNewWithChapterId:(NSString* )chId;

-(void) showGotoOption;
-(void) buildNewView;
- (void) hideViewBottom: (id) aTimer;
////add 
//- (void) viewBuildFrames;

@end

#pragma mark - main view controller
@implementation SinaEbookViewController

@synthesize bookID, loadingView;

- (id)init{
    self = [super init];
    if (self) {
        //self.view.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView{
    [super loadView];
    
    topBar = [[Toolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UIButton* btHome = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [btHome setBackgroundColor:[UIColor blackColor]];
    UIImage* imgHome = [UIImage imageNamed:@"home-icon.png"];
    [btHome addTarget:self action:@selector(homeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [btHome setImage: imgHome forState:UIControlStateNormal];
    [Utils addGradient:btHome AndCorectRadius:5.f];
    UIBarButtonItem* home = [[UIBarButtonItem alloc] initWithCustomView:btHome];
    
    UIBarButtonItem* flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
       
    btBookmark = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [btBookmark setBackgroundColor:[UIColor blackColor]];
    UIImage* imgBookmark = [UIImage imageNamed:@"bookmark-icon.png"];
    [btBookmark setImage: imgBookmark forState:UIControlStateNormal];
    [Utils addGradient:btBookmark AndCorectRadius:5.f];
    [btBookmark addTarget:self action:@selector(bookmarkButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* bookmark = [[UIBarButtonItem alloc] initWithCustomView:btBookmark];
    
    NSArray* topbarItems = [NSArray arrayWithObjects:home,flex,bookmark, nil];
    [topBar setItems:topbarItems];
     
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 210, 22)];
    lbTitle.text = @"";
    lbTitle.font = [UIFont boldSystemFontOfSize:18.f];
    lbTitle.textAlignment = UITextAlignmentCenter;
    lbTitle.lineBreakMode = UILineBreakModeTailTruncation;
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.textColor = [UIColor whiteColor];
    [topBar addSubview:lbTitle];

    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height -84, self.view.frame.size.width, 84)];
    bottomView.backgroundColor = [UIColor clearColor];

    lbProgress = [[UILabel alloc] initWithFrame:CGRectMake(0, bottomView.bounds.size.height - 20, bottomView.frame.size.width, 20)];
    lbProgress.text = @"Location 1 of 12345 • 0%";
    lbProgress.font = [UIFont systemFontOfSize:12.f];
    lbProgress.textAlignment = UITextAlignmentCenter;
    lbProgress.textColor = [UIColor whiteColor];
    lbProgress.backgroundColor = [UIColor blackColor];
    [Utils addGradientForView:lbProgress Operacity:0.2f];

    sliderView = [[MNEValueTrackingSlider alloc] initWithFrame:CGRectMake(0, bottomView.bounds.size.height - 40, bottomView.frame.size.width, 20)];
    sliderView.backgroundColor = parserColor(0x0f0f1f);
    [Utils addGradientForView:sliderView Operacity:0.1f];
    
//    sliderView.maximumValue = 12345;
//    sliderView.minimumValue = 1;
    sliderView.value =1;
    
    //add event
    [sliderView addTarget:self action:@selector(slideVavlueChanging:) forControlEvents:UIControlEventValueChanged];
    [sliderView addTarget:self action:@selector(slideVavlueChanged:) forControlEvents:UIControlEventTouchUpInside];
    [sliderView addTarget:self action:@selector(slideVavlueChanged:) forControlEvents:UIControlEventTouchUpOutside];
    
    
    UIColor * backgroundOption = [UIColor colorWithWhite:0.2f alpha:0.7];
    Toolbar2 * optionView = [[Toolbar2 alloc] initWithFrame:CGRectMake(0, 0, bottomView.frame.size.width, 44) AndBackgroundColor:backgroundOption];
    [Utils addGradientForView:optionView Operacity:1.f];
    
    [optionView AddToolbarItemWithImage:[UIImage imageNamed:@"left-arow.png"] Target:self Selector:@selector(goBackLocationClick)];
    [optionView AddToolbarItemWithImage:[UIImage imageNamed:@"font-choose.png"] Target:self Selector:@selector(chooseFontClick)];
    [optionView AddToolbarItemWithImage:[UIImage imageNamed:@"book-icon.png"] Target:self Selector:@selector(gotoClick)];
    [optionView AddToolbarItemWithImage:[UIImage imageNamed:@"search-icon.png"] Target:self Selector:@selector(searchTextInBookClick)];
    
    [optionView AddToolbarItemWithImage:[UIImage imageNamed:@"re-syncbook.png"] Target:self Selector:@selector(reSyncBookProgressClick:)];

    [bottomView addSubview:optionView];
    [bottomView addSubview:lbProgress];
    [bottomView addSubview:sliderView];
    
    bookViewProperties = [[BookViewProperties alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2+44, self.view.frame.size.width, self.view.frame.size.height/2-44)];
    
    bookViewProperties.delegate = self;
    bookViewProperties.alpha = 0.f;
       
    ctView = [[CTView alloc] initWithFrame:self.view.frame];
    ctView.backgroundColor = [UIColor clearColor];
    ctView.delegate = self;
    [self.view addSubview:ctView];
    
//    UIView* viewT = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, 0, self.view.frame.size.width/3, self.view.frame.size.height)];
//    viewT.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:viewT];
    UITapGestureRecognizer *tapToView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [ctView addGestureRecognizer:tapToView];

    
    [self.view addSubview:bookViewProperties];
    [self.view addSubview:topBar];
    [self.view addSubview:bottomView];
    topBar.alpha = 0.f;
    bottomView.alpha = 0.f;
    
//    tapView = [[GestureRecognizerForEbookView alloc] initWithTarget:ctView action:nil];
//    tapView.tapDelegate = self;
//    [self.view addGestureRecognizer:tapView];
    
    [self.view sendSubviewToBack:ctView];
        
    //khoi tao gia tri ban dau
    currentChapter = 0;
    currentFontSize = FONT_SIZE_2;
    currentTextColor = parserColor(WHITE_FG_COLOR);
    currentBackgoundColor = parserColor(WHITE_BG_COLOR);
    
    self.view.backgroundColor = currentBackgoundColor;
}

#pragma mark - handle tap view book
// Present the slider when tapped
- (void) handleTap: (UIGestureRecognizer *) recognizer
{
    if(bottomView.alpha == 1.f || bookViewProperties.alpha == 1.f){
        [UIView animateWithDuration:0.5f animations:^(void){
            bottomView.alpha = 0.0f;
            topBar.alpha = 0.0f;
            bookViewProperties.alpha = 0.f;
        }];
    }else{
        [UIView animateWithDuration:0.5f animations:^(void){
            bottomView.alpha = 1.0f;
            topBar.alpha = 1.0f;
        }];
        
        [hiderTimer invalidate];
        hiderTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hideViewBottom:) userInfo:nil repeats:NO];
    }
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

/*
- (void) tapToPoint:(CGPoint)point {
    NSLog(@"%.0f - %.0f", point.x, point.y);
    
    if (point.x >= (self.view.frame.size.width / 3) && point.x <= ((2 * self.view.frame.size.width) / 3)) {
    
        if (bookViewProperties.alpha == 1.f) {
            return;
        }
        
        if ([bottomView alpha] == 1.0f) {
            bottomView.alpha = 0.0f;
            topBar.alpha = 0.f;
            return;
        }
        
        [UIView animateWithDuration:0.3f animations:^(void){
            bottomView.alpha = 1.0f;
            topBar.alpha = 1.0f;
            //hiden navigationbar here
        }];
    
    [self hideViewBottom:nil];
//        [hiderTimer invalidate];
//        hiderTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self.view selector:@selector(hideViewBottom:) userInfo:nil repeats:NO];
    }
    else{
        bookViewProperties.alpha = 0;
    }
}
*/
- (void) hideViewBottom: (id) aTimer
{
    if ([bookViewProperties alpha] == 1.0f) {
        return;
    }
    
    [UIView animateWithDuration:0.5f animations:^(void){
        bottomView.alpha = 0.0f;
        topBar.alpha = 0.0f;
        //hiden navigation bar here        
    }];
    
    [hiderTimer invalidate];
    hiderTimer = nil;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.loadingView = [LoadingView loadingViewInView:self.view];
    // Set value default
    locationId = 0;
    locationIdByChapter = 0;
    frameXOffset = 0;
    lenghtFrameRange = 0;
    stepLocation = 0;
    pageControlBeingUsed = YES;
    isPreView = NO;
    isSiler = NO;
    rangeOfText = [[NSMutableArray alloc] init];
    beginLocationByView = [[NSMutableArray alloc] init];
   
//    currentChapter = 1;
    NSString * selectQuery = @"";
    selectQuery = [NSString stringWithFormat:@"SELECT * FROM BOOK WHERE ID = %@", self.bookID];
    //NSLog(@"selectQuery %@", selectQuery);
     NSLog(@"Run here! %@", self.bookID);
    NSMutableArray * bookInfor = [[DatabaseManager shareInstance] exeQueryGetTable:selectQuery ObjectInstance:[[Book alloc] init]];
    
    if (bookInfor.count!=0) {
        currentBook = [bookInfor objectAtIndex:0];
        lbTitle.text = currentBook.name;
        sliderView.maximumValue = currentBook.totalspan;
        lbProgress.text = [NSString stringWithFormat:@"Location 1 of %i • %@", currentBook.totalspan, @"0%"];
        NSString * selectAllChapterArray = [NSString stringWithFormat:@"SELECT * FROM CHAPTER WHERE ID_BOOK = %@", self.bookID];
        
        allChapterArray = [[DatabaseManager shareInstance] exeQueryGetTable:selectAllChapterArray ObjectInstance:[[ChapterData alloc] init]];
        
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
//<<<<<<< HEAD
        NSString * selectConf = [NSString stringWithFormat:@"SELECT * FROM CONFIG WHERE BOOK_ID = %@ AND ID_USER = %@", self.bookID, [user stringForKey:USERID_PREFERENCES]];
        
        ConfigBook * cb = [[[DatabaseManager shareInstance] exeQueryGetTable:selectConf ObjectInstance:[[ConfigBook alloc] init]] objectAtIndex:0];
//=======
//        NSLog(@"user: %@", [user objectForKey:@"IDUSER"]);
//        ConfigBook * cb = [[[DatabaseManager shareInstance] exeQueryGetTable:[NSString stringWithFormat:@"SELECT * FROM CONFIG WHERE BOOK_ID = %@ AND ID_USER = %@", self.bookID, [user objectForKey:@"IDUSER"]] ObjectInstance:[[ConfigBook alloc] init]] objectAtIndex:0];
//>>>>>>> 4a4af0de670ad23c634c7ecc0e4aa5b152d38e61

        NSLog(@"Config %@", cb);
        
//        [ctView buildFrames];
        [NSThread detachNewThreadSelector:@selector(buildNewView) toTarget:self withObject:nil];
//
//        [self buildNewView];
    }
    
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}
-(void) buildNewView{
    @autoreleasepool {
        [ctView reset];
        [self addChapterContentToListSpanNewWithChapterId:[NSString stringWithFormat:@"%i", currentChapter]];
        NSInteger tmpLoc = 0;
        NSRange currentRange;
        NSString* strNeed = @"";
        NSInteger countSpan = [listSpanNew count];
        
        lenghtFrameRange = 0;
        
        for (unsigned int i = 0; i < countSpan; i++) {
            NSString * tmpS = [listSpanNew objectAtIndex:i];
            
            currentRange = NSMakeRange(tmpLoc, [tmpS length]);
            tmpLoc += [tmpS length];
            tmpS = [tmpS stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\n"];
            strNeed = [NSString stringWithFormat:@"%@%@", strNeed, tmpS];
            currentRange.length = i;
            [rangeOfText addObject:[NSValue valueWithRange:currentRange]];

          
 
            if(locationIdByChapter == (i+1)) {
                lenghtFrameRange = currentRange.location;

            }
            
        }
        NSLog(@"locationIdByChapter: %@", rangeOfText);
        stringOfChapter = strNeed;
        strNeed = nil;
        
        // MarkupParser
        markup = [[MarkupParser alloc] init];
    //    markup.color = [UIColor redColor];
        markup.fontSize = currentFontSize;
        markup.color = currentTextColor;
        
        self.view.backgroundColor = currentBackgoundColor;
        NSAttributedString* attString = [markup attrStringFromMarkup:stringOfChapter];
        stringOfChapter = nil;
        
    //    
        [ctView setAttString:attString /*withImages:markup.images*/];
        attString = nil;
        [ctView buildFrames];
        if(!pageControlBeingUsed) {
//            [ctView nextView];
        }
        
        if(frameXOffset > 0 && isSiler) {
            [ctView setContentOffset:CGPointMake(frameXOffset, ctView.contentOffset.y) animated:NO];
            frameXOffset = 0;
            isSiler = NO;
        }
        
        //
        if(isPreView) {
            [ctView setContentOffset:CGPointMake(ctView.contentSize.width - self.view.frame.size.width, ctView.contentOffset.y) animated:NO];
            isPreView = NO;
        }
//        [ctView setContentOffset:CGPointMake(ctView.contentOffset.x + 320.0, ctView.contentOffset.y) animated:YES];
//        [self performSelectorOnMainThread:@selector(viewBuildFrames) withObject:nil waitUntilDone:NO];
//        [NSThread detachNewThreadSelector:@selector(viewBuildFrames) toTarget:ctView withObject:nil];
    //    [ctView setContentOffset:CGPointMake(0, 0)];
    //    [pool release];
        pageControlBeingUsed = YES;
        [self.loadingView removeFromSuperview];
//        [ctView viewLoadFrame];
    }

}

- (void) viewBuildFrames {
    [ctView buildFrames];
}

- (void)setLocationByChapter:(NSInteger)len columnNumber:(int)number {
//    NSLog(@"Lenght: %i", len);
    if(lenghtFrameRange < len) {
        frameXOffset = number * self.view.frame.size.width;
        NSLog(@"frameXOffset: %i = %i", len, [rangeOfText count]);
    }
    
    for (NSInteger index = stepLocation; index < [rangeOfText count]; index++) {
//        NSValue *value = [rangeOfText objectAtIndex:index];
        NSRange range = [[rangeOfText objectAtIndex:index] rangeValue];
        if(len <= range.location) {
//            NSLog(@"location: %i", range.length);
            //[beginLocationByView addObject:(NSString *)range.length];
            break;
        }
        
    }

}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{    
    if(topBar.alpha == 1.f || bookViewProperties.alpha == 1.f){
        topBar.alpha = 0.f;
        bookViewProperties.alpha = 0.f;
        bottomView.alpha = 0.f;
    }
    if(pageControlBeingUsed && ctView.contentOffset.x > (ctView.contentSize.width - (self.view.frame.size.width - 50)) &&
       currentChapter >= 0 &&
       currentChapter < [allChapterArray count] - 1){
//        [ctView reset];
        self.loadingView = [LoadingView loadingViewInView:self.view];
        pageControlBeingUsed = NO;
        currentChapter++;
//        NSLog(@"Tang: %.0f - %.0f", ctView.contentOffset.x, ctView.contentSize.width - self.view.frame.size.width);
        
//        [ctView setContentOffset:CGPointMake(0, 0) animated:NO];
        [NSThread detachNewThreadSelector:@selector(buildNewView) toTarget:self withObject:nil];
//        [self buildNewView];
        
    }
    else if(pageControlBeingUsed && ctView.contentOffset.x < -50 && currentChapter > 0) {
        self.loadingView = [LoadingView loadingViewInView:self.view];
        
        isPreView = YES;
        pageControlBeingUsed = NO;
        currentChapter--;
        
//        [self buildNewView];
        [NSThread detachNewThreadSelector:@selector(buildNewView) toTarget:self withObject:nil];
//        NSLog(@"contentOffset: %.0f", ctView.contentSize.width);
//        [ctView setContentOffset:CGPointMake(ctView.contentSize.width - self.view.frame.size.width, 0) animated:NO];
        
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"ddContentOffset: %i", (NSInteger)ceilf(scrollView.contentOffset.x/self.view.frame.size.width));
    sliderView.value = 1024;
}  


//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//	pageControlBeingUsed = YES;
//    
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//	if(!pageControlBeingUsed && !isPreView) {
//        NSLog(@"abc %.0f", scrollView.contentOffset.x);
////        [ctView setContentOffset:CGPointMake(0, 0) animated:YES];
//        pageControlBeingUsed = YES;
//    }
//}

#pragma mark - action by selector
-(void) homeButtonClick{
    
    for(UIViewController* VC in [self.navigationController viewControllers]){
        if ([VC isKindOfClass:[MainViewController class]]) {
            [self.navigationController popToViewController:VC animated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            break;
        }
    }
        
}
-(void) bookmarkButtonClick{
    [btBookmark setBackgroundColor:[UIColor blueColor]];
}

-(void) goBackLocationClick{
    NSLog(@"Quay ve trang da doc truoc do");
    
}

-(void) chooseFontClick{
    [UIView animateWithDuration:0.5f animations:^{
        bookViewProperties.alpha = 1.f;
        bottomView.alpha = 0.f;
    }];
    
}
-(void) gotoClick{
    [self showGotoOption];
}
-(void) searchTextInBookClick{
    
    SearchWordInBookViewController * searchWordVC = [[SearchWordInBookViewController alloc] init];
    
    searchWordNavController = [[UINavigationController alloc] initWithRootViewController:searchWordVC];
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneSearchWordClick)];
    searchWordVC.navigationItem.rightBarButtonItem = doneButtonItem;

    searchWordVC.title = @"Tìm theo từ khóa";
    searchWordVC.idBook = self.bookID;
    searchWordVC.arrayChapter = allChapterArray;
    CustomNavigationBar* customNavigation = [[CustomNavigationBar alloc] initWithFrame:self.navigationController.navigationBar.frame];
    [customNavigation setBackgroundWith:[UIImage imageNamed:@"bannertop.png"]];
    [searchWordNavController setValue:customNavigation forKeyPath:@"navigationBar"];
    
    [Utils addGradientForView:searchWordNavController.navigationBar Operacity:0.5f];
    
    [self presentModalViewController:searchWordNavController animated:YES];    
}
-(void) reSyncBookProgressClick:(UIButton*)button{
    //button.enabled = NO;
    NSLog(@"Quay ve trang dau(android)");
}

-(void) doneSearchWordClick{
    [searchWordNavController dismissModalViewControllerAnimated:YES];
}
#pragma mark - action bookview properties
-(void) selectPropertyWithTagId:(NSInteger)tag{
    
    NSLog(@"Action apply for button tag %i", tag);
  
    switch (tag) {
        case TAG_FONT1:{

            currentFontSize = FONT_SIZE_1;
 
        }break;
        case TAG_FONT2:{

            currentFontSize = FONT_SIZE_2;

        }break;
        case TAG_FONT3:{
                        
            currentFontSize = FONT_SIZE_3;
    
        }break;
        case TAG_FONT4:{

   
            currentFontSize = FONT_SIZE_4;

        }break;
        case TAG_FONT5:{

            currentFontSize = FONT_SIZE_5;
            
        
        }break;
        case TAG_BG_BLACK:{
            
            currentTextColor = parserColor(BLACK_FG_COLOR);
            currentBackgoundColor = parserColor(BLACK_BG_COLOR);
        
        }break;
        case TAG_BG_WHITE:{
            
            currentTextColor = parserColor(WHITE_FG_COLOR);
            currentBackgoundColor = parserColor(WHITE_BG_COLOR);
        
        }break;
        case TAG_BG_SAPIE:{
   
            currentTextColor = parserColor(SEPIA_FG_COLOR);
            currentBackgoundColor = parserColor(SEPIA_BG_COLOR);
        
        }break;
        default:{
         
            
        }break;
    }
    [self buildNewView];
}
//slide value changing
-(void) slideVavlueChanging:(MNEValueTrackingSlider*)slider{
    //NSLog(@"--- %f", [slider value]);
    [hiderTimer invalidate];
    hiderTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(hideViewBottom:) userInfo:nil repeats:NO];
    
    lbProgress.text = [NSString stringWithFormat:@"Location %4.f/%u - %2.f%%",slider.value,currentBook.totalspan, (slider.value/(float)currentBook.totalspan)*100];
}
//slider changed Value - TouthUp In-Out Side
-(void) slideVavlueChanged:(MNEValueTrackingSlider*)slider{
    self.loadingView = [LoadingView loadingViewInView:self.view];
    isSiler = YES;
    // Set current chapter
    currentChapter = (NSInteger)[self getChapterByLocation:(unsigned int)slider.value];
    
    NSInteger location = [self getLocationInChapter:(int)[self getChapterByLocation:(unsigned int)slider.value]];
    locationId = (unsigned int)slider.value;
    locationIdByChapter = (unsigned int)slider.value - location;
    [NSThread detachNewThreadSelector:@selector(buildNewView) toTarget:self withObject:nil];
}

//field editor view controller delegate
- (void)fieldEditor:(FieldEditorViewController *)editor didFinishEditingWithValues:(NSDictionary *)returnValues{
    
    [self dismissModalViewControllerAnimated:YES];
}
- (void)fieldEditorDidCancel:(FieldEditorViewController *)editor{
    
}
- (void)fieldEditor:(FieldEditorViewController *)editor pressedButtonWithKey:(NSString *)key{
    NSLog(@"Key: %@", key);
    if([key isEqual:kBatDauDoc]){
        currentChapter = 0;
        [self addChapterContentToListSpanNewWithChapterId:[NSString stringWithFormat:@"%i",currentChapter]];
        [self buildNewView];
        [self dismissModalViewControllerAnimated:YES];
        
        
    }else if([key isEqual:kViTriTrangSach]){
        CustomAlert *prompt = [CustomAlert alloc];
        prompt = [prompt initWithTitle:@"Chuyển đến" message:@"Bạn đang ở location\n\n" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Ok"];
        prompt.tag = TAG_ALERT_LOCATION;
        prompt.delegate = self;
        [prompt show];
    }else{
        
        NSArray * tmp = [key componentsSeparatedByString:@"."];
        currentChapter = [[tmp objectAtIndex:1] intValue]; NSLog(@"currentChapter: %i", currentChapter);
        [self addChapterContentToListSpanNewWithChapterId:[NSString stringWithFormat:@"%i",currentChapter]];
        [self buildNewView];
        [self dismissModalViewControllerAnimated:YES];
        
    }
    

}
-(NSArray*) loadChapterField{
    NSMutableArray* chapterField = [[NSMutableArray alloc] init];
    int n = [allChapterArray count];
    for(int i = 0;i<n;i++){
        FieldSpecifier* f = [FieldSpecifier buttonFieldWithKey:[NSString stringWithFormat:@"Chuong.%i",i] title:[NSString stringWithFormat:@"%i. %@",(i+1), [[allChapterArray objectAtIndex:i] name]]];
        [chapterField addObject:f];
    }
    
    return chapterField;
}

#pragma -mark - show goto Option - option for view book
-(void) showGotoOption{
    //goto form
    FieldSpecifier* fBatDauDoc = [FieldSpecifier buttonFieldWithKey:kBatDauDoc title:@"Bắt đầu đọc"];
    FieldSpecifier* fViTriTrangSach = [FieldSpecifier buttonFieldWithKey:kViTriTrangSach title:@"Vị trí trang sách..."];;
    //go to các chương
    FieldSectionSpecifier *pushSection = [FieldSectionSpecifier sectionWithFields:[self loadChapterField] title:@"Mục lục" description:@""];
    
    FieldSpecifier *pushSectionField = [FieldSpecifier subsectionFieldWithSection:pushSection key:kCacChuong];
    
    
    NSArray* arrFields = [[NSArray alloc] initWithObjects: pushSectionField,fBatDauDoc,fViTriTrangSach, nil];
    
    FieldSectionSpecifier* mainSection = [FieldSectionSpecifier sectionWithFields:arrFields title:@"" description:@""];
    
    NSArray *sections = [[NSArray alloc] initWithObjects:mainSection, nil];
    gotoViewController = [[FieldEditorViewController alloc] initWithFieldSections:sections title:@"Go to"];
    
    UINavigationController* gotoNavController = [[UINavigationController alloc] initWithRootViewController:gotoViewController];
    CustomNavigationBar* customNavigation = [[CustomNavigationBar alloc] initWithFrame:self.navigationController.navigationBar.frame];
    [customNavigation setBackgroundWith:[UIImage imageNamed:@"bannertop.png"]];
    [gotoNavController setValue:customNavigation forKeyPath:@"navigationBar"];
    
    [Utils addGradientForView:gotoNavController.navigationBar Operacity:0.5f];
    
    //UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:gotoViewController];
    
    gotoViewController.doneButtonTitle = @"Done";
    gotoViewController.delegate = self;
    gotoViewController.editorIdentifier = @"Go to";
    
    //[navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bannertop"] forBarMetrics:UIBarMetricsDefault];
    [self presentModalViewController:gotoNavController animated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - chapter calculator
-(NSInteger) getChapterByLocation:(NSInteger)location{
    
    NSInteger total_location_book = 0;
    int count = [allChapterArray count];
    
    for (int i =0; i<count; i++) {
        
        NSInteger tmp = total_location_book+[[allChapterArray objectAtIndex:i] totalspan];
        if(total_location_book <= location && location < tmp){
            
            return [[allChapterArray objectAtIndex:i] order];
            
        }	
		
        total_location_book = tmp;
    }
    
    return count - 1;
}

-(void) addChapterContentToListSpanNewWithChapterId:(NSString* )chId{
    NSLog(@"Chapter: %@", chId);
    listSpanNew = [self getListSpanNewWithBookId:self.bookID chapterId:chId];
    
}

- (NSArray *) getListSpanNewWithBookId:(NSString*)bookId chapterId:(NSString* )chapterId{ NSLog(@"Select ID: %@", chapterId);
    NSString* nameTableBook = [NSString stringWithFormat:@"%@%@", DATABOOKNAMEDEFAULT, bookId];
    NSString * contentChapterBookQuery = [NSString stringWithFormat:@"SELECT SPAN_CONTENT_NEW FROM %@ WHERE SPAN_BOOK_ID_NEW = '%@' AND SPAN_CHAPTER_NEW_ID = '%@'", nameTableBook, bookId, chapterId];
    
    NSString * contentChapterBook = [[DatabaseManager shareInstance] exeQueryGetString:contentChapterBookQuery];
    
    NSArray * contentChapterArray = [contentChapterBook componentsSeparatedByString:@"__123sdv456__"];
    
    return contentChapterArray;
    
}


- (NSInteger) getLocationInChapter:(int)chId{
    NSString *sql = [NSString stringWithFormat:@"SELECT SUM(`TOTAL_SPAN`) AS TOTAL FROM `CHAPTER` WHERE ID_BOOK = '%@' AND ORDER_CHAPTER < %d", self.bookID, chId];
    return [[[DatabaseManager shareInstance] exeQueryGetString:sql] intValue];
}

#pragma  - mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case TAG_ALERT_LOCATION:
            NSLog(@"Alert log here %@ index %i", alertView, buttonIndex);
            break;
            
        default:
            break;
    }
    
    
}


@end

