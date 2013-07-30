//
//  ChapterData.m
//  SinaIOS
//
//  Created by macos on 25/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChapterData.h"


@implementation ChapterData

@synthesize name = _name, order = _order,idbook = _idbook, totalspan=_totalspan;

-(id)initChapterWithBookId: (NSInteger)idbook ChapterOrder:(NSInteger)order ChapterName: (NSString*)name TotalSpan:(NSUInteger)span{
    if(self = [super init]){
        self.idbook = idbook;
        self.name = name;
        self.order = order;
        self.totalspan= span; 
    }
    return self; 
}

@end
