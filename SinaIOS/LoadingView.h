//
//  LoadingView.h
//  NUY Social
//
//  Created by Dac Diep Vuong on 10/6/12.
//  Copyright (c) 2012 Lai The Su. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView {
    BOOL modalMode;
	CGRect modalRect;
}

+ (id)loadingModalInView:(UIView *)aSuperview;
+ (id)loadingViewInView:(UIView *)aSuperview;
- (void)removeView;

@property (assign) BOOL modalMode;
@property (assign) CGRect modalRect;

@end
