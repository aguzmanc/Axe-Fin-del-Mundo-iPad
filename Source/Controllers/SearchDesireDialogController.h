#import <UIKit/UIKit.h>
#import	<QuartzCore/QuartzCore.h>

#import "Logic.h"
#import "DesireCell.h"

@protocol SearchDesireDialogDelegate;

@interface SearchDesireDialogController : UIViewController <SearchViewDelegate, UITextFieldDelegate, UITableViewDataSource>
{
	Logic * _logic;
	NSArray * _foundDesires;
	NSMutableDictionary * _cellCache;
	
	IBOutlet UIView * _alertView;
	IBOutlet UILabel * _lblTitle;
	IBOutlet UITextField * _txfSearch;
	IBOutlet UITableView * _tableResults;
	IBOutlet UIButton * _btnClose;
	
	id<SearchDesireDialogDelegate> _delegate;
}

// Properties
@property (nonatomic, retain) id<SearchDesireDialogDelegate> delegate;

// Initialization
-(id)initWithLogic:(Logic *)logic;

// Actions
-(IBAction)textEdited;
-(IBAction)closeDialog;

// Public Methods
-(void)focusOnTextField;


@end






@protocol SearchDesireDialogDelegate

-(void)closeDesireDialog;

@end

