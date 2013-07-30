//
//  ViewBookViewController.m
//  SinaIOS
//
//  Created by Dac Diep Vuong on 12/28/12.
//
//

#import "ViewBookViewController.h"
#import "DatabaseManager.h"

@interface ViewBookViewController ()

@end

@implementation ViewBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view load
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - database
- (NSArray *) getListSpanNewWithBookId:(NSString*)bookId chapterId:(NSString* )chapterId{
    NSString* nameTableBook = [NSString stringWithFormat:@"%@%@", DATABOOKNAMEDEFAULT, bookId];
    NSString * contentChapterBookQuery = [NSString stringWithFormat:@"SELECT SPAN_CONTENT_NEW FROM %@ WHERE SPAN_BOOK_ID_NEW = '%@' AND SPAN_CHAPTER_NEW_ID = '%@'", nameTableBook, bookId, chapterId];
    
    NSString * contentChapterBook = [[DatabaseManager shareInstance] exeQueryGetString:contentChapterBookQuery];
    
    NSArray * contentChapterArray = [contentChapterBook componentsSeparatedByString:@"__123sdv456__"];
    
    return contentChapterArray;
    
}

#pragma mark - format string
//- (CGSize)getSizeText:(NSString *)string font:(UIFont *)font frame:(CGSize)frame {
//    CGSize size = [string sizeWithFont:font constrainedToSize:frame lineBreakMode:UILineBreakModeWordWrap];
//    return nil;
//}

#pragma mark - 

@end
