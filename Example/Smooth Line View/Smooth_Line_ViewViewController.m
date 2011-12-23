//
//  Smooth_Line_ViewViewController.m
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/10/11.
//  Copyright 2011 culturezoo. All rights reserved.
//

#import "Smooth_Line_ViewViewController.h"

#import "SLDrawBezier.h"
#import "SLDrawSpline.h"


@implementation Smooth_Line_ViewViewController 

@synthesize canvas;

#pragma mark - UI Actions
-(IBAction)clear:(id)sender
{
    self.canvas.image = nil;
}

#pragma mark - SLCanvasProtocol

-(UIColor*)drawingStrokeColor:(SLCanvas*)myCanvas {
    return [UIColor blackColor];
}

-(float)drawingLineWidth:(SLCanvas*)myCanvas {
    return 5.0f;
}

#pragma mark

- (void)viewDidLoad
{
    self.canvas = [[SLCanvas alloc] initWithFrame:self.view.bounds];
    self.canvas.delegate = self;
    self.canvas.drawArray = [NSArray arrayWithObjects:
                             [[SLDrawBezier alloc] init],
                             [[SLDrawSpline alloc] init],
                             nil];
    
    [self.view addSubview:self.canvas];
    [super viewDidLoad];
}

@end


