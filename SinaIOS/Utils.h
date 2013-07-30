//
//  Utils.h
//  SinaIOS
//
//  Created by macos on 18/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface Utils : NSObject

+ (void)resetDefaults;
+ (NSString *)databasePath;

+(void)flipView:(UIView*)v;
+(void) ShowHideView:(UIView*)view animation:(UIViewAnimationCurve)curve alpha:(float) a;

+(void) addGradientForView:(UIView *)view Operacity:(float)operacity;

+(void) animationForView: (UIView* )view kCATransition: (NSString* const) animation duration:(float) time forKey:(NSString*)key;
+ (NSString *)applicationDocumentsDirectory;
+(void) removeBackground:(UIView*)theView;
+(UIButton *)newButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector frame:(CGRect)frame image:(UIImage *)image hilightImage:(UIImage*)hImage;
+(BOOL) validateEmailwithEmail: (NSString*)email;
+(void) aleartWithTitle: (NSString*)title Message:(NSString* ) mes CancelButton:(NSString*) cancel Delegate: (id)me;
+(void) addGradient:(UIButton *) _button;
+(void) addGradient:(UIButton *) _button AndCorectRadius: (CGFloat)radius;
+(UIImage*) resizedImage:(UIImage *)inImage: (CGRect) thumbRect;
+(ASIFormDataRequest *) requestWithLink:(NSString*)link Data: (NSString*)data;
+(UIImageView*) imageWithCorectRadius:(CGFloat)radius Strock:(CGFloat)strock frameImg:(CGRect)frame;
+(NSString *) stringByStrippingHTML:(NSString*)s;

+(NSString*) getDeviceId;
+(NSString* )getDeviceName;



@end
