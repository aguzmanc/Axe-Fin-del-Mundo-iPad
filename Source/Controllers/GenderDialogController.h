#import <UIKit/UIKit.h>

@protocol GenderDialogDelegate;

@interface GenderDialogController : UIViewController 
{
	id<GenderDialogDelegate> _delegate;
}

// Properties
@property (nonatomic, retain) id<GenderDialogDelegate> delegate;

// Actions
-(IBAction)maleSelected;
-(IBAction)femaleSelected;

@end


@protocol GenderDialogDelegate

-(void)genderSelected:(NSString *)gender;

@end

