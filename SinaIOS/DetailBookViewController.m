//
//  DetailBookViewController.m
//  SinaIos
//
//  Created by macos on 10/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "DetailBookViewController.h"
#import "JSONKit.h"
#import "SinaEbookViewController.h"
#import "DatabaseManager.h"
#import "ZipArchive.h"
#import "ChapterData.h"
#import "ConfigBook.h"
#import "User.h"
#import "LoginViewController.h"
#import "AppDelegate.h"



#define VIEW_PADDING                10.f
#define BOLD_SYSTEM_FONT_HEIGHT_18  22.0f
#define BOLD_SYSTEM_FONT_HEIGHT_20  24.0f

#define kProgressViewKey	@"ProgressViewKey"
#define kAlertViewKey		@"AlertViewKey"

@interface DetailBookViewController()

- (void) parserBook;
- (void)unzipFilePath:(NSString*)path;

- (void)insertBookToDatabase;
-(BOOL) checkBookDownloaded:(NSInteger) idBook;
-(BOOL) checkUserBookWithIdUser: (NSInteger)idUser andIdBook: (NSInteger)idBook;

@end


@implementation DetailBookViewController

@synthesize BookId, urlCover, mainVC;

- (id)init{
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_background.png"]];

        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.rightBarButtonItem = doneButtonItem;

    }
    return self;
}
-(void) done{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
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

    imgThumbBig = [Utils imageWithCorectRadius:3.f Strock:2.f frameImg:CGRectZero];
    
    lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    lbTitle.font = [UIFont boldSystemFontOfSize:20.f];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.textColor = [UIColor blackColor];
    lbTitle.textAlignment = UITextAlignmentCenter;
    //lbTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    lbTitle.numberOfLines = 0;
    lbTitle.lineBreakMode = UILineBreakModeWordWrap;
    
    
    _lbAuthor = [[UILabel alloc] initWithFrame:CGRectZero];
    _lbAuthor.backgroundColor = [UIColor clearColor];
    _lbAuthor.textColor = [UIColor blackColor];
    _lbAuthor.textAlignment = UITextAlignmentCenter;
    _lbAuthor.text = @"Tác giả";
    
    lbAuthor = [[UILabel alloc] initWithFrame:CGRectZero];
    lbAuthor.font = [UIFont systemFontOfSize:16.f];
    lbAuthor.backgroundColor = [UIColor clearColor];
    lbAuthor.textColor = [UIColor blackColor];
    lbAuthor.textAlignment = UITextAlignmentCenter;
    //lbAuthor.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    lbAuthor.numberOfLines = 0;
    lbAuthor.lineBreakMode = UILineBreakModeWordWrap;
    
    starView = [[RateView alloc] initWithFrame:CGRectZero];
    starView.rate = 0.f;
    starView.padding = 5.f;
   
    btShare = [Utils newButtonWithTitle:@"Chia sẻ" target:self selector:@selector(btShareClick) frame:CGRectZero image:nil hilightImage:nil];
    [btShare setBackgroundColor:[UIColor blueColor]];
    
    
    btDownloadNow = [Utils newButtonWithTitle:@"Tải ngay" target:self selector:@selector(btDownloadNowClick) frame:CGRectZero image:nil hilightImage:nil];
    [btDownloadNow setBackgroundColor:[UIColor greenColor]];
    
    
    _line1 = [[UIView alloc] initWithFrame:CGRectZero];
    _line1.backgroundColor  = [UIColor grayColor];
    
    _lbDescription = [[UILabel alloc] initWithFrame:CGRectZero];
    _lbDescription.backgroundColor = [UIColor clearColor];
    _lbDescription.font =[UIFont boldSystemFontOfSize:16.f];
    _lbDescription.textColor = [UIColor blackColor];
    _lbDescription.text = @"Mô tả: ";
    
    wvDescription = [[UIWebView alloc] initWithFrame:CGRectZero];
    [Utils removeBackground:wvDescription];
    wvDescription.backgroundColor = [UIColor clearColor];
    wvDescription.delegate = self;
    wvDescription.opaque = NO;
    
    
    
    _line2 = [[UIView alloc] initWithFrame:CGRectZero];
    _line2.backgroundColor = [UIColor grayColor];
    
    _lbRelative = [[UILabel alloc] initWithFrame:CGRectZero];
    _lbRelative.backgroundColor = [UIColor clearColor];
    _lbRelative.textColor = [UIColor blackColor];
    _lbRelative.text = @"Đề xuất dành cho bạn: ";
    _lbRelative.font =[UIFont boldSystemFontOfSize:16.f];
    
    scrollBookRelate = [[AQGridView alloc] initWithFrame:CGRectZero];    
    //scrollBookRelate.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollBookRelate.layoutDirection = AQGridViewLayoutDirectionHorizontal;
    scrollBookRelate.showsHorizontalScrollIndicator =NO;
    scrollBookRelate.showsVerticalScrollIndicator = NO;
    scrollBookRelate.alwaysBounceVertical = NO;
    scrollBookRelate.autoresizesSubviews = YES;
    
    [self.view addSubview:imgThumbBig];
    [self.view addSubview:lbTitle];
    [self.view addSubview:lbAuthor];
    [self.view addSubview:starView];
    [self.view addSubview:btShare];
    [self.view addSubview:btDownloadNow];
    [self.view addSubview:wvDescription];
    [self.view addSubview:scrollBookRelate];
    
    
    [self.view addSubview:_lbAuthor];
    [self.view addSubview:_lbDescription];
    [self.view addSubview:_lbRelative];
    [self.view addSubview:_line1];
    [self.view addSubview:_line2];
    
    viewLoading = [[UIView alloc] initWithFrame:self.view.frame];
    viewLoading.backgroundColor = [UIColor whiteColor];
    viewLoading.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-70, 20, 20);
    UILabel* lb = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2-50, self.view.frame.size.width, 24)];
    lb.font = [UIFont systemFontOfSize:14];
    lb.text = @"Đang tải dữ liệu...";
    lb.backgroundColor = [UIColor clearColor];
    lb.textAlignment = UITextAlignmentCenter;
    [viewLoading addSubview:lb];
    [viewLoading addSubview:activityView];
    [activityView startAnimating];
    [self.view addSubview:viewLoading];

    viewLoading.alpha = 0.f;
 
    queueInsert = [[IPOfflineQueue alloc] initWithName:@"downloadbookone" delegate:self];

    

}
-(void)relayoutView{
    imgThumbBig.frame = CGRectMake(VIEW_PADDING, VIEW_PADDING, self.view.frame.size.width*0.4, self.view.frame.size.height*0.45);
    CGSize textSize_lbTitle = [lbTitle.text sizeWithFont:lbTitle.font constrainedToSize:CGSizeMake(self.view.frame.size.width*0.4+VIEW_PADDING*2, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    
    if (textSize_lbTitle.height>BOLD_SYSTEM_FONT_HEIGHT_20*2) {
        lbTitle.frame = CGRectMake(self.view.frame.size.width*0.4+VIEW_PADDING*2,VIEW_PADDING, self.view.frame.size.width*0.5, BOLD_SYSTEM_FONT_HEIGHT_20*3);
        _lbAuthor.frame = CGRectMake(self.view.frame.size.width*0.4 + VIEW_PADDING*2 , VIEW_PADDING+BOLD_SYSTEM_FONT_HEIGHT_20*3 , self.view.frame.size.width*0.5, 22);
        
        lbAuthor.frame = CGRectMake(self.view.frame.size.width*0.4 +VIEW_PADDING*2 , VIEW_PADDING+BOLD_SYSTEM_FONT_HEIGHT_20*3 + 22,self.view.frame.size.width*0.5, 40);
        starView.frame = CGRectMake(self.view.frame.size.width*0.4 +VIEW_PADDING*4 , VIEW_PADDING+BOLD_SYSTEM_FONT_HEIGHT_20*3 + 22 + 40, self.view.frame.size.width*0.5, 40);

    }else if (textSize_lbTitle.height>BOLD_SYSTEM_FONT_HEIGHT_20){
        lbTitle.frame = CGRectMake(self.view.frame.size.width*0.4+VIEW_PADDING*2,VIEW_PADDING , self.view.frame.size.width*0.5, BOLD_SYSTEM_FONT_HEIGHT_20*2);
        _lbAuthor.frame = CGRectMake(self.view.frame.size.width*0.4 + VIEW_PADDING*2 , VIEW_PADDING+BOLD_SYSTEM_FONT_HEIGHT_20*2 , self.view.frame.size.width*0.5, 22);
        lbAuthor.frame = CGRectMake(self.view.frame.size.width*0.4 +VIEW_PADDING*2 , VIEW_PADDING+BOLD_SYSTEM_FONT_HEIGHT_20*2 + 22,self.view.frame.size.width*0.5, 40);
        starView.frame = CGRectMake(self.view.frame.size.width*0.4 +VIEW_PADDING*4 , VIEW_PADDING+BOLD_SYSTEM_FONT_HEIGHT_20*2.5 + 22 + 40, self.view.frame.size.width*0.5, 40);
        
    }
    else if (textSize_lbTitle.height==BOLD_SYSTEM_FONT_HEIGHT_20){
        lbTitle.frame = CGRectMake(self.view.frame.size.width*0.4+VIEW_PADDING*2,VIEW_PADDING , self.view.frame.size.width*0.5, BOLD_SYSTEM_FONT_HEIGHT_20);
        _lbAuthor.frame = CGRectMake(self.view.frame.size.width*0.4 + VIEW_PADDING*2 , VIEW_PADDING+BOLD_SYSTEM_FONT_HEIGHT_20*1.3 , self.view.frame.size.width*0.5, 22);
        lbAuthor.frame = CGRectMake(self.view.frame.size.width*0.4 +VIEW_PADDING*2 , VIEW_PADDING+BOLD_SYSTEM_FONT_HEIGHT_20*1.8 + 22,self.view.frame.size.width*0.5, 40);
        starView.frame = CGRectMake(self.view.frame.size.width*0.4 +VIEW_PADDING*4 , VIEW_PADDING+BOLD_SYSTEM_FONT_HEIGHT_20*2.3 + 22 + 40, self.view.frame.size.width*0.5, 40);
    }
    
    btShare.frame = CGRectMake(self.view.frame.size.width*0.4 +VIEW_PADDING*2 , VIEW_PADDING+BOLD_SYSTEM_FONT_HEIGHT_20*3 + 22+22+42, 70, 28);
    btDownloadNow.frame = CGRectMake(self.view.frame.size.width*0.4 +VIEW_PADDING*2 +90, VIEW_PADDING+BOLD_SYSTEM_FONT_HEIGHT_20*3 + 22+22+42, 70, 28);
    if(btShare.layer.cornerRadius < 1.f){
        [Utils addGradient:btShare AndCorectRadius:5.f];
        [Utils addGradient:btDownloadNow AndCorectRadius:5.f];
    }
    
    _line1.frame = CGRectMake(VIEW_PADDING , VIEW_PADDING +BOLD_SYSTEM_FONT_HEIGHT_20*3 + 22+22+ 42+28+VIEW_PADDING, self.view.frame.size.width-VIEW_PADDING*2, 1);
    _lbDescription.frame = CGRectMake(VIEW_PADDING , VIEW_PADDING +BOLD_SYSTEM_FONT_HEIGHT_20*3 + 22+22+ 42+28+VIEW_PADDING*1.5, self.view.frame.size.width-VIEW_PADDING*2, 22);
    wvDescription.frame =CGRectMake(VIEW_PADDING, VIEW_PADDING +BOLD_SYSTEM_FONT_HEIGHT_20*3 + 22+22+ 42+28+VIEW_PADDING*1.5+22, self.view.frame.size.width-VIEW_PADDING*2, 80);
    _line2.frame = CGRectMake(VIEW_PADDING, VIEW_PADDING +BOLD_SYSTEM_FONT_HEIGHT_20*3 + 22+22+ 42+28+VIEW_PADDING*2.5+22+80, self.view.frame.size.width-VIEW_PADDING*2, 1);
    _lbRelative.frame = CGRectMake(VIEW_PADDING, VIEW_PADDING +BOLD_SYSTEM_FONT_HEIGHT_20*3 + 22+22+ 42+28+VIEW_PADDING*3+22+80, self.view.frame.size.width-VIEW_PADDING*2, 22);
    scrollBookRelate.frame = CGRectMake(VIEW_PADDING, VIEW_PADDING +BOLD_SYSTEM_FONT_HEIGHT_20*3 + 22+22+ 42+28+VIEW_PADDING*3+44+80, self.view.frame.size.width-VIEW_PADDING*2, 60);
    //scrollBookRelate.backgroundColor = [UIColor redColor];
    scrollBookRelate.contentSize = CGSizeMake(self.view.frame.size.width-VIEW_PADDING*2, 60);
    scrollBookRelate.dataSource = self;
    scrollBookRelate.delegate = self;
    
    
}
-(void) setInforView{
    [imgThumbBig setImageWithURL:[NSURL URLWithString:self.urlCover]];
    if(!imgThumbBig.image) [imgThumbBig setImage:[UIImage imageNamed:@"cover.jpg"]];
    lbTitle.text = [bookInformation objectForKey:KEY_NAME];
    self.title = [bookInformation objectForKey:KEY_NAME];
    lbAuthor.text = [bookInformation objectForKey:KEY_AUTHOR]==@"" ? @"Vô danh":[bookInformation objectForKey:KEY_AUTHOR];
    starView.rate = [[bookInformation objectForKey:KEY_RATE_BOOK] floatValue];
    [wvDescription loadHTMLString:[bookInformation objectForKey:@"desc"] baseURL:[NSURL URLWithString:@"http://123doc.vn/"]];
    
}

-(void)loadBookInformationWithId:(NSString*)idBook{
    NSString* stringBookInfor = DATAGETBOOKINFOR(idBook);
    //self.BookId = idBook;
    requestBookInfor = [Utils requestWithLink:URL_GETBOOKINFOR Data:stringBookInfor];
    requestBookInfor.delegate = self;
    [requestBookInfor startAsynchronous];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    viewLoading.alpha = 1.0f;

    [self loadBookInformationWithId:self.BookId];
    
}

#pragma mark - gridview

- (NSUInteger) numberOfItemsInGridView:(AQGridView *) gridView{
    return [listBookRelate count];
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index{
    static NSString * Identifier = @"CellIdentifier";
    
    AQGridViewCell * cell = (AQGridViewCell *)[gridView dequeueReusableCellWithIdentifier:Identifier];
    if(cell == nil){
    cell = [[AQGridViewCell alloc] initWithFrame:CGRectMake(0, 0, 50, 60) reuseIdentifier:Identifier];
    }
    cell.selectionGlowColor = [UIColor clearColor];
    UIImageView* img= [Utils imageWithCorectRadius:2.f Strock:1.f frameImg:CGRectMake(0, 0, 50, 60)];
    
    [img setImageWithURL:[[listBookRelate objectAtIndex:index] objectForKey:KEY_LINK_IMAGE]];
    
    if(!img.image){
        img.image= [UIImage imageNamed:@"cover.jpg"];
    }

    [cell.contentView addSubview:img];
    return cell;
}
- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView{
    
    return CGSizeMake(60, 60);
    
}
- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index{
    
    NSLog(@"USERID_PREFERENCES %@ \nindex %u \nsach cua nguoidung hien thoi %i \n book ID %@",[[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES], index,[self checkUserBookWithIdUser:[[[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES] intValue] andIdBook:[self.BookId intValue]], self.BookId);
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES] == nil || 
        ![self checkUserBookWithIdUser:[[[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES] intValue] andIdBook:[[[listBookRelate objectAtIndex:index] objectForKey:KEY_IDBOOK] intValue]]) {
        self.BookId = [[listBookRelate objectAtIndex:index] objectForKey:KEY_IDBOOK];
        self.urlCover = [[listBookRelate objectAtIndex:index] objectForKey:KEY_LINK_IMAGE];
        [Utils flipView:self.view];
        viewLoading.alpha = 1.f;
        self.title = @"Đang tải dữ liệu...";
        [self loadBookInformationWithId:self.BookId];
    }else{
        NSLog(@"Sach nay la cua nguoi dung hien thoi");
        NSString * selectQuery = [NSString stringWithFormat:@"SELECT * FROM BOOK WHERE ID = %@", [[listBookRelate objectAtIndex:index] objectForKey:KEY_IDBOOK]];
        if([[DatabaseManager shareInstance] exeQueryGetCountInt:selectQuery] != 0){
            SinaEbookViewController* sinaEbookVC = [[SinaEbookViewController alloc] init];
            self.navigationController.navigationBarHidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            sinaEbookVC.bookID = [[listBookRelate objectAtIndex:index] objectForKey:KEY_IDBOOK];
            
            [self.navigationController pushViewController:sinaEbookVC animated:YES];
            
        }

    }
       
    
    
}
#pragma mark - action by dev bt share click and bt download now
-(void)btShareClick{
    
    [Utils aleartWithTitle:@"Thông báo" Message:@"Tính năng đang phát triển" CancelButton:@"OK" Delegate:nil];
    
//    NSString * s = DATADOWLOADBOOK(@"1", @"150");
//    ASIFormDataRequest * da = [Utils requestWithLink:URL_DOWNLOADBOOK Data:s];
//    
//    [da startSynchronous];
//    
//    NSData * data = [da responseData];
//    
//    [data writeToFile:[NSString stringWithFormat:@"%@/book.zip", [Utils applicationDocumentsDirectory]]  atomically:YES];
    
}
-(void) btDownloadNowClick{
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:USERID_PREFERENCES] == nil /*|| [[NSUserDefaults standardUserDefaults] stringForKey:USERID_PREFERENCES] == @""*/) {
        
        alertNonLogin = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Bạn chưa đăng nhập, bạn muốn đăng nhập không?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        [alertNonLogin show];
        return;
        
    }
    
    self.view.userInteractionEnabled = NO;
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString* dataCheckUserBook = DATA_CHECK_USER_S_BOOK([userDefault stringForKey:USERID_PREFERENCES], [bookInformation objectForKey:KEY_IDBOOK]);
    requestCheckUserBook = [Utils requestWithLink:URL_USERSBOOK Data:dataCheckUserBook];
    requestCheckUserBook.delegate = self;
    [requestCheckUserBook startAsynchronous];
    
       
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([alertView isEqual:alertBuyBook]) {
        if(buttonIndex == 1){
            NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
            NSString* dataBuyBook = DATA_CHECK_USER_S_BOOK([userDefault stringForKey:USERID_PREFERENCES], [bookInformation objectForKey:KEY_IDBOOK]);
            requestBuyBook = [Utils requestWithLink:URL_BUY_BOOK Data:dataBuyBook];
            requestBuyBook.delegate = self;
            [requestBuyBook startAsynchronous];
            
        }else{
            [self.view setUserInteractionEnabled:YES];
        }

    }else if([alertView isEqual:alertNonLogin]){
        if(buttonIndex == 0){
//            [self.navigationController popViewControllerAnimated:NO];
            //Present modal view controller loginview controller
            LoginViewController * loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            loginView.mainView = delegate.mainVC;
            [self presentModalViewController:loginView animated:YES];
        
        }
        
    }
}

-(BOOL) checkBookDownloaded:(NSInteger) idBook{
    
    NSMutableArray * bookExistsOnDevice = [[DatabaseManager shareInstance] exeQueryGetTable:@"SELECT * FROM BOOK" ObjectInstance:[Book new]];
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
#pragma mark - request delegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    if([request isEqual:requestBookInfor]){
        bookInformation = [[requestBookInfor responseString] objectFromJSONString];
        listBookRelate = [bookInformation objectForKey:KEY_LIST_BOOK_RELATED];
        [self setInforView];
        
        [self relayoutView];
        
        [scrollBookRelate reloadData];
        [scrollBookRelate setNeedsDisplay];
        viewLoading.alpha = 0.f;
        
        //NSLog(@"book Information: %@", bookInformation);

    }else if([request isEqual:requestDownloadBook]){
//        [queueInsert clear];
            NSData * data = [requestDownloadBook responseData];
            NSString * filePath = [NSString stringWithFormat:@"%@/%@.zip", [Utils applicationDocumentsDirectory],[bookInformation objectForKey:KEY_NAME]];
            [data writeToFile:filePath  atomically:YES];
//        NSLog(@"Run Queue");
//        NSDictionary * dic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"book%@", [bookInformation objectForKey:KEY_IDBOOK]] forKey:@"bookID"];
        NSDictionary * dic1  = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"book%@", [bookInformation objectForKey:KEY_IDBOOK]],@"bookID",
                            filePath, @"bookFilePath",    
                            nil];
        
        [queueInsert enqueueActionWithUserInfo:dic1];
//            [self unzipFilePath:filePath];
//            
//            [self parserBook];
        

    }else if([request isEqual:requestBuyBook]){
        //Neu sach da co 1 user truoc mua thi no da co tren device cho nen bo qua buoc download, ma
        //chi mua roi thuc hien dc doc ngay
        NSDictionary* responceDic = [[requestBuyBook responseString] objectFromJSONString];
//        NSLog(@"responceDic %@", responceDic);
        if([[responceDic objectForKey:@"success"] intValue]==1){
            
            NSUserDefaults * userInfor = [NSUserDefaults standardUserDefaults];
            if([self checkBookDownloaded:[[bookInformation objectForKey:KEY_IDBOOK] intValue]]){
                NSLog(@"checkBookDownloaded OK");
//                NSLog(@"responceDic %@", [requestBuyBook responseString]);
                
                NSString *sqlCheck = [NSString stringWithFormat:@"select * from USER where ID_USER = %@ and ID_BOOK = %@", [[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES],self.BookId];
                NSInteger countTmp = [[DatabaseManager shareInstance] exeQueryGetCountInt:sqlCheck];
                NSLog(@"[DatabaseManager shareInstance] exeQueryGetCountInt:sqlCheck] = %i", countTmp);
                if(countTmp > 0){
                    //tro ve view controller main
//                    self.navigationController.navigationBarHidden = YES;
//                    [self.navigationController popViewControllerAnimated:YES];
                    SinaEbookViewController* sinaEbookVC = [[SinaEbookViewController alloc] init];
                    self.navigationController.navigationBarHidden = YES;
                    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                    sinaEbookVC.bookID = [bookInformation objectForKey:KEY_IDBOOK];
                    [self.navigationController pushViewController:sinaEbookVC animated:YES];
                
                }else{
                    ConfigBook * configBook = [[ConfigBook alloc] initConfigBookWithIdUser:[[userInfor stringForKey:USERID_PREFERENCES] intValue] IdBook:[[bookInformation objectForKey:KEY_IDBOOK] intValue] Font:@"Tahoma" Size:17 Align:@"justify" PaddingLeft:20 PaddingRight:20 PaddingTop:20 PaddingBottom:20 BackgroundColor:@"#ffffff" TextColor:@"#000000" ConfigChapterId:1 LocationReading:1];
                    NSString * insertConfigBook = [NSString stringWithFormat:@"INSERT INTO CONFIG VALUES(%i,%i,'%@',%i,'%@',%i,%i,%i,%i,'%@','%@',%i,%i)",configBook.idUser, configBook.idbook, configBook.font, configBook.size, configBook.align, configBook.padding_left, configBook.padding_right, configBook.padding_top, configBook.padding_bottom,configBook.backgroundcolor, configBook.textcolor, configBook.config_chapter_id, configBook.locationreading];
                    [[DatabaseManager shareInstance] exeQueryNoneResult:insertConfigBook];
                    
                    User * user = [[User alloc] initUserWithIdUser:[[userInfor stringForKey:USERID_PREFERENCES] intValue] IdBook:[[bookInformation objectForKey:KEY_IDBOOK] intValue] linkImageBook:self.urlCover];
                    NSString * insertUserBookQuery = [NSString stringWithFormat:@"INSERT INTO USER VALUES(%i,%i,'%@')", user.idUser, user.idBook, user.linkImageBook];
                    [[DatabaseManager shareInstance] exeQueryNoneResult:insertUserBookQuery];
                    //tro ve view controller main
//                    self.navigationController.navigationBarHidden = YES;
//                    [self.navigationController popViewControllerAnimated:YES];
                    SinaEbookViewController* sinaEbookVC = [[SinaEbookViewController alloc] init];
                    self.navigationController.navigationBarHidden = YES;
                    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                    sinaEbookVC.bookID = [bookInformation objectForKey:KEY_IDBOOK];
                    [self.navigationController pushViewController:sinaEbookVC animated:YES];
                }

                
                
            }else{ // nguoc lai thi download book ve roi thuc hien cac thao tac tren
               
                alertDownloadBook = [[UIAlertView alloc] initWithTitle:@"Thông báo"
                                                                    message: @"Đang tải sách, xin chờ!"
                                                                   delegate: self
                                                          cancelButtonTitle: nil
                                                          otherButtonTitles: nil];
                
                progressViewDownloadBook = [[MNMProgressBar alloc] initWithFrame:CGRectMake(30.0f, 80.0f, 225.0f, 15.f)];
                [alertDownloadBook addSubview:progressViewDownloadBook];
                progressViewDownloadBook.progress = MNMProgressBarIndeterminateProgress;
                
                [alertDownloadBook show];
                
//                viewLoading.alpha = 1.f;
                NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                NSString * s = DATADOWLOADBOOK([bookInformation objectForKey:KEY_IDBOOK], [userDefault stringForKey:USERID_PREFERENCES]);
                
                requestDownloadBook = [Utils requestWithLink:URL_DOWNLOADBOOK Data:s];
                requestDownloadBook.delegate = self;
                requestDownloadBook.downloadProgressDelegate = self;
                [requestDownloadBook startAsynchronous];
            }
     
        
        }else{
            [Utils aleartWithTitle:@"Thông báo" Message:[responceDic objectForKey:@"message"] CancelButton:@"Ok" Delegate:nil];
        }
    }else if([request isEqual:requestCheckUserBook]){
        NSDictionary* responceDic = [[requestCheckUserBook responseString] objectFromJSONString];
        if([[responceDic objectForKey:@"success"] intValue]==1){
            
            NSUserDefaults * userInfor = [NSUserDefaults standardUserDefaults];
            if([self checkBookDownloaded:[[bookInformation objectForKey:KEY_IDBOOK] intValue]]){
                NSLog(@"checkBookDownloaded OK - check user's book and check book -J");
                
                NSString *sqlCheck = [NSString stringWithFormat:@"select * from USER where ID_USER = %@ and ID_BOOK = %@", [[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES],self.BookId];
                NSInteger countTmp = [[DatabaseManager shareInstance] exeQueryGetCountInt:sqlCheck];
                NSLog(@"[DatabaseManager shareInstance] exeQueryGetCountInt:sqlCheck] 2 = %i, \n sql = %@", countTmp, sqlCheck);
                if(countTmp > 0){
                    //tro ve view controller main
//                    self.navigationController.navigationBarHidden = YES;
//                    [self.navigationController popViewControllerAnimated:YES];
                    SinaEbookViewController* sinaEbookVC = [[SinaEbookViewController alloc] init];
                    self.navigationController.navigationBarHidden = YES;
                    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                    sinaEbookVC.bookID = [bookInformation objectForKey:KEY_IDBOOK];
                    [self.navigationController pushViewController:sinaEbookVC animated:YES];
                }else{
                    ConfigBook * configBook = [[ConfigBook alloc] initConfigBookWithIdUser:[[userInfor stringForKey:USERID_PREFERENCES] intValue] IdBook:[[bookInformation objectForKey:KEY_IDBOOK] intValue] Font:@"Tahoma" Size:17 Align:@"justify" PaddingLeft:20 PaddingRight:20 PaddingTop:20 PaddingBottom:20 BackgroundColor:@"#ffffff" TextColor:@"#000000" ConfigChapterId:1 LocationReading:1];
                    NSString * insertConfigBook = [NSString stringWithFormat:@"INSERT INTO CONFIG VALUES(%i,%i,'%@',%i,'%@',%i,%i,%i,%i,'%@','%@',%i,%i)",configBook.idUser, configBook.idbook, configBook.font, configBook.size, configBook.align, configBook.padding_left, configBook.padding_right, configBook.padding_top, configBook.padding_bottom,configBook.backgroundcolor, configBook.textcolor, configBook.config_chapter_id, configBook.locationreading];
                    [[DatabaseManager shareInstance] exeQueryNoneResult:insertConfigBook];
                    
                    User * user = [[User alloc] initUserWithIdUser:[[userInfor stringForKey:USERID_PREFERENCES] intValue] IdBook:[[bookInformation objectForKey:KEY_IDBOOK] intValue] linkImageBook:self.urlCover];
                    NSString * insertUserBookQuery = [NSString stringWithFormat:@"INSERT INTO USER VALUES(%i,%i,'%@')", user.idUser, user.idBook, user.linkImageBook];
                    [[DatabaseManager shareInstance] exeQueryNoneResult:insertUserBookQuery];
                    //tro ve view controller main
//                    self.navigationController.navigationBarHidden = YES;
//                    [self.navigationController popViewControllerAnimated:YES];
                    SinaEbookViewController* sinaEbookVC = [[SinaEbookViewController alloc] init];
                    self.navigationController.navigationBarHidden = YES;
                    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                    sinaEbookVC.bookID = [bookInformation objectForKey:KEY_IDBOOK];
                    [self.navigationController pushViewController:sinaEbookVC animated:YES];
                }
                
               
                
            }else{ // nguoc lai thi download book ve roi thuc hien cac thao tac tren
//                viewLoading.alpha = 1.f;
                alertDownloadBook = [[UIAlertView alloc] initWithTitle:@"Thông báo"
                                                               message: @"Đang tải sách, xin chờ!"
                                                              delegate: self
                                                     cancelButtonTitle: nil
                                                     otherButtonTitles: nil];
                
                progressViewDownloadBook = [[MNMProgressBar alloc] initWithFrame:CGRectMake(30.0f, 80.0f, 225.0f, 25.f)];
                [alertDownloadBook addSubview:progressViewDownloadBook];
                progressViewDownloadBook.progress = MNMProgressBarIndeterminateProgress;
                [alertDownloadBook show];
                NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                NSString * s = DATADOWLOADBOOK([bookInformation objectForKey:KEY_IDBOOK], [userDefault stringForKey:USERID_PREFERENCES]);
                requestDownloadBook = [Utils requestWithLink:URL_DOWNLOADBOOK Data:s];
                requestDownloadBook.delegate = self;
                [requestDownloadBook startAsynchronous];
            }
            
            
        }else{
            alertBuyBook= [[UIAlertView alloc]
                                  initWithTitle: @"Thông báo"
                                  message: @"Bạn thực sự muốn mua quyển sách này với giá 0 vnd!"
                                  delegate: self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"OK",nil];
            [alertBuyBook show];
        }
    }

}

- (void)requestFailed:(ASIHTTPRequest *)request{
    //NSError *error = [request error];
//    [Utils aleartWithTitle:@"Lỗi" Message:@"Lỗi, vui lòng xem lại kết nối mạng của bạn" CancelButton:@"Ok" Delegate:nil];
    [self.view makeToast:@"Lỗi, vui lòng xem lại kết nối mạng của bạn!" duration:1.f position:@"center"];
    viewLoading.alpha = 0.f;
    self.view.userInteractionEnabled = YES;
    self.title = [bookInformation objectForKey:KEY_NAME];
    
}
- (void)setProgress:(float)newProgress{
    NSLog(@"newProgress %f", newProgress);
}


-(void) forcePopViewController{
    
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.mainVC.view makeToast:@"Đã thêm sách vào thiết bị" duration:1.f position:@"center"];
    NSDictionary * tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [bookInformation objectForKey:KEY_IDBOOK],KEY_IDBOOK,[bookInformation objectForKey:KEY_NAME],KEY_NAME, [bookInformation objectForKey:KEY_AUTHOR],KEY_AUTHOR, self.urlCover,@"boi_avatar", nil];
    [delegate.mainVC.listBookOnDevice addObject:tmpDic];
    [alertDownloadBook dismissWithClickedButtonIndex:0 animated:NO];
    [self.view setUserInteractionEnabled:YES];
