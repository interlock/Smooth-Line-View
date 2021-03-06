Smooth line Canvas 
====================

The original goal of this project is to create a UIView that can generate smooth lines from touch input in a reasonably fast manner without moving to a more complex framework like OpenGL.

Having found that success, it has been converted to a UI Widget that can be implemented in to projects. A UIImageView was extened to SLCanvas, which has abstracted out some of the core drawing functionality. 

This view uses two methods of smoothing:

1. **Catmull Rom spline:** This seems to have the best results as far as curve smoothing. However it gets _really_ slow over a certain number of points. So I switch interpolation methods to the following for more complex curves…
2. **Bezier Interpolation:** This method is very fast and doesn't care how complex the path is. The view uses some math to calculate the control points. The results aren't as good as the Catmull Rom but _much_ faster and with more complex shapes the differences are hard to notice.


### Features

* Interface for providing your own line drawing renders in the CoreGraphics context
* Delegate for setting color and width
* Adjustable capture accuracy, so you can refine the canvas to your applications needs 
* Integrated NSUndoManager

### TODO

* Implement optimized frame drawing area for Bezier and Catmull
* Provide way to serialize whole canvas as points
* Provide easy way to export image of the canvas

### Examples

* ![alt text](https://github.com/levinunnink/Smooth-Line-View/blob/master/Examples/examples/1.png?raw=true "Drawing")
* ![alt text](https://github.com/levinunnink/Smooth-Line-View/blob/master/Examples/examples/3.png?raw=true "Writing")
