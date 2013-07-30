//
//  LoginViewController.h
//  SinaEbookReader
//
//  Created by macos on 26/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TPKeyboardAvoidingScrollView.h"
#import "MBProgressHUD.h"
#import "MainViewController.h"

@class FBSession;
@interface LoginViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate,UIAlertViewDelegate,ASIHTTPRequestDelegate>{
    
    UITextField *txtUser;
    UITextField *txtPass;
    UISwitch* swSavePass;
    MBProgressHUD *progressHUB;
    
    NSString* fbName;
    NSString* fbEmail;
    
    
    
    ASIFormDataRequest *aResQuestLogin;
    ASIFormDataRequest* requestFBLogin;
    
    
}

@property (nonatomic, retain) IBOutlet UITextField *txtUser;
@property (nonatomic, retain) IBOutlet UITextField *txtPass;
@property (nonatomic, strong) IBOutlet UISwitch  *swSavePass;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView * spinner;
@property (nonatomic, strong) MainViewController * mainView;


@property (nonatomic, strong) NSURLConnection *sendIDConnection;

-(IBAction)btnDangNhapClicked:(id)sender;
-(IBAction)btFaceBookClick:(id)sender;
-(IBAction)BTDangKyClick:(id)sender;

//for FacebookSDK
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void)loginFailed;


@end
