//
//  CellSearchWord.m
//  SinaIOS
//
//  Created by macos on 07/01/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CellSearchWord.h"

@implementation CellSearchWord


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _lbLocation = [[UILabel alloc] initWithFrame:CGRectMake(10, 28, self.frame.size.width, 16)];
        _lbLocation.backgroundColor = [UIColor clearColor];
        _lbLocation.font = [UIFont systemFontOfSize:12];
        _lbLocation.text = @"";
        [self addSubview:_lbLocation];
    }
    return self;
}

-(NSString *)lbLocation{
    return _lbLocation.text;
}
-(void) setLbLocation:(NSString *)lbLocation{
    _lbLocation.text = lbLocation;
//    [_lbLocation setNeedsDisplay];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
