//
//  CustomAlert.h
//  sinaIos
//
//  Created by macos on 26/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlert : UIAlertView 
{
    UITextField *textField;
}
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString *enteredText;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;
@end