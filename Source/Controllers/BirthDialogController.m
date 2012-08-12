#import "BirthDialogController.h"

@implementation BirthDialogController

@synthesize delegate = _delegate;

-(IBAction)selectDate
{
	[_delegate birthSelected:[_picker date]];
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
