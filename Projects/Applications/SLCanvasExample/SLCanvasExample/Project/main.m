
/*!
@file		main.m
@project	SLCanvasExample
@copyright	(c) 2011, __MyCompanyName__
@created	11-12-28 - James Sapara
*/

#import <UIKit/UIKit.h>

int 
main(int argc, char *argv[]) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, @"SLCanvasExampleApplicationDelegate");
	[pool release];
	return retVal;
}
