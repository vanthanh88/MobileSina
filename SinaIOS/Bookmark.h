//
//  Bookmark.h
//  sinaIos
//
//  Created by macos on 24/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bookmark : NSObject{
    NSInteger _bookmark_book_id;
    NSString * _bookmark_content;
    NSInteger _bookmark_id_user;
    NSUInteger _bookmark_location;
    
}

@property(nonatomic, assign) NSInteger bookmark_book_id;
@property(nonatomic, strong) NSString * bookmark_content;
@property(nonatomic, assign) NSInteger bookmark_id_user;
@property(nonatomic, assign) NSUInteger bookmark_location;


-(id) initBookmarkWithBookid:(NSInteger)bookId Content:(NSString*)content IdUser:(NSInteger)iduser Location:(NSUInteger)location;

@end
