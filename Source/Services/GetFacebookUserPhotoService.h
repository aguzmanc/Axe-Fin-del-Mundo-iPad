#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AsyncImageReceiverDelegate;

@interface GetFacebookUserPhotoService : NSObject 
{
	id<AsyncImageReceiverDelegate> _receiverDelegate;
	NSString * _identifier;
	BOOL _obtainForLoggedUser;
	
	NSMutableData * _responseData;
}

// Properties
@property BOOL obtainForLoggedUser;

// Initialization
-(id)initWithImageReceiverDelegate:(id<AsyncImageReceiverDelegate>) delegate;

// Public Methods
-(void)obtainImageForIdentifier:(NSString *)identifier;

@end





// Allows receive async response of an image from web
@protocol AsyncImageReceiverDelegate

-(void)receiveImage:(UIImage *)image ForIdentifier:(NSString *) identifier;
-(void)receiveImageForLoggedUser:(UIImage *)image;

@end