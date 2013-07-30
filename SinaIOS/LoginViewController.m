//
//  LoginViewController.m
//  SinaEbookReader
//
//  Created by macos on 26/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "LoginViewController.h"
#import "ASIFormDataRequest.h"
#import "NSString+MD5.h"
#import "JSONKit.h"
#import "MainViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"


@implementation UITextField (custom)
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 8,
                      bounds.size.width - 20, bounds.size.height - 16);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}
@end

@interface LoginViewController()
-(void) initHomeView;

@end


@implementation LoginViewController

@synthesize txtUser,txtPass, swSavePass, spinner;
@synthesize mainView;

@synthesize sendIDConnection = _sendIDConnection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - User define
-(void) initHomeView{
    txtPass.delegate=self;
    txtUser.delegate = self;
    self.spinner.hidden = YES;
    
}
#pragma mark - dang nhap clicked
-(IBAction)btnDangNhapClicked:(id)sender{
    
    if ([[txtUser.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [Utils aleartWithTitle:@"Thông báo" Message:@"Tên đăng nhập không để trống" CancelButton:@"Ok" Delegate:self];
        return;

    }else if([[txtPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        [Utils aleartWithTitle:@"Thông báo" Message:@"Mật khẩu không được trống" CancelButton:@"Ok" Delegate:self];
        return;
    }

    if(![Utils validateEmailwithEmail:txtUser.text]){
        [Utils aleartWithTitle:@"Thông báo" Message:@"Email không đúng định dạng" CancelButton:@"Ok" Delegate:self];
        return;
    }
      
    
    [txtPass resignFirstResponder];
    progressHUB = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:progressHUB];
	
	progressHUB.delegate = self;
	progressHUB.labelText = @"Đang đăng nhập...";
	
	[progressHUB showWhileExecuting:@selector(loginTask) onTarget:self withObject:nil animated:YES];
}
-(void) loginTask{

    NSString *object_data = DATALOGIN([txtUser text],[txtPass text],[Utils getDeviceId],[Utils getDeviceName]);
    aResQuestLogin = [Utils requestWithLink:URL_LOGIN Data:object_data];
    aResQuestLogin.delegate = self;
    [aResQuestLogin startAsynchronous];
   
//    if ([aResQuestLogin responseStatusCode] == 200) {
//                
//    }else{
//        [Utils aleartWithTitle:@"Thông báo" Message:@"Kết nối mạng không khả dụng, vui lòng kiểm tra lại" CancelButton:@"Ok" Delegate:self];
//        return;
//    }

}

#pragma mark - text field
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == txtUser) {
        [txtPass becomeFirstResponder];
    }
    else if (textField == txtPass) {
        [textField becomeFirstResponder];
    }

    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [(TPKeyboardAvoidingScrollView*)self.view adjustOffsetToIdealIfNeeded];
}
#pragma mark - UIAlerView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex]) {
//        [_facebook logout];
    }
}
#pragma mark - btFacebook
-(IBAction)btFaceBookClick:(id)sender{
    
    if([FBSession activeSession].isOpen == NO){
        [self.spinner startAnimating];
        [self.spinner setHidden:NO];
        [self.view setUserInteractionEnabled:NO];
        [self openSessionWithAllowLoginUI:YES];
    }else{
        [FBSession setActiveSession:nil];
        [self.spinner startAnimating];
        [self.spinner setHidden:NO];
        [self.view setUserInteractionEnabled:NO];
        [self openSessionWithAllowLoginUI:YES];
    }
    
    
}

- (void)loginFailed
{
    
    [self.spinner stopAnimating];
    [self.spinner setHidden:YES];
    [self.view setUserInteractionEnabled:YES];
}
-(IBAction)BTDangKyClick:(id)sender{
    self.navigationController.navigationBarHidden = NO;
    RegisterViewController * registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initHomeView];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:kUsernameLogin] != nil){
       txtUser.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUsernameLogin]; 
        txtPass.text =  [[NSUserDefaults standardUserDefaults] objectForKey:kPasswordLogin];
    }
    
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.txtPass = nil;
    self.txtUser =nil;
   
}
#pragma mark - FB SDK
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    // FBSample logic
    // Any time the session is closed, we want to display the login controller (the user
    // cannot use the application unless they are logged in to Facebook). When the session
    // is opened successfully, hide the login controller and show the main UI.
    switch (state) {
        case FBSessionStateOpen: {
            //            NSLog(@"Run here");
            //da ton tai session
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                 if (!error) {
                     fbName = [NSString stringWithFormat:@"%@(FaceBook)",user.name];
                     fbEmail = [user objectForKey:@"email"];
                     NSString * dataFBLogin = DATA_REQUEST_FACEBOOK([user objectForKey:@"email"], user.name, user.id, [FBSession activeSession].accessToken,[Utils getDeviceId]);
                     
//                     NSLog(@"Data result %@", dataFBLogin);
                     requestFBLogin = [Utils requestWithLink:URL_FB_LOGIN Data:dataFBLogin];
                     requestFBLogin.delegate = self;
                     //request finish thi se an view nay va chuyen qua view main
                     [requestFBLogin startAsynchronous];
//                     NSLog(@"User name %@ Name: %@%@%@", user.name, user.first_name, user.middle_name, user.last_name);
//                     NSLog(@"Dic result %@", [user objectForKey:@"email"]);
                 }
             }];   
            FBCacheDescriptor *cacheDescriptor = [FBFriendPickerViewController cacheDescriptor];
            [cacheDescriptor prefetchAndCacheForSession:session];
            
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // FBSample logic
            // Once the user has logged in, we want them to be looking at the root view.
            [self.navigationController popToRootViewControllerAnimated:NO];
            [FBSession.activeSession closeAndClearTokenInformation];
            
            //Van o view nay
            
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SessionStateChangedNotification 
                                                        object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }    
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions", @"user_photos",@"email", nil];
    
    return [FBSession openActiveSessionWithPermissions:permissions
                                          allowLoginUI:allowLoginUI
                                     completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                         [self sessionStateChanged:session state:state error:error];
                                     }];    
}


