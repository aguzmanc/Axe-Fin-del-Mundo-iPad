#import <UIKit/UIKit.h>

@protocol BirthDialogDelegate;

@interface BirthDialogController : UIViewController {
	id<BirthDialogDelegate> _delegate;
	
	IBOutlet UIDatePicker * _picker;
}

// Properties
@property (nonatomic, retain) id<BirthDialogDelegate> delegate;

// Actions
-(IBAction)selectDate;

@end


@protocol BirthDialogDelegate

-(void)birthSelected:(NSDate *)birthDate;

@end

