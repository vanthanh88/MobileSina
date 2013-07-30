//
//  AppDelegate.m
//  SinaIos
//
//  Created by macos on 04/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "SinaEbookViewController.h"
#import "MainViewController.h"
#import "Config.h"
#import "Utils.h"
#import "JSONKit.h"
#import "Toast+UIView.h"

NSString *const SessionStateChangedNotification = @"com.vatgia.sina.SinaIOS:SessionStateChangedNotification";
//for iphone 4
//@implementation UINavigationBar (CustomImage)
//- (void)drawRect:(CGRect)rect {
//    UIImage *image = [UIImage imageNamed:@"bannertop.png"];
//    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    [Utils addGradientForView:self Operacity:0.5f];
//}
//@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize mainVC;


-(void)requestCategory{
    requestCategory = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_GET_CAT]];
    requestCategory.delegate = self;
    [requestCategory startSynchronous];
}

-(void) createDatabase{
    NSString *docsDir = nil;
//    sqlite3 * SinaDB;
    docsDir = [Utils applicationDocumentsDirectory];
    
    // Build the path to the database file
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:DATA_NAME]];
    NSLog(@"databasePath: %@", databasePath);
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath] == NO)
    {

        NSString *sql_category = @"CREATE TABLE category (category_id TEXT Primary Key, name TEXT)";
        [[DatabaseManager shareInstance] exeQueryNoneResult:sql_category];

              //book TABLE
        NSString *sql_sina_book = @"CREATE TABLE BOOK (ID TEXT, NAME TEXT, AUTHOR TEXT, PUBLISHER TEXT, CATEGORY TEXT, BOOK_BOOK_MARK TEXT, TOTAL_SPAN INTEGER, TOTAL_CHAPTER INTEGER)";
        [[DatabaseManager shareInstance] exeQueryNoneResult:sql_sina_book];
             //chapter TABLE
        NSString *sql_sina_chapter = @"CREATE TABLE CHAPTER (ID_BOOK TEXT, ORDER_CHAPTER INTEGER, NAME TEXT, TOTAL_SPAN TEXT)";
        [[DatabaseManager shareInstance] exeQueryNoneResult:sql_sina_chapter];
              //config TABLE
        NSString *sql_sina_config = @"CREATE TABLE CONFIG (ID_USER INTEGER, BOOK_ID INTEGER, FONT TEXT, SIZE INTEGER, ALIGN TEXT, PADDING_LEFT INTEGER, PADDING_RIGHT INTEGER, PADDING_TOP INTEGER, PADDING_BOTTOM INTEGER, BACKGROUND_COLOR TEXT, TEXT_COLOR TEXT,CONFIG_CHAPTER_ID INTEGER,LOCATION_READING INTEGER)";
        [[DatabaseManager shareInstance] exeQueryNoneResult:sql_sina_config];
             //BOOKMARK_TABLE 
        NSString *sql_sina_bookmark = @"CREATE TABLE BOOKMARK_TABLE (BOOKMARK_BOOK_ID TEXT, BOOKMARK_CONTENT TEXT, BOOKMARK_ID_USER INTEGER, BOOKMARK_LOCATION INTEGER)";
          [[DatabaseManager shareInstance] exeQueryNoneResult:sql_sina_bookmark];    
        //user TABLE
        NSString *sql_sina_user = @"CREATE TABLE USER (ID_USER TEXT, ID_BOOK TEXT, LINK_IMAGE TEXT)";
        [[DatabaseManager shareInstance] exeQueryNoneResult:sql_sina_user];
             

		/*
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &SinaDB) == SQLITE_OK)
        {
            char *errMsg;
            
            //sina_content TABLE
            const char *sql_sina_content = "CREATE TABLE sina_content (ID TEXT, state NUMERIC, error NUMERIC, type TEXT, title TEXT, author TEXT, publish_date TEXT, publisher TEXT)";
            
            if (sqlite3_exec(SinaDB, sql_sina_content, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table sina_content");
            }
            //local_content TABLE
            const char *sql_local_content = "CREATE TABLE local_content (ID TEXT, file_path TEXT, guild TEXT)";
            
            if (sqlite3_exec(SinaDB, sql_local_content, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table local_content");
            }
            
            //cover TABLE
            const char *sql_cover = "CREATE TABLE cover (book_id TEXT, file_path TEXT)";
            
            if (sqlite3_exec(SinaDB, sql_cover, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table cover");
            }
            
            //category TABLE
            const char *sql_category = "CREATE TABLE category (category_id TEXT Primary Key, name TEXT)";
            
            if (sqlite3_exec(SinaDB, sql_category, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table cover");
            }
            //book TABLE
            const char *sql_sina_book = "CREATE TABLE BOOK (ID TEXT, NAME TEXT, AUTHOR TEXT, PUBLISHER TEXT, CATEGORY TEXT, BOOK_BOOK_MARK TEXT, TOTAL_SPAN INTEGER, TOTAL_CHAPTER INTEGER)";
            
            if (sqlite3_exec(SinaDB, sql_sina_book, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table sina_book");
            }
            
           
            //chapter TABLE
            const char *sql_sina_chapter = "CREATE TABLE CHAPTER (ID_BOOK TEXT, ORDER_CHAPTER INTEGER, NAME TEXT, TOTAL_SPAN TEXT)";
            
            if (sqlite3_exec(SinaDB, sql_sina_chapter, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table sina_chapter");
            }
            //config TABLE
            const char *sql_sina_config = "CREATE TABLE CONFIG (ID_USER INTEGER PRIMARY KEY, BOOK_ID INTEGER, FONT TEXT, SIZE INTEGER, ALIGN TEXT, PADDING_LEFT INTEGER, PADDING_RIGHT INTEGER, PADDING_TOP INTEGER, PADDING_BOTTOM INTEGER, BACKGROUND_COLOR TEXT, TEXT_COLOR TEXT,CONFIG_CHAPTER_ID INTEGER,LOCATION_READING INTEGER)";
            
            if (sqlite3_exec(SinaDB, sql_sina_config, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table sql_sina_config");
            }
            //BOOKMARK_TABLE 
            const char *sql_sina_bookmark = "CREATE TABLE BOOKMARK_TABLE (BOOKMARK_BOOK_ID TEXT, BOOKMARK_CONTENT TEXT, BOOKMARK_ID_USER INTEGER, BOOKMARK_LOCATION INTEGER)";
            
            if (sqlite3_exec(SinaDB, sql_sina_bookmark, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table sql_sina_bookmark");
            }
            
            //user TABLE
            const char *sql_sina_user = "CREATE TABLE USER (ID_USER TEXT PRIMARY KEY, ID_BOOK TEXT, LINK_IMAGE TEXT)";
            
            if (sqlite3_exec(SinaDB, sql_sina_user, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table sql_sina_user");
            }
            
            
            sqlite3_close(SinaDB);
         
            
        } else {
            NSLog(@"Failed to open/create database");
        }
         */
        [self requestCategory];
    }else{
        [self requestCategory];
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //tao database
    [self createDatabase];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    //==========
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mainVC = [[MainViewController alloc] init];
    //SinaEbookViewController * loginVC = [[SinaEbookViewController alloc] init];
    
//<<<<<<< HEAD
//    LoginViewController* loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    MainViewController *mainViewController = [[MainViewController alloc] init];
//    SinaEbookViewController * loginVC = [[SinaEbookViewController alloc] init];

//    self.navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
//=======
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.mainVC];    
//>>>>>>> 47606243da27b412719e3058fd3db3da703b6143
    CustomNavigationBar* customNavigation = [[CustomNavigationBar alloc] initWithFrame:self.navigationController.navigationBar.frame];
    [customNavigation setBackgroundWith:[UIImage imageNamed:@"bannertop.png"]];
    [Utils addGradientForView:customNavigation Operacity:0.5f];
    [self.navigationController setValue:customNavigation forKeyPath:@"navigationBar"];
    
    //cach set 
