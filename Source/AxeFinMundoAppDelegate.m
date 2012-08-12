//
//  AxeFinMundoAppDelegate.m
//  AxeFinMundo
//
//  Created by Giancarlo on 09/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AxeFinMundoAppDelegate.h"

@implementation AxeFinMundoAppDelegate

@synthesize window = _window;
@synthesize coverViewController = _coverViewController;
@synthesize registerViewController = _registerViewController;
@synthesize desiresViewController = _desiresViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{ 
	// Create Logic
	_logic = [[Logic alloc] initWithMain:self 
								   cover:_coverViewController 
								 desires:_desiresViewController 
							 AndRegister:_registerViewController];
	
	// Let logic decide initial conditions
	[_logic makeInitialConditions];
	//[self.window addSubview:_coverViewController.view];
	[self.window makeKeyAndVisible];
	
	// Setup and play sound
	NSString *path = [[NSBundle mainBundle] pathForResource:@"fondo" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path isDirectory:NO];
	
	NSError * error;
	_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	[_audioPlayer prepareToPlay];
	[_audioPlayer play];
	
	return YES;
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	return [_logic handleOpenURL:url];
}



- (void)applicationWillResignActive:(UIApplication *)application 
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark MainViewDelegate

-(void)setLogic:(Logic *)logic
{
	_logic = logic;
}



-(void)switchToCover
{
	[self.window addSubview:_coverViewController.view];
	
	[self doTransitionWithBlock:^{
		if (_currentView != nil) 
			_currentView.hidden = YES;
		_coverViewController.view.hidden = NO;
	} 
			  andTransitionType:UIViewAnimationTransitionCurlDown];

	if(_currentView != nil)
		[_currentView removeFromSuperview];
		
	_currentView = _coverViewController.view;
	
	[_coverViewController stopWaiting];
}



-(void)switchToDesires
{	
	[self.window addSubview:_desiresViewController.view];
	
	[self doTransitionWithBlock:^{
		if (_currentView != nil) 
			_currentView.hidden = YES;
		_desiresViewController.view.hidden = NO;
	} 
			  andTransitionType:UIViewAnimationTransitionCurlUp];
	
	if(_currentView != nil)
		[_currentView removeFromSuperview];

	_currentView = _desiresViewController.view;
}



-(void)switchToRegister
{
	[self.window addSubview:_registerViewController.view];
	
	[self doTransitionWithBlock:^{
		if (_currentView != nil) 
			_currentView.hidden = YES;
		_registerViewController.view.hidden = NO;
	} 
			  andTransitionType:UIViewAnimationTransitionCurlUp];

	if(_currentView != nil)
	{
		[_currentView removeFromSuperview];
	}
	
	_currentView = _registerViewController.view;
	
	[_registerViewController stopWaiting];
}



-(void)doTransitionWithBlock:(id)block andTransitionType:(UIViewAnimationTransition)transition{
	[UIView transitionWithView:self.window
					  duration:2.0
					   options:transition 
					animations:block
					completion:nil];
	
	[UIView beginAnimations:@"Transition" context:nil];
	[UIView setAnimationTransition:transition forView:self.window cache:YES];
	[UIView setAnimationDuration:2.0];
	[UIView commitAnimations];
}




#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [_coverViewController release];
	[_registerViewController release];
	[_desiresViewController release];
    [_window release];
    [super dealloc];
}


@end
