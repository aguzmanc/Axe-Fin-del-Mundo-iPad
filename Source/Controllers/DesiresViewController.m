#import "DesiresViewController.h"
#import	<QuartzCore/QuartzCore.h>

@implementation DesiresViewController


#pragma mark DesiresViewDelegate

-(void)setLogic:(Logic *)logic
{
	_logic = logic;
}



-(void)sendError:(NSString *)message	
{
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ERROR AL ENVIAR EL DESEO" message:message delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
	
	[alert show];
	[alert release];
}



-(void)updateImage:(UIImage *)image forIdentifier:(NSString *)identifier
{
	// updates cell with image
	if ([[_pageCells allKeys] containsObject:identifier] == YES){
		DesireCell * cell = (DesireCell *)[_pageCells objectForKey:identifier];
		[cell setUserImage:image];
	}
}



-(void)updateUserImage:(UIImage *)image
{
	[_actUserImage stopAnimating];
	[_userImage setHidden:NO];
	[_userImage setImage:image];
}



-(void)refreshDesires
{
	[_activityIndicator stopAnimating];
	[_table setHidden:NO];
	[_table reloadData];
	
	[self refreshFooter];
}



-(void)refreshFooter
{
	_lblCurrentPage.text = [NSString stringWithFormat:@"%d", (_logic.currentPage + 1)];
	_lblTotalPages.text = [NSString stringWithFormat:@"%d", _logic.totalPages];
}



-(void)waitForList
{
	[_activityIndicator startAnimating];
	[_table setHidden:YES];
	
}



-(void)waitForUserImage
{
	[_actUserImage startAnimating];
	[_userImage setHidden:YES];
	
	[_logic obtainImageForLoggedUser];
}



-(void)desireSending
{
	//_tvDesire.editable = FALSE;
	_tvDesire.text = @"";
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Publicación exitosa!" 
													message:@"Tu deseo ha sido publicado. Gracias por participar! "
												   delegate:nil
										  cancelButtonTitle:@"Aceptar" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];		
}



-(NSString *)getDesireText
{
	return _tvDesire.text;
}






#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [_logic countDesiresInCurrentPage];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 	
	DesireCell * cell = (DesireCell *)[tableView dequeueReusableCellWithIdentifier:@"DesireCell"];
	
    if (cell == nil) {
		NSArray * objs = [[NSBundle mainBundle] loadNibNamed:@"DesireCell" owner:nil options:nil];
		
		for (id obj in objs) {
			if ([obj isKindOfClass:[DesireCell class]]) {
				cell = (DesireCell *)obj;
				break;
			}
		}
	}
	
	// link cell with according identifier
	Desire * desire = [_logic getDesireForIndex:indexPath.row];
	NSString * identifier = desire.desireId;
	
	// Apply data to desire View
	[cell applyData:desire];
	// Assign logic to cell
	cell.logic = _logic;
	
	if ([[_pageCells allKeys] containsObject:identifier] == YES)
		[_pageCells removeObjectForKey:identifier];

	[_pageCells setObject:cell forKey:identifier];
	
	// check if there is user image in the cache
	if ([_logic existsImageForIdentifier:identifier] == YES) {
		[cell setUserImage:[_logic getImageForIdentifier:identifier]];
	}
	else {
		[cell waitForPhoto];
		[_logic obtainImageForIdentifier:identifier];
	}
	
	return cell;	
}






#pragma mark Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 90; // --- set height for rows of custom table view
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; //--- set default 1 number of section because only had one section's
}






#pragma mark SearchDesireDialogDelegate

-(void)closeDesireDialog
{
	[_searchPopover dismissPopoverAnimated:YES];
}






#pragma mark Actions

