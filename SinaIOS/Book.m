//
//  Book.m
//  SinaIOS
//
//  Created by macos on 25/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Book.h"

@implementation Book

@synthesize idbook = _idbook, name = _name, category = _category, author = _author, publisher = _publisher, totalspan = _totalspan, totalchapter= _totalchapter, book_book_mark = _book_book_mark;

@synthesize linkImage;

-(id) initWithBookId:(NSInteger)idbook BookName:(NSString *)name BookAuthor: (NSString*)author BookPublisher:(NSString*)publisher BookCategory:(NSString*)category BookBookMark:(NSInteger)book_book_mark TotalSpan: (NSUInteger)totalspan TotalChapter:(NSInteger)totalchapter{
    
    if (self = [super init]) {
        self.idbook = idbook;
        self.name = name;
        self.author = author;
        self.category = category;
        self.publisher = publisher;
        self.totalchapter = totalchapter;
        self.totalspan = totalspan;
        self.book_book_mark = book_book_mark;
        
    }
    
    return self;
}
-(id)initWithBookInfor:(NSDictionary*)bookInfor BookMark:(NSInteger)bookmark{
    if (self = [super init]) {
        self.idbook = [[bookInfor objectForKey:KEY_IDBOOK] intValue];
        self.name = [bookInfor objectForKey:KEY_NAME];
        self.author = [bookInfor objectForKey:KEY_AUTHOR];
        self.category = [bookInfor objectForKey:KEY_CATEGORY];
        self.publisher = [bookInfor objectForKey:KEY_PUBLISHER];
        self.totalchapter = [(NSArray*)[bookInfor objectForKey:KEY_CHAPTER] count];
        self.totalspan = [[bookInfor objectForKey:KEY_TOTALSPAN] intValue];
        self.book_book_mark = bookmark;
    
    }
    return self;
    
}

@end
