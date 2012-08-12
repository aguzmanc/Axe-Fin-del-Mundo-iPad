//
//  Desire.h
//  AxeFinMundo
//
//  Created by Giancarlo on 13/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Desire : NSObject 
{
	NSString * _desireId;
	NSString * _userName;
	NSString * _comment;
}

@property (nonatomic, retain) NSString * desireId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * comment;


@end
