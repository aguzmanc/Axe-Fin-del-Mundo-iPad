
#import "LikeDialogController.h"


@implementation LikeDialogController

@synthesize delegate = _delegate;

#pragma mark Actions

-(IBAction)okAtLike 
{
	[_delegate atLike];
}



-(void)viewDidLoad
{
	//_likeButton = [[FBLikeButton alloc] initWithFrame:CGRectMake(0, 130, 320, 75) andUrl:AXE_APP_URL];
	
	//[self.view addSubview:_likeButton];
	//[self.view sendSubviewToBack:_likeButton];
	self.modalInPopover = YES;
	
	
}



-(void)generateLikeContent
{
	if (_likeButton != nil) {
		[_likeButton removeFromSuperview];
		[_likeButton release];
	}
	
	_likeButton = [[FBLikeButton alloc] initWithFrame:CGRectMake(0, 130, 320, 75) andUrl:AXE_APP_URL];
	[self.view addSubview:_likeButton];
}



- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}



- (void)viewDidUnload {
	if (_likeButton != nil)	[_likeButton release];
	
    [super viewDidUnload];
}



- (void)dealloc {
    [super dealloc];
}


@end
