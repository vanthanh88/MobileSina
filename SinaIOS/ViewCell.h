//
//  ViewCellList.h
//  SinaIOS
//
//  Created by macos on 21/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AQGridViewCell.h"
#import "MNMProgressBar.h"

@interface ViewCell : AQGridViewCell
{
    UIImageView * _imageView;
    UIImageView* _imgStatus;
    MNMProgressBar* _progressView;
    
    UILabel*      _titleBook;
    UILabel*      _authorBook;
    BOOKSTATUS _statusBook;
    
    
}
@property (nonatomic, retain) UIImageView * imageView;
@property (nonatomic, retain) UIImageView* imgStatus;
@property (nonatomic, retain) MNMProgressBar* progressView;
@property (nonatomic, retain) NSString* titleBook;
@property (nonatomic, retain) NSString* authorBook;

@property (nonatomic, assign) BOOKSTATUS statusBook;

@property(nonatomic, assign) BOOL gridActive;

@end
