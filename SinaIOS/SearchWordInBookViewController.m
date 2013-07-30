//
//  SearchWordInBookViewController.m
//  sinaIos
//
//  Created by macos on 24/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchWordInBookViewController.h"
#import "Toolbar.h"
#import "DatabaseManager.h"
#import "CellSearchWord.h"

@interface SearchWordInBookViewController()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    Toolbar* topBar;
    UISearchBar* aSearchBar;
    UITableView* aTableView;
    NSMutableArray * arrayResult;
}

@property(nonatomic, strong) NSMutableArray * arrayResult;

- (NSArray *) getListSpanNewWithBookId:(NSString*)bookId chapterId:(NSString* )chapterId;
- (void) doSearchTextInBook:(NSString*)text;

@end

@implementation SearchWordInBookViewController

@synthesize idBook, arrayChapter, arrayResult;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor whiteColor]];
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
    aSearchBar = [[UISearchBar alloc] initWithFrame:topBar.frame];
    //aSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    //aSearchBar.showsCancelButton = YES;
    aSearchBar.barStyle = UIBarStyleDefault;
    [aSearchBar setBackgroundImage:[UIImage imageNamed:@"bannertop.png"]];
    [aSearchBar becomeFirstResponder];
//    [Utils removeBackground:aSearchBar];
//    aSearchBar.backgroundColor = [UIColor clearColor];
    aSearchBar.delegate = self;
    
    aTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 88)];
    self.arrayResult = [[NSMutableArray alloc] init];
    
    
    [self.view addSubview:topBar];
    [self.view addSubview:aSearchBar];
    [self.view addSubview:aTableView];
}  

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //NSLog(@" SearchWordInBookViewController - viewWillAppear arrayChapter %@", self.arrayChapter);
    
    //code snipplet here!   
}

- (NSArray *) getListSpanNewWithBookId:(NSString*)bookId chapterId:(NSString* )chapterId{
    
    NSString* nameTableBook = [NSString stringWithFormat:@"%@%@", DATABOOKNAMEDEFAULT, bookId];
    NSString * contentChapterBookQuery = [NSString stringWithFormat:@"SELECT SPAN_CONTENT_NEW FROM %@ WHERE SPAN_BOOK_ID_NEW = '%@' AND SPAN_CHAPTER_NEW_ID = '%@'", nameTableBook, bookId, chapterId];
    
    NSString * contentChapterBook = [[DatabaseManager shareInstance] exeQueryGetString:contentChapterBookQuery];
    
    NSArray * contentChapterArray = [contentChapterBook componentsSeparatedByString:@"__123sdv456__"];
    
    return contentChapterArray;
    
}
-(void)addCellTotable:(NSDictionary *) cell{
    [self.arrayResult addObject:cell];
}

- (void) doSearchTextInBook:(NSString*)text{
    
   text =  [text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
//    arrayResult = nil;
//    arrayResult = [[NSMutableArray alloc] init];
    NSInteger countChapter = [arrayChapter count];
    NSInteger tmpCount = 1;
    
    if([text rangeOfString:@" "].location == NSNotFound){
        for(NSInteger i = 0; i<countChapter; i++){
            NSArray * arrayText = [self getListSpanNewWithBookId:self.idBook chapterId:[NSString stringWithFormat:@"%i",[[arrayChapter objectAtIndex:i] order]]];
            NSInteger countText = [arrayText count];
            for (NSInteger j = 0; j< countText; j++) {
                 tmpCount++;
                if ([[arrayText objectAtIndex:j] rangeOfString:text].location != NSNotFound) {
                    
                    NSDictionary * tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:[arrayText objectAtIndex:j],@"Value",[NSNumber numberWithInt:tmpCount],@"Location", nil];
                    
                    [self performSelectorOnMainThread:@selector(addCellTotable:) withObject:tmpDic waitUntilDone:YES];
                    
                    [aTableView reloadData];
                }
                
               
            }
            
        }           
    }else{
        for(NSInteger i = 0; i<countChapter; i++){
            NSArray * arrayText = [self getListSpanNewWithBookId:self.idBook chapterId:[NSString stringWithFormat:@"%i",[[arrayChapter objectAtIndex:i] order]]];
            NSInteger countText = [arrayText count];
            for (NSInteger j = 0; j< countText; j++) {
                 tmpCount++;
                 NSString * tmpStringCompare = @"";
                
                if(i == countChapter - 1 && j == countText - 1){
                    tmpStringCompare = [NSString stringWithFormat:@"%@%@",[arrayText objectAtIndex:j]];
                }else{
                    tmpStringCompare = [NSString stringWithFormat:@"%@%@",[arrayText objectAtIndex:j],[arrayText objectAtIndex:j+1]];
                }
                
                
                
                if ([tmpStringCompare rangeOfString:text].location != NSNotFound) {
                    
                    NSDictionary * tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:tmpStringCompare,@"Value",[NSNumber numberWithInt:tmpCount],@"Location", nil];
                    
                    [self performSelectorOnMainThread:@selector(addCellTotable:) withObject:tmpDic waitUntilDone:YES];
                    
                    [aTableView reloadData];
                }
                
               
            }
            
        }           

    }
     
}

#pragma mark - search bar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [aSearchBar resignFirstResponder];
    //button cancel alway enable
//    for(id subview in [aSearchBar subviews]){
//        if ([subview isKindOfClass:[UIButton class]]) {
//            [subview setEnabled:YES];
//            break;}}
    [self.arrayResult removeAllObjects];
    [aTableView reloadData];
    self.arrayResult = [[NSMutableArray alloc] init];
    
    aTableView.dataSource = self;
    aTableView.delegate = self;
    
    [self doSearchTextInBook:searchBar.text];
    
    
//    [aTableView reloadData];
    
}



/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CellSearchWord * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil){
        cell = [[CellSearchWord alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
//cell.textLabel.frame = CGRectMake(10, 0, self.view.frame.size.width, 20);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [NSString stringWithFormat:@"%@...",[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"Value"]];
    [cell setLbLocation:[NSString stringWithFormat:@"Location %@", [[arrayResult objectAtIndex:indexPath.row] objectForKey:@"Location"]]];
    
    
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

@end
