#import <Foundation/Foundation.h>

#import "Globals.h"
#import "Desire.h"
#import "JSON.h"

@protocol GetDesireListServiceDelegate;

@interface GetDesireListService : NSObject 
{
	id<GetDesireListServiceDelegate> _delegate;
	
	NSMutableData * _responseData;
}

// Initialization
-(id)initWithDelegate:(id<GetDesireListServiceDelegate>)delegate;

// Public Methods
-(void)getList;

@end






@protocol GetDesireListServiceDelegate

-(void)desireListResponseSucceeded:(BOOL)success Reason:(NSString *)reason andList:(NSArray *)list;

@end

