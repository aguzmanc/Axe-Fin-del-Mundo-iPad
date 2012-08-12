//
//  SendDesireService.m
//  AxeFinMundo
//
//  Created by Arnold Guzmán on 10/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SendDesireService.h"
#import "JSON.h"
#import "Globals.h"

@implementation SendDesireService

#pragma mark Initialization

-(id)initWithDelegate:(id<SendDesireServiceDelegate>)delegate
{
	self = [super init];
	
	_delegate = delegate;
	
	return self;
}

#pragma mark Public Methods

-(void)registerDesire:(NSString *)textDesire ForFacebookId:(NSString *)facebookId
{
	// encode name
	NSString * encodedDesire = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, 
																				 (CFStringRef)textDesire, 
																				 NULL, 
																				 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				 kCFStringEncodingUTF8);
	
	
	NSString * requestURL = [NSString stringWithFormat:@"%@?comment=%@&fbId=%@",SEND_DESIRE_SERVICE_REQUEST_PAGE ,encodedDesire,facebookId];
	NSLog(@"%@", requestURL);
	responseData = [[NSMutableData data] retain];
	NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
	NSHTTPURLResponse *HTTPresponse = (NSHTTPURLResponse *)response; 
	NSInteger statusCode = [HTTPresponse statusCode]; 
	if ( 404 == statusCode || 500 == statusCode ) {
		NSLog(@"Server Error - %@", [ NSHTTPURLResponse localizedStringForStatusCode: statusCode ]);
	} else { 
		[ responseData setLength:0 ];
	}
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
	[responseData appendData:data];
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{	
	NSLog(@"%@",[NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{	
	[connection release];
	
	responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSLog(@"%@",responseString);
	NSDictionary * results = [responseString JSONValue];
	NSString * res = [results objectForKey:@"Success"];
	
	BOOL success  = [res isEqualToString:@"true"];
	NSString * reason = nil;
	
	if (success == NO)
		reason = (NSString *)[results objectForKey:@"Reason"];
	
	[_delegate sendStatus:success AndMessage:reason];
}


@end
