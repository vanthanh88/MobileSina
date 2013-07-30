//
//  ConfigBook.m
//  SinaIOS
//
//  Created by macos on 25/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfigBook.h"

@implementation ConfigBook

@synthesize idUser = _idUser, idbook= _idbook, font =_font, align=_align, padding_left=_padding_left, padding_right = _padding_right, padding_top=_padding_top, padding_bottom = _padding_bottom, size=_size ,textcolor = _textcolor,backgroundcolor= _backgroundcolor,config_chapter_id = _config_chapter_id, locationreading = _locationreading;


-(id)initConfigBookWithIdUser:(NSInteger)idUser IdBook:(NSInteger)idbook Font:(NSString*)font Size:(NSInteger)size Align:(NSString*)align PaddingLeft:(NSInteger)padding_left PaddingRight:(NSInteger)padding_right PaddingTop:(NSInteger)padding_top PaddingBottom:(NSInteger)padding_bottom BackgroundColor: (NSString*) backgroundcolor TextColor:(NSString*)textcolor ConfigChapterId:(NSInteger)confChapterid LocationReading:(NSUInteger)locationreading{
    
    if(self = [super init]){
        self.idUser = idUser;
        self.idbook = idbook;
        self.font = font;
        self.size = size;
        self.align = align;
        self.padding_left = padding_left;
        self.padding_right = padding_right;
        self.padding_top = padding_top;
        self.padding_bottom = padding_bottom;
        self.backgroundcolor = backgroundcolor;
        self.textcolor = textcolor;
        self.config_chapter_id = confChapterid;
        self.locationreading = locationreading;
        
    }
    
    return self;
}

@end
