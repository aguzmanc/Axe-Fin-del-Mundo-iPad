#import "RegisterViewController.h"

@implementation RegisterViewController

@synthesize tfPhone = _tfPhone;
@synthesize scrollView;


//---size of keyboard--- 
CGRect keyboardBounds;
//---size of application screen--- 
CGRect applicationFrame;
//---original size of ScrollView--- 
CGSize scrollViewOriginalSize;



#pragma mark Initialization

- (void)viewDidLoad
{
	_genderDialog = [[GenderDialogController alloc] initWithNibName:@"GenderDialog" bundle:nil];
	_genderDialog.delegate = self;
	
	_birthDialog = [[BirthDialogController alloc] initWithNibName:@"BirthDialog" bundle:nil];
	_birthDialog.delegate = self;
	
	_genderPopover = [[UIPopoverController alloc] initWithContentViewController:_genderDialog];
	_birthPopover = [[UIPopoverController alloc] initWithContentViewController:_birthDialog];
	
	_gender = nil;
	_birthDate = nil;
	
	scrollViewOriginalSize = scrollView.contentSize;
    applicationFrame = [[UIScreen mainScreen] applicationFrame];
	[super viewDidLoad];	
}



- (void)moveScrollView:(UIView *) theView {  
	//---get the y-coord of the view---
    CGFloat viewCenterY = theView.center.y;  
	
	//---calculate how much free space is left---
    CGFloat freeSpaceHeight = applicationFrame.size.height - keyboardBounds.size.height;      
    
	CGFloat scrollAmount = viewCenterY - freeSpaceHeight / 2.0;  
	
    if (scrollAmount < 0)  scrollAmount = 0;  
   	
	//---set the new scrollView contentSize---
    scrollView.contentSize = CGSizeMake(
										applicationFrame.size.width, 
										applicationFrame.size.height + keyboardBounds.size.height);  
	
	//---scroll the ScrollView---
    [scrollView setContentOffset:CGPointMake(0, scrollAmount) animated:YES];  
}



//---when a TextField view begins editing---
-  (void)textFieldDidBeginEditing:(UITextField *)textFieldView {  
    [self moveScrollView:textFieldView];
}  



//---when a TextField view is done editing---
- (void)textFieldDidEndEditing:(UITextField *) textFieldView {  
	//[scrollView setContentOffset:CGPointMake(0, -(dis * 2.0)) animated:YES];  
	[UIView beginAnimations:@"back to original size" context:nil];
	scrollView.contentSize = scrollViewOriginalSize;
	[UIView commitAnimations];
	
}



//---when the keyboard appears---
- (void)keyboardWillShow:(NSNotification *) notification
{
	//---gets the size of the keyboard---
	NSDictionary *userInfo = [notification userInfo];  
	NSValue *keyboardValue = [userInfo objectForKey:UIKeyboardBoundsUserInfoKey];  
    [keyboardValue getValue:&keyboardBounds];  	
}



//---when the keyboard disappears---
- (void)keyboardWillHide:(NSNotification *) notification
{
	
}



-(void)viewWillAppear:(BOOL)animated
{	
	//---registers the notifications for keyboard---
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self 
	 selector:@selector(keyboardWillShow:) 
	 name:UIKeyboardWillShowNotification 
	 object:self.view.window]; 
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(keyboardWillHide:)
	 name:UIKeyboardWillHideNotification
	 object:nil];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] 
	 removeObserver:self 
	 name:UIKeyboardWillShowNotification 
	 object:nil];
	
	[[NSNotificationCenter defaultCenter] 
	 removeObserver:self 
	 name:UIKeyboardWillHideNotification 
	 object:nil];
}



- (BOOL)textFieldShouldReturn:(UITextField *) textFieldView {  
	if (textFieldView == _tfPhone){
		[_tfPhone resignFirstResponder];
	}
	if (textFieldView == _tfCity){
		[_tfCity resignFirstResponder];
	}
	return NO;
}



#pragma mark RegisterViewDelegate

-(void)setLogic:(Logic *)logic
{
	_logic = logic;
}



-(void)registerError:(NSString *)message
{
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ERROR AL REGISTRAR" message:message delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
	
	[alert show];
	[alert release];
	
	[self stopWaiting];
}






#pragma mark Actions

-(IBAction) doneEditing:(id) sender
{
  	[sender resignFirstResponder];
}



