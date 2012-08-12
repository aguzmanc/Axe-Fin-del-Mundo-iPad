#import "GenderDialogController.h"


@implementation GenderDialogController

@synthesize delegate = _delegate;

-(void)viewDidLoad
{
	self.modalInPopover = YES;
}



-(IBAction)maleSelected
{
	[_delegate genderSelected:@"male"];
}



-(IBAction)femaleSelected
{
	[_delegate genderSelected:@"female"];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}



- (void)viewDidUnload {
    [super viewDidUnload];
}



- (void)dealloc {
    [super dealloc];
}


@end
