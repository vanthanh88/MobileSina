//
//  CategoryManager.h
//  sinaIos
//
//  Created by macos on 20/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseManager.h"

@interface CategoryManager : NSObject{
    
    NSMutableArray * allCategory;
    NSString * currentCat;
    DatabaseManager * dataSina;
}

@property (nonatomic, strong) NSMutableArray * allCategory;


-(void) setCurrentCategory:(NSString*)c;
-(NSString*) currentCategory;
+(CategoryManager *) sharedCategory;




@end
