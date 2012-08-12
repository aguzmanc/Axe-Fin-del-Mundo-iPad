#import <UIKit/UIKit.h>

#import "Desire.h"
#import "Logic.h"


@interface DesireCell : UITableViewCell 
{
	IBOutlet UIImageView * _photo;
	IBOutlet UIActivityIndicatorView * _indicator;
	IBOutlet UILabel * _lblUserName;
	IBOutlet UITextView * _textComment;
	
	NSString * _desireId;
	Desire * _desire;
	
	Logic * _logic;
}

// Actions
-(IBAction)shareClick;

// Public Methods
-(void)setUserImage:(UIImage *)img;
-(void)waitForPhoto;
-(void)applyData:(Desire *)desire;

@property (nonatomic, retain) Logic * logic;

@end
