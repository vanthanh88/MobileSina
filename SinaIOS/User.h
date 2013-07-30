//
//  User.h
//  sinaIos
//
//  Created by macos on 24/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject{
    
    NSInteger  _idUser;
    NSInteger  _idBook;
    NSString * _linkImageBook;
}


@property (nonatomic, assign) NSInteger idUser;

@property (nonatomic, assign) NSInteger idBook;
@property (nonatomic, strong) NSString * linkImageBook;

-(id) initUserWithIdUser: (NSInteger) idUser IdBook:(NSInteger)idBook linkImageBook:(NSString*)image;

@end
