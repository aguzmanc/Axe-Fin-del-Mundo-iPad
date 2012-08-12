    //
//  CoverViewController.m
//  AxeFinMundo
//
//  Created by Arnold Guzmán on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoverViewController.h"

@implementation CoverViewController


#pragma mark Initialization

- (void)viewDidLoad 
{
	_likeDialog = [[LikeDialogController alloc] initWithNibName:@"LikeDialog" bundle:nil];
	_likeDialog.delegate = self;
	
	_likePopover = [[UIPopoverController alloc] initWithContentViewController:_likeDialog];
	
    [super viewDidLoad];
}	






#pragma mark RegisterViewDelegate

-(void)setLogic:(Logic *)logic
{
	_logic = logic;
}



-(void)startWaiting
{
	[_activityIndicator startAnimating];
}






#pragma mark Actions

-(IBAction)closeClick
{
	[_logic exitAplication];
}



-(IBAction)writeClick
{
	[_logic openBook];
	[self startWaiting];
}






#pragma mark LikeDialogDelegate

-(void)atLike
{
	[_likePopover dismissPopoverAnimated:YES];
	[_logic checkIfUserIsFan];
}






#pragma mark Public Methods

-(void)stopWaiting
{
	[_activityIndicator stopAnimating];
}



-(void)offerFanPage
{
	[self stopWaiting];
	
	[_likeDialog generateLikeContent];
	
	[_likePopover setPopoverContentSize:CGSizeMake(320, 273) animated:NO];
	
	[_likePopover presentPopoverFromRect:_btnWriters.frame
								  inView:self.view
				permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
 		
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    // Overriden to allow any orientation.
	
	return (orientation == UIInterfaceOrientationLandscapeLeft || 
			orientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
