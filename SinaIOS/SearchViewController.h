//
//  SearchViewController.h
//  SinaIos
//
//  Created by macos on 11/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toolbar.h"
#import "AQGridView.h"
#import "ASIFormDataRequest.h"
#import "MainViewController.h"

@interface SearchViewController : UIViewController<UISearchBarDelegate, AQGridViewDelegate, AQGridViewDataSource,ASIHTTPRequestDelegate>{
    
    Toolbar* topBar;
    UISearchBar* aSearchBar;
    AQGridView* gridV;
    
    NSMutableArray * searchResult;
    ASIFormDataRequest * requestSearch;
    
    
}

@property(nonatomic, strong) MainViewController * mainVC;

-(void) doSearchingWithCloud:(BOOL)isCloudSearch stringKeySearch:(NSString*)string;


@end