-(IBAction)sendClick
{
	if ([self validateFields] == YES){
		NSString * userName = _tfName.text;
		NSString * ci = _tfCI.text;
		NSString * phone = _tfPhone.text;
		NSString * city = _tfCity.text;
		
		[_logic registerUserName:userName CI:ci Phone:phone City:city Gender:_gender AndBirthDate:_birthDate];
		
		[_activityIndicator startAnimating];
	}
}



-(IBAction)closeClick
{
	[_logic makeInitialConditions];
}



-(IBAction)popupGender
{
	[_genderPopover setPopoverContentSize:CGSizeMake(170, 123) animated:NO];
	
	[_genderPopover presentPopoverFromRect:_btnGender.frame
									inView:self.view
				  permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
	
}



-(IBAction)popupBirth
{
	[_birthPopover setPopoverContentSize:CGSizeMake(320, 270) animated:NO];
	
	[_birthPopover presentPopoverFromRect:_btnBirth.frame
									inView:self.view
				  permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}





#pragma mark GenderDialogDelegate

-(void)genderSelected:(NSString *)gender
{
	[_genderPopover dismissPopoverAnimated:YES];
	
	if ([gender isEqualToString:@"male"]) 
		[_btnGender setTitle:@"HOMBRE" forState:UIControlStateNormal];
	else if ([gender isEqualToString:@"female"])
		[_btnGender setTitle:@"MUJER" forState:UIControlStateNormal];
	
	_gender = [gender retain];
}






#pragma mark BirthDialogDelegate

-(void)birthSelected:(NSDate *)birthDate
{
	NSArray * monthNumbers = [NSArray arrayWithObjects:@"01", @"02", @"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
	NSArray * monthNames = [NSArray arrayWithObjects:@"Enero",@"Febrero",@"Marzo",@"Abril",@"Mayo",@"Junio",@"Julio",@"Agosto",@"Septiembre",@"Octubre",@"Noviembre",@"Diciembre",nil];
	NSDictionary * months = [NSDictionary dictionaryWithObjects:monthNames forKeys:monthNumbers];	
	
	// Month 
	NSDateFormatter * format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MM"];
	
	NSString * key = [format stringFromDate:birthDate];
	NSString * monthName = [months objectForKey:key];
	
	// Day
	[format setDateFormat:@"dd"];
	NSString * day = [format stringFromDate:birthDate];
	
	// Year
	[format setDateFormat:@"yyyy"];
	NSString * year = [format stringFromDate:birthDate];
	
	NSString * completeDateStr = [NSString stringWithFormat:@"%@ de %@ de %@", day, monthName, year];
	
	[_btnBirth setTitle:completeDateStr forState:UIControlStateNormal];
	
	[_birthPopover dismissPopoverAnimated:YES];
	
	[format release];
	
	_birthDate = [birthDate retain];
}






#pragma mark Public Methods

-(void)stopWaiting
{
	[_activityIndicator stopAnimating];
}






#pragma mark Private Methods

-(BOOL)validateFields
{
	NSString * message = nil;
	
	NSString * name = _tfName.text;
	NSString * ci = _tfCI.text;
	NSString * phone = _tfPhone.text;	
	NSString * city = _tfCity.text;	
	
	if ([name length] == 0) 
		message = @"Nombre esta vacío";
	else if ([ci length] == 0) 
		message = @"CI esta vacío";
	else if([self isNumber:ci] == NO) 
		message = @"CI debe contenter solo números";	
	else if([phone length]==0) 
		message = @"Teléfono esta vacío";
	else if([self isNumber:phone] == NO) 
		message = @"Teléfono debe contener solo números"; 
	else if([city length] == 0) 
		message = @"Ciudad esta vacío";
	else if(_gender == nil){
		message = @"Debe seleccionar su género";
	}
	else if(_birthDate == nil){
		message = @"Debe seleccionar su fecha de nacimiento";
	}

	
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




-(BOOL)isNumber:(NSString *)numberText
{
	NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithRange:NSMakeRange('0',10)] invertedSet];
	NSString *trimmed = [numberText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	BOOL isNumeric = trimmed.length > 0 && [trimmed rangeOfCharacterFromSet:nonNumberSet].location == NSNotFound;
	return isNumeric;
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
	[scrollView release];
	[_tfPhone release];
	[_genderDialog release];
	
    [super dealloc];
}


@end
