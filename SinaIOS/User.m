//
//  User.m
//  sinaIos
//
//  Created by macos on 24/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize idUser = _idUser, idBook = _idBook, linkImageBook = _linkImageBook;

-(id) initUserWithIdUser: (NSInteger) idUser IdBook:(NSInteger)idBook linkImageBook:(NSString*)image{
    
    if(self = [super init]){
        self.idUser = idUser;
        self.idBook = idBook;
        self.linkImageBook = image;
    }
    
    return self;
}

@end
