//
//  OAuthClientController.h
//  MPOAuthConnection
//
//  Created by Karl Adam on 08.12.05.
//  Copyright 2008 matrixPointer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MPOAuth/MPOAuth.h>
#import <MPOAuth/MPOAuthAuthenticationMethodOAuth.h>

@class MPOAuthAPI;

@interface OAuthClientController : NSObject <MPOAuthAuthenticationMethodOAuthDelegate> {
	IBOutlet	NSTextField			*baseURLField;
	IBOutlet	NSTextField			*authenticationURLField;
	IBOutlet	NSTextField			*consumerKeyField;
	IBOutlet	NSTextField			*consumerSecretField;
	IBOutlet	NSButton			*getTokenButton;
	IBOutlet	NSProgressIndicator *tokenProgressIndicator;
	IBOutlet	NSButton			*getAccessButton;
	IBOutlet	NSProgressIndicator *accessProgressIndicator;
	IBOutlet	NSTextField			*methodField;
	IBOutlet	NSTextField			*requestBodyField;
	IBOutlet	NSTextView			*responseBodyView;
	IBOutlet	NSTextField			*pinField;
				MPOAuthAPI			*_oauthAPI;
}

- (IBAction)performAuthentication:(id)sender;
- (IBAction)getUserAccess:(id)sender;
- (IBAction)performMethod:(id)sender;

@end
