//
//  LoadingView.m
//  NUY Social
//
//  Created by Dac Diep Vuong on 10/6/12.
//  Copyright (c) 2012 Lai The Su. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoadingView

@synthesize modalMode, modalRect;

+ (id)loadingModalInView:(UIView *)aSuperview {
    CGRect rect = [aSuperview bounds];
	LoadingView *loadingView = [[LoadingView alloc] initWithFrame:rect];
	loadingView.modalMode = YES;
	
	if (!loadingView){
		return nil;
	}
    
    loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	loadingView.opaque = NO;
	[aSuperview addSubview:loadingView];
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[loadingView addSubview:activityIndicatorView];
    
    activityIndicatorView.frame = CGRectMake(rect.size.width - 30, rect.size.height - 30, 20, 20);
	[activityIndicatorView startAnimating];
    
    return loadingView;
}

+ (id)loadingViewInView:(UIView *)aSuperview {
    CGRect rect = [aSuperview bounds];
	LoadingView *loadingView = [[LoadingView alloc] initWithFrame:rect];
	loadingView.modalMode = NO;
	
	if (!loadingView){
		return nil;
	}
    
    loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	loadingView.opaque = NO;
	[aSuperview addSubview:loadingView];
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.frame = CGRectMake((rect.size.width / 2.0) - 10, (rect.size.height / 2.0) - 10, 20, 20);
    [loadingView addSubview:activityIndicatorView];
	[activityIndicatorView startAnimating];
    
    // Set up the fade-in animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
    
    return loadingView ;
}

- (void)removeView {
	UIView *aSuperview = [self superview];
	[super removeFromSuperview];
    
	// Set up the animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
}

-(void) createRoundedRect: (CGRect) rect WithRadius: (float) radius UsingContext: (CGContextRef) context {
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect));
	CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI / 2, 0, 0);
	CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, M_PI / 2, 0);
	CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, M_PI / 2, M_PI, 0);
	CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3 * M_PI / 2, 0);
	CGContextClosePath(context);
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if(modalMode) {
		CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0.0 alpha:0.8] CGColor]);
		CGContextFillRect(context, rect);
		
		[self createRoundedRect:self.modalRect WithRadius:5.0 UsingContext:context];
		CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0.0 alpha:1.0] CGColor]);
		CGContextFillPath(context);
		
		CGContextSetStrokeColorWithColor(context, [[UIColor colorWithWhite:1.0 alpha:0.0] CGColor]);
		[self createRoundedRect:self.modalRect WithRadius:5.0 UsingContext:context];
		CGContextStrokePath(context);
		
	} else {
		CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
		CGContextFillRect(context, rect);
	}
}

@end