-(IBAction)search
{	
	[_searchPopover setPopoverContentSize:CGSizeMake(469, 570) animated:NO];
	
	[_searchPopover presentPopoverFromRect:_btnSearch.frame
								   inView:self.view
				 permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
	
	[_searchDialog focusOnTextField];
}



-(IBAction)next
{

	
	if ([_logic canNextPage] == NO) 
		return;
	
	// conditions before animation
	_currentChangingPageType = CHANGE_PAGE_NEXT;
	_curlImage.hidden = NO;
	_curlImage.alpha = 0.0;
	
	CABasicAnimation * alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	
	alphaAnimation.duration = 0.5;
	alphaAnimation.fromValue = [NSNumber numberWithFloat:0.0];
	alphaAnimation.toValue = [NSNumber numberWithFloat:1.0];
	alphaAnimation.delegate = self;	
	alphaAnimation.removedOnCompletion = YES;
	[[_curlImage layer] addAnimation:alphaAnimation forKey:@"opacity"];
}



-(IBAction)previous
{
	if ([_logic canPreviousPage] == NO)
		return;
	
	// 
	_currentChangingPageType = CHANGE_PAGE_PREVIOUS;
	_curlImage.hidden = YES;
	_curlImage.alpha = 1.0;
	
	[UIView transitionWithView:_curlImage
					  duration:1.0
					   options:UIViewAnimationTransitionCurlDown 
					animations:^{ _curlImage.hidden = NO; }
					completion:nil];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(curlDownFinished:finished:context:)];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_curlImage cache:YES];
	[UIView setAnimationDuration:1.0];
	[UIView commitAnimations];
}



-(IBAction)publicDesire
{
     if ([self validateField] == YES)
	 {
		 [_tvDesire resignFirstResponder];
		 [_logic publicDesire:_tvDesire.text];
	 }
}



-(IBAction)close
{
   [_logic makeInitialConditions];
}



-(IBAction)baseConditions
{
	[_logic baseConditions];
}



-(BOOL)validateField
{
   NSString * message = nil;
   NSString * desire = _tvDesire.text;
	
   if ([desire length] == 0) 
		message = @"Tu deseo no puede estar vacio!!!";
   if (message != nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error de Validación" 
														message:message
													   delegate:self
											  cancelButtonTitle:@"Aceptar" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return NO;
	}
	
	return YES;
}


#pragma mark Initialization

-(void)viewDidLoad
{
	_pageCells = [[NSMutableDictionary alloc] init];
	
	_searchDialog = [[[SearchDesireDialogController alloc] initWithLogic:_logic] autorelease];
	_searchDialog.delegate = self;
	
	_searchPopover = [[UIPopoverController alloc] initWithContentViewController:_searchDialog];
}



-(void)curlDownFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
	[_logic previousPage];	
	[self refreshFooter];
	
	CABasicAnimation * alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];

	alphaAnimation.duration = 0.5;
	alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
	alphaAnimation.toValue = [NSNumber numberWithFloat:0.0];
	alphaAnimation.delegate = self;	
	alphaAnimation.removedOnCompletion = YES;
	[[_curlImage layer] addAnimation:alphaAnimation forKey:@"opacity"];
}



// Changing final state of image just after the animation begins
// avoids final "flicking" and does not alter animation itself
- (void)animationDidStart:(CAAnimation *)theAnimation 
{
	if(_currentChangingPageType == CHANGE_PAGE_PREVIOUS)
		[_curlImage setAlpha:0.0];
	else if (_currentChangingPageType == CHANGE_PAGE_NEXT){
		[_curlImage setAlpha:1.0];
		
		
	}
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	if (_currentChangingPageType == CHANGE_PAGE_NEXT) {
		[_logic nextPage];
		[self refreshFooter];

		
		// animation for curl up
		[UIView transitionWithView:_curlImage
						  duration:1.0
						   options:UIViewAnimationTransitionCurlUp
						animations:^{ _curlImage.hidden = YES; }
						completion:nil];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelegate:nil];
		//[UIView setAnimationDidStopSelector:@selector(curlDownFinished:finished:context:)];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:_curlImage cache:YES];
		[UIView setAnimationDuration:1.0];
		[UIView commitAnimations];		
	}
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation 
{
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
