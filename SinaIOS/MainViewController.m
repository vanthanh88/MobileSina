//
//  MainViewController.m
//  SinaIos
//
//  Created by macos on 04/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"
#import "MCSegmentedControl.h"
#import "JSONKit.h"
#import "ViewCell.h"
#import "UIImageView+WebCache.h"
#import "Category.h"
#import "DetailBookViewController.h"
#import "SearchViewController.h"
#import "CustomNavigationBar.h"
#import "CategoryManager.h"
#import "ContactViewController.h"
#import "SinaEbookViewController.h"
#import "DatabaseManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ZipArchive.h"

//define key setting
#define kSortSegmentControl             @"segmentSort"
#define kUserLogin                      @"userlogin"
#define kEmailAddress                   @"emailaddress"
#define kLienHeVoiChungToi              @"lienhevoichungtoi"
#define kChinhSachBaoMat                @"chinhsachbaomat"
#define kThongTinPhanMem                @"thongtinphanmem"
#define kHieuUngLatTrang                @"hieuunglattrang"

enum {
    segmentSortTime = 0,
    segmentSortTitle,
    segmentSortPrice
};

enum {
    user_type_khach = 0,
    user_type_loginfb,
    user_type_loginnomal
    };

@interface MainViewController(){

    BOOL isLoadMore;
    BOOL checkIfLoadCategory;
    NSString * idcurentCat;
    UIView * loadMoreView;
    
    //mang chua tat ca cac book hien co trong may
    NSMutableArray * bookExistsOnDevice;
    NSInteger segmentSort; //lua chon trong menu setting
    NSInteger userType;
    
    NSDictionary * currentBookInformation;
}


- (void)loadData;
-(BOOL) checkBookDownloaded:(NSInteger) idBook; //kiem tra xem book da download ve may hay chua
-(NSString*)listUserSBook: (NSString*)idUser; //kiem tra sach do cua User hay khong tra ve kieu 1,2,3,4,...
-(BOOL) checkUserBookWithIdUser: (NSInteger)idUser andIdBook: (NSInteger)idBook; //Kiem tra id book co phai cua user hien thoi hay khong.
-(void) showAllUserBookOnDevice; // hien thi tat ca cac sach cua user dang dang nhap hien co tren device

//parser book
- (void)unzipFilePath:(NSString*)path;
-(void) parserBook;


@property(nonatomic,assign) BOOL gridActive;
@property(nonatomic,assign) BOOL checkOnCloud;
@property (nonatomic, assign) BOOL checkLoadedDevice;

@end

@implementation MainViewController
@synthesize gridActive, checkOnCloud, checkLoadedDevice;

@synthesize userInformation, userEmail,listBookOnCloud, listBookOnDevice, listBookNeedToSync, current_page;

-(id)init{
    
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_background.png"]];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.gridActive = YES;
    self.checkOnCloud= YES;
    self.checkLoadedDevice = NO;
    checkIfLoadCategory = NO;
    idcurentCat = @"";
    //[self performSelector:@selector(loadData) withObject:nil afterDelay:0.0];
    [self loadData];
    
    // khoi tao bien loadmore
    isLoadMore = YES;
    loadMoreView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 44)];
    UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = CGRectMake(30, 10, 25, 25);
    UILabel * lb = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 300, 30)];
    lb.backgroundColor = [UIColor clearColor];
    [activityView startAnimating];
    [loadMoreView addSubview:activityView];
    [loadMoreView addSubview:lb];
    lb.text = @"Đang tải dữ liệu...";
    //[self.gridV addSubview:loadMoreView];
    self.gridV.gridFooterView = loadMoreView;
    self.gridV.gridFooterView.backgroundColor = [UIColor clearColor]; 
    [self.gridV setContentInset:(UIEdgeInsetsMake(0, 0, -30, 0))];
    
    [loadMoreView setAlpha:0.f];
    
    [self showAllUserBookOnDevice]; //neu co sach cua nguoi dung tren device thi show;
    
    //    // Show the footer
    //    [UIView animateWithDuration:0.3 animations:^{
    //        self.gridV.contentInset = UIEdgeInsetsMake(0, 0, 44+self.view.frame.size.height, 0);
    //        
    //    }];
    

    
//    NSDictionary * tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Object 1",@"boi_avatar",
//                             @"Object 2",@"name",@"Object 3",@"author",@"Object 4",@"category",nil];
//    
//    [listBookOnCloud addObject:tmpDic];
//    [listBookOnCloud addObject:tmpDic];
//    [Utils aleartWithTitle:@"Thong bao" Message:[NSString stringWithFormat:@"NSUserDefault %@", [[NSUserDefaults standardUserDefaults] stringForKey:USERID_PREFERENCES]] CancelButton:@"Ok" Delegate:nil];
   

   

}

-(void) viewWillAppear:(BOOL)animated{
    
    if ([UIApplication sharedApplication].statusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
    //luu tat ca book co tren device de so sanh
    bookExistsOnDevice = [[DatabaseManager shareInstance] exeQueryGetTable:@"SELECT * FROM BOOK" ObjectInstance:[Book new]];
    [self.gridV reloadData];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERTYPE_PREFERENCES] != nil) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:USERTYPE_PREFERENCES] isEqualToString:@"type_nomal"]) {
            userType = user_type_loginnomal;

        }else{
            userType = user_type_loginfb;
            
        }
        
        self.userInformation = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
//        NSLog(@"self.userInformation %@",self.userInformation);
        
    }else{
        userType = user_type_khach;
        
    }
    
    NSString *modalClassName = NSStringFromClass([self.modalViewController class]);
    if([modalClassName isEqualToString:@"LoginViewController"]){
        [self showAllUserBookOnDevice];

    }
