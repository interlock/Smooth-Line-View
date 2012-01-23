//
//  SLCanvasProtocol.h
//  SLCanvas
//
//  Created by James Sapara on 12-01-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 SLCanvasProtocol
 
 */

@class SLCanvas;

@protocol SLCanvasProtocol <NSObject>

-(UIColor*)drawingStrokeColor:(SLCanvas*)canvas;
-(float)drawingLineWidth:(SLCanvas*)canvas;

@end
