//
//  SLCanvas.m
//  Smooth Line View
//
//  Created by James Sapara on 11-12-22.
//  Copyright (c) 2011. All rights reserved.
//

#import "SLCanvas.h"
#import "SLDrawProtocol.h"


@implementation SLCanvas

@synthesize pointsArray, drawArray, traceColor, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pointsArray = [NSMutableArray array];
        self.drawArray = [NSArray array];
        mouseSwiped = NO;
        trace = YES;
        self.delegate = nil;
        [self setUserInteractionEnabled:YES];
        self.traceColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        captureThreshold = 5.0;
    }
    return self;
}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
    [self.pointsArray removeAllObjects];
	lastPoint = [touch locationInView:self];

    [self.pointsArray addObject:[NSValue valueWithCGPoint:lastPoint]];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
	mouseSwiped = YES;
	
	UITouch *touch = [touches anyObject];	
	CGPoint currentPoint = [touch locationInView:self];
    float distance = sqrtf(
                           powf(lastPoint.x - currentPoint.x, 2.0f) + 
                           powf(lastPoint.y - currentPoint.y, 2.0f)
                    );
    NSLog(@"Distance: %f", distance);
    if ( distance >= captureThreshold ) { // TODO refactor this code to be resued between touchMoved and touchesEnded
        if ( trace ) {
            UIGraphicsBeginImageContext(self.frame.size);
            [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            
            float lineWidth = 5.0;
            if ( [self.delegate respondsToSelector:@selector(drawingLineWidth:)] ) {
                lineWidth = [self.delegate drawingLineWidth:self];
            }
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWidth);
            
            CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [traceColor CGColor]);
            CGContextBeginPath(UIGraphicsGetCurrentContext());
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            self.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        lastPoint = currentPoint;
        
        [self.pointsArray addObject:[NSValue valueWithCGPoint:currentPoint]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if ( trace ) {
        UIGraphicsBeginImageContext(self.frame.size);
        [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        
        float lineWidth = 5.0;
        if ( [self.delegate respondsToSelector:@selector(drawingLineWidth:)] ) {
            lineWidth = [self.delegate drawingLineWidth:self];
        }
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWidth);
        
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [traceColor CGColor]);
        
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // determine best SLDrawProtocol
    id<SLDrawProtocol> bestDraw = nil;
    float bestDrawConfidence = -1.0f;
    for (id _drawer in self.drawArray) {
        if ( [[_drawer class] conformsToProtocol:@protocol(SLDrawProtocol)] ) {
            id<SLDrawProtocol> drawer = (id<SLDrawProtocol>)_drawer;
            float thisDrawerConfidence = [drawer getConfidence:self.pointsArray];
            // This loop will honour order in the array for equal confidences
            if ( thisDrawerConfidence > bestDrawConfidence ) {
                bestDrawConfidence = thisDrawerConfidence;
                bestDraw = drawer;
            }
        }
    }
    
    [bestDraw draw:self.pointsArray onCanvas:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
