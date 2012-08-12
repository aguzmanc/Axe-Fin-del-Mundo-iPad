#import <UIKit/UIKit.h>
#import "FBLikeButton.h"
#import "Globals.h"

@protocol LikeDialogDelegate;

@interface LikeDialogController : UIViewController 
{
    id<LikeDialogDelegate> _delegate;
	
	FBLikeButton * _likeButton;
}

// Properties
@property (nonatomic, retain) id<LikeDialogDelegate> delegate;

// Actions
-(IBAction)okAtLike;

// Public Methods
-(void)generateLikeContent; // Generates a new like button in order to avoid navigation issues

@end






@protocol LikeDialogDelegate

-(void)atLike;

@end