//    [horizontalMenu setSelectedIndex:1 animated:NO];
    
    if(current_page == 1){
        [self loadData];
    }
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
    
    //self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.gridActive = YES;
    //top View
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [Utils addGradientForView:topView Operacity:0.5f];
    
    topView.backgroundColor = ColorWithImage(@"bannertop.png");
    topView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    //bottom view
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    [Utils addGradientForView:bottomView Operacity:0.5f];
    bottomView.backgroundColor = ColorWithImage(@"banner_bottom.png");
    bottomView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;

    btKindView = [Utils newButtonWithTitle:@"" target:self selector:@selector(kindViewClicked) frame:CGRectMake(15, 13, 25, 25) image:[UIImage imageNamed:@"menu.png"] hilightImage:[UIImage imageNamed:@"menu.png"]];
    [bottomView addSubview:btKindView];
    
    //setting
    btSetting = [Utils newButtonWithTitle:@"" target:self selector:@selector(showSetting) frame:CGRectMake(bottomView.frame.size.width - 40, 13, 25, 25) image:[UIImage imageNamed:@"settingicon.png"] hilightImage:[UIImage imageNamed:@"settingicon.png"]];
    [bottomView addSubview:btSetting];
    //segment control
    NSArray *item = [NSArray arrayWithObjects:@"Cloud",@"Device", nil];
    
    segmentControl = [[MCSegmentedControl alloc] initWithItems:item];

    segmentControl.frame = CGRectMake(89.0f, 13.0f, 143.0f, 28.0f);
    [bottomView addSubview:segmentControl];
    segmentControl.tintColor = parserColor(0x1b1b1b);
    segmentControl.unSelectedItemBackgroundGradientColors=[NSArray arrayWithObjects:parserColor(0x403e3e),parserColor(0x181818), nil];
    segmentControl.selectedItemColor = parserColor(0xffffff);
    segmentControl.unselectedItemColor=parserColor(0xffffff);
    [segmentControl addTarget:self action:@selector(segmentedControlDidChange:) forControlEvents:UIControlEventValueChanged];
    segmentControl.selectedSegmentIndex=0;
    [segmentControl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
    
    
    
    //horizontal menu    
    UIImage *imgSearch = [UIImage imageNamed:@"search-icon.png"];
//    UIImage * v = [UIImage imageNamed:@"bg_trongsuot.png"];
    NSMutableArray * arrayTmp = [[NSMutableArray alloc] init];
    
//    [arrayTmp addObject:v];
    [arrayTmp addObject:imgSearch];
    [arrayTmp addObject:@"Tất cả"];
    [arrayTmp addObject:@"Sách"];
//    [arrayTmp addObject:v];
    
    itemsHoriMenu = arrayTmp;
    horizontalMenu = [[MKHorizMenu alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 44)];
    
//    NSLog(@"item %@", itemsHoriMenu);
    
    [topView addSubview:horizontalMenu];
    UIImageView *mask=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask.png"]];
	mask.frame=topView.frame;
    mask.alpha = .4f;
	[topView addSubview:mask];
    
    horizontalMenu.dataSource = self;
    horizontalMenu.itemSelectedDelegate= self;
    
    [horizontalMenu reloadData];
    
    //khoi tao du lieu cho chuong trinh
    self.current_page = 1;
    segmentSort = 1;
    listBookOnCloud = [[NSMutableArray alloc] init];
    listBookOnDevice = [[NSMutableArray alloc] init];
    listBookNeedToSync = [[NSMutableArray alloc] init];
    
    [self.view addSubview:topView];
    [self.view addSubview:bottomView];
    
    
    //khoi tao queue multiple insert
    queueMultiInsert = [[IPOfflineQueue alloc] initWithName:@"queuemultipleinsert" delegate:self];

}
#pragma  mark - segmented control
- (void)segmentedControlDidChange:(MCSegmentedControl *)sender{
    
    if(sender.selectedSegmentIndex == 0){
        self.checkOnCloud = YES;
    }else{
        self.checkOnCloud = NO;
        if(listBookOnDevice.count == 0) [self.view makeToast:@"Bạn hãy tải sách từ Cloud" duration:1.f position:@"center"];
    }
   
    [self.gridV reloadData];
    
//    [self.gridV setNeedsLayout];
//    NSLog(@"NSUserDefault %@ ", [[NSUserDefaults standardUserDefaults] stringForKey:USER_PREFERENCES]);
//    NSLog(@"NSUserDefault 1 %@ ", [[NSUserDefaults standardUserDefaults] stringForKey:EMAIL_PREFERENCES]);
//    NSLog(@"NSUserDefault 2 %@ ", [[NSUserDefaults standardUserDefaults] stringForKey:NAME_PREFERENCES]);
    
}
#pragma mark - AQgridView datasource and delegate
- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView{
    return  self.checkOnCloud?[listBookOnCloud count]:[listBookOnDevice count];
}
- (AQGridViewCell*) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index{

    static NSString * Identifier = @"CellIdentifier"; //for Grid
    static NSString * Identifier1 = @"CellIdentifier1";  //for List  
    AQGridViewCell * cell = nil;
    
    ViewCell* viewCell = (ViewCell*) [gridView dequeueReusableCellWithIdentifier:self.gridActive ? Identifier : Identifier1];
    if (viewCell == nil) {
        if (self.gridActive) {
            viewCell = [[ViewCell alloc] initWithFrame:CGRectMake(0, 0 , 100.0, 130) reuseIdentifier : Identifier];
        }else{
            viewCell = [[ViewCell alloc] initWithFrame:CGRectMake(0, 0 , self.view.frame.size.width-20, 140) reuseIdentifier:Identifier1];
        }
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [viewCell addGestureRecognizer:longPress];

    }
    viewCell.selectionGlowColor = parserColor(0xdfceb6);
    //NSLog(@"%@",FetchData(listBookOnCloud, index, @"link_image"));
    if (self.checkOnCloud){
        
        if ([self checkBookDownloaded:[FetchData(listBookOnCloud, index,KEY_IDBOOK) intValue]] && [self checkUserBookWithIdUser:[[[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES] intValue] andIdBook:[FetchData(listBookOnCloud, index,KEY_IDBOOK) intValue]]) {
            viewCell.statusBook = BOOKSTATUS_DOWLOADED;
        }else{
            viewCell.statusBook = BOOKSTATUS_ONCLOUD;
        }
        [viewCell.imageView setImageWithURL:[NSURL URLWithString:FetchData(listBookOnCloud, index, @"link_image")]];
        viewCell.titleBook = FetchData(listBookOnCloud, index,KEY_NAME);
        viewCell.authorBook = FetchData(listBookOnCloud, index,KEY_AUTHOR);
        //NSLog(@"checkOnCloud");
    }
    else { 

        if ([self checkBookDownloaded:[FetchData(listBookOnDevice, index,KEY_IDBOOK) intValue]] /* && [self checkUserBookWithIdUser:[[[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES] intValue] andIdBook:[FetchData(listBookOnCloud, index,KEY_IDBOOK) intValue]]*/) {
            viewCell.statusBook = BOOKSTATUS_DOWLOADED;
        }else{
            viewCell.statusBook = BOOKSTATUS_ONCLOUD;
        }
        
        [viewCell.imageView setImageWithURL:[NSURL URLWithString:FetchData(listBookOnDevice, index, @"boi_avatar")]];
        viewCell.titleBook = FetchData(listBookOnDevice, index,KEY_NAME);
        viewCell.authorBook = FetchData(listBookOnDevice, index,KEY_AUTHOR);
        //NSLog(@"!checkOnCloud");
    }
    
    if(!viewCell.imageView.image){
        viewCell.imageView.image= [UIImage imageNamed:@"cover.jpg"];
    }
    cell = viewCell;

    return cell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView{
    if(self.gridActive) {
        return CGSizeMake(100.0, 140.0);
    }
    else {
        return CGSizeMake(self.view.frame.size.width-20, 120.0);
    }

}
#pragma mark - AQgrid delegate
- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index{

    NSLog(@"index %u", index);
    
    if(self.checkOnCloud){
        if(index > listBookOnCloud.count) return;
        if (![self checkUserBookWithIdUser:[[[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES] intValue] andIdBook:[FetchData(listBookOnCloud, index, KEY_IDBOOK) intValue]]) {
            DetailBookViewController* detailBookVC = [[DetailBookViewController alloc] init];
            detailBookVC.BookId = FetchData(listBookOnCloud, index, KEY_IDBOOK);
            detailBookVC.urlCover = FetchData(listBookOnCloud, index, KEY_LINK_IMAGE);
//            if(detailBookVC.queueInsert != nil){
//                [detailBookVC.queueInsert halt];
//                detailBookVC.queueInsert = nil;
//            }
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController pushViewController:detailBookVC animated:YES];

            return;
        }
        NSLog(@"User preferences %@", [[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES]);
        if([[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES] == nil){
            [self.view makeToast:@"Vui lòng đăng nhập để thực hiện chức năng" duration:1.f position:@"center"];
            return;
        }
    }

    if(self.checkOnCloud){
        if(index > listBookOnCloud.count) return;
        NSString * selectQuery = [NSString stringWithFormat:@"SELECT * FROM BOOK WHERE ID = %@", FetchData(listBookOnCloud, index, KEY_IDBOOK)];
        if([[DatabaseManager shareInstance] exeQueryGetCountInt:selectQuery] != 0){  
            SinaEbookViewController* sinaEbookVC = [[SinaEbookViewController alloc] init];
            self.navigationController.navigationBarHidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            sinaEbookVC.bookID = FetchData(listBookOnCloud, index, KEY_IDBOOK);
//            NSLog(@"Id book %@",FetchData(listBookOnCloud, index, KEY_IDBOOK));
            [self.navigationController pushViewController:sinaEbookVC animated:YES];
            
        }else{
            
            DetailBookViewController* detailBookVC = [[DetailBookViewController alloc] init];
            detailBookVC.BookId = FetchData(listBookOnCloud, index, KEY_IDBOOK);
            detailBookVC.urlCover = FetchData(listBookOnCloud, index, KEY_LINK_IMAGE);

            detailBookVC.mainVC = self;
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController pushViewController:detailBookVC animated:YES];
        } 
    }else{
        if(index > listBookOnDevice.count) return;
        NSString * selectQuery = [NSString stringWithFormat:@"SELECT * FROM BOOK WHERE ID = %@", FetchData(listBookOnDevice, index, KEY_IDBOOK)];
        if([[DatabaseManager shareInstance] exeQueryGetCountInt:selectQuery] != 0){
            SinaEbookViewController* sinaEbookVC = [[SinaEbookViewController alloc] init];
            self.navigationController.navigationBarHidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            sinaEbookVC.bookID = FetchData(listBookOnDevice, index, KEY_IDBOOK);
            NSLog(@"User %@", [[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES]);
            [self.navigationController pushViewController:sinaEbookVC animated:YES];
            
            
        }else{
            DetailBookViewController* detailBookVC = [[DetailBookViewController alloc] init];
            detailBookVC.BookId = FetchData(listBookOnDevice, index, KEY_IDBOOK);
            detailBookVC.urlCover = FetchData(listBookOnDevice, index, @"boi_avatar");

            detailBookVC.mainVC = self;
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController pushViewController:detailBookVC animated:YES];
            } 
        }
}

-(void) handleLongPress: (UIGestureRecognizer *)longPress {
    if (!self.checkOnCloud) {

        if (longPress.state==UIGestureRecognizerStateBegan) {

            CGPoint pressPoint = [longPress locationInView:self.gridV];
            NSUInteger index = [self.gridV indexForItemAtPoint:pressPoint];

            if (![self checkBookDownloaded:[FetchData(listBookOnDevice, index, KEY_IDBOOK) intValue]]) {
                return;
            }
            
            alertDeleteBook = [[ExtraAlert alloc] initWithTitle:@"Thông báo" message:[NSString stringWithFormat:@"Bạn thực sự muốn xóa quyển sách \"%@\"?",FetchData(listBookOnDevice, index, KEY_NAME)] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
            alertDeleteBook.idBook = FetchData(listBookOnDevice, index, KEY_IDBOOK);
            alertDeleteBook.index = index;
            alertDeleteBook.delegate = self;
            
            [alertDeleteBook show];
            
            
        }
    }
    
}
#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if ([alertView isEqual:alertDeleteBook]) {
        if (buttonIndex == 0) {
            NSLog(@"Xoa sach co id %@", alertDeleteBook.idBook);
            NSString * deleteChapter = [NSString stringWithFormat:@"DELETE FROM CHAPTER WHERE ID_BOOK = %@", alertDeleteBook.idBook];
            [[DatabaseManager shareInstance] exeQueryNoneResult:deleteChapter];
            
            NSString * deleteConfig = [NSString stringWithFormat:@"DELETE FROM CONFIG WHERE BOOK_ID = %@ AND ID_USER = %@",alertDeleteBook.idBook,[[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES]];
            [[DatabaseManager shareInstance] exeQueryNoneResult:deleteConfig];
            
            NSString * deleteBook = [NSString stringWithFormat:@"DELETE FROM BOOK WHERE ID = %@", alertDeleteBook.idBook];
            [[DatabaseManager shareInstance] exeQueryNoneResult:deleteBook];
            
            NSString * deleteUser = [NSString stringWithFormat:@"DELETE FROM USER WHERE ID_BOOK = %@ AND ID_USER = %@",alertDeleteBook.idBook,[[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES]];
            [[DatabaseManager shareInstance] exeQueryNoneResult:deleteUser];
            
            NSString * deleteContentBook = [NSString stringWithFormat:@"DROP TABLE IF EXISTS SPAN_TABLE_NEW%@", alertDeleteBook.idBook];
            [[DatabaseManager shareInstance] exeQueryNoneResult:deleteContentBook];
            
            NSString * deleteBookmark = [NSString stringWithFormat:@"DELETE FROM BOOKMARK_TABLE WHERE BOOKMARK_BOOK_ID=%@ AND BOOKMARK_ID_USER = %@",alertDeleteBook.idBook,[[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES]];
            
            [[DatabaseManager shareInstance] exeQueryNoneResult:deleteBookmark];
            
            [listBookOnDevice removeObjectAtIndex:alertDeleteBook.index];
            [self.gridV reloadData];
            
            
        }
    }
}

#pragma mark - refresh data load from server
- (void)refresh{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}

- (void)loadData {
    
    if(self.checkOnCloud == YES){
        NSString* page = [NSString stringWithFormat:@"%i",self.current_page];
        NSString* sort = [NSString stringWithFormat:@"%i", segmentSort];
        
        NSString *dataListOnCloud = DATALISTONCLOUD(@"0", sort, page);
        
        //        NSLog(@"Data Post %@", dataListOnCloud);
        aRequestLoadListBook = [Utils requestWithLink:URL_LISTBOOKONCLOUD Data:dataListOnCloud];
        aRequestLoadListBook.delegate = self;
        aRequestLoadListBook.downloadProgressDelegate= self;
        [aRequestLoadListBook startAsynchronous];
        
    }else{
        if(userType == user_type_khach){
            [self stopLoading];
            [self.view makeToast:@"Vui lòng đăng nhập để thực hiện chức năng" duration:1.f position:@"center"];
        }else{
//            [listBookOnDevice removeAllObjects];
            NSUserDefaults* currentUser = [NSUserDefaults standardUserDefaults];
            //        NSString * listUserSBook = [self listUserSBook:[currentUser objectForKey:@"IDUSER"]];

            NSString *dataSync = DATASYNC([currentUser objectForKey:USERID_PREFERENCES], [self listUserSBook:[currentUser objectForKey:USERID_PREFERENCES]]);
//            NSLog(@"Data Post %@, %@", dataSync, [currentUser objectForKey:USERID_PREFERENCES]);
            aResquestSync = [Utils requestWithLink:URL_SYNC Data:dataSync];
            aResquestSync.delegate = self;
            aResquestSync.downloadProgressDelegate= self;
            [aResquestSync startAsynchronous];
            
        }
    }

    
//    if (checkIfLoadCategory) {
//       
//        NSString * currentPageS = [NSString stringWithFormat:@"%i", current_page];
//        NSString * segmentSortS = [NSString stringWithFormat:@"%i",segmentSort];
//        
//        NSString * dataLoadBook  = DATA_GET_BOOK_BY_CAT(idcurentCat, currentPageS, segmentSortS);
//        
//        NSLog(@"data post segment %@", dataLoadBook);
//        aReQuestLoadBookByCat = [Utils requestWithLink:URL_GET_BOOK_BY_CAT Data:dataLoadBook];
//        aReQuestLoadBookByCat.delegate = self;
//        [aReQuestLoadBookByCat startAsynchronous];
//    }
//    else{
        // Add a new time
         
//    }
       
    
}
-(void)forceReloadGridView{
    [self.gridV reloadData];
}
#pragma mark - IPOfflineQueueDelegate
- (BOOL)offlineQueueShouldAutomaticallyResume:(IPOfflineQueue *)queue
{
    return YES;
}

- (IPOfflineQueueResult)offlineQueue:(IPOfflineQueue *)queue executeActionWithUserInfo:(NSDictionary *)userInfo{
     NSLog(@"Executing task: %@", [userInfo valueForKey:@"bookID"]);
    [self unzipFilePath:[userInfo objectForKey:@"bookFilePath"]];
    [self parserBook];
    [self performSelectorOnMainThread:@selector(forceReloadGridView) withObject:nil waitUntilDone:YES];
    NSLog(@"done task: %@", [userInfo valueForKey:@"bookFilePath"]);
    return IPOfflineQueueResultSuccess;
}

#pragma mark - request delegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    
    if([request isEqual:aResquestSync]){
        
        NSString *responseSync = [aResquestSync responseString];
        NSDictionary *responseDic = [responseSync objectFromJSONString];
//        NSLog(@"Responce dic sync%@", responseSync);
        NSMutableArray* tempArray = nil;
        if ([[responseDic objectForKey:KEY_SUCCESS] intValue]==1) {
            tempArray =[responseDic objectForKey:@"list_book"];
            
        }else if ([responseDic isEqual:nil]){
            [Utils aleartWithTitle:@"Lỗi" Message:@"Mất kết nối" CancelButton:@"Ok" Delegate:nil];
        }else{
            [Utils aleartWithTitle:@"Lỗi" Message:@"Sai thông tin" CancelButton:@"Ok" Delegate:nil];
        }
        if (self.checkLoadedDevice==NO) {
            self.checkLoadedDevice = YES;
            
           
            int n = [tempArray count];
            
            if(n>=5){
                //optimazer data
                for (int i =0; i< 5; i++) {
                    if([[tempArray objectAtIndex:i] objectForKey:@"message"] == nil){
                        //tac vu download book
                    }
                }
            }

//            NSLog(@"listBookOnDevice  %@", [listBookOnDevice objectAtIndex:2]);

            
//            [self showAllUserBookOnDevice];
//            [self.gridV reloadData];
//            [self.gridV setNeedsDisplay];
            
        }
        [self stopLoading];
        loadMoreView.alpha = 0.f;
        isLoadMore = NO;
  
    }else if([request isEqual:aResquestDownloadBook]){
        //download tai detail
        NSData * data = [aResquestDownloadBook responseData];
        NSString * filePath = [NSString stringWithFormat:@"%@/%@.zip", [Utils applicationDocumentsDirectory],[currentBookInformation objectForKey:KEY_NAME]];
        [data writeToFile:filePath  atomically:YES];
        
        NSLog(@"Run OK ======== OK");
        //day vao queue de download lan luot tat ca
        
//        [self unzipFilePath:filePath];
//        [self parserBook];
   
     
    }else if([request isEqual:aRequestLoadListBook]){
        
        NSLog(@"self.current_page %i", self.current_page);

        
        NSString *responseSync = [aRequestLoadListBook responseString];
        NSDictionary *responseDic = [responseSync objectFromJSONString];
        //NSLog(@"Responce dic %@", responseSync);
        NSMutableArray* tempArray = nil;
        if ([[responseDic objectForKey:KEY_SUCCESS] intValue]==1) {
            tempArray =[responseDic objectForKey:@"book"];
        }else if ([responseDic isEqual:nil]){
           
            [Utils aleartWithTitle:@"Lỗi" Message:@"Mất kết nối" CancelButton:@"Ok" Delegate:self];
            
        }else{
           
            [Utils aleartWithTitle:@"Lỗi" Message:@"Sai thông tin" CancelButton:@"Ok" Delegate:self];
            
        }
        int n = [tempArray count];
        if (n==0) {
            [self stopLoading];
            loadMoreView.alpha = 0.f;
            isLoadMore = NO;
            self.gridV.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            return;
        }else{
            self.current_page++;
         
        }
        //optimazer data
        for (int i =0; i<n; i++) {
            
            if([[tempArray objectAtIndex:i] objectForKey:@"message"] == nil){
                [listBookOnCloud addObject:[tempArray objectAtIndex:i]];
            }
        }
        
        //NSLog(@"%@ --- %@", listBookOnDevice, listBookOnCloud);
        [self.gridV reloadData];
//        [self.gridV setNeedsDisplay];
        [self.view makeToast:@"Kéo xuống để xem thêm sách" duration:1.f position:@"center"];
        
        
        
    }else if([request isEqual:aReQuestLoadBookByCat]){ //load book by category
        NSLog(@"self.current_page %i", self.current_page);
        
        
        NSString *responseSync = [aReQuestLoadBookByCat responseString];
        NSDictionary *responseDic = [responseSync objectFromJSONString];
        //NSLog(@"Responce dic %@", responseSync);
        NSMutableArray* tempArray = nil;
        if ([[responseDic objectForKey:KEY_SUCCESS] intValue]==1) {
            tempArray =[responseDic objectForKey:@"book"];
        }else if ([responseDic isEqual:nil]){
            
            [Utils aleartWithTitle:@"Lỗi" Message:@"Mất kết nối" CancelButton:@"Ok" Delegate:self];
            
        }else{
            
            [Utils aleartWithTitle:@"Lỗi" Message:@"Sai thông tin" CancelButton:@"Ok" Delegate:self];
            
        }
        int n = [tempArray count];
        if (n==0) {
             [self.view makeToast:@"Tất cả sách đã được hiển thị" duration:1.f position:@"center"];
            [self stopLoading];
            checkIfLoadCategory = NO;
            loadMoreView.alpha = 0.f;
            isLoadMore = NO;
            self.gridV.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
           
            return;
        }else{
            self.current_page++;
            
        }
        //optimazer data
        for (int i =0; i<n; i++) {
            
            if([[tempArray objectAtIndex:i] objectForKey:@"message"] == nil){
                [listBookOnCloud addObject:[tempArray objectAtIndex:i]];
            }
        }
        
        //NSLog(@"%@ --- %@", listBookOnDevice, listBookOnCloud);
        [self.gridV reloadData];
//        [self.gridV setNeedsDisplay];
        
        [self.view makeToast:@"Kéo xuống để xem thêm sách" duration:1.f position:@"center"];
    }
    [self stopLoading];
    
    loadMoreView.alpha =0.f;
    isLoadMore = YES;
}


- (void)requestFailed:(ASIHTTPRequest *)request{
    [self stopLoading];

    loadMoreView.alpha = 0.f;
    isLoadMore = YES;
//    [Utils aleartWithTitle:@"Lỗi" Message:@"Lỗi, vui lòng xem lại kết nối mạng của bạn" CancelButton:@"Ok" Delegate:self];
    [self.view makeToast:@"Kết nối mạng không khả dụng, vui lòng kiểm tra lại" duration:1.f position:@"center"];
    
}

-(void) showAllUserBookOnDevice{
    
    //hien cac sach cua nguoi dung ma co tren device;
    NSString* select = [NSString stringWithFormat:@"Select * from BOOK,USER where USER.ID_USER = %@ and BOOK.ID = USER.ID_BOOK", [[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES]];
    
    EGODatabaseResult *result = [[DatabaseManager shareInstance] exeQueryGetTable:select];
    if (result.count>0) {
        for(EGODatabaseRow * row in result){
            NSDictionary * tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[row intForColumn:@"ID"]],KEY_IDBOOK,[row stringForColumn:@"NAME"],KEY_NAME, [row stringForColumn:@"AUTHOR"],KEY_AUTHOR, [row stringForColumn:@"LINK_IMAGE"],@"boi_avatar", nil];
            [listBookOnDevice addObject:tmpDic];
        }
    }
    //        [self loadData];
    [self.gridV reloadData];
}


#pragma mark - click to grid and list
-(void) kindViewClicked{
    
    
    if (self.gridActive) {
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        
        
        [btKindView setBackgroundImage:[UIImage imageNamed:@"menu_grid.png"] forState:UIControlStateNormal];
        self.gridV.separatorStyle = AQGridViewCellSeparatorStyleSingleLine;
        self.gridActive = NO;
    }else{
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

        
        [btKindView setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        
        self.gridV.separatorStyle = AQGridViewCellSeparatorStyleNone;
        self.gridActive = YES;
    }
    
     [self.gridV reloadData];
     [self.gridV setNeedsLayout];
}



/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:NO];
//    NSLog(@"viewDidDisappear");
//    self.gridV = nil;
//}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    NSLog(@"viewDidUnload");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - show setting
-(void) showSetting{
    NSLog(@"showSetting - User Infor: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    //section sap xep
    NSArray *groupSorting = [[NSArray alloc] initWithObjects:@"Thời gian",@"Tiêu đề", @"Giá cả", nil];
    FieldSpecifier *sort = [FieldSpecifier segmentFieldWithKey:kSortSegmentControl segments:groupSorting defaultSegment:segmentSort];
    //    NSLog(@"Segment sort %i", segmentSort);
    NSArray *sectionSortArray = [[NSArray alloc] initWithObjects:sort, nil];
    FieldSectionSpecifier *sectionSort = [FieldSectionSpecifier sectionWithFields:sectionSortArray title:@"Sắp xếp theo thứ tự" description:@""];
    //section hien thi sach theo danh muc
    
	NSMutableArray *danhmucsach = [NSMutableArray array];
    NSMutableArray* dataCategory = [[CategoryManager sharedCategory] allCategory];
    NSString * currentCat = [[CategoryManager sharedCategory] currentCategory];
    
    //NSLog(@"Curent cat %@ Arr %@", currentCat, dataCategory);
    int cat_count = [dataCategory count];
    for (int i = 0; i<cat_count;i++) {
        // NSString * tempString = [dataCategory objectAtIndex:i];
		FieldSpecifier *danhmuc = [FieldSpecifier checkFieldWithKey:[NSString stringWithFormat:@"%i.%@",[[dataCategory objectAtIndex:i] id_cat],[[dataCategory objectAtIndex:i] name]] title:[[dataCategory objectAtIndex:i] name] defaultValue:[currentCat isEqualToString:[[dataCategory objectAtIndex:i] name]]];
        
        //NSLog(@"Default Value %@", tempString);
		[danhmucsach addObject:danhmuc];
	}
    
	FieldSectionSpecifier *categoryBookSection = [FieldSectionSpecifier sectionWithFields:danhmucsach title:@"Danh mục" description:nil];
	categoryBookSection.exclusiveSelection = YES;
	FieldSpecifier *categoryBookSectionField = [FieldSpecifier subsectionFieldWithSection:categoryBookSection key:@"category"];
    
    FieldSectionSpecifier* categoryBookSectionMain = [FieldSectionSpecifier sectionWithFields:[NSArray arrayWithObjects:categoryBookSectionField,nil] title:@"Hiển thị sách theo danh mục" description:nil];
    //tao 1 view co nut huy dang ky thiet bi
    FieldSpecifier *deRegister = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:NAME_PREFERENCES] == nil /*|| [[NSUserDefaults standardUserDefaults] objectForKey:NAME_PREFERENCES] == @""*/){
        UIView* viewDeregister = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 200)];
        viewDeregister.backgroundColor = [UIColor clearColor];
        UIButton* bDeregister = [Utils newButtonWithTitle:@"Đăng nhập" target:self selector:@selector(DangNhapClick) frame:CGRectMake(20, 50, self.view.frame.size.width-60, 30) image:nil hilightImage:nil];
        [Utils addGradient:bDeregister];
        bDeregister.backgroundColor = parserColor(0xacc813);
        [viewDeregister addSubview:bDeregister];
        
        deRegister = [FieldSpecifier viewNomalFieldWithKey:@"viewNomal" viewNomal:viewDeregister];
    }else{
        UIView* viewDeregister = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 200)];
        
        viewDeregister.backgroundColor = [UIColor clearColor];
        UIButton* bDeregister = [Utils newButtonWithTitle:@"Hủy đăng ký thiết bị" target:self selector:@selector(huyDangKyThietBiClick) frame:CGRectMake(20, 50, self.view.frame.size.width-60, 30) image:nil hilightImage:nil];
        [Utils addGradient:bDeregister];
        bDeregister.backgroundColor = parserColor(0xacc813);
        [viewDeregister addSubview:bDeregister];
        
        deRegister = [FieldSpecifier viewNomalFieldWithKey:@"viewNomal" viewNomal:viewDeregister];
    }
	FieldSectionSpecifier *pushSection = [FieldSectionSpecifier sectionWithFields:[NSArray arrayWithObjects:deRegister, nil] title:(([[NSUserDefaults standardUserDefaults] objectForKey:NAME_PREFERENCES] == nil /*|| [[NSUserDefaults standardUserDefaults] objectForKey:NAME_PREFERENCES] == @""*/) ? @"Bạn là khách" :[[NSUserDefaults standardUserDefaults] objectForKey:NAME_PREFERENCES]) description:@""];
    pushSection.showHeader = NO;
    pushSection.exclusiveSelection =YES;
    
    
	FieldSpecifier *pushSectionField = [FieldSpecifier subsectionFieldWithSection:pushSection key:@"PushSectionField"];
	FieldSectionSpecifier *pushSectionFieldSection = [FieldSectionSpecifier sectionWithFields:[NSArray arrayWithObject:pushSectionField] title:@"Đăng nhập" description:nil];
    pushSectionFieldSection.textExclusiveSelectionDefault = @"Cập nhật";
    //Sent to 123doc email address
    FieldSpecifier *email = [FieldSpecifier buttonFieldWithKey:kEmailAddress title:(([[NSUserDefaults standardUserDefaults] objectForKey:EMAIL_PREFERENCES] == nil /* ||[[NSUserDefaults standardUserDefaults] objectForKey:EMAIL_PREFERENCES] == @""*/) ? @"Bạn hãy đăng nhập để có thể tải sách" :[[NSUserDefaults standardUserDefaults] objectForKey:EMAIL_PREFERENCES])];
    email.disable = YES;
    //Liên hệ với chúng tôi
    //    FieldSpecifier *lienhe1 = [FieldSpecifier buttonFieldWithKey:@"3" title:@"Infor 1..."];
    //	FieldSpecifier *lienhe2 = [FieldSpecifier buttonFieldWithKey:@"4" title:@"Infor 2..."];
    //    FieldSectionSpecifier *pushSectionLienhe  = [FieldSectionSpecifier sectionWithFields:[NSArray arrayWithObjects:lienhe1,lienhe2, nil] title:@"Liên hệ với chúng tôi" description:@""];
    //    FieldSpecifier *lienheVoiChungToi = [FieldSpecifier subsectionFieldWithSection:pushSectionLienhe key:kLienHeVoiChungToi];
    
    FieldSpecifier * lienheVoiChungToi = [FieldSpecifier buttonFieldWithKey:kLienHeVoiChungToi title:@"Liên hệ với chúng tôi"];
    
    //hieu ung lat trang
    FieldSpecifier *hieuunglattrang = [FieldSpecifier switchFieldWithKey:kHieuUngLatTrang title:@"Hiệu ứng lật trang" defaultValue:NO];
    //Liên kết với mạng xã hội
    FieldSpecifier *facebook = [FieldSpecifier imageButtonFieldWithKey:@"fb" imageName:@"icon_facebook.png" textTitle:@"Facebook"];
	FieldSpecifier *zingme = [FieldSpecifier imageButtonFieldWithKey:@"zing" imageName:@"logo_zme.png" textTitle:@"Zing me"];
    FieldSectionSpecifier *pushSectionMangxh  = [FieldSectionSpecifier sectionWithFields:[NSArray arrayWithObjects:facebook,zingme, nil] title:@"Liên kết với mạng xã hội" description:@""];
    FieldSpecifier *mangxh = [FieldSpecifier subsectionFieldWithSection:pushSectionMangxh key:@"mangxahoi"];
    //khác
    FieldSpecifier *khac1 = [FieldSpecifier buttonFieldWithKey:kChinhSachBaoMat title:@"Chính sách bảo mật"];
	FieldSpecifier *khac2 = [FieldSpecifier buttonFieldWithKey:kThongTinPhanMem title:@"Thông tin phần mềm"];
    FieldSectionSpecifier *pushSectionKhac  = [FieldSectionSpecifier sectionWithFields:[NSArray arrayWithObjects:khac1,khac2, nil] title:@"Khác" description:@""];
    FieldSpecifier *khac = [FieldSpecifier subsectionFieldWithSection:pushSectionKhac key:@"khac"];
    
    FieldSectionSpecifier *pushSectionLienheVoiChungToiField = [FieldSectionSpecifier sectionWithFields:[NSArray arrayWithObjects:email,lienheVoiChungToi,hieuunglattrang,mangxh,khac, nil] title:@"Sent to 123DOC Email address" description:@"Copy right © 2012 - 123DOC \n All rights reserved"];
    
    NSArray *sections = [NSArray arrayWithObjects:sectionSort,categoryBookSectionMain,pushSectionFieldSection,pushSectionLienheVoiChungToiField, nil];
    
    settingsViewController = [[FieldEditorViewController alloc] initWithFieldSections:sections title:@"Settings"];
    
    settingsViewController.doneButtonTitle = @"Done";
    settingsViewController.delegate = self;
    settingsViewController.editorIdentifier = @"Setting";
    
    UINavigationController * settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    CustomNavigationBar* customNavigation = [[CustomNavigationBar alloc] initWithFrame:self.navigationController.navigationBar.frame];
    [customNavigation setBackgroundWith:[UIImage imageNamed:@"bannertop.png"]];
    [settingsNavController setValue:customNavigation forKeyPath:@"navigationBar"];
    
    [Utils addGradientForView:settingsNavController.navigationBar Operacity:0.5f];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        settingsNavController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self presentModalViewController:settingsNavController animated:YES];
    
}

