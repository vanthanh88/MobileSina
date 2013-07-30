//
//  Category.h
//  SinaIos
//
//  Created by macos on 09/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject{
    NSInteger id_cat;
    NSString* name;
}

@property(nonatomic,assign) NSInteger id_cat;
@property(nonatomic, strong) NSString* name;


-(id)initWithId:(NSInteger)_id Name:(NSString*)_name;

@end
