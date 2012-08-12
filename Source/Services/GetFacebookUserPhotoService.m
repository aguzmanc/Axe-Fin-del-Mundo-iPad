#import "GetFacebookUserPhotoService.h"

@implementation GetFacebookUserPhotoService

@synthesize obtainForLoggedUser = _obtainForLoggedUser;

#pragma mark Initialization

-(id)initWithImageReceiverDelegate:(id<AsyncImageReceiverDelegate>) delegate
{
	self = [super init];
	
	_receiverDelegate = delegate;
	_obtainForLoggedUser = NO;
	
	return self;
}






#pragma mark Public Methods

-(void)obtainImageForIdentifier:(NSString *)identifier
{
	_identifier = identifier;
	
	NSString * requestURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", identifier];
	
	_responseData = [[NSMutableData data] retain];
	
	NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL] ];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
	NSHTTPURLResponse *HTTPresponse = (NSHTTPURLResponse *)response; 
	NSInteger statusCode = [HTTPresponse statusCode]; 
	if ( 404 == statusCode || 500 == statusCode ) {
		NSLog(@"Server Error - %@", [ NSHTTPURLResponse localizedStringForStatusCode: statusCode ]);
		
		if (_obtainForLoggedUser)
			[_receiverDelegate receiveImageForLoggedUser:nil];
		else
			[_receiverDelegate receiveImage:nil ForIdentifier:_identifier];
		
	} else { 
		[ _responseData setLength:0 ];
	}
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
	[_responseData appendData:data];
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{	
	NSLog(@"%@",[NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{	
	[connection release];
	
	UIImage * image = [UIImage imageWithData:_responseData];
	
	if (_obtainForLoggedUser)
		[_receiverDelegate receiveImageForLoggedUser:image];
	else
		[_receiverDelegate receiveImage:image ForIdentifier:_identifier];
}

@end


