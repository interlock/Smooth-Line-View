//
//  SLDrawBezier.m
//  Smooth Line View
//
//  Created by James Sapara on 11-12-22.
//  Copyright (c) 2011. All rights reserved.
//

#import "SLDrawBezier.h"
#include <math.h>
#include <stdio.h>
#import "SLCanvas.h"

@implementation SLDrawBezier

-(float)getConfidence:(NSArray *)points {
    float distance = 0;
    NSValue *lastPoint = nil;
    for(NSValue *v in points) {
        if ( lastPoint != nil ) {
            distance += sqrtf(powf([lastPoint CGPointValue].x - [v CGPointValue].x, 2.0f) + powf([lastPoint CGPointValue].y - [v CGPointValue].y, 2.0f));
        }
        lastPoint = v;
    }
    int count = [points count];
    float avgDistance = distance / count;
    // TODO fold this code after we are done tweaking it
    float confidenceA = 0.2f * ((5.0 - fminf(avgDistance, 5.0)) / 5.0); // progressively more weight to average distances between points < 5
    float confidenceB = ( 0.8f * ( MIN(15,count) / 15)); // progressively more weight for sets with 15 or more points
    float confidence = (confidenceA + confidenceB);
    return confidence;
}

-(CGRect)drawingFrame:(NSArray *)points withinFrame:(CGRect)frame {
    return frame;
}

-(void)draw:(NSArray *)pointsArray onCanvas:(SLCanvas *)canvas {
    NSMutableArray *newPointsArray = [NSMutableArray arrayWithArray:pointsArray];
    // Pad pointsArray to finish off tail
    NSValue *lastPoint = [pointsArray lastObject];
    [newPointsArray addObject:lastPoint];
    [newPointsArray addObject:lastPoint];
    [newPointsArray addObject:lastPoint];
    [newPointsArray addObject:lastPoint];
    pointsArray = [NSArray arrayWithArray:newPointsArray];
    
    
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
    int curIndex = 0;
    CGFloat x0,y0,x1,y1,x2,y2,x3,y3;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path,NULL,[[pointsArray objectAtIndex:0] CGPointValue].x,[[pointsArray objectAtIndex:0] CGPointValue].y);
    
    for(NSValue *v in pointsArray){
        
        if(curIndex >= 4){
            for (int i=curIndex;i>=curIndex-4;i--) {
                int step = (curIndex-i);
                switch (step) {
                    case 0:
                        x3 = [(NSValue*)[pointsArray objectAtIndex:i-1] CGPointValue].x;
                        y3 = [(NSValue*)[pointsArray objectAtIndex:i-1] CGPointValue].y;	
                        break;
                    case 1:
                        x2 = [(NSValue*)[pointsArray objectAtIndex:i-1] CGPointValue].x;
                        y2 = [(NSValue*)[pointsArray objectAtIndex:i-1] CGPointValue].y;						
                        break;
                    case 2:
                        x1 = [(NSValue*)[pointsArray objectAtIndex:i-1] CGPointValue].x;
                        y1 = [(NSValue*)[pointsArray objectAtIndex:i-1] CGPointValue].y;						
                        break;
                    case 3:
                        x0 = [(NSValue*)[pointsArray objectAtIndex:i-1] CGPointValue].x;
                        y0 = [(NSValue*)[pointsArray objectAtIndex:i-1] CGPointValue].y;						
                        break;	
                    default:
                        break;
                }			
            }
            
            
            double smooth_value = 0.5;
            
            double xc1 = (x0 + x1) / 2.0;
            double yc1 = (y0 + y1) / 2.0;
            double xc2 = (x1 + x2) / 2.0;
            double yc2 = (y1 + y2) / 2.0;
            double xc3 = (x2 + x3) / 2.0;
            double yc3 = (y2 + y3) / 2.0;
            
            double len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
            double len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
            double len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
            
            double k1 = len1 / (len1 + len2);
            double k2 = len2 / (len2 + len3);
            
            double xm1 = xc1 + (xc2 - xc1) * k1;
            double ym1 = yc1 + (yc2 - yc1) * k1;
            
            double xm2 = xc2 + (xc3 - xc2) * k2;
            double ym2 = yc2 + (yc3 - yc2) * k2;
            
            // Resulting control points. Here smooth_value is mentioned
            // above coefficient K whose value should be in range [0...1].
            double ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
            double ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
            
            double ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
            double ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;	
            
            CGPathMoveToPoint(path,NULL,x1,y1);
            CGPathAddCurveToPoint(path,NULL,ctrl1_x,ctrl1_y,ctrl2_x,ctrl2_y, x2,y2);
            CGPathAddLineToPoint(path,NULL,x2,y2);
        }
        curIndex++;
    }
	CGContextAddPath(UIGraphicsGetCurrentContext(), path);
    CGPathRelease(path);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
	CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(),YES);
    canvas.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
