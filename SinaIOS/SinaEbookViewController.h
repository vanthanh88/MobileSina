//
//  SinaEbookViewController.h
//  SinaIos
//
//  Created by macos on 11/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNEValueTrackingSlider.h"
#import "FieldEditorViewController.h"
#import "Toolbar2.h"
#import "Toolbar.h"
#import "Book.h"
#import "CTView.h"
#import "GestureRecognizerForEbookView.h"

@class BookViewProperties, LoadingView;

@protocol BookViewPropertiesDelegate <NSObject>
-(void) selectPropertyWithTagId:(NSInteger)tag;
@end

@interface SinaEbookViewController : UIViewController<BookViewPropertiesDelegate,FieldEditorViewControllerDelegate,GestureRecognizerForEbookViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate, CTViewDelegate, UIGestureRecognizerDelegate, MBProgressHUDDelegate>{
    
    
    
    Toolbar * topBar;
    UIButton * btBookmark;
    UILabel * lbTitle;
    
    Toolbar2 * bottomBar;
    UIView * bottomView;
    NSTimer *hiderTimer;
    MNEValueTrackingSlider * sliderView;
    UILabel * lbProgress;
    BookViewProperties * bookViewProperties;
    
    
    UITapGestureRecognizer * tap;
    
    NSMutableArray *allChapterArray;
    
    NSArray *listSpanNew;
    Book * currentBook;
    
    CTView *ctView;
    NSMutableArray * rangeOfText;
    NSString* stringOfChapter;
    NSInteger currentChapter;
       
    FieldEditorViewController * gotoViewController;
    UINavigationController* searchWordNavController;
    
    LoadingView *loadingView;
}

@property (nonatomic, retain) LoadingView *loadingView;
@property (nonatomic, strong) NSString * bookID;

@end
