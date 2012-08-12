#import "GetDesireListService.h"


@implementation GetDesireListService

#pragma mark Initialization

-(id)initWithDelegate:(id<GetDesireListServiceDelegate>)delegate
{
	self = [super init];
	
	_delegate = delegate;
	
	
	return self;
}






#pragma mark Public Methods

-(void)getList
{
	NSString * requestURL = [NSString stringWithFormat:@"%@",GET_DESIRE_LIST_SERVICE_REQUEST_PAGE];
	
	// encoding
	requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
	NSLog(@"%@", requestURL);
	
	_responseData = [[NSMutableData data] retain];
	
	// prepare and send request
	NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}






#pragma mark Request Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
	NSHTTPURLResponse *HTTPresponse = (NSHTTPURLResponse *)response; 
	NSInteger statusCode = [HTTPresponse statusCode]; 
	if ( 404 == statusCode || 500 == statusCode ) {
		NSLog(@"Server Error - %@", [ NSHTTPURLResponse localizedStringForStatusCode: statusCode ]);
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
	
	NSString * responseStr = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
	NSLog(@"%@",responseStr);
	
	NSDictionary * results = [responseStr JSONValue];
	NSString * res = [results objectForKey:@"Success"];
	
	BOOL success  = [res isEqualToString:@"true"];
	
	NSString * reason = nil;
	NSArray * rawList = nil;
	NSMutableArray * list = nil;
	
	if (success == NO)
	{
		reason = (NSString *)[results objectForKey:@"Reason"];
	}
	else {
		rawList = [results objectForKey:@"DesireList"];
		list = [[NSMutableArray alloc] init];
		
		for (id rawDesire in rawList) 
		{
			Desire * desire = [[Desire alloc] init];
			desire.desireId = [rawDesire objectForKey:@"FacebookId"];
			desire.userName = [rawDesire objectForKey:@"UserName"];
			desire.comment = [rawDesire objectForKey:@"Comment"];
			
			[list addObject:desire];
		}
	}

	[_delegate desireListResponseSucceeded:success Reason:reason andList:[NSArray arrayWithArray:list]];
}


@end
