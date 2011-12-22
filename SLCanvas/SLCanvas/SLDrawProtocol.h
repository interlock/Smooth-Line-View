//
//  SLDrawProtocol.h
//  Smooth Line View
//
//  Created by James Sapara on 11-12-22.
//  Copyright (c) 2011. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SLDrawProtocol <NSObject>

@required
- (float) getConfidence:(NSArray*)points;
- (CGRect) drawingFrame:(NSArray*)points withinFrame:(CGRect)frame;
- (void) draw:(NSArray*)pointsArray onImageView:(UIImageView*)imageView;

@end

