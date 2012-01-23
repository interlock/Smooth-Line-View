//
//  SLCanvas.m
//  Smooth Line View
//
//  Created by James Sapara on 11-12-22.
//  Copyright (c) 2011. All rights reserved.
//

#import "SLCanvas.h"
#import "SLCanvasTrace.h"

@interface SLCanvas()  {
@private
    
}
-(id<SLDrawProtocol>)getBestSLDraw:(NSMutableArray*)points;
-(void)_clear;

@end

@implementation SLCanvas

@synthesize pointsArray, allPointsArray = _allPointsArray, drawArray, traceColor, delegate = _delegate, undoManager, undoArray, enabled = _enabled, traceImageView = _traceImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pointsArray = [NSMutableArray array];
        self.allPointsArray = [NSMutableArray array];
        self.drawArray = [NSArray array];
        mouseSwiped = NO;
        _enabled = YES;
        self.delegate = nil;
        [self setUserInteractionEnabled:YES];
        
        trace = YES;
        self.traceColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        self.traceImageView = [[[SLCanvasTrace alloc] initWithFrame:self.frame] autorelease];
        self.traceImageView.canvas = self;
        [self addSubview:self.traceImageView];
        captureThreshold = 5.0;
        
        self.undoManager = [[[NSUndoManager alloc] init] autorelease];
        [self.undoManager setLevelsOfUndo:10];
        NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
        [dnc addObserver:self selector:@selector(undoManagerDidUndo:) name:NSUndoManagerDidUndoChangeNotification object:undoManager];
        [dnc addObserver:self selector:@selector(undoManagerDidRedo:) name:NSUndoManagerDidRedoChangeNotification object:undoManager];
    }
    return self;
}

-(void)setDelegate:(id<SLCanvasProtocol>)delegate {
    if ( _delegate != nil ) {
        [_delegate release];
    }
    _delegate = delegate;
    [_delegate retain];
    self.traceImageView.delegate = delegate;
    
}

-(void)dealloc {
    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];

    [dnc removeObserver:self];
    
    [super dealloc];
}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (!_enabled) return;
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
    [self.pointsArray removeAllObjects];
	lastPoint = [touch locationInView:self];

    [self.pointsArray addObject:[NSValue valueWithCGPoint:lastPoint]];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (!_enabled) return;
	mouseSwiped = YES;
	
	UITouch *touch = [touches anyObject];	
	CGPoint currentPoint = [touch locationInView:self];
    float distance = sqrtf(
                           powf(lastPoint.x - currentPoint.x, 2.0f) + 
                           powf(lastPoint.y - currentPoint.y, 2.0f)
                    );
    if ( distance >= captureThreshold ) { // TODO refactor this code to be resued between touchMoved and touchesEnded
        if ( trace ) {
            [self.traceImageView drawLine:lastPoint to:currentPoint];
        }
        
        lastPoint = currentPoint;
        
        [self.pointsArray addObject:[NSValue valueWithCGPoint:currentPoint]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (!_enabled) return;
    if ( trace ) {
        [self.traceImageView drawLine:lastPoint to:lastPoint];
    }
    
    [self.allPointsArray addObject:[[self.pointsArray copy]autorelease]];
    [[self.undoManager prepareWithInvocationTarget:self] undoManagerOp:[self.allPointsArray lastObject]];
    [[self getBestSLDraw:[self.allPointsArray lastObject]] draw:[self.allPointsArray lastObject] onCanvas: self];
    self.traceImageView.image = nil;
}

-(void)clear {
    [self _clear];
    [self.undoManager removeAllActions];
}

-(void)_clear {
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextClearRect(UIGraphicsGetCurrentContext(), self.frame);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); 
}

-(void)redraw {
    [self _clear];
    for(NSMutableArray *points in self.allPointsArray ) {
        [[self getBestSLDraw:points] draw:points onCanvas: self];
    }
}


#pragma mark - Private

-(id<SLDrawProtocol>)getBestSLDraw:(NSMutableArray*)points {
    id<SLDrawProtocol> bestDraw = nil;
    float bestDrawConfidence = -1.0f;
    for (id _drawer in self.drawArray) {
        if ( [[_drawer class] conformsToProtocol:@protocol(SLDrawProtocol)] ) {
            id<SLDrawProtocol> drawer = (id<SLDrawProtocol>)_drawer;
            float thisDrawerConfidence = [drawer getConfidence:points];
            // This loop will honour order in the array for equal confidences
            if ( thisDrawerConfidence > bestDrawConfidence ) {
                bestDrawConfidence = thisDrawerConfidence;
                bestDraw = drawer;
            }
        }
    }
    return bestDraw;
}

#pragma mark - NSUndoManager 
-(void)undoManagerOp:(NSMutableArray*)points {
    NSLog(@"Undo ### OP ###");
    self.undoArray = points;
    [[self.undoManager prepareWithInvocationTarget:self] undoManagerOp:points];
}


-(void)undoManagerDidUndo:(NSUndoManager*)undoManager {
    NSLog(@"Undo");
    [self.allPointsArray removeObject:self.undoArray];
    [self _clear];
    for(NSMutableArray *points in self.allPointsArray ) {
        [[self getBestSLDraw:points] draw:points onCanvas: self];
    }
}

-(void)undoManagerDidRedo:(NSUndoManager*)undoManager {
    NSLog(@"Redo");
    [self.allPointsArray addObject:self.undoArray];
    [self _clear];
    for(NSMutableArray *points in self.allPointsArray ) {
        [[self getBestSLDraw:points] draw:points onCanvas: self];
    }
}


@end
