//
//  DetailBookViewController.h
//  SinaIos
//
//  Created by macos on 10/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import "AQGridView.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "MainViewController.h"
#import "IPOfflineQueue.h"
#import "MNMProgressBar.h"

@interface DetailBookViewController : UIViewController<AQGridViewDelegate,AQGridViewDataSource,ASIHTTPRequestDelegate,ASIProgressDelegate, IPOfflineQueueDelegate, UIWebViewDelegate,UIAlertViewDelegate>{
    
    UIView*         viewLoading;
    UIImageView*    imgThumbBig;
    UILabel*        lbTitle;
    UILabel*        lbAuthor;
    RateView*       starView;
    UIButton*       btShare;
    UIButton*       btDownloadNow;
    UIWebView*      wvDescription;
    AQGridView*     scrollBookRelate;
    UILabel*        _lbAuthor;
    UILabel*        _lbDescription;
    UILabel*        _lbRelative;
    UIView*         _line1;
    UIView*         _line2;
    
    //timer 
    NSTimer* timer_;
    //Request
    ASIFormDataRequest* requestBookInfor;
    ASIFormDataRequest * requestDownloadBook;
    ASIFormDataRequest * requestBuyBook;
    ASIFormDataRequest * requestCheckUserBook;
    
    NSDictionary* bookInformation;
    NSArray* listBookRelate;
    
    UIAlertView *alertBuyBook;
    UIAlertView *alertNonLogin;
    
    UIAlertView *alertDownloadBook;
    MNMProgressBar* progressViewDownloadBook;
    IPOfflineQueue * queueInsert;
    
}

@property(nonatomic, strong) NSString* BookId;
@property (nonatomic, strong) NSString* urlCover;
@property (nonatomic, strong) MainViewController * mainVC;



@end