#pragma mark - FieldEditorViewControllerDelegate
- (void)fieldEditor:(FieldEditorViewController *)editor didFinishEditingWithValues:(NSDictionary *)returnValues{
    
//    NSLog(@"Return value %@", returnValues);

    for (NSString *key in [returnValues allKeys]) {
        if ([[returnValues objectForKey:key] boolValue]) {
            if ([key rangeOfString:@"."].location != NSNotFound) {
                NSArray* tmparr = [key componentsSeparatedByString:@"."];
                
                [[CategoryManager sharedCategory] setCurrentCategory:[tmparr objectAtIndex:1]];
                idcurentCat = [tmparr objectAtIndex:0];
                //NSLog(@"ID cat  %@ %@", [tmparr objectAtIndex:0], [tmparr objectAtIndex:1]);
                if([[CategoryManager sharedCategory].currentCategory isEqualToString:@"Tất cả"]){
                    NSLog(@"Khong lam gi, giu nguyen du lieu cho tab sach!");
                }else if([[CategoryManager sharedCategory].currentCategory isEqualToString:[tmparr objectAtIndex:1]]){
                
                    NSLog(@"Sap xep lai du lieu cho tab sach!");
                }
            }
        }   
    }
    
    if([[returnValues allKeys] containsObject:kSortSegmentControl]) {
        NSLog(@"kSortSegmentControl = %@",[returnValues objectForKey:kSortSegmentControl]);
        
        current_page = 1;
        [listBookOnCloud removeAllObjects];
        
        NSString* page = [NSString stringWithFormat:@"%i",self.current_page];
        NSString* sort = [NSString stringWithFormat:@"%i", segmentSort];
        
        NSString *dataListOnCloud = DATALISTONCLOUD(@"0", sort, page);
        
        // NSLog(@"Data Post %@", dataListOnCloud);
        aRequestLoadListBook = [Utils requestWithLink:URL_LISTBOOKONCLOUD Data:dataListOnCloud];
        aRequestLoadListBook.delegate = self;
        aRequestLoadListBook.downloadProgressDelegate= self;
        [aRequestLoadListBook startAsynchronous];

        
    }
    
    [editor dismissModalViewControllerAnimated:YES];
    
}

