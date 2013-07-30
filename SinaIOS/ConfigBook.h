//
//  ConfigBook.h
//  SinaIOS
//
//  Created by macos on 25/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ConfigBook : NSObject{
    
    
    
    NSInteger _idUser;
    NSInteger _idbook;
    NSString* _font;
    NSInteger _size;
    
    NSString* _align;
    
    NSInteger _padding_left;
    NSInteger _padding_right;
    NSInteger _padding_top;
    NSInteger _padding_bottom;
    
    NSString* _backgroundcolor;
    NSString* _textcolor;
    
    NSInteger _config_chapter_id;
    
    NSUInteger _locationreading;
}

@property (nonatomic, assign) NSInteger idUser;
@property(nonatomic, assign) NSInteger idbook;
@property(nonatomic, strong) NSString* font;
@property(nonatomic, assign) NSInteger size;

@property(nonatomic, strong) NSString* align;

@property(nonatomic, assign) NSInteger padding_left;
@property(nonatomic, assign) NSInteger padding_right;
@property(nonatomic, assign) NSInteger padding_top;
@property(nonatomic, assign) NSInteger padding_bottom;

@property(nonatomic, strong) NSString* backgroundcolor;
@property(nonatomic, strong) NSString* textcolor;

@property (nonatomic, assign) NSInteger config_chapter_id;

@property(nonatomic, assign) NSUInteger locationreading;


-(id)initConfigBookWithIdUser:(NSInteger)idUser IdBook:(NSInteger)idbook Font:(NSString*)font Size:(NSInteger)size Align:(NSString*)align PaddingLeft:(NSInteger)padding_left PaddingRight:(NSInteger)padding_right PaddingTop:(NSInteger)padding_top PaddingBottom:(NSInteger)padding_bottom BackgroundColor: (NSString*) backgroundcolor TextColor:(NSString*)textcolor ConfigChapterId:(NSInteger)confChapterid LocationReading:(NSUInteger)locationreading;

@end
