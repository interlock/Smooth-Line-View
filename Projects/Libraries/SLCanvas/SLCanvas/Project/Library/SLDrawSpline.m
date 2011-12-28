//
//  SLDrawSpline.m
//  Smooth Line View
//
//  Created by James Sapara on 11-12-22.
//  Copyright (c) 2011. All rights reserved.
//

#import "SLDrawSpline.h"
#import "spline/CatmullRomSpline.h"
#include <math.h>
#include <stdio.h>

@interface SLDrawSpline () {
    float confidenceDistance;
}

@end

@implementation SLDrawSpline

-(id) init {
    if ( self = [super init] ) {
        confidenceDistance = 20.0f;
    }
    return self;
}

/**
 Weighted heavily towards drawing less than 15 points. 
 A small portion is weighted on average point distance.
 */
-(float)getConfidence:(NSArray *)points {
    float distance = 0;
    int count = [points count];
    NSValue *lastPoint = nil;
    for(NSValue *v in points) {
        if ( lastPoint != nil ) {
            distance += sqrtf(powf([lastPoint CGPointValue].x - [v CGPointValue].x, 2.0f) + powf([lastPoint CGPointValue].y - [v CGPointValue].y, 2.0f));
        }
        lastPoint = v;
    }

    float confidence = ( 0.8f * ((15 - MIN(15,count)) / 15) ) + // exceptionally good at low point curves
    (0.2f * (fmaxf(confidenceDistance,(distance/count)) / confidenceDistance)); // good at well spaced points as well
    return confidence;
    
}

-(CGRect)drawingFrame:(NSArray *)points withinFrame:(CGRect)frame {
    return frame;
}

-(void)draw:(NSArray *)pointsArray onCanvas:(SLCanvas *)canvas {
    UIGraphicsBeginImageContext(CGSizeMake(canvas.frame.size.width, canvas.frame.size.height));
    [canvas.image drawInRect:CGRectMake(0, 0, canvas.frame.size.width, canvas.frame.size.height)];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);

    float lineWidth = 8.0;
    if ( [canvas.delegate respondsToSelector:@selector(drawingLineWidth:)] ) {
        lineWidth = [canvas.delegate drawingLineWidth:canvas];
    }
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWidth);
    
    UIColor *strokeColor = [UIColor colorWithRed:0.557 green:0.0 blue:0.0 alpha:0.9];
    if ( [canvas.delegate respondsToSelector:@selector(drawingStrokeColor:)] ) {
        strokeColor = [canvas.delegate drawingStrokeColor:canvas];
    }
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [strokeColor CGColor]);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
	
    CGPoint firstPoint = [[pointsArray objectAtIndex:0] CGPointValue];
    CGPoint lastPoint;
    
    CatmullRomSpline *currentSpline = [CatmullRomSpline catmullRomSplineAtPoint:firstPoint];
    int i = 0;
    for(NSValue *v in pointsArray){
        if (i>0) {
            [currentSpline addPoint:[v CGPointValue]];
        }
        i++;
    }
    BOOL isFirst = YES;
    for (int i =0;i<[[currentSpline asPointArray] count];i++) {
		CGPoint currentPoint = [[[currentSpline asPointArray] objectAtIndex:i] CGPointValue];
		if(isFirst){
			lastPoint = [[[currentSpline asPointArray] objectAtIndex:0] CGPointValue];
		}else {
			lastPoint = [[[currentSpline asPointArray] objectAtIndex:i-1] CGPointValue];
		}
		//lastPoint.y += 50;
		//currentPoint.y += 50;
		
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
		isFirst = NO;
	}
	
    CGContextStrokePath(UIGraphicsGetCurrentContext());
	CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(),YES);
    canvas.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