- (void)fieldEditor:(FieldEditorViewController *)editor pressedButtonWithKey:(NSString *)key{
    
    NSLog(@"KEY %@", key);
    
    if([key isEqualToString:kLienHeVoiChungToi]){
        ContactViewController *contactVC = [[ContactViewController alloc] init];
        
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Gửi" style:UIBarButtonItemStyleDone target:self action:@selector(SentEmailToUs)];
        contactVC.navigationItem.rightBarButtonItem = doneButtonItem;
        
        
        [editor.navigationController pushViewController:contactVC animated:YES];
    }

    
}
- (void)fieldEditorDidCancel:(FieldEditorViewController *)editor{
    
}
-(void)SentEmailToUs{
    [self dismissModalViewControllerAnimated:YES];
    [Utils aleartWithTitle:@"Thông báo" Message:@"Thành công" CancelButton:@"OK" Delegate:self];
    
}


- (void)fieldEditor:(FieldEditorViewController *)editor changeValueWithType:(FieldSpecifierType)type AndValue: (NSString*)value{
    if (type == FieldSpecifierTypeSwitch) {
        NSLog(@"swich value %@", value);
    }else if(type == FieldSpecifierTypeSegment){
        segmentSort = [value intValue];
//        [listBookOnCloud removeAllObjects];
        
//        [listBookOnCloud removeAllObjects];
//        [self refresh];
    }
}