#pragma mark - 

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - 
-(void) requestFinished:(ASIHTTPRequest *)request{
    if([request isEqual:aResQuestLogin]){
        NSDictionary *dataResponse = [[aResQuestLogin responseString] objectFromJSONString];
//        NSLog(@"dataResponse %@",dataResponse);
        if ([[dataResponse objectForKey:KEY_SUCCESS] intValue]==0) {
            [Utils aleartWithTitle:@"Thông báo" Message:[dataResponse objectForKey:@"message"] CancelButton:@"Ok" Delegate:self];
            return;
            
        }else{ //success
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
            
            self.navigationController.navigationBarHidden = YES;
            

//            NSDictionary *appPrerfs = [NSDictionary dictionaryWithObjectsAndKeys:
//                                       [dataResponse objectForKey:@"id_user"], USERID_PREFERENCES,
//                                       [dataResponse objectForKey:@"name"], NAME_PREFERENCES,
//                                       txtUser.text, EMAIL_PREFERENCES,
//                                       @"type_nomal", USERTYPE_PREFERENCES,
//                                       nil];
//            
//            [[NSUserDefaults standardUserDefaults] registerDefaults:appPrerfs];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:[dataResponse objectForKey:@"id_user"] forKey:USERID_PREFERENCES];
            [[NSUserDefaults standardUserDefaults] setObject:[dataResponse objectForKey:@"name"] forKey:NAME_PREFERENCES];
            [[NSUserDefaults standardUserDefaults] setObject:txtUser.text forKey:EMAIL_PREFERENCES];
            [[NSUserDefaults standardUserDefaults] setObject:@"type_nomal" forKey:USERTYPE_PREFERENCES];
            
            [[NSUserDefaults standardUserDefaults] setObject:txtUser.text forKey:kUsernameLogin];
            
            [[NSUserDefaults standardUserDefaults] setObject:txtPass.text forKey:kPasswordLogin];
            //                [[NSUserDefaults standardUserDefaults] registerDefaults:appPrerfs];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.mainView setCurrent_page:1];
            [self.mainView.listBookOnDevice removeAllObjects];
            [self.mainView.listBookOnCloud removeAllObjects];

            [self dismissModalViewControllerAnimated:YES]; 
        }

    }else if([request isEqual:requestFBLogin]){
        
        NSDictionary * responseDic = [[requestFBLogin responseString] objectFromJSONString];
        //        NSLog(@"responseString %@ - %@", [responseDic objectForKey:@"message_device"], [responseDic objectForKey:@"message"]);
        if([[responseDic objectForKey:@"success"] intValue] == 1){
            
            UIViewController *topViewController = [self.navigationController topViewController];
            if ([[topViewController modalViewController] isKindOfClass:[LoginViewController class]]) {
                [topViewController dismissModalViewControllerAnimated:YES];
            }else{
            
//                NSDictionary *appPrerfs = [NSDictionary dictionaryWithObjectsAndKeys:
//                                           [responseDic objectForKey:@"id_user"], USERID_PREFERENCES,
//                                           fbName, NAME_PREFERENCES,
//                                           fbEmail, EMAIL_PREFERENCES,
//                                           @"type_fb", USERTYPE_PREFERENCES,
//                                           nil];
                
                [[NSUserDefaults standardUserDefaults] setObject:[responseDic objectForKey:@"id_user"] forKey:USERID_PREFERENCES];
                [[NSUserDefaults standardUserDefaults] setObject:fbName forKey:NAME_PREFERENCES];
                [[NSUserDefaults standardUserDefaults] setObject:fbEmail forKey:EMAIL_PREFERENCES];
                [[NSUserDefaults standardUserDefaults] setObject:@"type_fb" forKey:USERTYPE_PREFERENCES];
//                [[NSUserDefaults standardUserDefaults] registerDefaults:appPrerfs];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.mainView setCurrent_page:1];
                [self.mainView.listBookOnDevice removeAllObjects];
                [self.mainView.listBookOnCloud removeAllObjects];
                [self dismissModalViewControllerAnimated:YES];
                
            }
            }else{
                [Utils aleartWithTitle:@"Thông báo" Message:[responseDic objectForKey:@"message"] CancelButton:@"OK" Delegate:nil];
            }
        
        }


}
-(void) requestFailed:(ASIHTTPRequest *)request{
    [Utils aleartWithTitle:@"Thông báo" Message:@"Đăng nhập không thành công!" CancelButton:@"Ok" Delegate:nil];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[progressHUB removeFromSuperview];
	
	progressHUB = nil;
}

@end
