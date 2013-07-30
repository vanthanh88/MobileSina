//
//  PullToRefreshAQgridViewController.h
//  SinaIos
//
//  Created by macos on 04/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "AQGridView.h"

#define FetchData(array, index, key) [[array objectAtIndex:index] objectForKey:key]
#define ColorWithImage(image) [UIColor colorWithPatternImage:[UIImage imageNamed:image]]

@interface PullToRefreshAQgridViewController : UIViewController<AQGridViewDataSource, AQGridViewDelegate>{
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    AQGridView* gridV;
}
@property(nonatomic, strong) AQGridView* gridV;
@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;


@end
