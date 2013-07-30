//
//  CustomAlert.m
//  sinaIos
//
//  Created by macos on 26/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomAlert.h"


@implementation CustomAlert
@synthesize textField;
@synthesize enteredText;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{
    
    
    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil])
    {
        
        
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 35.0)]; 
        [theTextField setBackgroundColor:[UIColor whiteColor]]; 
        theTextField.font = [UIFont systemFontOfSize:18];
        [theTextField setKeyboardType:UIKeyboardTypeNumberPad];
        
        [self addSubview:theTextField];
        self.textField = theTextField;
        UILabel * lbText = [[UILabel alloc] initWithFrame:CGRectMake(12, 75, 260, 30)];
        lbText.backgroundColor = [UIColor clearColor];
        lbText.font = [UIFont systemFontOfSize:14];
        lbText.textColor = [UIColor redColor];
        lbText.textAlignment = UITextAlignmentCenter;
        lbText.text = message;
        [self addSubview:lbText];
        


//        CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 30.0); 
//        [self setTransform:translate];
       
    }
    return self;
}
- (void)show
{
    [textField becomeFirstResponder];
    [super show];
}
- (NSString *)enteredText
{
    return textField.text;
}

@end
