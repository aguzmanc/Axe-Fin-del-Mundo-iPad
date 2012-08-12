#import <Foundation/Foundation.h>

@protocol RegisterUserServiceDelegate;

@interface RegisterUserService : NSObject 
{
	NSMutableData * responseData;
	NSMutableString * responseString;
	
	id<RegisterUserServiceDelegate> _delegate;
	
	BOOL requestSendOk;
}

// Initialization
-(id)initWithDelegate:(id<RegisterUserServiceDelegate>)delegate;

// Public Methods
-(void)registerUserName:(NSString *)name CI:(NSString *)ci Phone:(NSString *)phone City:(NSString *)city Gender:(NSString *)gender BirthDate:(NSDate *)birthDate andFacebookId:(NSString *)fbId;

@end




@protocol RegisterUserServiceDelegate

-(void)registerStatus:(BOOL)status AndMessage:(NSString *)message;

@end