-(void)huyDangKyTask{
    
    NSString* dataDeregisterDevice = DATA_DEREGISTER_DEVICE([[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES], [Utils getDeviceId]);
    
    aReQuestDeregisterDevice = [Utils requestWithLink:URL_DEREGISTERDEVICE Data:dataDeregisterDevice];

    [aReQuestDeregisterDevice startSynchronous];
    
    NSDictionary * responseDic = [[aReQuestDeregisterDevice responseString] objectFromJSONString];
    if ([[responseDic objectForKey:@"success"] intValue]==1) {
        [Utils aleartWithTitle:@"Thông báo" Message:[responseDic objectForKey:@"message"] CancelButton:@"OK" Delegate:self];
        [self dismissModalViewControllerAnimated:NO];
        
        self.userEmail = @"";
        self.userInformation = nil;
        
        if([[[NSUserDefaults standardUserDefaults] objectForKey:USERTYPE_PREFERENCES] isEqualToString:@"type_nomal"]){
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUsernameLogin];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPasswordLogin];
        }
        
        [Utils resetDefaults];
        
        
        [self.listBookOnDevice removeAllObjects];
        [self.listBookOnCloud removeAllObjects];
            
        self.current_page = 1;

        NSLog(@"NSUserDefaults: %@ ", [[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES]);

        if(current_page == 1){
            [self loadData];
        }
        
    }else{
        [Utils aleartWithTitle:@"Thông báo" Message:[responseDic objectForKey:@"message"] CancelButton:@"OK" Delegate:self];
    }

}