//    self.navigationController.navigationBarHidden = YES;
//    [self.navigationController popViewControllerAnimated:YES];
    
    SinaEbookViewController* sinaEbookVC = [[SinaEbookViewController alloc] init];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    sinaEbookVC.bookID = [bookInformation objectForKey:KEY_IDBOOK];
    [self.navigationController pushViewController:sinaEbookVC animated:YES];
    

    
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
    [self performSelectorOnMainThread:@selector(forcePopViewController) withObject:nil waitUntilDone:YES];
    NSLog(@"done task: %@", [userInfo valueForKey:@"bookFilePath"]);
    return IPOfflineQueueResultSuccess;
}
#pragma mark - tuong tac du lieu
-(void)insertBookToDatabase{
    NSArray * arrayChapter = [bookInformation objectForKey:KEY_CHAPTER];
    NSInteger chapterCount = [arrayChapter count];
    
    NSString* nameTableBook = [NSString stringWithFormat:@"%@%i", DATABOOKNAMEDEFAULT, [[bookInformation objectForKey:KEY_IDBOOK] intValue]];
    
    NSString * creatTableBook = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (SPAN_BOOK_ID_NEW TEXT, SPAN_CHAPTER_NEW_ID TEXT, SPAN_CONTENT_NEW TEXT)", nameTableBook];
    
    [[DatabaseManager shareInstance] exeQueryNoneResult:creatTableBook];
    
    for(NSInteger i = 0; i< chapterCount; i++){
        
        NSString* htmlPath = [NSString stringWithFormat:@"%@/Unzipped/%i.html", [Utils applicationDocumentsDirectory],i];

        NSString * contentBook = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:NULL];
        
        contentBook = [contentBook stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        //NSLog(@"contentBook %@", contentBook);
        
        NSString * insertBookContent = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@','%@','%@')",nameTableBook,[bookInformation objectForKey:KEY_IDBOOK], [NSString stringWithFormat:@"%i",i],contentBook];
        
        [[DatabaseManager shareInstance] exeQueryNoneResult:insertBookContent];
        
        NSString * chapterName = [[arrayChapter objectAtIndex:i] objectForKey:KEY_CHAPTER_NAME];
        chapterName = [chapterName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        ChapterData * chData = [[ChapterData alloc] initChapterWithBookId:[[bookInformation objectForKey:KEY_IDBOOK] intValue] ChapterOrder:i ChapterName:chapterName TotalSpan:[[[arrayChapter objectAtIndex:i] objectForKey:@"cha_location_total_m"] intValue]];
        
        NSString * strInsertChapter = nil;
        strInsertChapter = [NSString stringWithFormat:@"INSERT INTO CHAPTER VALUES(%i,%i,'%@',%i)",chData.idbook, chData.order, chData.name,chData.totalspan];
        [[DatabaseManager shareInstance] exeQueryNoneResult:strInsertChapter];
        
		
    }

    
    NSString * bookName = [bookInformation objectForKey:KEY_NAME];
    NSString * bookAuthor = [bookInformation objectForKey:KEY_AUTHOR];
    NSString * bookPublisher = [bookInformation objectForKey:KEY_PUBLISHER];
    NSString * bookCategory = [bookInformation objectForKey:KEY_CATEGORY];
    
    Book *book = [[Book alloc] initWithBookId:[[bookInformation objectForKey:KEY_IDBOOK] intValue] BookName:bookName BookAuthor:bookAuthor BookPublisher:bookPublisher BookCategory:bookCategory BookBookMark:-1 TotalSpan:[[bookInformation objectForKey:KEY_TOTALSPAN] intValue] TotalChapter:chapterCount+1];
    //book
    NSString * insertBookQuery = [NSString stringWithFormat:@"INSERT INTO BOOK VALUES(%i,'%@','%@','%@','%@',%i,%i,%i)", book.idbook, book.name, book.author, book.publisher, book.category, book.book_book_mark, book.totalspan, book.totalchapter];
    [[DatabaseManager shareInstance] exeQueryNoneResult:insertBookQuery];
    //cover book
//    NSString * inserCover = [NSString stringWithFormat:@"INSERT INTO cover VALUES(%i,'%@')", book.idbook,self.urlCover];
//    [[DatabaseManager shareInstance] exeQueryNoneResult:inserCover];
    
    NSUserDefaults * userInfor = [NSUserDefaults standardUserDefaults];
    
    ConfigBook * configBook = [[ConfigBook alloc] initConfigBookWithIdUser:[[userInfor stringForKey:USERID_PREFERENCES] intValue] IdBook:[[bookInformation objectForKey:KEY_IDBOOK] intValue] Font:@"Tahoma" Size:17 Align:@"justify" PaddingLeft:20 PaddingRight:20 PaddingTop:20 PaddingBottom:20 BackgroundColor:@"#ffffff" TextColor:@"#000000" ConfigChapterId:1 LocationReading:1];
    
    //NSLog(@"configBook %@", configBook);
    
    NSString * insertConfigBook = [NSString stringWithFormat:@"INSERT or REPLACE INTO CONFIG VALUES(%i,%i,'%@',%i,'%@',%i,%i,%i,%i,'%@','%@',%i,%i)",configBook.idUser, configBook.idbook, configBook.font, configBook.size, configBook.align, configBook.padding_left, configBook.padding_right, configBook.padding_top, configBook.padding_bottom,configBook.backgroundcolor, configBook.textcolor, configBook.config_chapter_id, configBook.locationreading];
    [[DatabaseManager shareInstance] exeQueryNoneResult:insertConfigBook];
    
    User * user = [[User alloc] initUserWithIdUser:[[userInfor stringForKey:USERID_PREFERENCES] intValue] IdBook:[[bookInformation objectForKey:KEY_IDBOOK] intValue] linkImageBook:self.urlCover];
    NSString * insertUserBookQuery = [NSString stringWithFormat:@"INSERT or REPLACE INTO USER VALUES(%i,%i,'%@')", user.idUser, user.idBook, user.linkImageBook];
    
    
//    NSLog(@"bookInformation %@", bookInformation);
    [[DatabaseManager shareInstance] exeQueryNoneResult:insertUserBookQuery];
    
    viewLoading.alpha = 0.f;
    
    

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
        viewLoading.alpha = 0.f;
        [alertDownloadBook dismissWithClickedButtonIndex:0 animated:YES];
        return;
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
        
		if(NO==ret){
			
            [Utils aleartWithTitle:@"Lỗi" Message:@"Lỗi trong khi mở file" CancelButton:@"OK" Delegate:nil];
            viewLoading.alpha = 0.f;
			
		}
		[za UnzipCloseFile]; 
        
        //unzip thanh cong thi xoa file zip
        if ([filemanager fileExistsAtPath:path]) {
			NSError *error;
			[filemanager removeItemAtPath:path error:&error];
		}
        
	}	
}

#pragma mark -

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
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none'; document.body.style.KhtmlUserSelect='none'"];
    
    NSString* s=[[NSString alloc] initWithFormat:@"for (a in document.getElementsByTagName(\"a\")) {a.href = \"\";}"];
    [webView stringByEvaluatingJavaScriptFromString:s];
    
    NSString * s2 = @"for(link in document.getElementsByTagName(\"a\")){var span = document.createElement(\"span\");var txt = link.href;var textNode= document.createTextNode(txt);span.appendChild(textNode);if(link!=undefined){link.parentNode.replaceChild(span, link);}}";
    [webView stringByEvaluatingJavaScriptFromString:s2];
}


@end




