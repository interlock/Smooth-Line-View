
#import "SLCanvasExampleApplicationDelegate.h"

@implementation SLCanvasExampleApplicationDelegate

@synthesize window;
@synthesize viewController;



#pragma mark <UIApplicationDelegate>

-(BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = self.viewController;
	self.window.userInteractionEnabled = TRUE;
	self.window.backgroundColor = [UIColor blackColor];
	self.window.contentMode = UIViewContentModeScaleToFill;
	self.window.autoresizesSubviews = TRUE;

	[self.window makeKeyAndVisible];

	return TRUE;
}

-(void) applicationDidEnterBackground:(UIApplication *)application {

}

-(void) applicationWillEnterForeground:(UIApplication *)application {
	
}

-(void) applicationWillResignActive:(UIApplication *)application {
	
}

-(void) applicationDidBecomeActive:(UIApplication *)application {
	
}

-(void) applicationWillTerminate:(UIApplication *)application {
	
}

-(BOOL) application:(UIApplication *)application openURL:(NSURL *)aURL sourceApplication:(NSString *)aSourceApplication annotation:(id)anAnnotation {
	return TRUE;
}


#pragma mark Memory

-(void) applicationDidReceiveMemoryWarning:(UIApplication *)application {
	
}

-(void) dealloc {
    self.window = nil;
	[super dealloc];
}

@end