-(void)huyDangKyThietBiClick{
    MBProgressHUD * progressHUB = [[MBProgressHUD alloc] initWithView:self.view];
	[settingsViewController.view addSubview:progressHUB];
	
	progressHUB.delegate = self;
	progressHUB.labelText = @"Đang hủy đăng ký thiết bị...";
	
	[progressHUB showWhileExecuting:@selector(huyDangKyTask) onTarget:self withObject:nil animated:YES];

}
-(void)DangNhapClick{
    [self dismissModalViewControllerAnimated:NO];
    [self.listBookOnCloud removeAllObjects];
    [self.listBookOnDevice removeAllObjects];
    NSLog(@"Run here ");
    //Present modal view controller login view controller
    LoginViewController * loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginView.mainView = self;
    [self presentModalViewController:loginView animated:YES];
}

#pragma mark - support method
-(BOOL) checkBookDownloaded:(NSInteger) idBook{
    
    for(Book *b in bookExistsOnDevice){
        //NSLog(@"%i --- %i", b.idbook, idBook);
        if (b.idbook == idBook) {
            return YES;
        }
    }
    
    return NO;
    
}
-(BOOL) checkUserBookWithIdUser: (NSInteger)idUser andIdBook: (NSInteger)idBook{
    
    NSString * selectQuery = [NSString stringWithFormat:@"Select * from USER where ID_USER = %i AND ID_BOOK = %i",idUser,idBook];
    
    NSInteger count = [[DatabaseManager shareInstance] exeQueryGetCountInt:selectQuery];
    if(count > 0) return YES;
    return NO;

}

