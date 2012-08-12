
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>
#import "Logic.h"
#import "LikeDialogController.h"


@interface CoverViewController : UIViewController <CoverViewDelegate, LikeDialogDelegate> {

	Logic * _logic;
	
	IBOutlet UIActivityIndicatorView * _activityIndicator;
	IBOutlet UIButton * _btnWriters;
	UIPopoverController * _likePopover;
	LikeDialogController * _likeDialog;
}

// Actions
-(IBAction)closeClick;
-(IBAction)writeClick;

// Public Methods
-(void)stopWaiting;

@end
