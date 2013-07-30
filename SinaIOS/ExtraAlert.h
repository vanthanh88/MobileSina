//
//  ExtraAlert.h
//  SinaIOS
//
//  Created by macos on 09/01/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//



@interface ExtraAlert : UIAlertView{
    
    NSString * _idBook;
    NSInteger _index;
}

@property (nonatomic, strong) NSString* idBook;
@property (nonatomic, assign) NSInteger index;

@end
