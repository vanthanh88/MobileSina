//
//  DatabaseManager.m
//  SinaIos
//
//  Created by macos on 09/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatabaseManager.h"



static  DatabaseManager   *_this = nil;

@implementation DatabaseManager

@synthesize sharedDatabase,dbPath;


+(DatabaseManager *)shareInstance{
    
    if (!_this)
    {
        _this = [[DatabaseManager alloc] init];
    }
    return _this;
}
- (id) init{
    
    self = [super init];
    if (self)
    {
        self.dbPath = [Utils databasePath];
        sharedDatabase = [EGODatabase databaseWithPath:self.dbPath];
    }
    
    _this = self;
    return _this;
}

-(id)initWithDatabasePath:(NSString*)dataPath{
    
    if (self = [super init]) {
        sharedDatabase = [EGODatabase databaseWithPath:dataPath];
    }
    
    return self;
}
-(EGODatabaseResult *)exeQueryGetTable:(NSString *)query{
    EGODatabaseResult* result = [sharedDatabase executeQuery:query];
    
    return result;

}

-(NSMutableArray*) exeQueryGetTable:(NSString*)query ObjectInstance:(id)obj{
    
    EGODatabaseResult* result = [sharedDatabase executeQuery:query];
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    if ([obj isKindOfClass:[Category class]]) {
        Category * catAll = [[Category alloc] initWithId:0 Name:@"Tất cả"];
        [array addObject:catAll];
        for(EGODatabaseRow* row in result){
            Category * cat = [[Category alloc] initWithId:[row intForColumnIndex:0] Name:[row stringForColumnIndex:1]];
            [array addObject:cat];
        
        }
    }else if([obj isKindOfClass:[Book class]]){
        for(EGODatabaseRow * row in result){
            Book * b = [[Book alloc] initWithBookId:[row intForColumnIndex:0] BookName:[row stringForColumnIndex:1] BookAuthor: [row stringForColumnIndex:2] BookPublisher:[row stringForColumnIndex:3] BookCategory:[row stringForColumnIndex:4] BookBookMark:[row intForColumnIndex:5] TotalSpan:[row intForColumnIndex:6] TotalChapter:[row intForColumnIndex:7]];
//            NSLog(@"[Book class]");
            [array addObject:b];
        }
    }else if([obj isKindOfClass:[ChapterData class]]){
        for(EGODatabaseRow * row in result){
            ChapterData * ch = [[ChapterData alloc] initChapterWithBookId:[row intForColumnIndex:0] ChapterOrder:[row intForColumnIndex:1] ChapterName:[row stringForColumnIndex:2] TotalSpan:[row intForColumnIndex:3]];
            [array addObject:ch];
        }
        
    }else if([obj isKindOfClass:[ConfigBook class]]){
        for(EGODatabaseRow * row in result){
            ConfigBook * cb = [[ConfigBook alloc] initConfigBookWithIdUser:[row intForColumnIndex:0] IdBook:[row intForColumnIndex:1] Font:[row stringForColumnIndex:2] Size:[row intForColumnIndex:3] Align:[row stringForColumnIndex:4] PaddingLeft:[row intForColumnIndex:5] PaddingRight:[row intForColumnIndex:6] PaddingTop:[row intForColumnIndex:7] PaddingBottom:[row intForColumnIndex:8] BackgroundColor:[row stringForColumnIndex:9] TextColor:[row stringForColumnIndex:10] ConfigChapterId:[row intForColumnIndex:11] LocationReading:[row intForColumnIndex:12]];
            
            [array addObject:cb];
        }
    }else if([obj isKindOfClass:[Bookmark class]]){
        for(EGODatabaseRow * row in result){
            Bookmark * bm = [[Bookmark alloc] initBookmarkWithBookid:[row intForColumnIndex:0] Content:[row stringForColumnIndex:1] IdUser:[row intForColumnIndex:2] Location:[row intForColumnIndex:3]];
            [array addObject:bm];
        }
    }else if([obj isKindOfClass:[User class]]){
        for(EGODatabaseRow * row in result){
            User * user = [[User alloc] initUserWithIdUser:[row intForColumnIndex:0] IdBook:[row intForColumnIndex:1] linkImageBook:[row stringForColumnIndex:2]];
            [array addObject:user];
        }
    }
    
    
    return array;
    
}
-(void) closeDatabase{
    if (sharedDatabase != nil) {
        [sharedDatabase close];
    }
}
-(NSInteger) exeQueryGetInt:(NSString*) query{
    EGODatabaseResult* result = [sharedDatabase executeQuery:query];
    return [[result rowAtIndex:0] intForColumnIndex:0];
}

-(NSInteger) exeQueryGetCountInt:(NSString*) query{
     EGODatabaseResult* result = [sharedDatabase executeQuery:query];
    return result.rows.count;
}
-(NSString*) exeQueryGetString: (NSString*) query{
    EGODatabaseResult* result = [sharedDatabase executeQuery:query];
    return [[result rowAtIndex:0] stringForColumnIndex:0];
}
-(void) exeQueryNoneResult:(NSString*)query{
    [sharedDatabase executeUpdate:query];
}



@end
