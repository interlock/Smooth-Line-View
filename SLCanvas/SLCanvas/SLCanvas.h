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
    BOOL mouseSwiped;
    CGPoint lastPoint;
}

@property (nonatomic,retain) NSMutableArray *pointsArray;
@property (nonatomic,retain) NSArray *drawArray;

@end
