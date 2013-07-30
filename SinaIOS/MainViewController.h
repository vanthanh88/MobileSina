//
//  MainViewController.h
//  SinaIos
//
//  Created by macos on 04/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "MKHorizMenu.h"
#import "PullToRefreshAQgridViewController.h"
#import "FieldEditorViewController.h"
#import "ASIHTTPRequest.h"
#import "DatabaseManager.h"
#import "MBProgressHUD.h"
#import "Toast+UIView.h"
#import "ExtraAlert.h"
#import "IPOfflineQueue.h"

@interface MainViewController : PullToRefreshAQgridViewController<MKHorizMenuDelegate,MKHorizMenuDataSource,FieldEditorViewControllerDelegate, MBProgressHUDDelegate, IPOfflineQueueDelegate, UIAlertViewDelegate>{
    UIView* topView;   //view top giong uitoolbar
    UIView* bottomView; //view botom
    UIButton* btKindView; // chon de xem dang list or grid cua aqgridview
    UIButton* btSetting;    //chon de hien thi form setting
    
    FieldEditorViewController* settingsViewController;
    MCSegmentedControl *segmentControl;
    //horizontal menu
    MKHorizMenu* horizontalMenu;
    NSArray* itemsHoriMenu;
   
    //request
    ASIFormDataRequest* aResquestSync;
    ASIFormDataRequest* aResquestDownloadBook;
    ASIFormDataRequest* aRequestLoadListBook;
    ASIFormDataRequest* aReQuestLoadBookByCat;
    ASIFormDataRequest* aReQuestDeregisterDevice;

    
    
    NSMutableArray* listBookOnCloud;
    NSMutableArray* listBookOnDevice;
    NSMutableArray* listBookNeedToSync;
    ExtraAlert * alertDeleteBook;
    
    //database manager
    DatabaseManager* databaseSina;
    IPOfflineQueue * queueMultiInsert;
    
}

@property (nonatomic, strong) NSDictionary* userInformation;
@property (nonatomic, strong) NSString* userEmail;
@property (nonatomic, strong) NSMutableArray* listBookOnCloud;
@property (nonatomic, strong) NSMutableArray* listBookOnDevice;
@property (nonatomic, strong) NSMutableArray* listBookNeedToSync;

@property (nonatomic, assign) NSInteger current_page;

@end
