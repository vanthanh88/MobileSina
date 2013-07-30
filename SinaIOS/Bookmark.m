//
//  Bookmark.m
//  sinaIos
//
//  Created by macos on 24/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Bookmark.h"

@implementation Bookmark

@synthesize bookmark_book_id = _bookmark_book_id, bookmark_content = _bookmark_content, bookmark_id_user = _bookmark_id_user, bookmark_location = _bookmark_location;


-(id) initBookmarkWithBookid:(NSInteger)bookId Content:(NSString*)content IdUser:(NSInteger)iduser Location:(NSUInteger)location{
    if(self = [super init]){
        self.bookmark_book_id = bookId;
        self.bookmark_content = content;
        self.bookmark_id_user = iduser;
        self.bookmark_location = location;
    }
    
    return self;
}
@end
