//
//  RegisterViewController.h
//  sinaIos
//
//  Created by macos on 19/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>{
    
    IBOutlet UITextField * tfUser;
    IBOutlet UITextField * tfEmail;
    IBOutlet UITextField * tfPassword;
    IBOutlet UITextField * tfRePassword;

}


-(IBAction)btDangkyClick:(id)sender;

@end
