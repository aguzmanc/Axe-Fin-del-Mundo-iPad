#import "SearchDesireDialogController.h"


@implementation SearchDesireDialogController

#pragma mark Initialization

@synthesize delegate = _delegate;

-(id)initWithLogic:(Logic *)logic
{
	self = [super initWithNibName:@"SearchDesireDialog" bundle:nil];
	
	_logic = logic;
	_logic.searchDelegate = self;
	
	_cellCache = [[NSMutableDictionary alloc] init];
	
	return self;
}






#pragma mark Actions

-(IBAction)textEdited;
{
	_foundDesires = [_logic searchDesiresWithText:_txfSearch.text];
	[_tableResults reloadData];
}



-(IBAction)closeDialog
{
	[_delegate closeDesireDialog];
}






#pragma mark Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 100; // --- set height for rows of custom table view
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; //--- set default 1 number of section because only had one section's
}






#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (_foundDesires == nil) return 0;
	
	return [_foundDesires count];
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
	Desire * desire = (Desire *)[_foundDesires objectAtIndex:indexPath.row];
	
	NSString * identifier = desire.desireId;
	
	// Apply data to desire View
	[cell applyData:desire];
	// Assign logic to cell
	cell.logic = _logic;
	
	if ([[_cellCache allKeys] containsObject:identifier] == YES)
		[_cellCache removeObjectForKey:identifier];
	
	[_cellCache setObject:cell forKey:identifier];
	
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






#pragma mark SearchViewDelegate

-(void)updateImage:(UIImage *)image forIdentifier:(NSString *)identifier
{
	// updates cell with image
	if ([[_cellCache allKeys] containsObject:identifier] == YES){
		DesireCell * cell = (DesireCell *)[_cellCache objectForKey:identifier];
		[cell setUserImage:image];
	}
}






#pragma mark Public Methods

-(void)focusOnTextField
{
	[_txfSearch becomeFirstResponder];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation 
{
	return (orientation == UIInterfaceOrientationLandscapeLeft ||
			orientation == UIInterfaceOrientationLandscapeRight);
}



- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}



- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)dealloc
{
    [super dealloc];
}


@end
