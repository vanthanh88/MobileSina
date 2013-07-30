//
//  DatabaseManager.h
//  SinaIos
//
//  Created by macos on 09/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGODatabase.h"
#import "Category.h"
#import "ChapterData.h"
#import "Book.h"
#import "ConfigBook.h"
#import "Bookmark.h"
#import "User.h"

@interface DatabaseManager : NSObject{
    
    EGODatabase* sharedDatabase;
    NSString* dbPath;
}

@property (nonatomic, copy) NSString    *dbPath;
@property(nonatomic, retain) EGODatabase* sharedDatabase;

-(id)initWithDatabasePath:(NSString*)dataPath;

+ (DatabaseManager *)shareInstance;

-(void) closeDatabase;
-(EGODatabaseResult *)exeQueryGetTable:(NSString *)query;
-(NSMutableArray*) exeQueryGetTable:(NSString*)query ObjectInstance:(id)obj;
-(NSInteger) exeQueryGetInt:(NSString*) query;
-(NSString*) exeQueryGetString: (NSString*) query;
-(void) exeQueryNoneResult:(NSString*)query;
-(NSInteger) exeQueryGetCountInt:(NSString*) query;


@end
