//
//  ViewCellList.m
//  SinaIOS
//
//  Created by macos on 21/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewCell.h"

#define HEIGHT_SIZE_FONT_SYSTEM_16  20.0

static NSString * Identifier = @"CellIdentifier";  //for grid
static NSString * Identifier1 = @"CellIdentifier1"; // for list

@implementation ViewCell

@synthesize gridActive;

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if (self == nil)
        return (nil);
    self.backgroundColor = [UIColor clearColor];
    _imageView = [[UIImageView alloc] initWithFrame: (aReuseIdentifier == Identifier1)?CGRectMake(5, 5, 80, 110):CGRectMake(5, 5, 90, 120)];
    //add layer
    _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _imageView.layer.shadowOffset = CGSizeMake(2, 3);
    _imageView.layer.shadowOpacity = 1;
    _imageView.layer.shadowRadius = 2.0;
    _imageView.layer.backgroundColor = [[UIColor grayColor] CGColor];
    
    [_imageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [_imageView.layer setBorderWidth: 1.4];
    
    
    _progressView = [[MNMProgressBar alloc] initWithFrame:CGRectMake(_imageView.center.x-35, _imageView.center.y+40, 70, 10)];

    _imgStatus = [[UIImageView alloc] initWithFrame:(aReuseIdentifier == Identifier1)?CGRectMake(55, 85, 30, 30):CGRectMake(65, 95, 30, 30)];
    _imgStatus.backgroundColor = [UIColor clearColor];


    _titleBook = [[UILabel alloc] initWithFrame:CGRectMake(95, 10, self.contentView.frame.size.width-95, 20)];
    _titleBook.backgroundColor= [UIColor clearColor];
    _titleBook.textColor = parserColor(0x118626);
    _titleBook.highlightedTextColor = [UIColor blueColor];
    _titleBook.font = [UIFont boldSystemFontOfSize: 16.0];
    _titleBook.lineBreakMode = UILineBreakModeWordWrap;
    _titleBook.numberOfLines = 0;

    _authorBook = [[UILabel alloc] initWithFrame:CGRectMake(95, 30, self.contentView.frame.size.width-95, 20)];
    _authorBook.backgroundColor= [UIColor clearColor];
    _authorBook.textColor = parserColor(0xa5a4a4);
    _authorBook.highlightedTextColor = [UIColor blueColor];
    _authorBook.font = [UIFont boldSystemFontOfSize: 14.0];
    _authorBook.numberOfLines = 0;
    _authorBook.autoresizingMask= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _authorBook.lineBreakMode = UILineBreakModeWordWrap;
    
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _progressView.progress = MNMProgressBarIndeterminateProgress;
    _imgStatus.hidden = YES;
    _progressView.hidden = YES;
    [self.contentView addSubview: _imageView];
    [self.contentView addSubview:_imgStatus];
    [self.contentView addSubview:_progressView];
    [self.contentView addSubview:_titleBook];
    [self.contentView addSubview:_authorBook];
    
    if (aReuseIdentifier == Identifier1) {
                
        _titleBook.hidden = NO;
        _authorBook.hidden= NO;
        
    }else{
        _titleBook.hidden = YES;
        _authorBook.hidden= YES;
  
    }

    return  (self);
}


- (UIImageView *) imageView
{
    return (_imageView);
}
- (void) setImageView:(UIImageView *)imageView
{
    _imageView = imageView;
//    [self setNeedsLayout];
}

-(UIImageView*) imgStatus{
    return _imgStatus;
}
-(void) setImgStatus:(UIImageView *)imgStatus{
    _imgStatus = imgStatus;
//    [self setNeedsLayout];
}

-(MNMProgressBar*) progressView{
    return _progressView;
}
-(void) setProgressView:(MNMProgressBar *)progressView{
    _progressView = progressView;
//    [self setNeedsLayout];
}


- (NSString *) titleBook
{
    return (_titleBook.text);
}

- (void) setTitleBook: (NSString *) titleBook
{
    _titleBook.text = titleBook;
    //CGFloat h = [titleBook sizeWithFont:_titleBook.font].height;
    CGSize textSize = [titleBook sizeWithFont:_titleBook.font constrainedToSize:CGSizeMake(self.contentView.frame.size.width-95, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    //NSLog(@"Name %@ labelSize %f",titleBook,textSize.height);
    if(textSize.height>HEIGHT_SIZE_FONT_SYSTEM_16*2){
        _titleBook.frame = CGRectMake(95, 10, self.contentView.frame.size.width-95, HEIGHT_SIZE_FONT_SYSTEM_16*3);
        _authorBook.frame = CGRectMake(95, 70, self.contentView.frame.size.width-95, 40);
        
    }
    else if (textSize.height>HEIGHT_SIZE_FONT_SYSTEM_16) {
        _titleBook.frame = CGRectMake(95, 10, self.contentView.frame.size.width-95, HEIGHT_SIZE_FONT_SYSTEM_16*2);
        _authorBook.frame = CGRectMake(95, 50, self.contentView.frame.size.width-95, 40);
       
    }else if(textSize.height==HEIGHT_SIZE_FONT_SYSTEM_16){
        _titleBook.frame = CGRectMake(95, 10, self.contentView.frame.size.width-95, HEIGHT_SIZE_FONT_SYSTEM_16);
        _authorBook.frame = CGRectMake(95, 30, self.contentView.frame.size.width-95, 40);
    }
    
    
//    [self setNeedsLayout];
}

- (NSString *) authorBook
{
    return (_authorBook.text);
}

- (void) setAuthorBook:(NSString *) authorBook
{
    _authorBook.text = authorBook;
//    [self setNeedsLayout];
   
}
-(BOOKSTATUS)statusBook{
    return _statusBook;
}
-(void) setStatusBook:(BOOKSTATUS)statusBook{
    
    switch (statusBook) {
        case BOOKSTATUS_QUEUED:{
            _progressView.hidden = NO;
        }break;
            
        case BOOKSTATUS_DOWLOADING:{
            _imgStatus.hidden = YES;
            _progressView.hidden = NO;
        }break;
        case BOOKSTATUS_DOWLOADED:{
            _imgStatus.hidden = YES;
        }break;
        case BOOKSTATUS_ONCLOUD:{
            _imgStatus.image = [UIImage imageNamed:@"download.png"];
            _imgStatus.hidden = NO;
            
        }break;
        case BOOKSTATUS_READING:{
            
        }break;
        default:
            break;
    }
    
    _statusBook = statusBook;
}



@end