//    [(CustomNavigationBar*)[self.navigationController valueForKeyPath:@"navigationBar"] setBackgroundWith:[UIImage imageNamed:@"banner_bottom.png"]];
    
    self.window.rootViewController = self.navigationController;

    self.navigationController.navigationBarHidden = YES;

    NSLog(@"database %@", [DatabaseManager shareInstance].sharedDatabase);
    NSLog(@"database %@", [DatabaseManager shareInstance].sharedDatabase);
    NSLog(@"database %@", [DatabaseManager shareInstance].sharedDatabase);
    NSLog(@"database %@", [DatabaseManager shareInstance].sharedDatabase);
    
    
    [self.window makeKeyAndVisible];
//    [Utils aleartWithTitle:@"Thong bao" Message:[NSString stringWithFormat:@"perferences save %@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]] CancelButton:@"Ok" Delegate:nil];
//    if([[NSUserDefaults standardUserDefaults] stringForKey:USERID_PREFERENCES]!=nil){
//        [Utils aleartWithTitle:@"Thong bao" Message:@"perferences save" CancelButton:@"Ok" Delegate:nil];
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:USERID_PREFERENCES] isEqualToString:@"type_nomal"]) {
//            [Utils aleartWithTitle:@"Thong bao" Message:@"perferences save" CancelButton:@"Ok" Delegate:nil];
//        }
//    }
    
    
    return YES;

}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [FBSession.activeSession handleOpenURL:url]; 
}

#pragma mark - request delegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    
    //category se duoc cap nhat lan dau vao co so su lieu
    if([request isEqual:requestCategory]){
        NSDictionary* responseDic = [[requestCategory responseString] objectFromJSONString];
        NSMutableArray* arrayCat = [responseDic objectForKey:@"list_cat"];
        int catcount = [arrayCat count];
        BOOL new = YES;
        NSString* insertString = nil;
        for (int i = 0; i<catcount; i++) {
            if (new) {
                insertString = @"insert or replace into category(category_id, name)";
                new = NO;
            }else{
                insertString = [NSString stringWithFormat:@"%@ union", insertString];
            }
            insertString  = [NSString stringWithFormat:@"%@ select '%@', '%@' ",insertString,[[arrayCat objectAtIndex:i] objectForKey:@"cat_id"],[[arrayCat objectAtIndex:i] objectForKey:@"name"]];
            
        }
        [[DatabaseManager shareInstance] exeQueryNoneResult:insertString];
//        [databaseSina closeDatabase];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    //NSError *error = [request error];
//    [Utils aleartWithTitle:@"Lỗi" Message:@"Kết nối mạng không khả dụng, vui lòng kiểm tra lại" CancelButton:@"Ok" Delegate:self];
    [self.mainVC.view makeToast:@"Kết nối mạng không khả dụng, vui lòng kiểm tra lại" duration:1.f position:@"center"];
    
}

- (void)applicationWillResignActive:(UIApplication *)application{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    if (FBSession.activeSession.state == FBSessionStateCreatedOpening) {
        // BUG: for the iOS 6 preview we comment this line out to compensate for a race-condition in our
        // state transition handling for integrated Facebook Login; production code should close a
        // session in the opening state on transition back to the application; this line will again be
        // active in the next production rev
        //[FBSession.activeSession close]; // so we close our session and start over
    }	

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [FBSession.activeSession close];
}

@end
