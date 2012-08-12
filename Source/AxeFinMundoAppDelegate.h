//
//  AxeFinMundoAppDelegate.h
//  AxeFinMundo
//
//  Created by Giancarlo on 09/10/11.
//  Copyright 2011 __MyCompanyName__ All rights reserved.
//

#import <UIKit/UIKit.h>
#import	<QuartzCore/QuartzCore.h>

#import "CoverViewController.h"
#import "RegisterViewController.h"
#import "DesiresViewController.h"
#import "Logic.h"


@interface AxeFinMundoAppDelegate : NSObject 
							<UIApplicationDelegate, MainViewDelegate>
{
    UIWindow * _window;
	
	CoverViewController * _coverViewController;
	RegisterViewController * _registerViewController;
	DesiresViewController * _desiresViewController;
	
	UIView * _currentView;  // Allows to remove a view before add another one.
	
	Logic * _logic;
	
	AVAudioPlayer * _audioPlayer;
}

@property (nonatomic, retain) IBOutlet UIWindow * window;
@property (nonatomic, retain) IBOutlet CoverViewController * coverViewController;
@property (nonatomic, retain) IBOutlet RegisterViewController * registerViewController;
@property (nonatomic, retain) IBOutlet DesiresViewController * desiresViewController;

-(void)doTransitionWithBlock:(id)block andTransitionType:(UIViewAnimationTransition)transition;

@end

