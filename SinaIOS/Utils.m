//
//  Utils.m
//  SinaIOS
//
//  Created by macos on 18/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"
#import "Config.h"
#import "NSString+MD5.h"



@implementation Utils


+ (void)resetDefaults {

    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (id key in dict) {
        if([key isEqualToString:USERID_PREFERENCES] || [key isEqualToString:USERTYPE_PREFERENCES] || [key isEqualToString:EMAIL_PREFERENCES] || [key isEqualToString:NAME_PREFERENCES]){
//            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:key];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"NSUserDefault %@", dict);
}

+ (NSString *)databasePath
{
    return [[Utils applicationDocumentsDirectory] stringByAppendingPathComponent:DATA_NAME];
}

+(void) removeBackground:(UIView*)theView //for webview,tableview
{
    for (UIView * subview in theView.subviews)
    {
        if ([subview isKindOfClass:[UIImageView class]])
            //subview.hidden = YES;
            [subview removeFromSuperview];
        
        [Utils removeBackground:subview];
        
        if ([subview isKindOfClass:[UIScrollView class]]) {  
            UIScrollView *sView = (UIScrollView *)subview;  
            
            sView.showsVerticalScrollIndicator = YES;  
            sView.showsHorizontalScrollIndicator = NO;
            
        }   
    }
}
+(void)flipView:(UIView*)v {
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:v cache:NO];
    [UIView commitAnimations];
}
+(void) ShowHideView:(UIView*)view animation:(UIViewAnimationCurve)curve alpha:(float) a{
    [UIView beginAnimations:@"ShowHideView" context:nil];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    // Make the animatable changes.
    view.alpha = a;
    
    // Commit the changes and perform the animation.
    [UIView commitAnimations];

}

+(void) animationForView: (UIView* )view kCATransition: (NSString* const) animation duration:(float) time forKey:(NSString*)key{
    CATransition *a = [CATransition animation];
    [a setDelegate:self];
    [a setType:animation];
    [a setSubtype:kCATransitionFromBottom];
    [a setDuration:time];
    [a setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [[view layer] addAnimation:a forKey:key];

}

+(UIButton *)newButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector frame:(CGRect)frame image:(UIImage *)image hilightImage:(UIImage*)hImage{
	
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    
    
    UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
    hImage!=nil?[button setBackgroundImage:hImage forState:UIControlStateHighlighted]:[button setBackgroundImage:[UIImage imageNamed:@"btblack_bg.png"] forState:UIControlStateHighlighted];
    
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
    // in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}

+ (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+(BOOL) validateEmailwithEmail: (NSString*)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(void) addGradient:(UIButton *) _button {
    
    // Add Border
    CALayer *layer = _button.layer;
    layer.cornerRadius = 8.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;
    
    // Add Shine
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [layer addSublayer:shineLayer];
}

+(void) addGradientForView:(UIView *)view Operacity:(float)operacity{
    
    // Add Border
    CALayer *layer = view.layer;
    
    // Add Shine
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    [shineLayer setOpaque:YES];
    [shineLayer setOpacity:operacity];
    shineLayer.frame = layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [layer addSublayer:shineLayer];
    
}

+(UIImageView*) imageWithCorectRadius:(CGFloat)radius Strock:(CGFloat)strock frameImg:(CGRect)frame{
    UIImageView* img = [[UIImageView alloc] initWithFrame:frame];
    [img.layer setCornerRadius:radius];
    [img.layer setMasksToBounds:YES];
    [img.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [img.layer setBorderWidth:strock];
    
    return img;

}

+(void) addGradient:(UIButton *) _button AndCorectRadius: (CGFloat)radius{
    
    // Add Border
    CALayer *layer = _button.layer;
    layer.cornerRadius = radius;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;
    
    // Add Shine
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [layer addSublayer:shineLayer];
}



+(UIImage*) resizedImage:(UIImage *)inImage: (CGRect) thumbRect{
	CGImageRef			imageRef = [inImage CGImage];
	CGImageAlphaInfo	alphaInfo = CGImageGetAlphaInfo(imageRef);
	
	if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;
    
	// Build a bitmap context that's the size of the thumbRect
	CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                thumbRect.size.width,		// width
                                                thumbRect.size.height,		// height
                                                CGImageGetBitsPerComponent(imageRef),	// really needs to always be 8
                                                4 * thumbRect.size.width,	// rowbytes
                                                CGImageGetColorSpace(imageRef),
                                                alphaInfo
                                                );
    
	// Draw into the context, this scales the image
	CGContextDrawImage(bitmap, thumbRect, imageRef);
    
	// Get an image from the context and a UIImage
	CGImageRef	ref = CGBitmapContextCreateImage(bitmap);
	UIImage*	result = [UIImage imageWithCGImage:ref];
    
	CGContextRelease(bitmap);	// ok if NULL
	CGImageRelease(ref);
    
	return result;
}

+(void) aleartWithTitle: (NSString*)title Message:(NSString* ) mes CancelButton:(NSString*) cancel Delegate: (id)me{
    UIAlertView *message = [[UIAlertView alloc] 
                            initWithTitle:title message:mes delegate:nil 
                            cancelButtonTitle:cancel otherButtonTitles:nil];
    message.delegate = me;
    
    [message show];

}
+(ASIFormDataRequest *) requestWithLink:(NSString*)link Data: (NSString*)data{
    NSURL *url = [NSURL URLWithString:link];
    ASIFormDataRequest *aResQuest = [ASIFormDataRequest requestWithURL:url];
    [aResQuest setUsername:ACC_AUTHEN];
    [aResQuest setPassword:PASS_AUTHEN];
    
    NSString *stringPost = [NSString stringWithFormat:@"%@%@", data, REST_SHARE_KEY];
    NSString *checkSum = [stringPost MD5];
    
    [aResQuest setPostValue:data forKey:KEY_DATA];
    [aResQuest setPostValue:ACCESSKEYID forKey:KEY_ACCESSKEYID];
    [aResQuest setPostValue:checkSum forKey:KEY_CHECKSUM];

    
    //[aResQuest startSynchronous];
    
    return aResQuest;
}
+(NSString *) stringByStrippingHTML:(NSString*)s {
    if (s == nil) {
        return @"";
    }
    NSRange r;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s; 
}
+(NSString* )getDeviceId{
    UIDevice *device = [UIDevice currentDevice];
    NSString *uniqueIdentifier = [device uniqueIdentifier];
    return uniqueIdentifier;
}

+(NSString* )getDeviceName{
    UIDevice *device = [UIDevice currentDevice];
    NSString *name = [device name];
    
    return name;
}

@end
