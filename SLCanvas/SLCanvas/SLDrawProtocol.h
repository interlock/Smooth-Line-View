//
//  SLDrawProtocol.h
//  Smooth Line View
//
//  Created by James Sapara on 11-12-22.
//  Copyright (c) 2011. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 This Protocol is must be implemented by an Object that will draw on the canvas.
 */
@protocol SLDrawProtocol <NSObject>

@required

/**
 Return a 0.0 to 1.0 value indicating how well of a fit this drawing method will be for the points provided
 */
- (float) getConfidence:(NSArray*)points;

/**
 Return an optimized drawing frame based on the points and parent frame.
 Useful if you are under memory restraints
 */
- (CGRect) drawingFrame:(NSArray*)points withinFrame:(CGRect)frame;

/**
 Draw the points provided on to a UIImageView->UIImage
 */
- (void) draw:(NSArray*)pointsArray onImageView:(UIImageView*)imageView;

@end

