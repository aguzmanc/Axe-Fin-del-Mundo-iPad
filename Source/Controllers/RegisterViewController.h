#import <UIKit/UIKit.h>

#import "Logic.h"
#import "GenderDialogController.h"
#import "BirthDialogController.h"


@interface RegisterViewController : UIViewController <RegisterViewDelegate, UITextFieldDelegate, GenderDialogDelegate, BirthDialogDelegate> {
	
	IBOutlet UITextField * _tfName;
	IBOutlet UITextField * _tfCI;
	IBOutlet UITextField * _tfPhone;
	IBOutlet UITextField * _tfCity;
	IBOutlet UIActivityIndicatorView * _activityIndicator;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIButton * _btnGender;
	IBOutlet UIButton * _btnBirth;
	
	Logic * _logic;
	
	UIPopoverController * _genderPopover;
	UIPopoverController * _birthPopover;
	
	GenderDialogController * _genderDialog;
	BirthDialogController * _birthDialog;
	
	NSString * _gender;
	NSDate * _birthDate;
}
@property (nonatomic, retain) UITextField * tfPhone;
@property (nonatomic, retain) UIScrollView *scrollView;

//Actions of ViewController
-(IBAction) doneEditing:(id) sender;

//Actions of Register
-(IBAction)sendClick;
-(IBAction)closeClick;
-(IBAction)popupGender;
-(IBAction)popupBirth;

// Public Methods
-(void)stopWaiting;

// Private Methods
-(BOOL)isNumber:(NSString *)numberText;
-(BOOL)validateFields;

@end
