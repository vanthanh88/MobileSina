//
//  GestureRecognizerForEbookView.m
//  sinaIos
//
//  Created by macos on 26/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GestureRecognizerForEbookView.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#define REQUIRED_TICKLES        2
#define MOVE_AMT_PER_TICKLE     25

@implementation GestureRecognizerForEbookView
@synthesize point, tapDelegate, lastDirection, tickleCount;

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {    
//    UITouch * touch = [touches anyObject];
//    self.point = [touch locationInView:self.view];
//    
//    [tapDelegate tapToPoint:self.point];
//    
//}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    // Make sure we've moved a minimum amount since curTickleStart
//    UITouch * touch = [touches anyObject];
//    CGPoint ticklePoint = [touch locationInView:self.view];
//    CGFloat moveAmt = ticklePoint.x - point.x;
//    Direction curDirection;
//    if (moveAmt < 0) {
//        curDirection = DirectionLeft;
//    } else {
//        curDirection = DirectionRight;
//    }
//    if (ABS(moveAmt) < MOVE_AMT_PER_TICKLE) return;
//    
//    // Make sure we've switched directions
//    if (self.lastDirection == DirectionUnknown ||
//        (self.lastDirection == DirectionLeft && curDirection == DirectionRight) ||
//        (self.lastDirection == DirectionRight && curDirection == DirectionLeft)) {
//        
//        // w00t we've got a tickle!
//        self.tickleCount++;
//        self.point = ticklePoint;
//        self.lastDirection = curDirection;     
//        
//        // Once we have the required number of tickles, switch the state to ended.
//        // As a result of doing this, the callback will be called.
//        if (self.state == UIGestureRecognizerStatePossible && self.tickleCount > REQUIRED_TICKLES) {
//            [self setState:UIGestureRecognizerStateEnded];
//        }
//    }
//    
//    NSLog(@"moveAmt %f - curDdrection %@", moveAmt, (self.lastDirection==1)?@"left":@"right");
//    if([self.tapDelegate respondsToSelector:@selector(directionChange:)])
//    [tapDelegate directionChange:self.lastDirection];
//    
//}

- (void)reset {  
    self.point = CGPointZero;
    self.lastDirection = DirectionUnknown;
    if (self.state == UIGestureRecognizerStatePossible) {
        [self setState:UIGestureRecognizerStateFailed]; 
    }

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self reset];
    UITouch * touch = [touches anyObject];
    self.point = [touch locationInView:self.view];
    
    [tapDelegate tapToPoint:self.point];
}

//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self reset];
//}

@end
