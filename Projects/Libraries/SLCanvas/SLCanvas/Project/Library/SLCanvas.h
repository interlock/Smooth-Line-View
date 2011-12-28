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
    /**
     CGPoint distance required to capture the point.
     Smaller values offer more precision in exchange for more processing to render curves
     */
    float captureThreshold; 
    id<SLCanvasProtocol> delegate;
    
    // Undo Related
    NSUndoManager *undoManager;
}

/**
 Store current touch event points tracked
 */
@property (nonatomic,retain) NSMutableArray *pointsArray;

/**
 Store all points on canvas
 */
@property (nonatomic,retain) NSMutableArray *allPointsArray;

/**
 Priority ordered array of instance which implement <SLDrawProtocol>
 */
@property (nonatomic,retain) NSArray *drawArray;

@property (nonatomic,retain) UIColor *traceColor;

@property (nonatomic,retain) id<SLCanvasProtocol> delegate;

@property (nonatomic,retain) NSUndoManager *undoManager;

@property (nonatomic,retain) NSMutableArray *undoArray;// Array of NSPointers to do undo/redo operation with

-(void)undoManagerOp:(NSMutableArray*)points;
-(void)undoManagerDidUndo:(NSUndoManager*)undoManager;
-(void)undoManagerDidRedo:(NSUndoManager*)undoManager;

/**
 Clear the image and undoManager
 */
-(void)clear;

@end
