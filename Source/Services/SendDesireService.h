//
//  SendDesireService.h
//  AxeFinMundo
//
//  Created by Arnold Guzmán on 10/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SendDesireServiceDelegate;

@interface SendDesireService : NSObject {
	  NSMutableData * responseData;
	  NSMutableString * responseString;
      id<SendDesireServiceDelegate> _delegate;
}

// Initialization
-(id)initWithDelegate:(id<SendDesireServiceDelegate>)delegate;

// Public Methods
-(void)registerDesire:(NSString *)textDesire ForFacebookId:(NSString *)facebookId;

@end

@protocol SendDesireServiceDelegate

-(void)sendStatus:(BOOL)status AndMessage:(NSString *)message;

@end