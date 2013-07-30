//
//  Toolbar2.h
//  SinaIos
//
//  Created by macos on 11/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Toolbar2 : UIView {
    
    NSMutableArray *ToolbarItems;
}

@property (readonly) NSMutableArray *ToolbarItems;

- (id)initWithFrame:(CGRect)frame AndBackgroundColor:(UIColor*)bgColor;
- (id)initWithFrame:(CGRect)frame AndBackgroundImage:(UIImage*)bgImage;

- (void)AddToolbarItemWithImage: (UIImage*)image Target:(id)target Selector:(SEL)selector;
-(void)AddToolbarItemWithImage: (UIImage*)image Target:(id)target Selector:(SEL)selector andTag:(NSInteger)tag;
- (void)ButtonAtIndex:(int)index SetEnabled:(BOOL)enabled;
- (void)RemoveButtonAtIndex:(int)index;

- (float)AdjustExistingButtonsToFitWithCount:(int)count;
- (UIButton*) buttonBarAtIndex:(int)index; 

@end
