//
//  SearchViewController.m
//  SinaIos
//
//  Created by macos on 11/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "SearchViewController.h"
#import "ViewCell.h"
#import "JSONKit.h"
#import "DatabaseManager.h"

@implementation SearchViewController

@synthesize mainVC;

- (id)init{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_background.png"]];
        searchResult = [[NSMutableArray alloc] init];
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
    aSearchBar.showsCancelButton = YES;
    aSearchBar.barStyle = UIBarStyleDefault;
    [aSearchBar becomeFirstResponder];
    [aSearchBar setBackgroundImage:[UIImage imageNamed:@"bannertop.png"]];
//    [Utils removeBackground:aSearchBar];
//    aSearchBar.backgroundColor = [UIColor clearColor];
    aSearchBar.delegate = self;
    
    gridV = [[AQGridView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44)];
    gridV.separatorStyle = AQGridViewCellSeparatorStyleSingleLine;
    gridV.showsVerticalScrollIndicator = NO;
    gridV.showsHorizontalScrollIndicator = NO;
    gridV.dataSource = self;
    gridV.delegate = self;
    
    
    [self.view addSubview:topBar];
    [self.view addSubview:aSearchBar];
    [self.view addSubview:gridV];
    [gridV reloadData];
    
}

#pragma mark - aqgridview 
- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView{
    return  [searchResult count];
}
- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index{
    static NSString * Identifier1 = @"CellIdentifier1";  //for list  
    AQGridViewCell * cell = nil;
    
    ViewCell* viewCell = (ViewCell*) [gridView dequeueReusableCellWithIdentifier:Identifier1];
    if (viewCell == nil) {
            viewCell = [[ViewCell alloc] initWithFrame:CGRectMake(0, 0 , self.view.frame.size.width-20, 140) reuseIdentifier:Identifier1];

    }
    viewCell.selectionGlowColor = parserColor(0xdfceb6);

    
    [viewCell.imageView setImageWithURL:[[searchResult objectAtIndex:index] objectForKey:@"link_image"]];
    viewCell.titleBook = [[searchResult objectAtIndex:index] objectForKey:@"name"];
    viewCell.authorBook = [[searchResult objectAtIndex:index] objectForKey:@"author"];

    if(!viewCell.imageView.image){
        viewCell.imageView.image= [UIImage imageNamed:@"cover.jpg"];
    }
    cell = viewCell;
    
    return cell;

}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView{
    return CGSizeMake(self.view.frame.size.width-20, 120.0);
}

#pragma mark - search bar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [aSearchBar resignFirstResponder];
    //button cancel alway enable
    for(id subview in [aSearchBar subviews]){
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
            break;}}
    
    [self doSearchingWithCloud:YES stringKeySearch:aSearchBar.text];
    
}

-(void) doSearchingWithCloud:(BOOL)isCloudSearch stringKeySearch:(NSString*)string{
    if (isCloudSearch) {
        NSString * dataSearch = DATA_SEARCH_BOOK(string, @"1");
        requestSearch = [Utils requestWithLink:URL_SEARCHBOOK Data:dataSearch];
        requestSearch.delegate = self;
        [requestSearch startAsynchronous];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [Utils animationForView:self.navigationController.view kCATransition:kCATransitionFromTop duration:0.5 forKey:@"FadeIn"];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - request
- (void)requestFinished:(ASIHTTPRequest *)request{
    if([request isEqual:requestSearch]){
//        NSLog(@"%@", [requestSearch responseString]);
        NSDictionary * responceDic = [[requestSearch responseString] objectFromJSONString];
        searchResult = [responceDic objectForKey:@"book"];
    }
    [gridV reloadData];
    [gridV setNeedsLayout];
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    
    [Utils aleartWithTitle:@"Thông báo" Message:@"Lỗi kết nối, vui lòng kiểm tra đường truyền" CancelButton:@"Ok" Delegate:self];
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
