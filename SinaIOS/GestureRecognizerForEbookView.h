//
//  GestureRecognizerForEbookView.h
//  sinaIos
//
//  Created by macos on 26/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    DirectionUnknown = 0,
    DirectionLeft,
    DirectionRight
} Direction;

@protocol GestureRecognizerForEbookViewDelegate <NSObject>

-(void) tapToPoint:(CGPoint)point;
@optional
-(void) directionChange:(Direction)currentDirection;

@end

@interface GestureRecognizerForEbookView : UIGestureRecognizer{
    
    id<GestureRecognizerForEbookViewDelegate> tapDelegate;
}

@property (assign) CGPoint point;
@property (assign) Direction lastDirection;
@property (nonatomic, strong) id<GestureRecognizerForEbookViewDelegate> tapDelegate;
@property (assign) int tickleCount;

@end
