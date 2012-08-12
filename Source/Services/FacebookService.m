#import "FacebookService.h"

@implementation FacebookService

@synthesize identifier = _identifier;
@synthesize name = _name;

#pragma mark Initialization

-(id)initWithDelegate:(id<FacebookServiceDelegate>)delegate;
{
	self = [super init];
	
	_delegate = delegate;
	_logged = NO;
	return self;
}




#pragma mark Public Methods

-(void)login
{
	if(_logged)
		[_delegate didFacebookLogin];
	else
	{
		_facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_IDENTIFIER andDelegate:self];
	
		NSArray * permissions = [NSArray arrayWithObjects:@"publish_stream", @"email", @"user_likes", nil];

		[_facebook authorize:permissions];
	}
}



- (void)logout 
{
	[_facebook logout:self];
}




-(BOOL)handleOpenURL:(NSURL *)url
{
	if (_facebook == nil) return NO;
	
	return [_facebook handleOpenURL:url];
}


-(void)shareDesire:(Desire *)desire
{
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   FACEBOOK_APP_IDENTIFIER, @"app_id",
								   [NSString stringWithFormat:@"http://www.facebook.com/%@", desire.desireId], @"link",
								   FACEBOOK_PUBLISH_ICON_URL, @"picture",
								   @"AXE 2012. Feliz Fin del Mundo!", @"name",
								   @"Feliz Fin del Mundo!", @"caption",
								   [NSString stringWithFormat:@"%@ compartió el último deseo de %@: \"%@\". Tú también puedes compartir un último deseo antes del Feliz Fin del Mundo.", _name, desire.userName, desire.comment], @"description",
								   
								   nil];
	
	[_facebook dialog:@"feed" andParams:params andDelegate:nil];
}



-(void)publishDesire:(NSString *)desireText
{
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   FACEBOOK_APP_IDENTIFIER, @"app_id",
								   AXE_APP_URL, @"link",
								   FACEBOOK_PUBLISH_ICON_URL, @"picture",
								   @"AXE 2012. Feliz Fin del Mundo!", @"name",
								   @"¿Cuál es tu deseo para el Feliz Fin del Mundo? ", @"caption",
								   [NSString stringWithFormat:@"%@ escribió desde su iPad:\"%@\". Tú también puedes publicar tu último deseo antes del Feliz Fin del Mundo y ganar fabulosos premios", _name, desireText], @"description",
								   nil];
	
	[_facebook dialog:@"feed" andParams:params andDelegate:self];
}



-(void)firstTimePublish
{
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   FACEBOOK_APP_IDENTIFIER, @"app_id",
								   AXE_APP_URL, @"link",
								   FACEBOOK_PUBLISH_ICON_URL, @"picture",
								   @"Feliz Fin del Mundo!", @"caption",
								   @"AXE 2012.", @"name",
								   [NSString stringWithFormat:@"%@ quiere escribir su último deseo antes del Feliz Fin del Mundo, tú también puedes hacerlo. Comparte tus últimos deseos AXE y gana fabulosos premios.", _name], @"description",								   
								   nil];
	
	[_facebook dialog:@"feed" andParams:params andDelegate:nil];
}



-(void)checkIfUserIsFan
{
	_isFanChecking = YES;
	[_facebook requestWithGraphPath:@"me/likes" andDelegate:self];
}






#pragma mark FBSessionDelegate

- (void)fbDidLogin
{
	_isFanChecking = NO;
	[_facebook requestWithGraphPath:@"me" andDelegate:self];
}





#pragma mark FBDialogDelegate

- (void)dialogDidComplete:(FBDialog *)dialog
{
	[_delegate didPublishDesire];
}






#pragma mark FBRequestDelegate

- (void)request:(FBRequest *)request didLoad:(id)result
{
	if (_isFanChecking) {
		BOOL isFan = NO;
		
		NSArray * likes = [result objectForKey:@"data"];
		
		for (NSDictionary * like in likes) {
			NSString * str = [like objectForKey:@"id"];
			
			NSLog(@"%@", str);
			
			if ([str isEqualToString:AXE_FAN_PAGE_ID]){
				isFan = YES;
				break;
			}
		}
		
		[_delegate didCheckedFan:isFan];
	}
	else
	{
		_identifier = [[NSString stringWithString:[result objectForKey:@"id"]] retain];
		_name = [[NSString stringWithString:[result objectForKey:@"name"]] retain];
	
		NSLog(@"Logged With : %@   %@", _identifier, _name);
	
		_logged = YES;
		[_delegate didFacebookLogin];
	}
}


@end
