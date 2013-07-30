//
//  ChapterData.h
//  SinaIOS
//
//  Created by macos on 25/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Book.h"

@interface ChapterData : NSObject{
    
    NSInteger   _idbook;
    NSInteger  _order;
    NSString* _name;
    NSUInteger _totalspan;
}



@property (nonatomic, assign) NSInteger idbook;
@property(nonatomic, assign) NSInteger  order;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, assign) NSUInteger totalspan;


-(id)initChapterWithBookId: (NSInteger)idbook ChapterOrder:(NSInteger)order ChapterName: (NSString*)name TotalSpan:(NSUInteger)span;

@end
