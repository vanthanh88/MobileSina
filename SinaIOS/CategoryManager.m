//
//  CategoryManager.m
//  sinaIos
//
//  Created by macos on 20/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryManager.h"
#import "Category.h"

@implementation CategoryManager

@synthesize allCategory;

-(id)init{
    if (self = [super init]) {
        dataSina = [[DatabaseManager alloc] initWithDatabasePath:DATAPATH];
        
         allCategory = [dataSina exeQueryGetTable:@"select * from category order by name" ObjectInstance:[[Category alloc ] init]];
        
        currentCat = [[allCategory objectAtIndex:0] name];
    }
    
    return self;
}

-(void) setCurrentCategory:(NSString*)c{
    currentCat = c;
}

-(NSString*) currentCategory{
    return currentCat;
}

+(CategoryManager *) sharedCategory{
    static CategoryManager * categories = nil;
    if (categories == nil) {
        categories = [CategoryManager new];
    }
    
    return categories;
    
}



@end
