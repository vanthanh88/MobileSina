//
//  RegisterViewController.m
//  sinaIos
//
//  Created by macos on 19/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ASIFormDataRequest.h"
#import "MainViewController.h"
#import "JSONKit.h"

@implementation UITextField (custom)
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 8,
                      bounds.size.width - 20, bounds.size.height - 16);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}
@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Đăng ký tài khoản mới";
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tfUser.delegate = self;
    tfEmail.delegate = self;
    tfPassword.delegate =self;
    tfRePassword.delegate =self;
    
}

-(IBAction)btDangkyClick:(id)sender{
    if ([[tfUser.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [Utils aleartWithTitle:@"Thông báo" Message:@"Tên người dùng không để trống" CancelButton:@"Ok" Delegate:self];
        return;
        
        
    }
    else if([[tfEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        [Utils aleartWithTitle:@"Thông báo" Message:@"Email không được trống" CancelButton:@"Ok" Delegate:self];
        return;
    }

    else if([[tfPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        [Utils aleartWithTitle:@"Thông báo" Message:@"Mật khẩu không được trống" CancelButton:@"Ok" Delegate:self];
        return;
    }
    else if([[tfRePassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        [Utils aleartWithTitle:@"Thông báo" Message:@"Nhập lại mật khẩu không được trống" CancelButton:@"Ok" Delegate:self];
        return;
    }

    
    if(![Utils validateEmailwithEmail:tfEmail.text]){
        
        [Utils aleartWithTitle:@"Thông báo" Message:@"Email không đúng định dạng" CancelButton:@"Ok" Delegate:self];
        return;
    }
    if(![tfPassword.text isEqualToString:tfRePassword.text]){
        [Utils aleartWithTitle:@"Thông báo" Message:@"Mật khẩu nhập vào không khớp" CancelButton:@"Ok" Delegate:self];
        return;
    }
    
    
    [tfRePassword resignFirstResponder];
   MBProgressHUD * progressHUB = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:progressHUB];
	
	progressHUB.delegate = self;
	progressHUB.labelText = @"Đang đăng ký...";
	
	[progressHUB showWhileExecuting:@selector(RegisterTask) onTarget:self withObject:nil animated:YES];

    
    
}

-(void) RegisterTask{
    NSString * dataRegister = DATA_REGISTER_USER(tfEmail.text, tfPassword.text, tfUser.text);
    ASIFormDataRequest * requestRegister = [Utils requestWithLink:URL_REGISTER Data:dataRegister];
    [requestRegister startSynchronous];
    if ([requestRegister responseStatusCode]==200) {
        NSDictionary *dataResponse = [[requestRegister responseString] objectFromJSONString];
        if ([[dataResponse objectForKey:KEY_SUCCESS] intValue]==0) {
            [Utils aleartWithTitle:@"Thông báo" Message:[dataResponse objectForKey:@"message"] CancelButton:@"Ok" Delegate:self];
            return;
        }else{ //success
            MainViewController *mainView = [[MainViewController alloc] init];
            
            [[NSUserDefaults standardUserDefaults] setObject:[dataResponse objectForKey:@"id_user"] forKey:USERID_PREFERENCES];
            [[NSUserDefaults standardUserDefaults] setObject:[dataResponse objectForKey:@"name"] forKey:NAME_PREFERENCES];
            [[NSUserDefaults standardUserDefaults] setObject:tfEmail.text forKey:EMAIL_PREFERENCES];
            [[NSUserDefaults standardUserDefaults] setObject:@"type_nomal" forKey:USERTYPE_PREFERENCES];
            
            [[NSUserDefaults standardUserDefaults] setObject:tfEmail.text forKey:kUsernameLogin];
            
            [[NSUserDefaults standardUserDefaults] setObject:tfPassword.text forKey:kPasswordLogin];
            //                [[NSUserDefaults standardUserDefaults] registerDefaults:appPrerfs];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            mainView.userEmail = tfUser.text;
            mainView.userInformation =dataResponse;
            self.navigationController.navigationBarHidden = YES;
            [self.navigationController pushViewController:mainView animated:YES]; 
        }
    }else{
        [Utils aleartWithTitle:@"Thông báo" Message:@"Kết nối mạng không khả dụng, vui lòng kiểm tra lại" CancelButton:@"Ok" Delegate:self];
        return;
    }
}


#pragma mark - text field
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == tfUser) {
        [tfUser becomeFirstResponder];
    }
    else if (textField == tfEmail) {
        [tfEmail becomeFirstResponder];
    }else if(textField == tfPassword){
        [tfPassword becomeFirstResponder];
    }else if(textField == tfRePassword){
        [tfRePassword becomeFirstResponder];
    }
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [(TPKeyboardAvoidingScrollView*)self.view adjustOffsetToIdealIfNeeded];
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

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hub {
	// Remove HUD from screen when the HUD was hidded
	[hub removeFromSuperview];
	
	hub = nil;
}


@end
