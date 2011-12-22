//
//  SLCanvas.h
//  Smooth Line View
//
//  Created by James Sapara on 11-12-22.
//  Copyright (c) 2011 culturezoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 SLCanvas
 
 A modified UIImageView which handles touch events to draw based on provided SLDraw implementations
 */

@interface SLCanvas : UIImageView {
    @private
    BOOL mouseSwiped;
    CGPoint lastPoint;
}

/**
 Store touch event points tracked
 */
@property (nonatomic,retain) NSMutableArray *pointsArray;
/**
 Priority ordered array of instance which implement <SLDrawProtocol>
 */
@property (nonatomic,retain) NSArray *drawArray;

@end
