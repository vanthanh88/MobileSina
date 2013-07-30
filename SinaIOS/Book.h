//
//  Book.h
//  SinaIOS
//
//  Created by macos on 25/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject{
    
    NSInteger _idbook;
    NSString* _name;
    
    NSString* _author;
    NSString* _publisher;
    NSString* _category;
    NSInteger _book_book_mark;
    NSUInteger _totalspan;
    NSInteger _totalchapter;
    
    

}

@property(nonatomic, assign) NSInteger idbook;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSString* author;
@property(nonatomic, strong) NSString* publisher;
@property(nonatomic, strong) NSString* category;
@property(nonatomic, assign) NSInteger book_book_mark;
@property(nonatomic, assign) NSUInteger totalspan;
@property(nonatomic, assign) NSInteger totalchapter;
@property (nonatomic, strong) NSString* linkImage;

-(id) initWithBookId:(NSInteger)idbook BookName:(NSString *)name BookAuthor: (NSString*)author BookPublisher:(NSString*)publisher BookCategory:(NSString*)category BookBookMark:(NSInteger)book_book_mark TotalSpan: (NSUInteger)totalspan TotalChapter:(NSInteger)totalchapter;

-(id)initWithBookInfor:(NSDictionary*)bookInfor BookMark:(NSInteger)bookmark;

@end
