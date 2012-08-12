#import <Foundation/Foundation.h>

#import "RegisterUserService.h"
#import "GetFacebookUserPhotoService.h"
#import "Desire.h"
#import "FacebookService.h"
#import "IsUserRegisteredService.h"
#import "GetDesireListService.h"
#import "SendDesireService.h"

@protocol MainViewDelegate;
@protocol CoverViewDelegate;
@protocol RegisterViewDelegate;
@protocol DesiresViewDelegate;
@protocol SearchViewDelegate;


@interface Logic : NSObject <AsyncImageReceiverDelegate, FacebookServiceDelegate,  IsUserRegisteredServiceDelegate,	 RegisterUserServiceDelegate,  GetDesireListServiceDelegate> 
{	
	id<MainViewDelegate> _mainDelegate;
	id<CoverViewDelegate> _coverDelegate;	
	id<RegisterViewDelegate> _registerDelegate;
	id<DesiresViewDelegate> _desiresDelegate;
	id<SearchViewDelegate> _searchDelegate;
	
	int _currentPage;
	int _totalPages;
	
	NSMutableDictionary * _userImageCache;
	NSArray * _desireList;
	
	RegisterUserService * _registerUserService;
	FacebookService * _facebookService;
	IsUserRegisteredService * _isUserRegisteredService;
	GetDesireListService * _getDesireListService;
	SendDesireService * _sendDesireService;
}

// Properties
@property (nonatomic, retain) id<SearchViewDelegate> searchDelegate;
@property (nonatomic, assign) NSString *messageDialogs;
@property (readonly) int totalPages;
@property (readonly) int currentPage;

// Initializacion
-(id)initWithMain:(id)main cover:(id)cover desires:(id)desires AndRegister:(id)reg;

// Public Methods
-(void)makeInitialConditions;
-(void)openBook;
-(void)exitAplication;
-(Desire *)getDesireForIndex:(int)index;  // deals with paging
-(void)nextPage;
-(void)previousPage;
-(BOOL)canNextPage;
-(BOOL)canPreviousPage;
-(void)obtainImageForLoggedUser;
-(void)obtainImageForIdentifier:(NSString *)identifier;
-(void)shareDesire:(Desire *)desire;
-(void)registerUserName:(NSString *)userName CI:(NSString *)ci Phone:(NSString *)phone City:(NSString *)city Gender:(NSString *)gender AndBirthDate:(NSDate *)birthDate;
-(BOOL)existsImageForIdentifier:(NSString *)identifier; // image cache
-(UIImage *)getImageForIdentifier:(NSString *)identifier;// image cache
-(NSArray *)searchDesiresWithText:(NSString *)searchText;
-(BOOL)handleOpenURL:(NSURL *)url;
-(int)countDesiresInCurrentPage;
-(void)publicDesire:(NSString *)textDesire;
-(void)baseConditions;
-(void)checkIfUserIsFan;



@end


// DELEGATE FOR LOGIC

/*
 * Main View Delegate
 */
@protocol MainViewDelegate

-(void)setLogic:(Logic *)logic;

// change view methods
-(void)switchToCover;
-(void)switchToDesires;
-(void)switchToRegister;

@end



/*
 * Cover View Delegate
 */

@protocol CoverViewDelegate

-(void)setLogic:(Logic *)logic;
-(void)startWaiting;
-(void)offerFanPage;
@end





/*
 * Register View Delegate
 */

@protocol RegisterViewDelegate

-(void)setLogic:(Logic *)logic;
-(void)registerError:(NSString *)message;

@end





/*
 * Desires View Delegate
 */
@protocol DesiresViewDelegate

-(void)setLogic:(Logic *)logic;
-(void)updateImage:(UIImage *)image forIdentifier:(NSString *)identifier;
-(void)updateUserImage:(UIImage *)image;
-(void)refreshDesires;
-(void)waitForList;
-(void)waitForUserImage;
-(void)desireSending;
-(void)sendError:(NSString *)message;
-(NSString *)getDesireText;

@end






/*
 * Search View Delegate
 */
@protocol SearchViewDelegate

-(void)updateImage:(UIImage *)image forIdentifier:(NSString *)identifier;

@end





