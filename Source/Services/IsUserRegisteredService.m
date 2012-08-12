#import "IsUserRegisteredService.h"


@implementation IsUserRegisteredService

#pragma mark Initialization

-(id)initWithDelegate:(id<IsUserRegisteredServiceDelegate>)delegate
{
	self = [super init];
	
	_delegate = delegate;
	
	return self;
}






#pragma mark Public Methods

-(void)executeWithIdentifier:(NSString *)identifier
{
	NSString * requestURL = [NSString stringWithFormat:@"%@?fbId=%@", IS_USER_REGISTERED_SERVICE_REQUEST_PAGE, identifier];
	
	NSLog(@"%@", requestURL);
	
	_responseData = [[NSMutableData data] retain];
	
	// encode
	requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	
	// send request
	NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}






#pragma mark URL Request Delegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[_responseData appendData:data];
}



-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[connection release];
	
	NSString * responseString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
	
	NSDictionary * result = [responseString JSONValue];
	NSString * res = [result objectForKey:@"IsRegistered"];
	
	BOOL isRegistered = [res isEqualToString:@"true"];
	
	NSLog(@"Is Registered: %@", res);

	[_delegate userIsRegistered:isRegistered];
}

@end
