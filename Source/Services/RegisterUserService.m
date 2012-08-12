//
//  RegisterUserService.m
//  AxeFinMundo
//
//  Created by Arnold Guzmán on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RegisterUserService.h"
#import "JSON.h"
#import "Globals.h"

@implementation RegisterUserService

#pragma mark Initialization

-(id)initWithDelegate:(id<RegisterUserServiceDelegate>)delegate
{
	self = [super init];
	
	_delegate = delegate;
	
	return self;
}


#pragma mark Public Methods

-(void)registerUserName:(NSString *)name CI:(NSString *)ci Phone:(NSString *)phone City:(NSString *)city Gender:(NSString *)gender BirthDate:(NSDate *)birthDate andFacebookId:(NSString *)fbId
{
	// encode name
	NSString * encodedName = (NSString *)CFURLCreateStringByAddingPercentEscapes(
	    NULL, 
		(CFStringRef)name, 
		NULL, 
		(CFStringRef)@"!*'();:@&=+$,/?%#[]",
		kCFStringEncodingUTF8);
	
	// encode city
	NSString * encodedCity = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, 
																				 (CFStringRef)city, 
																				 NULL, 
																				 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				 kCFStringEncodingUTF8);
	
	// encode birth date
	NSDateFormatter * format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"yyyyMMdd"];
	NSString * encodedBirth = [format stringFromDate:birthDate];
 
	// Build request URL with al parameters
	NSString * requestURL = [NSString stringWithFormat:@"%@?name=%@&ci=%@&phone=%@&city=%@&gender=%@&birth=%@&fbId=%@", 
							 REGISTER_USER_SERVICE_REQUEST_PAGE, encodedName, ci, phone, encodedCity, gender, encodedBirth, fbId];
	
	responseData = [[NSMutableData data] retain];

	NSLog(@"%@", requestURL);
	
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
	
	[_delegate registerStatus:success AndMessage:reason];
}

@end
