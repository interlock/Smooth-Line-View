
/*!
@project	___PACKAGENAMEASIDENTIFIER___
@header		SLCanvasExampleApplicationDelegate.h
@copyright	(c) ___YEAR___, ___ORGANIZATIONNAME___
@created	___DATE___ Ð ___FULLUSERNAME___
*/

#import <UIKit/UIKit.h>

/*!
@class SLCanvasExampleApplicationDelegate
@superclass NSObject <UIApplicationDelegate>
@abstract
@discussion
*/

@class Smooth_Line_ViewViewController;

@interface SLCanvasExampleApplicationDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Smooth_Line_ViewViewController *viewController;

@end
