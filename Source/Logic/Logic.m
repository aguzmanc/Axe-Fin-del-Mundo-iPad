#import "Logic.h"

@protocol CoverViewDelegate;
@protocol RegisterViewDelegate;
@protocol DesiresViewDelegate;

@implementation Logic

@synthesize messageDialogs;
@synthesize searchDelegate = _searchDelegate;
@synthesize totalPages = _totalPages;
@synthesize currentPage = _currentPage;

#pragma mark Initialization

-(id)initWithMain:(id)main 
			cover:(id)cover 
		  desires:(id)desires 
	  AndRegister:(id)reg
{
	self = [super init];
	
	_mainDelegate = main;
	_coverDelegate = cover;
	_desiresDelegate = desires;
	_registerDelegate = reg;
	
	// Assign logic to all delegates
	[_mainDelegate setLogic:self];
	[_coverDelegate setLogic:self];
	[_desiresDelegate setLogic:self];
	[_registerDelegate setLogic:self];
	
	_registerUserService = [[RegisterUserService alloc] initWithDelegate:self];
	_facebookService = [[FacebookService alloc] initWithDelegate:self];
	_isUserRegisteredService = [[IsUserRegisteredService alloc] initWithDelegate:self];
	_getDesireListService = [[GetDesireListService alloc] initWithDelegate:self];
	_sendDesireService = [[SendDesireService alloc] initWithDelegate:self];
	
	// init cache of images
	_userImageCache = [[NSMutableDictionary alloc] init];
	
	_desireList = nil;
	
	return self;
}






#pragma mark Public Methods

-(void)makeInitialConditions
{
	[_mainDelegate switchToCover];
}



-(void)openBook
{	
	[_facebookService login];
}



-(Desire *)getDesireForIndex:(int)index
{
	int indexInList = index + (_currentPage * DESIRES_PER_PAGE);
	
	Desire * desire = (Desire *)[_desireList objectAtIndex:indexInList];
	
	return desire;
}



-(void)nextPage
{
	if ([self canNextPage]) {
		_currentPage ++;
		[_desiresDelegate refreshDesires];
	}
}



-(void)previousPage
{
	if ([self canPreviousPage]) {
		_currentPage --;
		[_desiresDelegate refreshDesires];
	}
}



-(BOOL)canNextPage
{
	return ((_currentPage + 1) < _totalPages);
}



-(BOOL)canPreviousPage
{
	return ((_currentPage - 1) >= 0);
}



-(void)shareDesire:(Desire *)desire
{
	[_facebookService shareDesire:desire];
}



-(void)obtainImageForLoggedUser
{
	// Delegates Receiver for async event
	GetFacebookUserPhotoService * service = [[GetFacebookUserPhotoService alloc] initWithImageReceiverDelegate:self];
	service.obtainForLoggedUser = YES;
	
	[service obtainImageForIdentifier:_facebookService.identifier];
}



-(void)obtainImageForIdentifier:(NSString *)identifier
{
	// Delegates Receiver for async event
	GetFacebookUserPhotoService * service = [[GetFacebookUserPhotoService alloc] initWithImageReceiverDelegate:self];
	
	[service obtainImageForIdentifier:identifier];
}



-(BOOL)existsImageForIdentifier:(NSString *)identifier
{
	return ([[_userImageCache allKeys] containsObject:identifier] == YES);
}



-(UIImage *)getImageForIdentifier:(NSString *)identifier
{
	return [_userImageCache objectForKey:identifier];
}






-(void)registerUserName:(NSString *)userName CI:(NSString *)ci Phone:(NSString *)phone 
				   City:(NSString *)city Gender:(NSString *)gender AndBirthDate:(NSDate *)birthDate;
{
	NSString * fbId = _facebookService.identifier;
	
	[_registerUserService registerUserName:userName CI:ci Phone:phone City:city Gender:gender BirthDate:birthDate andFacebookId:fbId];
}



-(NSArray *)searchDesiresWithText:(NSString *)searchText
{
	// T.O.D.O. Implementar BUSQUEDA!!!
	NSMutableArray * arr = [[NSMutableArray alloc] init];
	
	if (_desireList == nil) 
		return arr;
	
	
	for (Desire * desire in _desireList) {
		NSRange  range = [desire.comment rangeOfString:searchText options:(NSCaseInsensitiveSearch)];
		
		if (range.location != NSNotFound) {
			[arr addObject:desire];
		}
	}
		
	return [[NSArray alloc] initWithArray:arr];
}



