//
//  SLCanvas.h
//  Smooth Line View
//
//  Created by James Sapara on 11-12-22.
//  Copyright (c) 2011 culturezoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 SLCanvasProtocol
 
 */

@class SLCanvas;

@protocol SLCanvasProtocol <NSObject>

-(UIColor*)drawingStrokeColor:(SLCanvas*)canvas;
-(float)drawingLineWidth:(SLCanvas*)canvas;

@end

/**
 SLCanvas
 
 A modified UIImageView which handles touch events to draw based on provided SLDraw implementations
 */

@interface SLCanvas : UIImageView {
    @private
    BOOL mouseSwiped;
    BOOL trace;
    CGPoint lastPoint;
    id<SLCanvasProtocol> delegate;
}

/**
 Store touch event points tracked
 */
@property (nonatomic,retain) NSMutableArray *pointsArray;
/**
 Priority ordered array of instance which implement <SLDrawProtocol>
 */
@property (nonatomic,retain) NSArray *drawArray;

@property (nonatomic,retain) UIColor *traceColor;

@property (nonatomic,retain) id<SLCanvasProtocol> delegate;

@end
