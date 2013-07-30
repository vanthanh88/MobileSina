//
//  Toolbar.m
//  SinaIos
//
//  Created by macos on 11/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Toolbar.h"

@implementation Toolbar


- (void) drawRect:(CGRect)rect
{
    // Drawing code    
    UIImage *image = [UIImage imageNamed:@"bannertop.png"];
    [image drawAsPatternInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [Utils addGradientForView:self Operacity:0.5f];
}

@end
