//
//  FBLikeButton.h
//  DemoApp
//
//  Created by Giancarlo on 30/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBDialog.h"
#define FB_LIKE_BUTTON_LOGIN_NOTIFICATION @"FBLikeLoginNotification"

typedef enum {
	FBLikeButtonStyleStandard,
	FBLikeButtonStyleButtonCount,
	FBLikeButtonStyleBoxCount
} FBLikeButtonStyle;

typedef enum {
	FBLikeButtonColorLight,
	FBLikeButtonColorDark
} FBLikeButtonColor;

@interface FBLikeButton : UIView <UIWebViewDelegate,FBDialogDelegate> {
	UIWebView *webView_;
	
}


- (id)initWithFrame:(CGRect)frame andUrl:(NSString *)likePage andStyle:(FBLikeButtonStyle)style andColor:(FBLikeButtonColor)color;
- (id)initWithFrame:(CGRect)frame andUrl:(NSString *)likePage;

@end
