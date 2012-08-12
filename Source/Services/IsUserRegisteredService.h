#import <Foundation/Foundation.h>

#import "JSON.h"

#import "Globals.h"

@protocol IsUserRegisteredServiceDelegate;

@interface IsUserRegisteredService : NSObject 
{
	id<IsUserRegisteredServiceDelegate> _delegate;
	
	NSMutableData * _responseData;
}

// Initialization
-(id)initWithDelegate:(id<IsUserRegisteredServiceDelegate>)delegate;

// Public Methods
-(void)executeWithIdentifier:(NSString *)identifier;

@end






@protocol IsUserRegisteredServiceDelegate

-(void)userIsRegistered:(BOOL)registered;

@end