-(BOOL)handleOpenURL:(NSURL *)url
{
	return [_facebookService handleOpenURL:url];
}



-(int)countDesiresInCurrentPage
{
	if (_desireList == nil) 
		return 0;
	
	if (_currentPage < (_totalPages - 1)) // check if is not the last page
		return DESIRES_PER_PAGE;
	
	int total = [_desireList count] % DESIRES_PER_PAGE;
	if (total == 0) total = DESIRES_PER_PAGE;
	
	return total;
}



-(void)exitAplication
{
	[_facebookService logout];
	exit(0);
}



-(void)publicDesire:(NSString *)textDesire
{
	[_facebookService publishDesire:textDesire];
}



-(void)baseConditions
{
	NSURL *url = [ [ NSURL alloc ] initWithString: AXE_CONTEST_RULES_PAGE_URL ];
    [[UIApplication sharedApplication] openURL:url];
}



-(void)checkIfUserIsFan
{
	[_facebookService checkIfUserIsFan];
	
	[_coverDelegate startWaiting];	
	
}






#pragma mark AsyncImageReceiverDelegate

-(void)receiveImage:(UIImage *)image ForIdentifier:(NSString *)identifier
{
	if (image == nil) {
		image = [UIImage imageNamed:@"noimage.png"];
	}
	
	// Updates image cache
	if ([[_userImageCache allKeys] containsObject:identifier] == YES)
		[_userImageCache removeObjectForKey:identifier];
	
	[_userImageCache setObject:image forKey:identifier];

	// sends image to Desires list
	[_desiresDelegate updateImage:image forIdentifier:identifier];
	
	// sends image to Search box
	if (_searchDelegate != nil) 
		[_searchDelegate updateImage:image forIdentifier:identifier];
}



-(void)receiveImageForLoggedUser:(UIImage *)image
{
	[_desiresDelegate updateUserImage:image];
}






#pragma mark FacebookServiceDelegate

-(void)didFacebookLogin
{
	[self checkIfUserIsFan];
}



-(void)didCheckedFan:(BOOL)isFan
{
	if (isFan) {
		[_isUserRegisteredService executeWithIdentifier:_facebookService.identifier];
		[_coverDelegate startWaiting];
	}
	else {
		[_coverDelegate offerFanPage];
	}

}



-(void)didPublishDesire
{
	NSString * desireText = [_desiresDelegate getDesireText];
	[_sendDesireService registerDesire:desireText ForFacebookId:_facebookService.identifier];
}



#pragma mark IsUserRegisteredServiceDelegate

-(void)userIsRegistered:(BOOL)registered
{
	if (registered) 
	{
		[_mainDelegate switchToDesires];
		[_getDesireListService getList];
		[_desiresDelegate waitForList];
		[_desiresDelegate waitForUserImage];
	}
	else
		[_mainDelegate switchToRegister];
}






#pragma mark RegisterUserServiceDelegate

-(void)registerStatus:(BOOL)status AndMessage:(NSString *)message
{
	if (status == YES) 
	{
		[_mainDelegate switchToDesires];
		[_getDesireListService getList];
		
		[_desiresDelegate waitForList];
		[_desiresDelegate waitForUserImage];
		
		[_facebookService firstTimePublish];
	}
	else 
		[_registerDelegate registerError:message];

}






#pragma mark GetDesireListServiceDelegate

-(void)desireListResponseSucceeded:(BOOL)success Reason:(NSString *)reason andList:(NSArray *)list
{
	if (success) {
		_desireList = [[NSArray arrayWithArray:list] retain];
		
		if ([_desireList count] == 0) {
			_totalPages = 0;
			_currentPage = 0;
		}
		else {
			_totalPages = (([_desireList count] - 1)/DESIRES_PER_PAGE) + 1;
			_currentPage = 0;
		}
		
		[_desiresDelegate refreshDesires];
	}
}






#pragma mark SendDesireServiceDelegate

-(void)sendStatus:(BOOL)status AndMessage:(NSString *)message
{
	if (status == YES) 
	{
		[_desiresDelegate desireSending];
		
		// reload data
		[_getDesireListService getList];
		[_desiresDelegate waitForList];
	}
	else 
		[_desiresDelegate sendError:message];
	
}


@end


