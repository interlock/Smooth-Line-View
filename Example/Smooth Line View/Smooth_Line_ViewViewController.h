//
//  Smooth_Line_ViewViewController.h
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/10/11.
//  Copyright 2011 culturezoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLCanvas.h"


@interface Smooth_Line_ViewViewController : UIViewController <SLCanvasProtocol> {
    SLCanvas *canvas;
}
@property (nonatomic,retain) SLCanvas *canvas;
-(IBAction)clear:(id)sender;
@end