-(NSString*)listUserSBook: (NSString*)idUser{
    
    NSString * query = [NSString stringWithFormat:@"Select * from USER where ID_USER = %@", idUser];
    NSMutableArray * array = [[DatabaseManager shareInstance] exeQueryGetTable:query ObjectInstance:[[User alloc] init]];
     
    NSString * tmp = @"";
    for(User * u in array){
        tmp = [NSString stringWithFormat:@"%@%i,",tmp,u.idBook];
        
    }
//   NSLog(@"%@", tmp);
    if ([tmp isEqualToString:@""]) {
        [self.view makeToast:@"Bạn hãy tải sách từ Cloud" duration:1.f position:@"center"];
        return @"";
    }
    return [tmp stringByReplacingCharactersInRange:NSMakeRange(tmp.length - 1, 1) withString:@""];
}

#pragma mark - horizontalMenu
- (UIImage*) selectedItemImageForMenu:(MKHorizMenu*) tabView{

    return [[UIImage imageNamed:@"bg_menu.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];;
}
- (UIColor*) backgroundColorForMenu:(MKHorizMenu*) tabView{
    return [UIColor clearColor];
}
- (int) numberOfItemsForMenu:(MKHorizMenu*) tabView{
//    NSLog(@"[itemsHoriMenu count] %u", [itemsHoriMenu count]);
    return [itemsHoriMenu count];
}

- (NSString*) horizMenu:(MKHorizMenu*) horizMenu titleForItemAtIndex:(NSUInteger) index{
    return [itemsHoriMenu objectAtIndex:index];
}

#pragma mark - Horizontal MenuDelegate
- (void)horizMenu:(MKHorizMenu*) horizMenu itemSelectedAtIndex:(NSUInteger) index{
    
    switch (index) {
        case 0:{ //search
            [horizMenu setContentOffset:CGPointMake(-100, 0) animated:YES];
            
            SearchViewController* searchVC = [[SearchViewController alloc] init];
            [Utils animationForView:self.navigationController.view kCATransition:kCATransitionReveal duration:0.4f forKey:@"PushOut"];
                        
            [self.navigationController pushViewController:searchVC animated:NO];
            
        }break;
        case 1:{ //tat ca
            [horizMenu setContentOffset:CGPointMake(0, 0) animated:YES];
            
        }break;
        case 2:{ //sach
            [horizMenu setContentOffset:CGPointMake(100, 0) animated:YES];
            
        }break;
            
        default:
            break;
    }
    
    
}

-(void) loadMoreData{
    
}


#pragma mark - UIScrollViewDelegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
    
    CGFloat height = scrollView.frame.size.height;
    
    CGFloat contentYoffset = scrollView.contentOffset.y;
    
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    
    if(distanceFromBottom < height) 
    {
        if(self.checkOnCloud){
            if(isLoadMore){
                isLoadMore = NO;
                loadMoreView.alpha = 1.f;
                [self loadData];
            }

        }
    }
    
    
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
	
	hud = nil;
}

#pragma mark - tuong tac du lieu, support sync
#pragma mark - tuong tac du lieu
-(void)insertBookToDatabase{
    NSArray * arrayChapter = [currentBookInformation objectForKey:KEY_CHAPTER];
    NSInteger chapterCount = [arrayChapter count];
    
    NSString* nameTableBook = [NSString stringWithFormat:@"%@%i", DATABOOKNAMEDEFAULT, [[currentBookInformation objectForKey:KEY_IDBOOK] intValue]];
    
    NSString * creatTableBook = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (SPAN_BOOK_ID_NEW TEXT, SPAN_CHAPTER_NEW_ID TEXT, SPAN_CONTENT_NEW TEXT)", nameTableBook];
    
    [[DatabaseManager shareInstance] exeQueryNoneResult:creatTableBook];
    
    for(NSInteger i = 0; i< chapterCount; i++){
        
        NSString* htmlPath = [NSString stringWithFormat:@"%@/Unzipped/%i.html", [Utils applicationDocumentsDirectory],i];
        
        
        NSString * contentBook = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:NULL];
        
        contentBook = [contentBook stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        //NSLog(@"contentBook %@", contentBook);
        
        NSString * insertBookContent = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@','%@','%@')",nameTableBook,[currentBookInformation objectForKey:KEY_IDBOOK], [NSString stringWithFormat:@"%i",i],contentBook];
        
        
        [[DatabaseManager shareInstance] exeQueryNoneResult:insertBookContent];
        
        NSString * chapterName = [[arrayChapter objectAtIndex:i] objectForKey:KEY_CHAPTER_NAME];
        chapterName = [chapterName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        ChapterData * chData = [[ChapterData alloc] initChapterWithBookId:[[currentBookInformation objectForKey:KEY_IDBOOK] intValue] ChapterOrder:i ChapterName:chapterName TotalSpan:[[[arrayChapter objectAtIndex:i] objectForKey:@"cha_location_total_m"] intValue]];
        
        NSString * strInsertChapter = nil;
        strInsertChapter = [NSString stringWithFormat:@"INSERT INTO CHAPTER VALUES(%i,%i,'%@',%i)",chData.idbook, chData.order, chData.name,chData.totalspan];
        [[DatabaseManager shareInstance] exeQueryNoneResult:strInsertChapter];
        
    }
    
    
    NSString * bookName = [currentBookInformation objectForKey:KEY_NAME];
    NSString * bookAuthor = [currentBookInformation objectForKey:KEY_AUTHOR];
    NSString * bookPublisher = [currentBookInformation objectForKey:KEY_PUBLISHER];
    NSString * bookCategory = [currentBookInformation objectForKey:KEY_CATEGORY];
    
    Book *book = [[Book alloc] initWithBookId:[[currentBookInformation objectForKey:KEY_IDBOOK] intValue] BookName:bookName BookAuthor:bookAuthor BookPublisher:bookPublisher BookCategory:bookCategory BookBookMark:-1 TotalSpan:[[currentBookInformation objectForKey:KEY_TOTALSPAN] intValue] TotalChapter:chapterCount+1];
    //book
    NSString * insertBookQuery = [NSString stringWithFormat:@"INSERT INTO BOOK VALUES(%i,'%@','%@','%@','%@',%i,%i,%i)", book.idbook, book.name, book.author, book.publisher, book.category, book.book_book_mark, book.totalspan, book.totalchapter];
    [[DatabaseManager shareInstance] exeQueryNoneResult:insertBookQuery];
    //cover book
    //    NSString * inserCover = [NSString stringWithFormat:@"INSERT INTO cover VALUES(%i,'%@')", book.idbook,self.urlCover];
    //    [[DatabaseManager shareInstance] exeQueryNoneResult:inserCover];
    
    NSUserDefaults * userInfor = [NSUserDefaults standardUserDefaults];
    
    ConfigBook * configBook = [[ConfigBook alloc] initConfigBookWithIdUser:[[userInfor stringForKey:USERID_PREFERENCES] intValue] IdBook:[[currentBookInformation objectForKey:KEY_IDBOOK] intValue] Font:@"Tahoma" Size:17 Align:@"justify" PaddingLeft:20 PaddingRight:20 PaddingTop:20 PaddingBottom:20 BackgroundColor:@"#ffffff" TextColor:@"#000000" ConfigChapterId:1 LocationReading:1];
    
    //NSLog(@"configBook %@", configBook);
    
    NSString * insertConfigBook = [NSString stringWithFormat:@"INSERT or REPLACE INTO CONFIG VALUES(%i,%i,'%@',%i,'%@',%i,%i,%i,%i,'%@','%@',%i,%i)",configBook.idUser, configBook.idbook, configBook.font, configBook.size, configBook.align, configBook.padding_left, configBook.padding_right, configBook.padding_top, configBook.padding_bottom,configBook.backgroundcolor, configBook.textcolor, configBook.config_chapter_id, configBook.locationreading];
    [[DatabaseManager shareInstance] exeQueryNoneResult:insertConfigBook];
    
    
    User * user = [[User alloc] initUserWithIdUser:[[userInfor stringForKey:USERID_PREFERENCES] intValue] IdBook:[[currentBookInformation objectForKey:KEY_IDBOOK] intValue] linkImageBook:[currentBookInformation objectForKey:@"boi_avatar"]];
    NSString * insertUserBookQuery = [NSString stringWithFormat:@"INSERT or REPLACE INTO USER VALUES(%i,%i,'%@')", user.idUser, user.idBook, user.linkImageBook];
    
    
    [[DatabaseManager shareInstance] exeQueryNoneResult:insertUserBookQuery];
    
    [self.view makeToast:@"Đã thêm sách vào thiết bị" duration:1.f position:@"center"];
    
    [self showAllUserBookOnDevice];
    //    SinaEbookViewController* sinaEbookVC = [[SinaEbookViewController alloc] init];
    //    self.navigationController.navigationBarHidden = YES;
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    //    [self.navigationController pushViewController:sinaEbookVC animated:YES];    
    
}

-(void) parserBook{
    
    NSString *strPath = [NSString stringWithFormat:@"%@/Unzipped",[Utils applicationDocumentsDirectory]];
    //giai nen duoc thu muc unzip moi khoi tao book
    NSFileManager *filemanager=[[NSFileManager alloc] init];
    if ([filemanager fileExistsAtPath:strPath]) {
        
        [self insertBookToDatabase];
        
    }else{
        [Utils aleartWithTitle:@"Thông báo" Message:@"Lỗi file" CancelButton:@"Ok" Delegate:nil];
    }
    
    [filemanager removeItemAtPath:strPath error:nil];
}


- (void)unzipFilePath:(NSString*)path{
	
	ZipArchive* za = [[ZipArchive alloc] init];
	if( [za UnzipOpenFile:path]){
		NSString *strPath=[NSString stringWithFormat:@"%@/Unzipped",[Utils applicationDocumentsDirectory]];
        //NSLog(@"string path %@", strPath);
		//Xoa cac file da ton tai truoc do neu co
		NSFileManager *filemanager=[[NSFileManager alloc] init];
		if ([filemanager fileExistsAtPath:strPath]) {
			NSError *error;
			[filemanager removeItemAtPath:strPath error:&error];
		}
		//start unzip
		BOOL ret = [za UnzipFileTo:[NSString stringWithFormat:@"%@/",strPath] overWrite:YES];
		if( NO==ret ){			
            [Utils aleartWithTitle:@"Lỗi" Message:@"Lỗi trong khi mở file" CancelButton:@"OK" Delegate:nil];
		}
		[za UnzipCloseFile]; 
        
        //unzip thanh cong thi xoa file zip
        if ([filemanager fileExistsAtPath:path]) {
			NSError *error;
			[filemanager removeItemAtPath:path error:&error];
		}
        
	}	
}

@end
