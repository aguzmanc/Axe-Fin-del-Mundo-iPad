#import <UIKit/UIKit.h>

#import "Logic.h"
#import "DesireCell.h"
#import "SearchDesireDialogController.h"

// private constants for this view only
#define CHANGE_PAGE_NEXT 0
#define CHANGE_PAGE_PREVIOUS 1


@interface DesiresViewController : UIViewController <DesiresViewDelegate, UITableViewDataSource, SearchDesireDialogDelegate> {

	Logic * _logic;
	
	SearchDesireDialogController * _searchDialog;
	UIPopoverController * _searchPopover;
	
	NSMutableDictionary * _pageCells;

	IBOutlet UITableView * _table;
	IBOutlet UIActivityIndicatorView * _activityIndicator;
	IBOutlet UIActivityIndicatorView * _actUserImage;
	IBOutlet UIImageView * _userImage;
	IBOutlet UILabel * _lblCurrentPage;
	IBOutlet UILabel * _lblTotalPages;
	IBOutlet UITextView * _tvDesire;
	IBOutlet UIImageView * _curlImage;
	IBOutlet UIButton * _btnSearch;
	
	int _currentChangingPageType;
}

// Actions
-(IBAction)search;
-(IBAction)next;
-(IBAction)previous;
-(IBAction)publicDesire;
-(IBAction)close;
-(IBAction)baseConditions;

-(void)curlDownFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;

// Private Methods
-(void)refreshFooter;
-(BOOL)validateField;
@end
