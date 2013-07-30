//
//  AppDelegate.h
//  SinaIos
//
//  Created by macos on 04/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <UIKit/UIKit.h>
#import "EGODatabase.h"
#import "ASIHTTPRequest.h"
#import "DatabaseManager.h"
#import "CustomNavigationBar.h"
#import "MainViewController.h"

extern NSString *const SessionStateChangedNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate,ASIHTTPRequestDelegate>{
    ASIHTTPRequest* requestCategory;
    DatabaseManager* databaseSina;

}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) MainViewController* mainVC;



@end
