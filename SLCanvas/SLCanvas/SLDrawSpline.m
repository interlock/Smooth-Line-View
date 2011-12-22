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

@implementation SLDrawSpline

-(float)getConfidence:(NSArray *)points {
    if ( [points count] < 15 ) {
        return 1.0f;
    }
    return 0.5f;
}

-(CGRect)drawingFrame:(NSArray *)points withinFrame:(CGRect)frame {
    return frame;
}

-(void)draw:(NSArray *)pointsArray onImageView:(UIImageView *)imageView {
    NSLog(@"Drawing Spline");
    UIGraphicsBeginImageContext(CGSizeMake(imageView.frame.size.width, imageView.frame.size.height));
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 8.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.557, 0.0, 0.0, 0.9);
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
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
