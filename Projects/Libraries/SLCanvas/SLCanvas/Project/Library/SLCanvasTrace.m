//
//  SLCanvasTrace.m
//  SLCanvas
//
//  Created by James Sapara on 12-01-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SLCanvasTrace.h"
#import "SLCanvas.h"

@implementation SLCanvasTrace

@synthesize delegate, canvas;

-(void)drawLine:(CGPoint)pointA to:(CGPoint)pointB {
    UIGraphicsBeginImageContext(self.frame.size);
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
    float lineWidth = 5.0;
    if ( [self.delegate respondsToSelector:@selector(drawingLineWidth:)] ) {
        lineWidth = [self.delegate drawingLineWidth:self.canvas];
    }
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWidth);
    
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [self.canvas.traceColor CGColor]);
     CGContextBeginPath(UIGraphicsGetCurrentContext());
     CGContextMoveToPoint(UIGraphicsGetCurrentContext(), pointA.x, pointA.y);
     CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), pointB.x, pointB.y);
     CGContextStrokePath(UIGraphicsGetCurrentContext());
     self.image = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
}

@end
