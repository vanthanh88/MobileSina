//
//  Category.m
//  SinaIos
//
//  Created by macos on 09/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Category.h"

@implementation Category
@synthesize id_cat, name;

-(id)initWithId:(NSInteger)_id Name:(NSString*)_name{
    if (self = [super init]) {
        id_cat = _id;
        name = _name;
    }
    return self;
}

@end
