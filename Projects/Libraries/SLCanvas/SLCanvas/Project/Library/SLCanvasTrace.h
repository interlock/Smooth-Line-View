//
//  SLCanvasTrace.h
//  SLCanvas
//
//  Created by James Sapara on 12-01-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLCanvasProtocol.h"

@class SLCanvas;

@interface SLCanvasTrace : UIImageView

@property (nonatomic,retain) SLCanvas *canvas;
@property (nonatomic,retain) id<SLCanvasProtocol> delegate;

-(void)drawLine:(CGPoint)pointA to:(CGPoint)pointB;

@end
