#import <Foundation/Foundation.h>
#import "FBConnect.h"

#import "Globals.h"
#import "Desire.h"

@protocol FacebookServiceDelegate;

@interface FacebookService : NSObject <FBRequestDelegate,FBDialogDelegate,FBSessionDelegate>
{
    Facebook * _facebook;
	NSString * _identifier;
	NSString * _name;
	
	BOOL _logged;
	BOOL _isFanChecking;
	
	id<FacebookServiceDelegate> _delegate;
}

// Properties
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;

//Initialization
-(id)initWithDelegate:(id<FacebookServiceDelegate>)delegate;

// Public Methods
-(void)login;
-(void)logout;
-(BOOL)handleOpenURL:(NSURL *)url;
-(void)shareDesire:(Desire *)desire;
-(void)publishDesire:(NSString *)desireText;
-(void)firstTimePublish;
-(void)checkIfUserIsFan;

@end






@protocol FacebookServiceDelegate

-(void)didFacebookLogin;
-(void)didPublishDesire;
-(void)didCheckedFan:(BOOL)isFan;

@end

